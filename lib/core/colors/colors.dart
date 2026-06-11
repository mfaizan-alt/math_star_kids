import 'package:flutter/material.dart';

class AppColors {

  // ── Primary Colors ──────────────────────────────
  static const Color yellowColor      = Color(0xFFFFD166);
  static const Color lightRed = Color(0xFFFFCDD2);
  static const Color orangeColor      = Color(0xFFFF9F1C);
  static const Color coralColor       = Color(0xFFEF476F);
  static const Color skyBlue     = Color(0xFF4CC9F0);
  static const Color mintGreen   = Color(0xFF06D6A0);
  static const Color purple      = Color(0xFF7B2FBE);

  // ── Neutral Colors ──────────────────────────────
  static const Color navy        = Color(0xFF1A1A2E);
  static const Color cream       = Color(0xFFFFFBF0);
  static const Color white       = Color(0xFFFFFFFF);
  static const Color grey        = Color(0xFF888888);
  static const Color lightGrey   = Color(0xFFEEEEEE);
  static const Color darkGrey    = Color(0xFF444444);

  // ── Gradient Colors ─────────────────────────────
  static const List<Color> splashGradient = [
    yellowColor,
    orangeColor,
    coralColor,
  ];

  static const List<Color> headerGradient = [
    skyBlue,
    purple,
  ];

  static const List<Color> buttonGradient = [
    coralColor,
    orangeColor,
  ];

  static const List<Color> successGradient = [
    mintGreen,
    skyBlue,
  ];

  static const List<Color> storyGradient = [
    coralColor,
    orangeColor,
  ];

  static const List<Color> mathGradient = [
    skyBlue,
    purple,
  ];

  static const List<Color> languageGradient = [
    mintGreen,
    skyBlue,
  ];

  static const List<Color> islamicGradient = [
    Color(0xFF0a3d1f),
    Color(0xFF1a5c2e),
  ];

  // ── Shadow Colors ────────────────────────────────
  static Color coralShadow     = coralColor.withValues(alpha: 0.4);
  static Color blueShadow      = skyBlue.withValues(alpha: 0.3);
  static Color greenShadow     = mintGreen.withValues(alpha: 0.4);
  static Color purpleShadow    = purple.withValues(alpha: 0.3);

  // ── Islamic Module ───────────────────────────────
  static const Color islamicGold        = Color(0xFFFFD166);
  static const Color islamicDarkGreen   = Color(0xFF0a3d1f);
  static const Color islamicLightGreen  = Color(0xFF1a5c2e);


  // private constructor — no one can instantiate this class
  AppColors._();


  //other apps color Math Learner app

  static const Color primaryLight = Color(0xFF6C63FF);
  static const Color primaryVariantLight = Color(0xFF3F37C9);
  static const Color secondaryLight = Color(0xFFFF6B6B);
  static const Color backgroundLight = Color(0xFFF8F9FE);
  static const Color surfaceLight = Colors.white;
  static const Color cardLight = Colors.white;
  static const Color textPrimaryLight = Color(0xFF2D3142);
  static const Color textSecondaryLight = Color(0xFF9C9EB9);

  // Dark Theme Colors
  static const Color primaryDark = Color(0xFF7C74FF);
  static const Color primaryVariantDark = Color(0xFF5A52E0);
  static const Color secondaryDark = Color(0xFFFF8A8A);
  static const Color backgroundDark = Color(0xFF1A1A2E);
  static const Color surfaceDark = Color(0xFF16213E);
  static const Color cardDark = Color(0xFF1F2940);
  static const Color textPrimaryDark = Color(0xFFF0F0F0);
  static const Color textSecondaryDark = Color(0xFF8B8DA8);

  // Module Colors (same for both themes)
  static const Color addition = Color(0xFF4ECDC4);
  static const Color subtraction = Color(0xFFFF6B6B);
  static const Color multiplication = Color(0xFFFFD93D);
  static const Color division = Color(0xFF6BCB77);
  static const Color numbers = Color(0xFF4D96FF);
  static const Color counting = Color(0xFFAD6BFF);
  static const Color quiz = Color(0xFFFF8E53);

  static const Color shapes = Color(0xFFFF6EB4);

  // Add in AppColors — dark variants for module cards
  // static const Color counting     = Color(0xFF2D9E96); // darker teal
  // static const Color addition     = Color(0xFF2D9E96); // darker teal
  // static const Color subtraction  = Color(0xFFCC3333); // darker red
  // static const Color multiplication = Color(0xFFCCA800); // darker yellow
  // static const Color division    = Color(0xFF3D8C45); // darker green
  // static const Color numbers      = Color(0xFF1A5FCC); // darker blue
  // Game Colors
  static const Color correct = Color(0xFF4ECDC4);
  static const Color incorrect = Color(0xFFFF6B6B);
  static const Color star = Color(0xFFFFD93D);
  static const Color bronze = Color(0xFFCD7F32);
  static const Color silver = Color(0xFFC0C0C0);
  static const Color gold = Color(0xFFFFD700);


}

class TC {
  // Background
  static Color bg(BuildContext context) =>
      Theme.of(context).scaffoldBackgroundColor;

  // Card / container surface
  static Color card(BuildContext context) =>
      Theme.of(context).cardTheme.color ?? Theme.of(context).colorScheme.surface;

  // Primary text
  static Color text(BuildContext context) =>
      Theme.of(context).colorScheme.onSurface;

  // Secondary / hint text
  static Color textSub(BuildContext context) =>
      Theme.of(context).colorScheme.onSurfaceVariant;

  // Divider / progress bg
  static Color divider(BuildContext context) =>
      Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.12);
}