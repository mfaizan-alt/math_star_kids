// adUnitId: "ca-app-pub-2983283750660362/3759469533", real id


import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdManager {
  AdManager._();

  static final AdManager instance = AdManager._();

  InterstitialAd? _ad;
  bool get isReady => _ad != null;

  /// LOAD AD
  void load() {
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

  /// SHOW AD
  void show() {
    if (_ad == null) {
      load();
      return;
    }

    _ad!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _ad = null;
        load(); // preload next
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _ad = null;
        load(); // preload next
      },
    );

    _ad!.show();
    _ad = null;
  }
}