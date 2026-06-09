import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:math_carnival_kids/modules/splash_screen/splash_screen_controller.dart';

import '../../core/colors/colors.dart';



class SplashScreenView extends GetView<SplashScreenController> {
  const SplashScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration:  BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.yellowColor,
              AppColors.orangeColor,
              AppColors.coralColor,
            ],
            stops: [0.0, 0.4, 1.0],
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Decorative circles
            Positioned(
              top: -80,
              left: -80,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.08),
                ),
              ),
            ),
            Positioned(
              bottom: -40,
              right: -40,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.08),
                ),
              ),
            ),
            // Content
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0, end: 1),
                  duration: const Duration(seconds: 1),
                  curve: Curves.bounceOut,
                  builder: (context, value, child) {
                    return Transform.translate(
                      offset: Offset(0, -20 * value),
                      child: const Text(
                        '🦉',
                        style: TextStyle(fontSize: 90),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                Text(
                  'LearnQuest',
                  style: GoogleFonts.aBeeZee(
                    fontSize: 38,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        offset: const Offset(0, 4),
                        blurRadius: 12,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Learn · Play · Grow',
                  style: GoogleFonts.googleSans(
                    fontSize: 16,
                    color: Colors.white.withValues(alpha: 0.85),
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 50),
                // Loading bar
                Container(
                  width: 140,
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.centerLeft,
                  child: TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0, end: 1),
                    duration: const Duration(seconds: 3),
                    builder: (context, value, _) {
                      return FractionallySizedBox(
                        widthFactor: value,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                // Dots
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     Container(
                //       width: 28,
                //       height: 10,
                //       decoration: BoxDecoration(
                //         color: Colors.white,
                //         borderRadius: BorderRadius.circular(5),
                //       ),
                //     ),
                //     const SizedBox(width: 8),
                //     Container(
                //       width: 10,
                //       height: 10,
                //       decoration: const BoxDecoration(
                //         color: Colors.white38,
                //         shape: BoxShape.circle,
                //       ),
                //     ),
                //     const SizedBox(width: 8),
                //     Container(
                //       width: 10,
                //       height: 10,
                //       decoration: const BoxDecoration(
                //         color: Colors.white38,
                //         shape: BoxShape.circle,
                //       ),
                //     ),
                //   ],
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
