// math_quiz_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:math_carnival_kids/modules/math_question_view/quiz_game_view/quiz_game_controller.dart';
import '../../../core/colors/colors.dart';
import '../../../core/commonWidgets/screen_header.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/commonWidgets/ads/banner_ads.dart';

class QuizGameView extends GetView<QuizGameController> {
  const QuizGameView({super.key});

  @override
  Widget build(BuildContext context) {
    return StatusBarIcons(
      light: Theme.of(context).brightness == Brightness.dark,
      child: Scaffold(
        bottomNavigationBar: const BannerAdWidget(),
        backgroundColor: TC.bg(context),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 16),

                // Back Button
                _buildBackButton(),
                const SizedBox(height: 16),

                // Progress Section
                _buildProgressSection(),
                const SizedBox(height: 24),

                // Question Card
                _buildQuestionCard(),
                const SizedBox(height: 24),

                // Answer Buttons
                _buildAnswerGrid(),
                const SizedBox(height: 12),
                _buildFeedback(),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Back Button ─────────────────────────────────
  Widget _buildBackButton() {
    return const Align(
      alignment: Alignment.centerLeft,
      child: CircleBackButton(
        iconColor: AppColors.purple,
        backgroundColor: Colors.white,
      ),
    );
  }

  // ── Progress Section ────────────────────────────
  Widget _buildProgressSection() {
    return Obx(() => Column(
      children: [

        // Progress label + count
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Text('🎯', style: TextStyle(fontSize: 18)),
                const SizedBox(width: 6),
                Text(
                  AppStrings.progress,
                  style: AppTextStyles.button(AppColors.purple, size: 18),
                ),
              ],
            ),
            Text(
              '${controller.currentIndex.value + 1}/10',
              style: GoogleFonts.aBeeZee(
                fontSize: 18,
                color: AppColors.purple,
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        // Progress Bar
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: controller.progressValue,
            backgroundColor: Colors.white.withValues(alpha: 0.6),
            valueColor: const AlwaysStoppedAnimation<Color>(
              AppColors.orangeColor,
            ),
            minHeight: 14,
          ),
        ),

        const SizedBox(height: 12),

        // Progress Dots Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(controller.totalQuestions, (index) {
            final status = controller.progressStatus[index];
            return _buildProgressDot(index, status);
          }),
        ),
      ],
    ));
  }

  Widget _buildProgressDot(int index, String status) {
    Color dotColor;
    Widget child;

    if (status == 'correct') {
      dotColor = AppColors.mintGreen;
      child = const Icon(Icons.check, size: 10, color: Colors.white);
    } else if (status == 'wrong') {
      dotColor = AppColors.coralColor;
      child = const Icon(Icons.close, size: 10, color: Colors.white);
    } else if (index == controller.currentIndex.value) {
      dotColor = AppColors.purple;
      child = const Icon(Icons.circle, size: 6, color: Colors.white);
    } else {
      dotColor = Colors.transparent;
      child = Container(
        width: 20, height: 20,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.coralColor.withValues(alpha: 0.5),
            width: 2,
          ),
        ),
      );
    }

    if (status == 'empty' && index != controller.currentIndex.value) {
      return child;
    }

    return Container(
      width: 24, height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: dotColor,
      ),
      child: Center(child: child),
    );
  }

  // ── Question Card ───────────────────────────────
  Widget _buildQuestionCard() {
    return Obx(() {
      final q = controller.currentQuestion;
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: AppColors.purple.withValues(alpha: 0.2),
            width: 2.5,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.purple.withValues(alpha: 0.12),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '${q['a']}',
                    style: GoogleFonts.aBeeZee(
                      fontSize: 52,
                      color: AppColors.purple,
                    ),
                  ),
                  TextSpan(
                    text: ' ${q['op']} ',   // ← was hardcoded ' × '
                    style: GoogleFonts.aBeeZee(
                      fontSize: 52,
                      color: AppColors.purple,
                    ),
                  ),
                  TextSpan(
                    text: '${q['b']}',
                    style: GoogleFonts.aBeeZee(
                      fontSize: 52,
                      color: AppColors.purple,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '= ',
                    style: GoogleFonts.aBeeZee(
                      fontSize: 36,
                      color: AppColors.orangeColor,
                    ),
                  ),
                  TextSpan(
                    text: '?',
                    style: GoogleFonts.aBeeZee(
                      fontSize: 36,
                      color: AppColors.orangeColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  // ── Answer Grid ─────────────────────────────────
  Widget _buildAnswerGrid() {
    return Obx(() {
      final options = controller.currentQuestion['options'] as List<int>;
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 10,
          childAspectRatio: 1.4,
        ),
        itemCount: options.length,
        itemBuilder: (context, index) {
          return _buildAnswerButton(options[index]);
        },
      );
    });
  }

  Widget _buildAnswerButton(int value) {
    return Obx(() {
      final selected = controller.selectedAnswer.value;
      final correct = controller.currentQuestion['answer'] as int;
      final answered = controller.answered.value;

      // Determine button state
      Color btnColor;
      Color shadowColor;
      Color textColor = Colors.white;

      if (!answered) {
        // not answered yet
        btnColor = AppColors.purple;
        shadowColor = AppColors.purple.withValues(alpha: 0.4);
      } else if (value == correct) {
        // correct answer — always green
        btnColor = AppColors.mintGreen;
        shadowColor = AppColors.mintGreen.withValues(alpha: 0.4);
      } else if (value == selected && value != correct) {
        // wrong selected — red
        btnColor = AppColors.coralColor;
        shadowColor = AppColors.coralColor.withValues(alpha: 0.4);
      } else {
        // other options — dimmed
        btnColor = AppColors.purple.withValues(alpha: 0.3);
        shadowColor = Colors.transparent;
      }

      return GestureDetector(
        onTap: () => controller.checkAnswer(value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            color: btnColor,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.5),
              width: 2.5,
            ),
            boxShadow: [
              BoxShadow(
                color: shadowColor,
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Center(
            child: Text(
              '$value',
              style: GoogleFonts.aBeeZee(
                fontSize: 30,
                color: textColor,
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildFeedback() {
    // Fixed height in BOTH states: no layout jump and no overflow.
    return Obx(() {
      const double feedbackHeight = 80;

      if (!controller.showFeedback.value) {
        return const SizedBox(height: feedbackHeight);
      }

      final isCorrect = controller.isCorrectFeedback.value;

      return SizedBox(
        height: feedbackHeight,
        width: double.infinity,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Column(
              children: [
                Text(
                  controller.feedbackMessage.value,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.feedback(
                    isCorrect ? AppColors.mintGreen : AppColors.coralColor,
                  ),
                ),
                if (!isCorrect &&
                    controller.hintMessage.value.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    controller.hintMessage.value,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.label(AppColors.navy, size: 15),
                  ),
                ],
              ],
            ),
          ),
        ),
      );
    });
  }
}