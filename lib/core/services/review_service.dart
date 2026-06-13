import 'package:flutter/foundation.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Handles the Google Play / App Store in-app review prompt.
///
/// Rules (to stay within Google Play policy and maximise conversion):
/// - Only show after a genuinely positive moment (3-star game result, streak milestone)
/// - Never show more than once per 30 days
/// - Never show in the first 3 days after install (user needs time to form an opinion)
/// - Never show more than 3 times total (Google throttles it anyway, but we respect users)
/// - Silently no-op if the store is unavailable (emulators, sideloaded APKs)
class ReviewService {
  ReviewService._();
  static final ReviewService instance = ReviewService._();

  final InAppReview _review = InAppReview.instance;

  static const _keyInstallDate = 'review_install_date';
  static const _keyLastPrompt = 'review_last_prompt';
  static const _keyPromptCount = 'review_prompt_count';

  static const int _minDaysAfterInstall = 3;
  static const int _minDaysBetweenPrompts = 30;
  static const int _maxPrompts = 3;

  /// Call this once on first app launch to record the install date.
  Future<void> recordInstall() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString(_keyInstallDate) == null) {
      await prefs.setString(_keyInstallDate, DateTime.now().toIso8601String());
    }
  }

  /// Call this after a positive moment:
  /// - User earns 3 stars on a game
  /// - User hits a streak milestone (3, 7, 14 days)
  /// - User completes a story
  ///
  /// Internally enforces all cooldowns — safe to call frequently.
  Future<void> maybeRequestReview() async {
    try {
      if (!await _review.isAvailable()) return;

      final prefs = await SharedPreferences.getInstance();

      // Check install age
      final installStr = prefs.getString(_keyInstallDate);
      if (installStr == null) return;
      final installDate = DateTime.tryParse(installStr);
      if (installDate == null) return;
      final daysSinceInstall = DateTime.now().difference(installDate).inDays;
      if (daysSinceInstall < _minDaysAfterInstall) {
        if (kDebugMode) debugPrint('Review: too early — $daysSinceInstall days since install');
        return;
      }

      // Check prompt count
      final count = prefs.getInt(_keyPromptCount) ?? 0;
      if (count >= _maxPrompts) {
        if (kDebugMode) debugPrint('Review: max prompts ($count) reached');
        return;
      }

      // Check cooldown since last prompt
      final lastStr = prefs.getString(_keyLastPrompt);
      if (lastStr != null) {
        final last = DateTime.tryParse(lastStr);
        if (last != null) {
          final daysSinceLast = DateTime.now().difference(last).inDays;
          if (daysSinceLast < _minDaysBetweenPrompts) {
            if (kDebugMode) debugPrint('Review: cooldown — $daysSinceLast days since last prompt');
            return;
          }
        }
      }

      // All checks passed — request the review
      await _review.requestReview();

      // Record this prompt
      await prefs.setString(_keyLastPrompt, DateTime.now().toIso8601String());
      await prefs.setInt(_keyPromptCount, count + 1);

      if (kDebugMode) debugPrint('Review: prompt shown (count now ${count + 1})');
    } catch (e) {
      // Never crash the app over a review prompt
      if (kDebugMode) debugPrint('Review: error — $e');
    }
  }
}
