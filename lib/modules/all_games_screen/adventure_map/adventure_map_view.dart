import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../../core/colors/colors.dart';
import '../frog_jump/frog_jump_view.dart';
import '../math-puzzle/math_puzzle_view.dart';
import '../math_circus/math_circus_view.dart';
import '../number_builder/number_builder_view.dart';
import '../number_pop/number_pop_view.dart';
import '../runner_game/runner_view.dart';
import '../speed_battle/speed_battle_view.dart';
import 'adventure_map_controller.dart';

class AdventureMapScreen extends StatelessWidget {
  AdventureMapScreen({super.key});


  final controller = Get.put(AdventureMapController());
  @override
  Widget build(BuildContext context) {

    final totalStars = controller.totalStars;

    final levels = [
      _MapLevel('Math Runner', '🏃', 0, const RunnerGameScreen(), const Color(0xFF6BCB77)),
      _MapLevel('Number Pop', '🫧', 10, const NumberPopScreen(), const Color(0xFFFF6EB4)),
      _MapLevel('Math Puzzle', '🧩', 25, const MathPuzzleScreen(), const Color(0xFFFFD93D)),
      _MapLevel('Math Circus', '🎪', 40, const MathCircusScreen(), const Color(0xFFDC143C)),
      _MapLevel('Number Builder', '🏗️', 60, const NumberBuilderScreen(), const Color(0xFF764ba2)),
      _MapLevel('Frog Jump', '🐸', 80,  FrogJumpScreen(), const Color(0xFF2E7D32)),
      _MapLevel('Speed Battle', '⚡', 100,  SpeedBattleScreen(), const Color(0xFFFF6B6B)),
    ];

    return Scaffold(
      body: Stack(children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF87CEEB),
                Color(0xFF98FB98),
                Color(0xFF90EE90)
              ],
            ),
          ),
        ),

        SafeArea(
          child: Column(children: [
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
                      color: Colors.white.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '⭐ $totalStars Stars',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
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
                color: const Color(0xFF2D3142),
              ),
            ).animate().fadeIn(),

            Text(
              'Unlock new games by earning stars!',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey[700],
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

                  return Column(children: [
                    if (index > 0)
                      Container(
                        height: 30,
                        width: 3,
                        color: isUnlocked ? AppColors.correct : Colors.grey[300],
                      ),

                    Row(
                      mainAxisAlignment:
                      isLeft ? MainAxisAlignment.start : MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: isUnlocked
                              ? () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => level.screen,
                            ),
                          )
                              : null,
                          child: Container(
                            width: 200,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isUnlocked ? Colors.white : Colors.grey[200],
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isUnlocked
                                    ? level.color
                                    : Colors.grey[400]!,
                                width: 2,
                              ),
                            ),
                            child: Row(children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: isUnlocked
                                      ? level.color.withValues(alpha: 0.2)
                                      : Colors.grey[300],
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
                                            ? const Color(0xFF2D3142)
                                            : Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      isUnlocked
                                          ? 'Play now!'
                                          : '⭐ ${level.starsRequired} to unlock',
                                      style: GoogleFonts.poppins(
                                        fontSize: 11,
                                        color: isUnlocked
                                            ? level.color
                                            : Colors.grey[500],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ]),
                          ),
                        )
                            .animate()
                            .fadeIn(delay: Duration(milliseconds: 100 * index))
                            .slideX(begin: isLeft ? -0.2 : 0.2),
                      ],
                    ),
                  ]);
                },
              ),
            ),
          ]),
        ),
      ]),
    );
  }
}

class _MapLevel {
  final String name, emoji;
  final int starsRequired;
  final Widget screen;
  final Color color;

  _MapLevel(this.name, this.emoji, this.starsRequired, this.screen, this.color);
}