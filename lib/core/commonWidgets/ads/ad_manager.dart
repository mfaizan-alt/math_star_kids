// adUnitId: "ca-app-pub-2983283750660362/3759469533", real id

import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Central interstitial manager with frequency capping.
///
/// Two trigger types share one cooldown clock:
///  - [showOnGameEnd] / [show]: natural break after a game or flow finishes.
///    Capped to one ad per [_gameEndInterval] so chained games don't stack ads.
///  - [maybeShowOnNavigation]: random ad while moving between screens (fires
///    on back-navigation via [AdNavigationObserver]). Longer cap + dice roll
///    so it feels occasional, which keeps kids/parents from uninstalling and
///    stays inside Google Play Families ad-frequency expectations.
class AdManager {
  AdManager._();

  static final AdManager instance = AdManager._();

  static const Duration _gameEndInterval = Duration(seconds: 45);
  static const Duration _navInterval = Duration(minutes: 2);
  static const double _navChance = 0.35; // ~1 in 3 eligible transitions

  final Random _random = Random();

  InterstitialAd? _ad;

  // Starts "now" so no interstitial can fire in the first seconds after launch.
  DateTime _lastShownAt = DateTime.now();

  bool get isReady => _ad != null;

  Duration get _sinceLast => DateTime.now().difference(_lastShownAt);

  /// LOAD AD
  void load() {
    if (_ad != null) return; // already preloaded
    InterstitialAd.load(
      adUnitId: "ca-app-pub-3940256099942544/1033173712", // TEST ID
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _ad = ad;
          debugPrint("✅ Interstitial Ad Loaded");
        },
        onAdFailedToLoad: (error) {
          _ad = null;
          debugPrint("❌ Ad failed to load: $error");
        },
      ),
    );
  }

  /// Kept for existing call sites — all of them fire when a game or flow
  /// ends, so route through the game-end cap.
  void show() => showOnGameEnd();

  /// Show after a game/level/flow finishes (natural break).
  void showOnGameEnd() {
    if (_sinceLast < _gameEndInterval) return;
    _showNow();
  }

  /// Occasionally show while the user moves between screens.
  void maybeShowOnNavigation() {
    if (_sinceLast < _navInterval) return;
    if (_random.nextDouble() > _navChance) return;
    _showNow();
  }

  void _showNow() {
    final ad = _ad;
    if (ad == null) {
      load();
      return;
    }
    _ad = null;
    _lastShownAt = DateTime.now();

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        load(); // preload next
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        load(); // preload next
      },
    );

    ad.show();
  }
}

/// Fires a capped, randomised interstitial when the user pops back out of a
/// full screen (dialogs/bottom sheets don't count). Registered once on
/// [GetMaterialApp.navigatorObservers], so it covers both Get.toNamed and
/// Navigator.push navigation everywhere in the app.
class AdNavigationObserver extends NavigatorObserver {
  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (route is! PageRoute || previousRoute is! PageRoute) return;
    AdManager.instance.maybeShowOnNavigation();
  }
}
