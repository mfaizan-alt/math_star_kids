import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../colors/colors.dart';

/// Central text styles. Screens should use these (optionally with
/// `.copyWith(...)` for one-off tweaks) instead of constructing
/// GoogleFonts styles inline.
class AppTextStyles {
  AppTextStyles._();

  // ── Screen headers (on gradients — always white) ──
  static TextStyle get screenTitle =>
      GoogleFonts.fredoka(fontSize: 28, color: AppColors.white);

  static TextStyle get screenSubtitle => GoogleFonts.nunito(
        fontSize: 14,
        color: AppColors.white.withValues(alpha: 0.85),
        fontWeight: FontWeight.w700,
      );

  // ── Section titles (theme-aware color passed in) ──
  static TextStyle sectionTitle(Color color) =>
      GoogleFonts.aBeeZee(fontSize: 20, color: color);

  static TextStyle sectionTitleBold(Color color) => GoogleFonts.poppins(
      fontSize: 22, fontWeight: FontWeight.bold, color: color);

  // ── Cards ─────────────────────────────────────────
  static TextStyle get cardTitle => GoogleFonts.aBeeZee(
      fontSize: 17, fontWeight: FontWeight.w600, color: AppColors.white);

  static TextStyle get cardSubtitle =>
      GoogleFonts.aBeeZee(fontSize: 13, color: AppColors.white);

  // ── Body / labels ─────────────────────────────────
  static TextStyle label(Color color,
          {double size = 13, FontWeight weight = FontWeight.w800}) =>
      GoogleFonts.nunito(fontSize: size, color: color, fontWeight: weight);

  static TextStyle body(Color color, {double size = 14}) =>
      GoogleFonts.nunito(fontSize: size, color: color, fontWeight: FontWeight.w600);

  // ── Buttons ───────────────────────────────────────
  static TextStyle button(Color color, {double size = 16}) =>
      GoogleFonts.aBeeZee(fontSize: size, color: color);

  // ── Numbers / game text ───────────────────────────
  static TextStyle gameNumber(Color color, {double size = 30}) =>
      GoogleFonts.aBeeZee(fontSize: size, color: color);

  static TextStyle feedback(Color color, {double size = 22}) =>
      GoogleFonts.aBeeZee(fontSize: size, color: color);
}
