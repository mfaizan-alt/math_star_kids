import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/colors/colors.dart';
import '../../../core/commonWidgets/all_widgets.dart';
import 'subtraction_controller.dart';

class SubtractionScreen extends StatelessWidget {
  SubtractionScreen({super.key});

  final SubtractionController controller = Get.put(SubtractionController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SubtractionController>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Subtraction ➖'),
            actions: [
              AnimatedScoreCard(
                score: controller.score,
                total: controller.totalQuestions,
                color: AppColors.subtraction,
              ),
              // SizedBox(width: 16),
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
                    _buildQuestion(context, controller),
                    const Spacer(),
                    _buildOptions(controller),
                    const SizedBox(height: 40),
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
                    AppColors.subtraction,
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDifficultySelector(SubtractionController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildDifficultyChip(controller, 'Easy', 1),
        const SizedBox(width: 8),
        _buildDifficultyChip(controller, 'Medium', 2),
        const SizedBox(width: 8),
        _buildDifficultyChip(controller, 'Hard', 3),
      ],
    );
  }

  Widget _buildDifficultyChip(
      SubtractionController controller,
      String label,
      int level,
      ) {
    final isSelected = controller.difficulty == level;

    return GestureDetector(
      onTap: () {
        controller.changeDifficulty(level);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.subtraction
              : AppColors.subtraction.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            color: isSelected ? Colors.white : AppColors.subtraction,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildProgressBar(SubtractionController controller) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Question ${controller.questionNumber + 1}/${controller.totalQuestions}',
              style: GoogleFonts.poppins(fontSize: 14),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value:
            (controller.questionNumber + 1) / controller.totalQuestions,
            minHeight: 8,
            backgroundColor: AppColors.subtraction.withValues(alpha: 0.1),
            valueColor: const AlwaysStoppedAnimation<Color>(
              AppColors.subtraction,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuestion(
      BuildContext context,
      SubtractionController controller,
      ) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.subtraction.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'What is',
            style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Text(
            '${controller.num1} - ${controller.num2} = ?',
            style: GoogleFonts.poppins(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: AppColors.subtraction,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).scale(
      begin: const Offset(0.9, 0.9),
    );
  }

  Widget _buildOptions(SubtractionController controller) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 2.5,
      physics: const NeverScrollableScrollPhysics(),
      children: controller.options.map((option) {
        bool isSelected = controller.selectedOption == option;
        bool? isCorrectOption;

        if (controller.selectedOption != null) {
          isCorrectOption = option == controller.correctAnswer;
        }

        return AnswerButton(
          text: '$option',
          onPressed: () => controller.checkAnswer(option),
          isSelected:
          isSelected ||
              (controller.selectedOption != null &&
                  option == controller.correctAnswer),
          isCorrect: isCorrectOption,
        );
      }).toList(),
    );
  }
}

class ResultDialog extends StatelessWidget {
  final int score;
  final int total;
  final int stars;
  final VoidCallback onPlayAgain;
  final VoidCallback onHome;

  const ResultDialog({
    super.key,
    required this.score,
    required this.total,
    required this.stars,
    required this.onPlayAgain,
    required this.onHome,
  });

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
              score >= 7
                  ? '🎉 Great Job!'
                  : score >= 5
                  ? '👍 Good Try!'
                  : '💪 Keep Practicing!',
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
              'Score: $score / $total',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: DialogButton(
                    text: 'Home',
                    icon: Icons.home_rounded,
                    backgroundColor: Colors.blueGrey.shade400,
                    textColor: Colors.white,
                    onPressed: onHome,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DialogButton(
                    text: 'Play Again',
                    icon: Icons.replay_rounded,
                    backgroundColor: Colors.deepPurple,
                    textColor: Colors.white,
                    onPressed: onPlayAgain,
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