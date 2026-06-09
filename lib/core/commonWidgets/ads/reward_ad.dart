import 'dart:ui';

import 'package:google_mobile_ads/google_mobile_ads.dart';

class RewardedAdService {
  static final RewardedAdService instance = RewardedAdService._();
  RewardedAdService._();

  RewardedAd? _ad;
  bool get isLoaded => _ad != null;

  void loadAd() {
    RewardedAd.load(
      // adUnitId: "ca-app-pub-2983283750660362/1113959046", //real Unit id

      adUnitId: "ca-app-pub-3940256099942544/5224354917", //test Unit id
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) => _ad = ad,
        onAdFailedToLoad: (error) => _ad = null,
      ),
    );
  }

  void showAd(VoidCallback onReward) {
    if (_ad == null) {
      onReward();
      loadAd();
      return;
    }
    _ad!.show(
      onUserEarnedReward: (ad, reward) => onReward(),
    );
    _ad = null;
    loadAd();
  }
}