import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:confetti/confetti.dart';

import '../../../core/commonWidgets/ads/ad_manager.dart';
import '../../../core/commonWidgets/ads/reward_ad.dart';
import '../../../core/commonWidgets/theme.dart';
import 'frog_jump_controller.dart';
import '../../../core/commonWidgets/screen_header.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/commonWidgets/ads/banner_ads.dart';

class FrogJumpScreen extends StatelessWidget {
  FrogJumpScreen({super.key});

  final controller = Get.put(FrogJumpController());
  final confetti = ConfettiController(duration: const Duration(seconds: 2));

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
        body: Obx(() {
          return Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFFB3E5FC),
                      Color(0xFFC8E6C9),
                      Color(0xFF81C784),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 42,
                left: -30,
                child: _bubble(90, Colors.white.withValues(alpha: 0.15)),
              ),
              Positioned(
                top: 120,
                right: -20,
                child: _bubble(70, Colors.white.withValues(alpha: 0.12)),
              ),
              Positioned(
                bottom: 140,
                left: -18,
                child: _bubble(60, Colors.white.withValues(alpha: 0.10)),
              ),
              SafeArea(
                child: Column(
                  children: [
                    _topBar(isDark),
                    const SizedBox(height: 8),
                    if (!controller.isGameStarted.value && !controller.isGameOver.value)
                      Expanded(child: _startScreen(isDark)),
                    if (controller.isGameStarted.value)
                      Expanded(child: _gameUI(isDark)),
                    if (controller.isGameOver.value)
                      Expanded(child: _gameOver(isDark)),
                  ],
                ),
              ),
            ],
          );
        }),
      );
    });
  }

  Widget _bubble(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _topBar(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1F1F1F) : Colors.white.withValues(alpha: 0.88),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.arrow_back_rounded),
              color: isDark ? Colors.white : const Color(0xFF1B5E20),
            ),
            Row(
              children: [
                const Text('⭐', style: TextStyle(fontSize: 20)),
                const SizedBox(width: 6),
                Text(
                  '${controller.score.value}',
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF1B5E20),
                  ),
                ),
              ],
            ),
            Row(
              children: List.generate(
                3,
                    (i) => Icon(
                  i < controller.lives.value
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  color: i < controller.lives.value
                      ? Colors.redAccent
                      : Colors.grey.shade400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _startScreen(bool isDark) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1F1F1F) : Colors.white.withValues(alpha: 0.92),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 92,
              height: 92,
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.green.shade300, width: 3),
              ),
              child: const Center(
                child: Text('🐸', style: TextStyle(fontSize: 54)),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              AppStrings.frogJumpTitle,
              style: GoogleFonts.poppins(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF1B5E20),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              AppStrings.frogJumpTagline,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: isDark ? Colors.white70 : Colors.grey[700],
              ),
            ),
            const SizedBox(height: 18),
            _buildStartButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildStartButton() {
    return GestureDetector(
      onTap: controller.startGame,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF43A047), Color(0xFF2E7D32)],
          ),
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.green.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Text(
          AppStrings.start,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _answerPad(String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF66BB6A),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.green.shade900.withValues(alpha: 0.2),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
          border: Border.all(color: Colors.white, width: 3),
        ),
        child: Center(
          child: Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _gameUI(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1F1F1F) : Colors.white.withValues(alpha: 0.88),
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  "🐸 ${controller.num1.value} ${controller.operator.value} ${controller.num2.value}",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF1B5E20),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  AppStrings.chooseLilyPad,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: isDark ? Colors.white70 : Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Text(
              "⏱ ${controller.timeLeft.value}s",
              style: GoogleFonts.poppins(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          // Feedback lives inside the flexible space so it never adds fixed
          // height (a banner ad already trims the body; a fixed chip here
          // overflowed the column by a few pixels).
          Expanded(
            child: Center(
              child: controller.showFeedback.value
                  ? AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 10),
                      decoration: BoxDecoration(
                        color: controller.isCorrect.value
                            ? Colors.green
                            : Colors.redAccent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        controller.isCorrect.value
                            ? AppStrings.correctExcl
                            : AppStrings.oopsTryAgain,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    )
                  : const SizedBox(),
            ),
          ),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: 1.4,
            physics: const NeverScrollableScrollPhysics(),
            children: List.generate(
              5,
                  (i) => _answerPad(
                "${controller.padAnswers[i]}",
                    () => controller.jumpTo(i),
              ),
            ),
          ),
          const SizedBox(height: 14),
        ],
      ),
    );
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
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Colors.redAccent, Colors.deepOrange],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.redAccent.withValues(alpha: 0.4),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 10),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameOverBtn(String label, bool isDark, VoidCallback onTap,
      {bool isPrimary = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        decoration: BoxDecoration(
          color: isPrimary
              ? Colors.teal
              : isDark ? const Color(0xFF2C2C2C) : Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: isPrimary
                ? Colors.white
                : isDark ? Colors.white : const Color(0xFF2D3142),
          ),
        ),
      ),
    );
  }

  Widget _gameOver(bool isDark) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1F1F1F) : Colors.white.withValues(alpha: 0.95),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🪷', style: TextStyle(fontSize: 58)),
            const SizedBox(height: 10),
            Text(
              AppStrings.gameOver,
              style: GoogleFonts.poppins(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF1B5E20),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${AppStrings.score}: ${controller.score.value}',
              style: GoogleFonts.poppins(
                fontSize: 18,
                color: isDark ? Colors.white70 : Colors.black,
              ),
            ),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildGameOverBtn(AppStrings.home, isDark, () {
                  AdManager.instance.show();
                  Future.delayed(const Duration(milliseconds: 300), () {
                    Get.back();
                  });
                }),
                const SizedBox(width: 12),
                _buildGameOverBtn(AppStrings.retry, isDark, controller.restart,
                    isPrimary: true),
              ],
            ),
            // Only offer the revive when a rewarded ad is actually available.
            Obx(() => RewardedAdService.instance.isLoadedRx.value
                ? Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: _buildRewardedButton(
                      emoji: '❤️',
                      label: AppStrings.watchAdGetLife,
                      onTap: () {
                        RewardedAdService.instance.showAd(() {
                          controller.reviveWithLife();
                        });
                      },
                    ),
                  )
                : const SizedBox()),
          ],
        ),
      ),
    );
  }
}