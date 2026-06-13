import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

import '../../../core/colors/colors.dart';
import '../../../core/commonWidgets/ads/banner_ads.dart';
import '../../../core/commonWidgets/theme.dart';
import '../frog_jump/frog_jump_view.dart';
import '../math-puzzle/math_puzzle_view.dart';
import '../math_circus/math_circus_view.dart';
import '../number_builder/number_builder_view.dart';
import '../number_pop/number_pop_view.dart';
import '../runner_game/runner_view.dart';
import '../speed_battle/speed_battle_view.dart';
import 'adventure_map_controller.dart';
import '../../../core/commonWidgets/screen_header.dart';
import '../../../core/constants/app_strings.dart';

class AdventureMapScreen extends StatelessWidget {
  AdventureMapScreen({super.key});

  final AdventureMapController controller = Get.put(AdventureMapController());

  @override
  Widget build(BuildContext context) {
    return StatusBarIcons(
      light: false,
      child: _buildScreen(context),
    );
  }

  Widget _buildScreen(BuildContext context) {
    return Obx(() {
      final totalStars = controller.totalStars;
      final isDark = Get.find<ThemeController>().isDarkMode;

      final levels = [
        _MapLevel(AppStrings.gameMathRunner, '🏃', 0, const RunnerGameScreen(), const Color(0xFF6BCB77), '/mathRunner'),
        _MapLevel(AppStrings.gameNumberPop, '🫧', 10, const NumberPopScreen(), const Color(0xFFFF6EB4), '/numberPop'),
        _MapLevel(AppStrings.gameMathPuzzle, '🧩', 25, const MathPuzzleScreen(), const Color(0xFFFFD93D), '/mathPuzzle'),
        _MapLevel(AppStrings.gameMathCircus, '🎪', 40, const MathCircusScreen(), const Color(0xFFDC143C), '/mathCircus'),
        _MapLevel(AppStrings.gameNumberBuilder, '🏗️', 60, const NumberBuilderScreen(), const Color(0xFF764ba2), '/numberBuilder'),
        _MapLevel(AppStrings.gameFrogJump, '🐸', 80, FrogJumpScreen(), const Color(0xFF2E7D32), '/frogJump'),
        _MapLevel(AppStrings.gameSpeedBattle, '⚡', 100, SpeedBattleScreen(), const Color(0xFFFF6B6B), '/speedBattle'),
      ];

      return Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Stack(
            children: [
              // gradient stays same
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF87CEEB),
                      Color(0xFF98FB98),
                      Color(0xFF90EE90),
                    ],
                  ),
                ),
              ),
              SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.arrow_back_rounded),
                            style: IconButton.styleFrom(backgroundColor: Colors.white54),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF1F1F1F) : Colors.white.withValues(alpha: 0.9), // ✅
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '⭐ $totalStars Stars',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : const Color(0xFF2D3142), // ✅
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '🗺️ Adventure Map',
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF2D3142), // ✅
                      ),
                    ).animate().fadeIn(),
                    Text(
                      AppStrings.unlockByStars,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: isDark ? Colors.white70 : Colors.grey[700], // ✅
                      ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        itemCount: levels.length,
                        itemBuilder: (context, index) {
                          final level = levels[index];
                          final isUnlocked = totalStars >= level.starsRequired;
                          final isLeft = index.isEven;

                          return Column(
                            children: [
                              if (index > 0)
                                Container(
                                  height: 30,
                                  width: 3,
                                  color: isUnlocked ? AppColors.correct : Colors.grey[300],
                                ),
                              Row(
                                mainAxisAlignment: isLeft
                                    ? MainAxisAlignment.start
                                    : MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    onTap: () => controller.onLevelTap(
                                      route: level.route,
                                      name: level.name,
                                      screen: level.screen,
                                      starsRequired: level.starsRequired,
                                    ),
                                    child: Container(
                                      width: 200,
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: isUnlocked
                                            ? isDark ? const Color(0xFF1F1F1F) : Colors.white // ✅
                                            : isDark ? const Color(0xFF2C2C2C) : Colors.grey[200], // ✅
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: isUnlocked
                                              ? level.color
                                              : isDark ? Colors.grey[600]! : Colors.grey[400]!, // ✅
                                          width: 2,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 48,
                                            height: 48,
                                            decoration: BoxDecoration(
                                              color: isUnlocked
                                                  ? level.color.withValues(alpha: 0.2)
                                                  : isDark ? Colors.grey[700] : Colors.grey[300], // ✅
                                              shape: BoxShape.circle,
                                            ),
                                            child: Center(
                                              child: Text(
                                                isUnlocked ? level.emoji : '🔒',
                                                style: const TextStyle(fontSize: 24),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  level.name,
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    color: isUnlocked
                                                        ? isDark ? Colors.white : const Color(0xFF2D3142) // ✅
                                                        : Colors.grey,
                                                  ),
                                                ),
                                                Text(
                                                  isUnlocked
                                                      ? AppStrings.playNowShort
                                                      : '⭐ ${level.starsRequired} to unlock',
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 11,
                                                    color: isUnlocked
                                                        ? level.color
                                                        : isDark ? Colors.grey[400] : Colors.grey[500], // ✅
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ).animate().fadeIn(delay: Duration(milliseconds: 100 * index)).slideX(
                                    begin: isLeft ? -0.2 : 0.2,
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: const BannerAdWidget(), // uses default real banner ID

      );
    });
  }
}

class _MapLevel {
  final String name, emoji;
  final int starsRequired;
  final Widget screen;
  final Color color;
  final String route;

  _MapLevel(this.name, this.emoji, this.starsRequired, this.screen, this.color, this.route);
}