// math_quiz_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:math_carnival_kids/modules/math_question_view/quiz_game_view/quiz_game_controller.dart';
import '../../../core/colors/colors.dart';

class QuizGameView extends GetView<QuizGameController> {
  const QuizGameView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8E8FF), // light purple like reference
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Back Button
              _buildBackButton(),
              const SizedBox(height: 20),

              // Progress Section
              _buildProgressSection(),
              const SizedBox(height: 40),

              // Question Card
              _buildQuestionCard(),
              const SizedBox(height: 40),

              // Answer Buttons
              _buildAnswerGrid(),
              const SizedBox(height: 16),
              _buildFeedback(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // ── Back Button ─────────────────────────────────
  Widget _buildBackButton() {
    return Align(
      alignment: Alignment.centerLeft,
      child: GestureDetector(
        onTap: () => Get.back(),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 16,
                color: Color(0xFF7B2FBE),
              ),
              const SizedBox(width: 6),
              Text(
                'Back',
                style: GoogleFonts.aBeeZee(
                  fontSize: 16,
                  color: const Color(0xFF7B2FBE),
                ),
              ),
            ],
          ),
        ),
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
                  'Progress',
                  style: GoogleFonts.aBeeZee(
                    fontSize: 18,
                    color: const Color(0xFF7B2FBE),
                  ),
                ),
              ],
            ),
            Text(
              '${controller.currentIndex.value + 1}/10',
              style: GoogleFonts.aBeeZee(
                fontSize: 18,
                color: const Color(0xFF7B2FBE),
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
              Color(0xFFFF9F1C),
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
      dotColor = const Color(0xFF7B2FBE);
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
            color: const Color(0xFF7B2FBE).withValues(alpha: 0.2),
            width: 2.5,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF7B2FBE).withValues(alpha: 0.12),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            // Expression
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '${q['a']}',
                    style: GoogleFonts.aBeeZee(
                      fontSize: 52,
                      color: const Color(0xFF7B2FBE),
                    ),
                  ),
                  TextSpan(
                    text: ' × ',
                    style: GoogleFonts.aBeeZee(
                      fontSize: 52,
                      color: const Color(0xFF7B2FBE),
                    ),
                  ),
                  TextSpan(
                    text: '${q['b']}',
                    style: GoogleFonts.aBeeZee(
                      fontSize: 52,
                      color: const Color(0xFF7B2FBE),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // = ?
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
        btnColor = const Color(0xFF7B2FBE);
        shadowColor = const Color(0xFF7B2FBE).withValues(alpha: 0.4);
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
        btnColor = const Color(0xFF7B2FBE).withValues(alpha: 0.3);
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
    return Obx(() {
      if (!controller.showFeedback.value) {
        // Empty space so layout doesn't jump
        return const SizedBox(height: 70);
      }

      final isCorrect = controller.isCorrectFeedback.value;

      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [

              Text(
                controller.feedbackMessage.value,
                textAlign: TextAlign.center,
                style: GoogleFonts.aBeeZee(
                  fontSize: 22,
                  color: isCorrect
                      ? AppColors.mintGreen
                      : AppColors.coralColor,
                ),
              ),
              if (!isCorrect && controller.hintMessage.value.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  controller.hintMessage.value,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.nunito(
                    fontSize: 15,
                    color: AppColors.navy,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    });
  }
}