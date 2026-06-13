import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'analytics_service.dart';

// ── Notification IDs (stable — cancelling by ID requires the same value) ────
const int _kStreakReminderId = 1;
const int _kWeeklyChallengeId = 2;
const int _kForegroundId = 100; // base for incoming FCM foreground messages

/// Background FCM handler — runs in a separate Dart isolate.
/// Must be top-level. FCM shows the notification automatically from the payload
/// when the app is in background/terminated; no plugin calls needed here.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {}

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _local =
      FlutterLocalNotificationsPlugin();

  static const _channelId = 'math_stars_channel';
  static const _channelName = 'Math Stars Notifications';

  // Rotating foreground notification ID counter.
  int _foregroundId = _kForegroundId;

  Future<void> init() async {
    // Timezone database — needed for zonedSchedule.
    tz.initializeTimeZones();

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // Request permission (Android 13+, iOS always).
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Initialise local notifications plugin.
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings(
      requestAlertPermission: false, // already asked via FCM above
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    await _local.initialize(
      const InitializationSettings(android: android, iOS: ios),
      onDidReceiveNotificationResponse: _onTap,
    );

    // Create Android notification channel.
    if (Platform.isAndroid) {
      await _local
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(const AndroidNotificationChannel(
            _channelId,
            _channelName,
            description: 'Daily streak reminders and game updates',
            importance: Importance.high,
          ));
    }

    // Foreground FCM messages: FCM won't show a heads-up while app is open,
    // so we display manually via local notifications.
    FirebaseMessaging.onMessage.listen((message) async {
      await _showNow(
        id: _foregroundId++,
        title: message.notification?.title ?? '',
        body: message.notification?.body ?? '',
        payload: message.data['screen'],
      );
      await AnalyticsService.instance
          .logNotificationReceived(message.data['type'] ?? 'general');
    });

    // Background tap → app was running in background.
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpen);

    // Terminated tap → app was fully closed.
    final initial = await _messaging.getInitialMessage();
    if (initial != null) _handleMessageOpen(initial);

    if (kDebugMode) {
      final token = await _messaging.getToken();
      if (token != null) debugPrint('FCM Token: $token');
    }
  }

  // ── Public scheduling API ─────────────────────────────────────────────────

  /// Call this every time the home screen gains focus.
  /// Cancels any existing streak reminder and schedules a fresh one for
  /// tonight at [hour]:00 in the device's local timezone.
  /// If the user is active today, they'll never see it because we cancel and
  /// reschedule each time they open the app.
  Future<void> rescheduleStreakReminder({
    required String childName,
    required int streak,
    int hour = 18, // 6 PM device local time
  }) async {
    await _local.cancel(_kStreakReminderId);

    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
    );

    // If it's already past today's hour, schedule for tomorrow.
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    final title = _streakTitle(streak);
    final body = _streakBody(childName, streak);

    await _scheduleLocal(
      id: _kStreakReminderId,
      title: title,
      body: body,
      at: scheduled,
      payload: 'progress',
    );

    if (kDebugMode) {
      debugPrint('Streak reminder scheduled for $scheduled');
    }
  }

  /// Schedules a weekly challenge notification for the coming Monday at [hour].
  /// Called once per app open — safe to call repeatedly (cancels old one first).
  Future<void> rescheduleWeeklyChallenge({int hour = 9}) async {
    await _local.cancel(_kWeeklyChallengeId);

    final now = tz.TZDateTime.now(tz.local);
    // Days until next Monday (weekday 1 = Monday in Dart).
    int daysUntilMonday = DateTime.monday - now.weekday;
    if (daysUntilMonday <= 0) daysUntilMonday += 7;

    final scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day + daysUntilMonday,
      hour,
    );

    final challenges = [
      '🎯 Score 50+ in the Quiz Game this week!',
      '🐸 Complete 3 Frog Jump games this week!',
      '⭐ Earn 10 new stars this week!',
      '📚 Read 2 stories this week!',
      '🏃 Play Math Runner 3 times this week!',
    ];
    final challenge = challenges[now.weekNumber % challenges.length];

    await _scheduleLocal(
      id: _kWeeklyChallengeId,
      title: '🏆 New Weekly Challenge!',
      body: challenge,
      at: scheduled,
      payload: 'games',
    );
  }

  /// Shows a milestone notification immediately (no scheduling — fired inline
  /// when stars cross a threshold in ProgressController).
  Future<void> showMilestone({
    required String childName,
    required int stars,
  }) async {
    final milestones = {
      10: ('⭐ 10 Stars Earned!',
          'Amazing $childName! You unlocked new games — keep going!'),
      25: ('🌟 25 Stars — Superstar!',
          'Incredible $childName! You are a true Math Superstar!'),
      50: ('🏆 50 Stars — Champion!',
          '$childName is a Math Champion! You\'re unstoppable!'),
      100: ('👑 100 Stars — Math Master!',
          '$childName unlocked MASTER status! Premium stories are yours!'),
    };

    if (milestones.containsKey(stars)) {
      final (title, body) = milestones[stars]!;
      await _showNow(
        id: stars, // unique per milestone level
        title: title,
        body: body,
        payload: 'progress',
      );
    }
  }

  // ── Private helpers ───────────────────────────────────────────────────────

  Future<void> _scheduleLocal({
    required int id,
    required String title,
    required String body,
    required tz.TZDateTime at,
    String? payload,
  }) async {
    await _local.zonedSchedule(
      id,
      title,
      body,
      at,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
    );
  }

  Future<void> _showNow({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    await _local.show(
      id,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: payload,
    );
  }

  void _onTap(NotificationResponse response) {
    // response.payload = 'progress' | 'games' etc.
    // Add GetX navigation here when ready: Get.toNamed('/progress')
  }

  void _handleMessageOpen(RemoteMessage message) {
    // Tapped a remote notification — deep-link if needed.
  }

  // ── Streak copy ───────────────────────────────────────────────────────────

  String _streakTitle(int streak) {
    if (streak >= 7) return '🏆 $streak-Day Streak at risk!';
    if (streak >= 3) return '🔥 $streak-Day Streak — don\'t lose it!';
    if (streak >= 1) return '🔥 Keep your streak alive!';
    return '⭐ Time for Math Stars!';
  }

  String _streakBody(String name, int streak) {
    if (streak >= 7) {
      return '$name, a whole $streak days! Just 5 minutes keeps your streak going!';
    }
    if (streak >= 3) {
      return 'You\'ve been amazing $name! One quick session keeps your streak alive.';
    }
    if (streak >= 1) {
      return 'Come practice math today $name and keep your streak going!';
    }
    return '$name, come earn some stars today! 🌟';
  }
}

extension on tz.TZDateTime {
  int get weekNumber {
    final dayOfYear = difference(tz.TZDateTime(tz.local, year)).inDays + 1;
    return ((dayOfYear - weekday + 10) / 7).floor();
  }
}
