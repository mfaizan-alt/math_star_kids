import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/app_strings.dart';
import '../../services/premium_service.dart';
import '../../services/stars_service.dart';
import 'ad_badge.dart';
import 'reward_ad.dart';

/// "Watch a short video to DOUBLE your stars" button for game-end screens.
///
/// Hidden when nothing was earned, when no rewarded ad is available (no dead
/// button), or on premium (no ads). One use per result screen; after the
/// reward it flips to a confirmation label.
class DoubleStarsButton extends StatefulWidget {
  final int earnedStars;

  const DoubleStarsButton({super.key, required this.earnedStars});

  @override
  State<DoubleStarsButton> createState() => _DoubleStarsButtonState();
}

class _DoubleStarsButtonState extends State<DoubleStarsButton> {
  bool _doubled = false;

  @override
  void initState() {
    super.initState();
    RewardedAdService.instance.loadAd();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.earnedStars <= 0 || PremiumService.active) {
      return const SizedBox.shrink();
    }

    if (_doubled) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Text(
          '🎉 Stars doubled! +${widget.earnedStars} ⭐',
          textAlign: TextAlign.center,
          style: GoogleFonts.aBeeZee(
            fontSize: 16,
            color: const Color(0xFFFF9F1C),
            fontWeight: FontWeight.w900,
          ),
        ),
      );
    }

    return Obx(() {
      if (!RewardedAdService.instance.isLoadedRx.value) {
        return const SizedBox.shrink();
      }
      // Google Play Families "Ad format requirements": an ad entry point must
      // never look like a game reward. So this is deliberately NOT styled like
      // the game's bright gradient buttons — neutral grey tray, no glow, an
      // explicit "Ad" badge, and wording that says an ad will play.
      return GestureDetector(
        onTap: _watchAndDouble,
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(vertical: 6),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          decoration: BoxDecoration(
            color: AdSurfaceStyle.background,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AdSurfaceStyle.border, width: 1.5),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const AdBadge(),
              const SizedBox(width: 10),
              const Icon(Icons.play_circle_outline_rounded,
                  color: AdSurfaceStyle.foreground, size: 20),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  AppStrings.watchAdDoubleStars,
                  style: GoogleFonts.nunito(
                    fontSize: 15,
                    color: AdSurfaceStyle.foreground,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  void _watchAndDouble() {
    RewardedAdService.instance.showAd(() {
      StarsService.to.addStars(widget.earnedStars, sourceName: 'Double Stars');
      if (mounted) setState(() => _doubled = true);
    });
  }
}
