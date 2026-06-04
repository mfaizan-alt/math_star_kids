import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/colors/colors.dart';
import '../../../core/commonWidgets/ads/ad_Manager.dart';
import '../../../core/commonWidgets/all_widgets.dart';
import 'addition_controller.dart';

class AdditionScreen extends StatelessWidget {
  AdditionScreen({super.key});

  final AdditionController controller = Get.put(AdditionController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AdditionController>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Addition ➕'),
            actions: [
              AnimatedScoreCard(
                score: controller.score,
                total: controller.totalQuestions,
                color: AppColors.addition,
              ),
            ],
          ),
          body: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _difficultySelector(controller),
                    const SizedBox(height: 16),
                    _progressBar(controller),
                    const SizedBox(height: 32),
                    _question(controller, context),
                    const Spacer(),
                    _options(controller),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: ConfettiWidget(
                  confettiController: controller.confettiController,
                  colors: const [
                    Colors.blue,
                    AppColors.addition,
                    AppColors.correct,
                    AppColors.star,
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _difficultySelector(AdditionController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _chip(controller, 'Easy', 1),
        const SizedBox(width: 8),
        _chip(controller, 'Medium', 2),
        const SizedBox(width: 8),
        _chip(controller, 'Hard', 3),
      ],
    );
  }

  Widget _chip(AdditionController controller, String label, int level) {
    final isSelected = controller.difficulty == level;

    return GestureDetector(
      onTap: () => controller.changeDifficulty(level),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.addition
              : AppColors.addition.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            color: isSelected ? Colors.white : AppColors.addition,
          ),
        ),
      ),
    );
  }

  Widget _progressBar(AdditionController controller) {
    return Column(
      children: [
        Text(
          'Question ${controller.questionNumber + 1}/${controller.totalQuestions}',
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: (controller.questionNumber + 1) / controller.totalQuestions,
          color: AppColors.addition,
        ),
      ],
    );
  }

  Widget _question(AdditionController controller, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          const Text("What is"),
          const SizedBox(height: 10),
          Text(
            '${controller.num1} + ${controller.num2} = ?',
            style: GoogleFonts.poppins(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: AppColors.addition,
            ),
          ),
        ],
      ),
    );
  }

  Widget _options(AdditionController controller) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      childAspectRatio: 2.5,
      crossAxisSpacing: 12,
      mainAxisSpacing: 10,
      children: controller.options.map((e) {
        final selected = controller.selectedOption == e;

        return AnswerButton(
          text: "$e",
          onPressed: () => controller.checkAnswer(e),
          isSelected: selected,
          isCorrect: controller.selectedOption != null
              ? e == controller.correctAnswer
              : null,
        );
      }).toList(),
    );
  }
}
class AdditionResultDialog extends StatelessWidget {
  final AdditionController controller = Get.find();

  AdditionResultDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final score = controller.score;
    final total = controller.totalQuestions;

    int stars = 0;
    if (score >= 9) stars = 3;
    if (score >= 7) stars = 2;
    if (score >= 5) stars = 1;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
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
                  child: FunButton(
                    text: 'Home',
                    onPressed: () {
                      Navigator.of(context).pop(); // Close dialog
                      Navigator.of(context).pop(); // Close game screen
                    },
                    color: Colors.grey,
                    icon: Icons.home_rounded,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FunButton(
                    text: 'Again',
                    onPressed: () {
                      Navigator.of(context).pop(); // close dialog first
                      AdManager.instance.show();   // then show ad
                      controller.resetGame();      // then reset
                    },
                    color: AppColors.addition,
                    icon: Icons.replay_rounded,
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