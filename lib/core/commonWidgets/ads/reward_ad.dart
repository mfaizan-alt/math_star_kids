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

  /// Shows the rewarded ad. [onReward] runs ONLY when the user actually earns
  /// the reward (via [onUserEarnedReward]). If no ad is loaded, the reward is
  /// NOT granted — we just preload for next time. This prevents a free-reward
  /// exploit where revives could be claimed with no ad shown.
  void showAd(VoidCallback onReward) {
    final ad = _ad;
    if (ad == null) {
      loadAd();
      return;
    }
    _ad = null;

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        loadAd(); // preload next
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        loadAd();
      },
    );

    ad.show(
      onUserEarnedReward: (ad, reward) => onReward(),
    );
  }
}