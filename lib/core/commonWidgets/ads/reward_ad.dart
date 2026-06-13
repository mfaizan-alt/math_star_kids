import 'dart:ui';

import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../services/premium_service.dart';
import 'ad_config.dart';

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
    // Premium perk: reward features (revive, day pass) stay visible and are
    // granted instantly in [showAd] — no ad is ever loaded or shown.
    if (PremiumService.active) {
      isLoadedRx.value = true;
      return;
    }
    if (_ad != null) return; // already preloaded
    RewardedAd.load(
      adUnitId: AdConfig.rewarded,
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
    if (PremiumService.active) {
      onReward();
      return;
    }
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
