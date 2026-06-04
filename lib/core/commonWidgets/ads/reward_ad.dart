import 'package:google_mobile_ads/google_mobile_ads.dart';

class RewardedAdService {
  RewardedAd? _ad;

  void loadAd() {
    RewardedAd.load(
      adUnitId: "ca-app-pub-2983283750660362/1113959046",
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) => _ad = ad,
        onAdFailedToLoad: (error) => _ad = null,
      ),
    );
  }

  void showAd(Function onReward) {
    if (_ad == null) return;

    _ad!.show(
      onUserEarnedReward: (ad, reward) {
        onReward(); // give stars / coins here
      },
    );

    _ad = null;
    loadAd(); // preload next ad
  }
}