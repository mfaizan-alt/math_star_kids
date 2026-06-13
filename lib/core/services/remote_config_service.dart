import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';

/// Wraps Firebase Remote Config with typed getters and safe defaults.
///
/// Defaults are what the app uses when:
/// - There's no internet on first launch
/// - Firebase hasn't been set up yet
/// - A key hasn't been created in the console yet
///
/// Change values in Firebase Console → Remote Config without releasing an update.
class RemoteConfigService {
  RemoteConfigService._();
  static final RemoteConfigService instance = RemoteConfigService._();

  final FirebaseRemoteConfig _config = FirebaseRemoteConfig.instance;

  // ── Default values (safe fallbacks) ─────────────
  static const Map<String, dynamic> _defaults = {
    'ads_enabled': true,
    'interstitial_cooldown_seconds': 45,
    'nav_ad_cooldown_minutes': 2,
    'nav_ad_chance': 0.35,
    'premium_price_label': 'Remove Ads & Unlock All',
    'show_double_stars_button': true,
    'streak_reminder_enabled': true,
    'splash_duration_seconds': 2,
  };

  Future<void> init() async {
    await _config.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      // In debug: fetch every time so changes are visible immediately.
      // In release: fetch at most once per hour to save quota and battery.
      minimumFetchInterval:
          kDebugMode ? Duration.zero : const Duration(hours: 1),
    ));

    await _config.setDefaults(_defaults);

    try {
      await _config.fetchAndActivate();
    } catch (_) {
      // Silently fall back to defaults — app works fine without network.
    }
  }

  // ── Typed getters ────────────────────────────────
  bool get adsEnabled => _config.getBool('ads_enabled');
  int get interstitialCooldownSeconds =>
      _config.getInt('interstitial_cooldown_seconds');
  int get navAdCooldownMinutes => _config.getInt('nav_ad_cooldown_minutes');
  double get navAdChance => _config.getDouble('nav_ad_chance');
  String get premiumPriceLabel => _config.getString('premium_price_label');
  bool get showDoubleStarsButton => _config.getBool('show_double_stars_button');
  bool get streakReminderEnabled => _config.getBool('streak_reminder_enabled');
  int get splashDurationSeconds => _config.getInt('splash_duration_seconds');
}
