import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:math_carnival_kids/core/commonWidgets/ads/ad_manager.dart';

import '../../../core/colors/colors.dart';
import '../../../core/commonWidgets/all_widgets.dart';
import 'multiplication_controller.dart';
import '../../../core/commonWidgets/screen_header.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/commonWidgets/ads/banner_ads.dart';

class MultiplicationScreen extends StatelessWidget {
  MultiplicationScreen({super.key});

  final MultiplicationController controller =
  Get.put(MultiplicationController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MultiplicationController>(
      builder: (controller) {
        return Scaffold(
          bottomNavigationBar: const BannerAdWidget(),
          appBar: AppBar(
            leading: appBarBackButton(context),
            title: const Text(AppStrings.multiplicationTitle),
            actions: [
              AnimatedScoreCard(
                score: controller.score,
                total: controller.totalQuestions,
                color: AppColors.multiplication,
              ),
              const SizedBox(width: 16),
            ],
          ),
          body: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildDifficultySelector(controller),
                    const SizedBox(height: 16),
                    _buildProgressBar(controller),
                    const SizedBox(height: 32),
                    _buildQuestion(controller),
                    const Spacer(),
                    _buildOptions(controller),
                  ],
                ),
              ),

              Align(
                alignment: Alignment.topCenter,
                child: ConfettiWidget(
                  confettiController: controller.confettiController,
                  blastDirectionality: BlastDirectionality.explosive,
                  shouldLoop: false,
                  colors: const [
                    AppColors.star,
                    AppColors.correct,
                    AppColors.multiplication,
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ---------------- UI SECTIONS ----------------

  Widget _buildDifficultySelector(MultiplicationController c) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _chip(c, AppStrings.easy, 1),
        const SizedBox(width: 8),
        _chip(c, AppStrings.medium, 2),
        const SizedBox(width: 8),
        _chip(c, AppStrings.hard, 3),
      ],
    );
  }

  Widget _chip(MultiplicationController c, String label, int level) {
    final isSelected = c.difficulty == level;

    return GestureDetector(
      onTap: () => c.changeDifficulty(level),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.multiplication
              : AppColors.multiplication.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            color: isSelected ? Colors.white : AppColors.multiplication,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildProgressBar(MultiplicationController c) {
    return Column(
      children: [
        Text(
          '${AppStrings.question} ${c.questionNumber + 1}/${c.totalQuestions}',
          style: GoogleFonts.poppins(fontSize: 14),
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: (c.questionNumber + 1) / c.totalQuestions,
          backgroundColor: AppColors.multiplication.withValues(alpha: 0.1),
          valueColor:
          const AlwaysStoppedAnimation<Color>(AppColors.multiplication),
        ),
      ],
    );
  }

  Widget _buildQuestion(MultiplicationController c) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Theme.of(Get.context!).cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.multiplication.withValues(alpha: 0.15),
            blurRadius: 20,
          ),
        ],
      ),
      child: Column(
        children: [
          Text(AppStrings.whatIs,
              style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey)),
          const SizedBox(height: 8),
          Text(
            '${c.num1} × ${c.num2} = ?',
            style: GoogleFonts.poppins(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: AppColors.multiplication,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).scale();
  }

  Widget _buildOptions(MultiplicationController c) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 2.5,
      physics: const NeverScrollableScrollPhysics(),
      children: c.options.map((option) {
        final isSelected = c.selectedOption == option;
        final isCorrect = option == c.correctAnswer;

        return AnswerButton(
          text: '$option',
          onPressed: () => c.checkAnswer(option),
          isSelected: isSelected ||
              (c.selectedOption != null && isCorrect),
          isCorrect: c.selectedOption != null ? isCorrect : null,
        );
      }).toList(),
    );
  }
}

class MultiplicationResultDialog extends StatelessWidget {
  MultiplicationResultDialog({super.key});

  final MultiplicationController controller = Get.find();

  int get stars {
    if (controller.score >= 9) return 3;
    if (controller.score >= 7) return 2;
    if (controller.score >= 5) return 1;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              controller.score >= 7
                  ? AppStrings.greatJob
                  : controller.score >= 5
                  ? AppStrings.goodTry
                  : AppStrings.keepPracticing,
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                return Icon(
                  index < stars
                      ? Icons.star_rounded
                      : Icons.star_outline_rounded,
                  color: AppColors.star,
                  size: 40,
                );
              }),
            ),

            const SizedBox(height: 16),

            Text(
              '${AppStrings.score}: ${controller.score} / ${controller.totalQuestions}',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      AdManager.instance.show();
                      Future.delayed(const Duration(milliseconds: 300), () {
                        Get.offAllNamed('/gameScreen');
                      }); // go home
                    },
                    child: const Text(AppStrings.homeShort),
                  ),
                ),
                const SizedBox(width: 12),

                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.multiplication,
                    ),
                    onPressed: () {
                      Get.back();
                      AdManager.instance.show();
                      Future.delayed(const Duration(milliseconds: 300), () {
                        controller.resetGame();
                      });
                    },
                    child: const Text(AppStrings.again),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}