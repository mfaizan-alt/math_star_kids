// adUnitId: "ca-app-pub-2983283750660362/3759469533",

import 'package:google_mobile_ads/google_mobile_ads.dart';

class InterstitialAdService {
  InterstitialAd? _ad;

  bool get isReady => _ad != null;

  /// LOAD AD
  void loadAd() {
    InterstitialAd.load(
      adUnitId: "ca-app-pub-3940256099942544/1033173712", // TEST ID
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

          print("✅ Interstitial Ad Loaded");
        },
        onAdFailedToLoad: (error) {
          _ad = null;
          print("❌ Ad failed to load: $error");
        },
      ),
    );
  }

  /// SHOW AD
  void showAd() {
    if (_ad == null) {
      print("⚠️ Ad not ready, reloading...");
      loadAd();
      return;
    }

    _ad!.show();
    _ad = null;
  }
}