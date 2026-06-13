import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../services/premium_service.dart';
import '../../services/stars_service.dart';
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
      return GestureDetector(
        onTap: _watchAndDouble,
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(vertical: 6),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFF9F1C), Color(0xFFFFD200)],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFF9F1C).withValues(alpha: 0.4),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.play_circle_fill_rounded,
                  color: Colors.white, size: 22),
              const SizedBox(width: 8),
              Text(
                'Double your ⭐ ×2',
                style: GoogleFonts.aBeeZee(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
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
