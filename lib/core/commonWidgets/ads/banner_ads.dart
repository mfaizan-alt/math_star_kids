import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../constants/app_strings.dart';
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
      // Google Play Families "Ad format requirements": ads must be clearly
      // labelled and visually distinguishable from app content. The banner sits
      // in the bottomNavigationBar slot — right where kids expect game buttons —
      // so it gets an explicit ADVERTISEMENT caption plus a neutral grey tray
      // and a divider that visually detach it from the colourful game UI.
      final isDark = Theme.of(context).brightness == Brightness.dark;
      final trayColor = isDark ? const Color(0xFF14141C) : const Color(0xFFECEFF1);
      final dividerColor =
          isDark ? const Color(0xFF2E2E3A) : const Color(0xFFCFD8DC);
      final labelColor =
          isDark ? const Color(0xFF9AA0A6) : const Color(0xFF5F6368);

      return SafeArea(
        top: false,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: trayColor,
            border: Border(top: BorderSide(color: dividerColor, width: 1)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Label strip — deliberately plain system type (not the game's
              // playful font) so it reads as chrome, not content.
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
                  child: Row(
                    children: [
                      Icon(Icons.campaign_outlined, size: 11, color: labelColor),
                      const SizedBox(width: 4),
                      Text(
                        AppStrings.advertisement,
                        style: TextStyle(
                          fontSize: 9,
                          height: 1.0,
                          letterSpacing: 0.8,
                          fontWeight: FontWeight.w700,
                          color: labelColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: ad.size.height.toDouble(),
                width: ad.size.width.toDouble(),
                child: AdWidget(ad: ad),
              ),
              const SizedBox(height: 2),
            ],
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