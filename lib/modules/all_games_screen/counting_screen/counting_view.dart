import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/colors/colors.dart';
import '../../../core/commonWidgets/screen_header.dart';
import '../../../core/constants/app_strings.dart';
import 'counting_controller.dart';
import '../../../core/commonWidgets/ads/ad_manager.dart';
import '../../../core/commonWidgets/ads/banner_ads.dart';

class CountingScreen extends StatelessWidget {
  CountingScreen({super.key});

  final CountingController controller =
  Get.put(CountingController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CountingController>(
      builder: (controller) {
        return Scaffold(
          bottomNavigationBar: const BannerAdWidget(),
          appBar: AppBar(
            leading: appBarBackButton(context),
            title: const Text(AppStrings.countingTitle),
            actions: [
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                margin: const EdgeInsets.only(right: 16),
                decoration: BoxDecoration(
                  color: AppColors.counting.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '⭐ ${controller.score}/${controller.totalRounds}',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    color: AppColors.counting,
                  ),
                ),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  '${AppStrings.round} ${(controller.round + 1).clamp(1, controller.totalRounds)} ${AppStrings.of} ${controller.totalRounds}',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: ((controller.round + 1).clamp(1, controller.totalRounds)) / controller.totalRounds,
                  color: AppColors.counting,
                ),
                const SizedBox(height: 24),

                Text(
                  AppStrings.countTheItems,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 24),

                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: AppColors.counting.withValues(alpha: 0.2),
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        alignment: WrapAlignment.center,
                        children: List.generate(controller.targetNumber,
                                (index) {
                              return Text(
                                controller.emoji,
                                style: const TextStyle(fontSize: 36),
                              )
                                  .animate()
                                  .fadeIn(delay: Duration(milliseconds: 100 * index))
                                  .scale(begin: const Offset(0, 0));
                            }),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                if (controller.showFeedback)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: (controller.isCorrect
                          ? AppColors.correct
                          : AppColors.incorrect)
                          .withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      controller.isCorrect
                          ? AppStrings.correctTick
                          : AppStrings.tryAgainCross,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: controller.isCorrect
                            ? AppColors.correct
                            : AppColors.incorrect,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ).animate().fadeIn().shake()
                else ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _btn(Icons.remove, controller.decrement),
                      const SizedBox(width: 24),
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: AppColors.counting.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.counting,
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '${controller.currentNumber}',
                            style: GoogleFonts.poppins(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: AppColors.counting,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 24),
                      _btn(Icons.add, controller.increment),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: controller.submitAnswer,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.counting,
                      ),
                      child: const Text(AppStrings.submitAnswer),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _btn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: AppColors.coralColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(icon, color: Colors.white),
      ),
    );
  }
}

class CountingResultDialog extends StatelessWidget {
  CountingResultDialog({
    super.key,
    required this.score,
    required this.total,
  });

  final int score;
  final int total;

  final CountingController controller = Get.find();

  @override
  Widget build(BuildContext context) {
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
              score >= 8
                  ? AppStrings.amazing
                  : score >= 5
                  ? AppStrings.goodJob
                  : AppStrings.keepTrying,
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            Text(
              'You got $score/$total correct!',
              style: GoogleFonts.poppins(fontSize: 18),
            ),

            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back(); // close dialog
                      Get.back(); // go home
                    },
                    child: const Text(AppStrings.homeShort),
                  ),
                ),
                const SizedBox(width: 12),

                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.counting,
                    ),
                    onPressed: () {
                      Get.back(); // close dialog
                      AdManager.instance.showOnGameEnd();
                      controller.resetGame();
                    },
                    child: const Text(AppStrings.playAgain),
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