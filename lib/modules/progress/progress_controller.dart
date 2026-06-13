import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_constants.dart';
import '../../core/services/notification_service.dart';
import '../../core/services/review_service.dart';
import '../../core/services/stars_service.dart';

class ProgressController extends GetxController {
  var totalStars = 0.obs;
  int highScore = 0;
  int currentStreak = 0;

  final Map<String, int> moduleLevels = {};
  final Map<String, int> moduleStars = {};

  @override
  void onInit() {
    super.onInit();
    loadProgress();
  }

  int getModuleLevel(String module) => moduleLevels[module] ?? 1;
  int getModuleStars(String module) => moduleStars[module] ?? 0;

  Future<void> loadProgress() async {
    final prefs = await SharedPreferences.getInstance();

    totalStars.value = prefs.getInt(AppConstants.keyTotalStars) ?? 0;
    highScore = prefs.getInt(AppConstants.keyHighScore) ?? 0;
    currentStreak = prefs.getInt(AppConstants.keyCurrentStreak) ?? 0;

    for (final module in [
      'addition',
      'subtraction',
      'multiplication',
      'division',
      'counting',
      'numbers'
    ]) {
      moduleLevels[module] = prefs.getInt('${module}_level') ?? 1;
      moduleStars[module] = prefs.getInt('${module}_stars') ?? 0;
    }

    update();
  }

  Future<void> addStars(String module, int stars) async {
    final prevTotal = totalStars.value;
    totalStars.value += stars;

    moduleStars[module] = (moduleStars[module] ?? 0) + stars;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(AppConstants.keyTotalStars, totalStars.value);
    await prefs.setInt('${module}_stars', moduleStars[module]!);

    if (Get.isRegistered<StarsService>()) {
      await StarsService.to.addStars(stars, sourceName: module);
    }

    // Fire milestone notification if a threshold was just crossed.
    _checkMilestone(prevTotal, totalStars.value);

    // Ask for a review after a perfect 3-star result — the happiest moment.
    if (stars == 3) ReviewService.instance.maybeRequestReview();

    update();
  }

  Future<void> completeLevel(String module) async {
    final currentLevel = moduleLevels[module] ?? 1;

    if (currentLevel < AppConstants.maxLevel) {
      moduleLevels[module] = currentLevel + 1;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('${module}_level', moduleLevels[module]!);
    }

    update();
  }

  Future<void> updateHighScore(int score) async {
    if (score > highScore) {
      highScore = score;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(AppConstants.keyHighScore, highScore);

      update();
    }
  }

  Future<void> incrementStreak() async {
    currentStreak++;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(AppConstants.keyCurrentStreak, currentStreak);

    update();
  }

  /// Daily-streak engine. Call once whenever the home screen gains focus.
  /// Increments the streak the first time the user shows up on a new calendar
  /// day, resets to 1 if a day was skipped, no-op for repeat visits same day.
  Future<void> recordDailyActivity() async {
    final prefs = await SharedPreferences.getInstance();
    final todayKey = _dayKey(DateTime.now());
    final lastKey = prefs.getString('last_active_day');

    if (lastKey == todayKey) {
      // Already counted today — still reschedule the reminder so it stays
      // pushed to tomorrow even if user opens the app multiple times.
      _rescheduleLocalNotifications();
      return;
    }

    if (lastKey == null) {
      currentStreak = 1;
    } else {
      final last = DateTime.tryParse(lastKey);
      final today = DateTime.tryParse(todayKey);
      if (last != null && today != null && today.difference(last).inDays == 1) {
        currentStreak++;
      } else {
        currentStreak = 1;
      }
    }

    await prefs.setString('last_active_day', todayKey);
    await prefs.setInt(AppConstants.keyCurrentStreak, currentStreak);
    update();

    _rescheduleLocalNotifications();

    // Ask for a review on streak milestones — user is clearly engaged.
    if (currentStreak == 3 || currentStreak == 7 || currentStreak == 14) {
      ReviewService.instance.maybeRequestReview();
    }
  }

  void _rescheduleLocalNotifications() {
    final box = GetStorage();
    final name = box.read<String>('childName') ?? 'Friend';

    // Streak reminder — fires tonight at 6 PM if user doesn't return.
    NotificationService.instance.rescheduleStreakReminder(
      childName: name,
      streak: currentStreak,
    );

    // Weekly challenge — fires next Monday at 9 AM.
    NotificationService.instance.rescheduleWeeklyChallenge();
  }

  void _checkMilestone(int prev, int current) {
    const milestones = [10, 25, 50, 100];
    final box = GetStorage();
    final name = box.read<String>('childName') ?? 'Friend';

    for (final m in milestones) {
      if (prev < m && current >= m) {
        NotificationService.instance.showMilestone(
          childName: name,
          stars: m,
        );
        break;
      }
    }
  }

  String _dayKey(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-'
      '${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';

  Future<void> resetStreak() async {
    currentStreak = 0;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(AppConstants.keyCurrentStreak, 0);

    update();
  }
}
