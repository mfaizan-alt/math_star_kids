import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

/// Controls status-bar icon brightness for screens without an AppBar.
/// Use `light: true` on dark/colorful backgrounds, `light: false` on
/// light backgrounds (or pass the theme brightness for adaptive screens).
class StatusBarIcons extends StatelessWidget {
  const StatusBarIcons({super.key, required this.light, required this.child});

  final bool light;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: (light ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark)
          .copyWith(statusBarColor: Colors.transparent),
      child: child,
    );
  }
}

/// Rounded translucent back button — the same style used by the
/// Story Mode and Math section headers. Use everywhere a screen
/// needs a back affordance so the app stays visually consistent.
class CircleBackButton extends StatelessWidget {
  const CircleBackButton({
    super.key,
    this.iconColor = Colors.white,
    this.backgroundColor,
  });

  final Color iconColor;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.back(),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          Icons.arrow_back_ios_new_rounded,
          color: iconColor,
          size: 18,
        ),
      ),
    );
  }
}

/// [CircleBackButton] adapted for use as an [AppBar.leading] widget.
Widget appBarBackButton(BuildContext context) {
  final onSurface = Theme.of(context).colorScheme.onSurface;
  return Center(
    child: CircleBackButton(
      iconColor: onSurface,
      backgroundColor: onSurface.withValues(alpha: 0.08),
    ),
  );
}

/// Gradient screen header matching the Story Mode / Math section style:
/// extends behind the status bar, rounded bottom corners, circle back
/// button, emoji + title + subtitle.
class ScreenHeader extends StatelessWidget {
  const ScreenHeader({
    super.key,
    required this.colors,
    required this.emoji,
    required this.title,
    required this.subtitle,
    this.bottom,
  });

  final List<Color> colors;
  final String emoji;
  final String title;
  final String subtitle;

  /// Optional extra content below the title row (e.g. stat chips).
  final Widget? bottom;

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20, topPad + 12, 20, 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleBackButton(),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 40)),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.fredoka(
                        fontSize: 28,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: GoogleFonts.nunito(
                        fontSize: 14,
                        color: Colors.white.withValues(alpha: 0.85),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (bottom != null) ...[
            const SizedBox(height: 16),
            bottom!,
          ],
        ],
      ),
    );
  }
}
