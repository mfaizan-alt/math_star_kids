import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../services/premium_service.dart';
import 'ad_config.dart';

class BannerAdWidget extends StatefulWidget {
  const BannerAdWidget({super.key});

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  BannerAd? bannerAd;
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    if (PremiumService.active) return; // paid: no banner, don't even load

    bannerAd = BannerAd(
      adUnitId: AdConfig.banner, // test in debug, real in release
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          if (!mounted) return;
          setState(() {
            isLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    );

    bannerAd!.load();
  }

  @override
  Widget build(BuildContext context) {
    final ad = bannerAd;

    // This widget is used as the Scaffold's bottomNavigationBar on nearly every
    // screen. In edge-to-edge mode the Scaffold strips the bottom system inset
    // from the body and hands it to the bottomNavigationBar — so if we render a
    // zero-height box when there's no ad (failed load / premium user), the body
    // draws UNDERNEATH the device navigation bar (worst with 3-button nav).
    //
    // To prevent that we always reserve at least the bottom inset, and wrap the
    // ad itself in SafeArea(top:false) so the ad sits above the nav bar.
    final bottomInset = MediaQuery.viewPaddingOf(context).bottom;

    if (isLoaded && ad != null) {
      return SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          height: ad.size.height.toDouble(),
          child: Center(
            child: SizedBox(
              height: ad.size.height.toDouble(),
              width: ad.size.width.toDouble(),
              child: AdWidget(ad: ad),
            ),
          ),
        ),
      );
    }

    // No ad to show — still occupy the bottom inset so content stays clear of
    // the system navigation bar.
    return SizedBox(height: bottomInset);
  }

  @override
  void dispose() {
    bannerAd?.dispose();
    super.dispose();
  }
}