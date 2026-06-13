import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../services/premium_service.dart';
import 'ad_config.dart';

class InterstitialAdService {
  InterstitialAd? _ad;

  bool get isReady => _ad != null;

  /// LOAD AD — no-op for premium users
  void loadAd() {
    if (PremiumService.active) return;
    InterstitialAd.load(
      adUnitId: AdConfig.interstitial,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _ad = ad;

          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _ad = null;
              loadAd(); // preload next ad
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _ad = null;
              loadAd();
            },
          );

          debugPrint("✅ Interstitial Ad Loaded");
        },
        onAdFailedToLoad: (error) {
          _ad = null;
          debugPrint("❌ Ad failed to load: $error");
        },
      ),
    );
  }

  /// SHOW AD — silently skipped for premium users
  void showAd() {
    if (PremiumService.active) return;
    if (_ad == null) {
      debugPrint("⚠️ Ad not ready, reloading...");
      loadAd();
      return;
    }

    _ad!.show();
    _ad = null;
  }

  /// DISPOSE any preloaded ad that was never shown (call from onClose)
  void dispose() {
    _ad?.dispose();
    _ad = null;
  }
}
