import 'dart:ui';

import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class RewardedAdService {
  static final RewardedAdService instance = RewardedAdService._();
  RewardedAdService._();

  RewardedAd? _ad;
  int _retries = 0;
  static const int _maxRetries = 3;

  bool get isLoaded => _ad != null;

  /// Reactive mirror of [isLoaded] so views can hide the "Watch Ad" button
  /// when no ad is available (rewarded fill is not guaranteed, especially
  /// with child-directed requests) instead of showing a dead button.
  final RxBool isLoadedRx = false.obs;

  void loadAd() {
    if (_ad != null) return; // already preloaded
    RewardedAd.load(
      // adUnitId: "ca-app-pub-2983283750660362/1113959046", //real Unit id

      adUnitId: "ca-app-pub-3940256099942544/5224354917", //test Unit id
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _ad = ad;
          _retries = 0;
          isLoadedRx.value = true;
        },
        onAdFailedToLoad: (error) {
          _ad = null;
          isLoadedRx.value = false;
          // Rewarded inventory often no-fills; retry a few times with a
          // delay so the button can still appear once an ad arrives.
          if (_retries < _maxRetries) {
            _retries++;
            Future.delayed(Duration(seconds: 15 * _retries), loadAd);
          }
        },
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
      _retries = 0;
      loadAd();
      return;
    }
    _ad = null;
    isLoadedRx.value = false;

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
