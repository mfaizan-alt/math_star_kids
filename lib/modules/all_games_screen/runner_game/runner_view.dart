import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:confetti/confetti.dart';
import 'package:get/get.dart';
import 'package:math_carnival_kids/modules/all_games_screen/runner_game/runner_controller.dart';
import '../../../core/colors/colors.dart';
import '../../../core/commonWidgets/ads/ad_badge.dart';
import '../../../core/commonWidgets/ads/ad_manager.dart';
import '../../../core/commonWidgets/ads/reward_ad.dart';
import '../../../core/commonWidgets/theme.dart';
import '../../../core/commonWidgets/screen_header.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/commonWidgets/ads/banner_ads.dart';

class RunnerGameScreen extends StatefulWidget {
  const RunnerGameScreen({super.key});

  @override
  State<RunnerGameScreen> createState() => _RunnerGameScreenState();
}

class _RunnerGameScreenState extends State<RunnerGameScreen>
    with TickerProviderStateMixin {

  final RunnerGameController controller = Get.put(RunnerGameController());

  // ── Pure UI animation controllers (no game logic) ──
  late AnimationController _runController;
  late AnimationController _obstacleController;
  late AnimationController _feedbackController;

  int _characterFrame = 0;
  Timer? _characterAnimTimer;
  Worker? _feedbackWorker;

  @override
  void initState() {
    super.initState();

    _runController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat();

    _obstacleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    );

    _feedbackController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _characterAnimTimer = Timer.periodic(
      const Duration(milliseconds: 200),
          (_) {
        if (mounted &&
            controller.isGameStarted.value &&
            !controller.isGameOver.value) {
          setState(() => _characterFrame = (_characterFrame + 1) % 4);
        }
      },
    );

    // React to feedback: play animation then notify controller
    _feedbackWorker = ever(controller.showFeedback, (bool showing) {
      if (showing) {
        _feedbackController.forward(from: 0).then((_) {
          if (!mounted) return;
          controller.onFeedbackDone();
          if (!controller.isGameOver.value) {
            _startObstacleAnimation();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _feedbackWorker?.dispose();
    _runController.dispose();
    _obstacleController.dispose();
    _feedbackController.dispose();
    _characterAnimTimer?.cancel();
    super.dispose();
  }

  void _startObstacleAnimation() {
    final duration = Duration(
      milliseconds: (4000 / controller.gameSpeed.value).round(),
    );
    _obstacleController.duration = duration;
    _obstacleController.forward(from: 0).then((_) {
      if (mounted && !controller.isGameOver.value) {
        controller.checkAnswer();
      }
    });
  }

  void _onStartGame() {
    controller.startGame();
    _startObstacleAnimation();
  }

  @override
  Widget build(BuildContext context) {
    return StatusBarIcons(
      light: false,
      child: _buildScreen(context),
    );
  }

  Widget _buildScreen(BuildContext context) {
    return Obx(() {
      final isDark = Get.find<ThemeController>().isDarkMode;

      return Scaffold(
        bottomNavigationBar: const BannerAdWidget(),
        body: Stack(
          children: [
            _buildBackground(),
            SafeArea(
              child: Obx(() => Column(
                children: [
                  _buildTopBar(),
                  Expanded(
                    child: controller.isGameStarted.value
                        ? _buildGameArea()
                        : controller.isGameOver.value
                        ? _buildGameOverScreen(isDark)
                        : _buildStartScreen(),
                  ),
                ],
              )),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: controller.confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                colors: const [
                  AppColors.correct,
                  AppColors.star,
                  AppColors.primaryLight,
                  Colors.pink,
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF87CEEB),
            const Color(0xFF98FB98).withValues(alpha: 0.5),
            const Color(0xFF90EE90),
          ],
          stops: const [0.0, 0.6, 1.0],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    // Already inside Obx from build()
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
            style: IconButton.styleFrom(backgroundColor: Colors.black26),
          ),
          if (controller.isGameStarted.value) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Text('⭐', style: TextStyle(fontSize: 18)),
                  const SizedBox(width: 6),
                  Text(
                    '${controller.score.value}',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryLight,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: List.generate(3, (i) {
                return Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Icon(
                    i < controller.lives.value
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: i < controller.lives.value
                        ? Colors.red
                        : Colors.grey,
                    size: 28,
                  ),
                );
              }),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStartScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildCharacterWidget(isLarge: true),
          const SizedBox(height: 32),
          Text(
            AppStrings.runnerTitle,
            style: GoogleFonts.poppins(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [
                Shadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(2, 2),
                ),
              ],
            ),
          ).animate().fadeIn().slideY(begin: -0.2),
          const SizedBox(height: 12),
          Text(
            AppStrings.runnerTagline,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ).animate().fadeIn(delay: 200.ms),
          const SizedBox(height: 8),
          Text(
            '👈 Swipe Left or Right 👉',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.white70,
              fontWeight: FontWeight.w500,
            ),
          ).animate().fadeIn(delay: 400.ms),
          const SizedBox(height: 40),
          GestureDetector(
            onTap: _onStartGame,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primaryLight, Color(0xFF8B5CF6)],
                ),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryLight.withValues(alpha: 0.5),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Text(
                '▶  START GAME',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ).animate().fadeIn(delay: 600.ms).scale(begin: const Offset(0.8, 0.8)),
        ],
      ),
    );
  }

  Widget _buildGameArea() {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.velocity.pixelsPerSecond.dx > 100) {
          controller.moveRight();
        } else if (details.velocity.pixelsPerSecond.dx < -100) {
          controller.moveLeft();
        }
      },
      onTapUp: (details) {
        final width = MediaQuery.of(context).size.width;
        if (details.localPosition.dx < width / 3) {
          controller.moveLeft();
        } else if (details.localPosition.dx > width * 2 / 3) {
          controller.moveRight();
        }
      },
      child: Container(
        color: Colors.transparent,
        child: Obx(() {
          final isDark = Get.find<ThemeController>().isDarkMode;
          return Column(
            children: [
              const SizedBox(height: 20),
              _buildQuestionBubble(isDark), // ✅
              const Spacer(),
              _buildAnswerLanes(),
              const SizedBox(height: 20),
              _buildRunnerArea(),
              const SizedBox(height: 20),
              _buildLaneButtons(),
              const SizedBox(height: 16),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildQuestionBubble(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1F1F1F) : Colors.white, // ✅
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryLight.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            AppStrings.solveIt,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: AppColors.primaryLight,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${controller.num1.value} ${controller.operator_.value} ${controller.num2.value} = ?',
            style: GoogleFonts.poppins(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : const Color(0xFF2D3142), // ✅
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnswerLanes() {
    return AnimatedBuilder(
      animation: _obstacleController,
      builder: (context, _) {
        final progress = _obstacleController.value;
        return Transform.translate(
          offset: Offset(0, progress * 200 - 150),
          child: Opacity(
            opacity: (1 - progress * 0.3).clamp(0.5, 1.0),
            child: Obx(() => Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(3, (index) {
                final isCorrectLane =
                    controller.answers[index] == controller.correctAnswer.value;
                final isSelected = controller.currentLane.value == index;
                final showResult = controller.showFeedback.value;

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: showResult
                        ? (isCorrectLane
                        ? AppColors.correct.withValues(alpha: 0.9)
                        : (isSelected
                        ? AppColors.incorrect.withValues(alpha: 0.9)
                        : Colors.white.withValues(alpha: 0.9)))
                        : (isSelected
                        ? AppColors.primaryLight.withValues(alpha: 0.15)
                        : Colors.white.withValues(alpha: 0.9)),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primaryLight
                          : Colors.grey.withValues(alpha: 0.3),
                      width: isSelected ? 3 : 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: (isSelected
                            ? AppColors.primaryLight
                            : Colors.grey)
                            .withValues(alpha: 0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      '${controller.answers[index]}',
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: showResult
                            ? (isCorrectLane || isSelected
                            ? Colors.white
                            : const Color(0xFF2D3142))
                            : const Color(0xFF2D3142),
                      ),
                    ),
                  ),
                );
              }),
            )),
          ),
        );
      },
    );
  }

  Widget _buildRunnerArea() {
    return Obx(() {
      final screenWidth = MediaQuery.of(context).size.width;
      final laneWidth = screenWidth / 3;
      final targetX = laneWidth * controller.currentLane.value + laneWidth / 2 - 40;

      return SizedBox(
        height: 100,
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFF8B7355).withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildLaneDivider(),
                    _buildLaneDivider(),
                  ],
                ),
              ),
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutBack,
              left: targetX,
              top: 10,
              child: _buildCharacterWidget(),
            ),
            if (controller.showFeedback.value)
              Center(
                child: Text(
                  controller.isCorrect.value ? '✅ Correct!' : '❌ Wrong!',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: controller.isCorrect.value
                        ? AppColors.correct
                        : AppColors.incorrect,
                  ),
                ),
              ).animate().scale(begin: const Offset(0.5, 0.5)).fadeIn(),
          ],
        ),
      );
    });
  }

  Widget _buildLaneDivider() {
    return Container(
      width: 3,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildCharacterWidget({bool isLarge = false}) {
    final size = isLarge ? 120.0 : 80.0;
    final fontSize = isLarge ? 60.0 : 44.0;
    final frames = ['🏃', '🏃‍♂️', '🏃', '🏃‍♂️'];
    final currentEmoji =
    controller.isGameStarted.value ? frames[_characterFrame] : '🧍';

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.primaryLight.withValues(alpha: 0.15),
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.primaryLight.withValues(alpha: 0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryLight.withValues(alpha: 0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: AnimatedBuilder(
          animation: _runController,
          builder: (context, _) {
            final bounce =
                sin(_runController.value * 2 * pi) * (isLarge ? 4 : 3);
            return Transform.translate(
              offset: Offset(0, controller.isGameStarted.value ? bounce : 0),
              child: Text(currentEmoji, style: TextStyle(fontSize: fontSize)),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLaneButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildDirectionButton(
              Icons.arrow_back_rounded, AppStrings.left, controller.moveLeft),
          Obx(() => Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${AppStrings.speed}: ${controller.gameSpeed.value.toStringAsFixed(1)}x',
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryLight,
              ),
            ),
          )),
          _buildDirectionButton(
              Icons.arrow_forward_rounded, AppStrings.right, controller.moveRight),
        ],
      ),
    );
  }

  Widget _buildDirectionButton(
      IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primaryLight, size: 24),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryLight,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameOverScreen(bool isDark) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(32),
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1F1F1F) : Colors.white, // ✅
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(controller.gameOverEmoji, style: const TextStyle(fontSize: 64)),
            const SizedBox(height: 16),
            Text(
              AppStrings.gameOverExcl,
              style: GoogleFonts.poppins(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF2D3142), // ✅
              ),
            ),
            const SizedBox(height: 8),
            Text(
              controller.gameOverMessage,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: isDark ? Colors.white54 : Colors.grey[600], // ✅
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.star.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('⭐', style: TextStyle(fontSize: 24)),
                  const SizedBox(width: 8),
                  Text(
                    '${AppStrings.score}: ${controller.score.value}',
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF2D3142), // ✅
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Only offer the revive when a rewarded ad is actually available.
            Obx(() => RewardedAdService.instance.isLoadedRx.value
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _buildRewardedButton(
                      emoji: '❤️',
                      label: AppStrings.watchAdGetLife,
                      onTap: () {
                        RewardedAdService.instance.showAd(() {
                          controller.reviveWithLife();
                          _startObstacleAnimation();
                        });
                      },
                    ),
                  )
                : const SizedBox()),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildGameOverButton(AppStrings.home, isDark, () {
                  AdManager.instance.show(); // ✅ load interstitial ad
                  Future.delayed(const Duration(milliseconds: 300), () {
                    if (mounted) Navigator.pop(context); // ✅ navigate after ad
                  });
                }),
                const SizedBox(width: 16),
                _buildGameOverButton(AppStrings.retry, isDark, () {
                  AdManager.instance.show();
                  Future.delayed(const Duration(milliseconds: 300), () {
                    if (mounted) _onStartGame();
                  });
                }, isPrimary: true),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn().scale(begin: const Offset(0.8, 0.8));
  }

  Widget _buildRewardedButton({
    required String emoji,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        // Neutral ad styling + "Ad" badge — an ad entry point must never look
        // like a game reward button (Play Families ad-format requirement).
        decoration: BoxDecoration(
          color: AdSurfaceStyle.background,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AdSurfaceStyle.border, width: 1.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const AdBadge(),
            const SizedBox(width: 10),
            Text(emoji, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AdSurfaceStyle.foreground,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameOverButton(String label, bool isDark, VoidCallback onTap,
      {bool isPrimary = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        decoration: BoxDecoration(
          gradient: isPrimary
              ? const LinearGradient(
              colors: [AppColors.primaryLight, Color(0xFF8B5CF6)])
              : null,
          color: isPrimary
              ? null
              : isDark ? const Color(0xFF2C2C2C) : Colors.grey[100], // ✅
          borderRadius: BorderRadius.circular(20),
          boxShadow: isPrimary
              ? [
            BoxShadow(
              color: AppColors.primaryLight.withValues(alpha: 0.4),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ]
              : null,
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: isPrimary
                ? Colors.white
                : isDark ? Colors.white : const Color(0xFF2D3142), // ✅
          ),
        ),
      ),
    );
  }
}