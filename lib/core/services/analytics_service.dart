import 'package:firebase_analytics/firebase_analytics.dart';

/// Central analytics service. Call these from controllers/views at the exact
/// moment the event happens — don't log hypothetical events.
class AnalyticsService {
  AnalyticsService._();
  static final AnalyticsService instance = AnalyticsService._();

  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  FirebaseAnalyticsObserver get observer =>
      FirebaseAnalyticsObserver(analytics: _analytics);

  // ── Screen tracking ──────────────────────────────
  Future<void> logScreen(String screenName) =>
      _analytics.logScreenView(screenName: screenName);

  // ── Game events ──────────────────────────────────
  Future<void> logGameStart(String gameName) =>
      _analytics.logEvent(name: 'game_start', parameters: {'game': gameName});

  Future<void> logGameComplete({
    required String gameName,
    required int score,
    required int stars,
  }) =>
      _analytics.logEvent(name: 'game_complete', parameters: {
        'game': gameName,
        'score': score,
        'stars': stars,
      });

  Future<void> logLevelUp(String module, int level) =>
      _analytics.logEvent(name: 'level_up', parameters: {
        'module': module,
        'level': level,
      });

  // ── Monetisation events ──────────────────────────
  Future<void> logAdImpression(String adType) =>
      _analytics.logEvent(name: 'ad_impression', parameters: {'type': adType});

  Future<void> logPremiumTapped() =>
      _analytics.logEvent(name: 'premium_tapped');

  Future<void> logPremiumPurchased() async {
    await _analytics.logEvent(name: 'premium_purchased');
    await _analytics.setUserProperty(name: 'is_premium', value: 'true');
  }

  Future<void> logRewardedAdWatched(String placement) =>
      _analytics.logEvent(name: 'rewarded_ad_watched',
          parameters: {'placement': placement});

  // ── Engagement events ────────────────────────────
  Future<void> logStoryRead(String storyTitle) =>
      _analytics.logEvent(name: 'story_read',
          parameters: {'title': storyTitle});

  Future<void> logStreakUpdated(int streak) =>
      _analytics.logEvent(name: 'streak_updated',
          parameters: {'streak': streak});

  Future<void> logNotificationReceived(String type) =>
      _analytics.logEvent(name: 'notification_received',
          parameters: {'type': type});

  // ── User properties ──────────────────────────────
  Future<void> setUserStars(int stars) =>
      _analytics.setUserProperty(name: 'total_stars', value: '$stars');
}
