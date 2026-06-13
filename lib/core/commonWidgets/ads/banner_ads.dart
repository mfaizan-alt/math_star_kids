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
    return (isLoaded && ad != null)
        ? SafeArea(
            top: false,
            child: Center(
              heightFactor: 1,
              child: SizedBox(
                height: ad.size.height.toDouble(),
                width: ad.size.width.toDouble(),
                child: AdWidget(ad: ad),
              ),
            ),
          )
        : const SizedBox();
  }

  @override
  void dispose() {
    bannerAd?.dispose();
    super.dispose();
  }
}