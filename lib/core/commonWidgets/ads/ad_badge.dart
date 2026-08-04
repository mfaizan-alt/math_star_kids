import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/app_strings.dart';

/// Shared colours for any control that launches an advertisement.
///
/// Google Play Families "Ad format requirements" reject ads or ad entry points
/// that aren't clearly distinguishable from app content. So ad controls use a
/// flat neutral grey tray — deliberately unlike the game's bright gradient +
/// glow buttons — and never the playful game palette.
class AdSurfaceStyle {
  const AdSurfaceStyle._();

  static const Color background = Color(0xFFECEFF1);
  static const Color border = Color(0xFFB0BEC5);
  static const Color foreground = Color(0xFF37474F);
  static const Color badge = Color(0xFF546E7A);
}

/// Small high-contrast "Ad" chip.
///
/// Put this on every button that opens a rewarded ad, so a child can always
/// tell an advertisement apart from a game reward.
class AdBadge extends StatelessWidget {
  const AdBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: AdSurfaceStyle.badge,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        AppStrings.adBadge,
        style: GoogleFonts.nunito(
          fontSize: 11,
          height: 1.0,
          letterSpacing: 0.5,
          color: Colors.white,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
