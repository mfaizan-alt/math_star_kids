// story_detail_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:math_carnival_kids/core/commonWidgets/ads/ad_manager.dart';
import '../../core/colors/colors.dart';
import '../../core/services/stars_service.dart';
import 'story_detail_controller.dart';
import '../../core/commonWidgets/screen_header.dart';
import '../../core/constants/app_strings.dart';
import '../../core/commonWidgets/ads/banner_ads.dart';

class StoryDetailView extends GetView<StoryDetailController> {
  const StoryDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return StatusBarIcons(
      light: false,
      child: _buildScreen(context),
    );
  }

  Widget _buildScreen(BuildContext context) {
    return Obx(() => controller.storyCompleted.value
        ? _buildCelebration()
        : _buildStoryScreen(context),
    );
  }

  // ══════════════════════════════════════════════
  // MAIN STORY SCREEN
  // ══════════════════════════════════════════════
  Widget _buildStoryScreen(BuildContext context) {
    return Obx(() {
      final scene = controller.currentSceneData;
      final bg = scene['bg'] as String;
      final bgColor = controller.sceneBackground(bg);
      final accentColor = controller.sceneAccent(bg);

      return Scaffold(
        bottomNavigationBar: const BannerAdWidget(),
        // backgroundColor: bgColor,
        backgroundColor: TC.bg(context),
        body: SafeArea(
          child: Column(
            children: [

              // Top Bar
              _buildTopBar(context,accentColor),

              // Scene Progress Dots
              _buildSceneDots(accentColor),

              const SizedBox(height: 10),

              // Scene Illustration
              _buildIllustration(scene, accentColor),

              const SizedBox(height: 16),

              // Story Text
              _buildStoryText(scene, bgColor, accentColor),

              const Spacer(),

              // Question or Next Button
              if (scene['hasQuestion'] == true)
                _buildQuestionSection(scene, accentColor)
              else
                _buildNextButton(accentColor),

              const SizedBox(height: 24),
            ],
          ),
        ),
      );
    });
  }

  // ── Top Bar ─────────────────────────────────────
  Widget _buildTopBar(BuildContext context,Color accentColor) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          GestureDetector(
            // onTap: () => Navigator.of(Get.context!).pop(),
            onTap: () {
              if (controller.currentScene.value > 0) {
                controller.currentScene.value--;
                controller.answered.value = false;
                controller.showFeedback.value = false;
                controller.selectedAnswer.value = -1;
              } else {
                Get.back();
              }
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 18,
                color: accentColor,
              ),
            ),
          ),

          // Story title
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                controller.story['title'] ?? '',
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.aBeeZee(
                  fontSize: 16,
                  color: AppColors.navy,
                ),
              ),
            ),
          ),

          // Stars chip
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12, vertical: 6,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                const Text('⭐', style: TextStyle(fontSize: 14)),
                const SizedBox(width: 4),
                Text(
                  '+${controller.story['stars'] ?? 2}',
                  style: GoogleFonts.aBeeZee(
                    fontSize: 14,
                    color: AppColors.orangeColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Scene Progress Dots ──────────────────────────
  Widget _buildSceneDots(Color accentColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16, vertical: 14,
      ),
      child: Obx(() => Row(
        children: List.generate(controller.scenes.length, (index) {
          final isCurrent = index == controller.currentScene.value;
          final isDone = index < controller.currentScene.value;
          return Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 3),
              height: 6,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: isDone
                    ? accentColor
                    : isCurrent
                    ? accentColor.withValues(alpha: 0.5)
                    : Colors.white.withValues(alpha: 0.6),
              ),
            ),
          );
        }),
      )),
    );
  }

  // ── Illustration ─────────────────────────────────
  Widget _buildIllustration(
      Map<String, dynamic> scene, Color accentColor) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 220,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: 0.2),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Stack(
          fit: StackFit.expand,
          children: [

            Image.asset(
              scene['image'] as String,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stack) {
                return Container(
                  color: accentColor.withValues(alpha: 0.1),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.broken_image_outlined,
                          size: 48,
                          color: accentColor.withValues(alpha: 0.4),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          AppStrings.imageNotFound,
                          style: GoogleFonts.nunito(
                            fontSize: 12,
                            color: accentColor.withValues(alpha: 0.5),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Shows exact path for debugging
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            '${scene['image']}',
                            style: TextStyle(
                              fontSize: 9,
                              color: accentColor.withValues(alpha: 0.4),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            // Gradient overlay at bottom
            Positioned(
              bottom: 0, left: 0, right: 0,
              child: Container(
                height: 70,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.35),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            // Scene number badge — top left
            Positioned(
              top: 12, left: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10, vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                  ),
                ),
                child: Obx(() => Text(
                  '${AppStrings.scene} ${controller.currentScene.value + 1} ${AppStrings.of} ${controller.scenes.length}',
                  style: GoogleFonts.nunito(
                    fontSize: 11,
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Story Text ───────────────────────────────────
  Widget _buildStoryText(
      Map<String, dynamic> scene,
      Color bgColor,
      Color accentColor,
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Text(
          scene['text'] ?? '',
          textAlign: TextAlign.center,
          style: GoogleFonts.nunito(
            fontSize: 16,
            color: AppColors.navy,
            fontWeight: FontWeight.w700,
            height: 1.6,
          ),
        ),
      ),
    );
  }

  // ── Next Button ──────────────────────────────────
  Widget _buildNextButton(Color accentColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: GestureDetector(
        onTap: controller.nextScene,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: accentColor,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: accentColor.withValues(alpha: 0.4),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Center(
            child: Obx(() => Text(
              controller.isLastScene
                  ? AppStrings.finishStory
                  : AppStrings.next,
              style: GoogleFonts.aBeeZee(
                fontSize: 20,
                color: Colors.white,
              ),
            )),
          ),
        ),
      ),
    );
  }

  // ── Question Section ─────────────────────────────
  Widget _buildQuestionSection(
      Map<String, dynamic> scene,
      Color accentColor,
      ) {
    final options = scene['options'] as List<dynamic>;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [

          // Feedback strip
          _buildFeedback(),
          const SizedBox(height: 12),

          // Answer grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 2.2,
            ),
            itemCount: options.length,
            itemBuilder: (context, index) {
              return _buildAnswerBtn(
                options[index],
                scene['answer'],
                accentColor,
              );
            },
          ),
        ],
      ),
    );
  }

  // ── Answer Button ────────────────────────────────
  Widget _buildAnswerBtn(dynamic value, dynamic correct, Color accentColor) {
    return Obx(() {
      final selected = controller.selectedAnswer.value;
      final isAnswered = controller.answered.value;

      Color btnColor;
      if (!isAnswered) {
        btnColor = accentColor;
      } else if (value == correct) {
        btnColor = AppColors.mintGreen;
      } else if (value == selected) {
        btnColor = AppColors.coralColor;
      } else {
        btnColor = accentColor.withValues(alpha: 0.3);
      }

      return GestureDetector(
        onTap: () => controller.checkAnswer(value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          decoration: BoxDecoration(
            color: btnColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: btnColor.withValues(alpha: 0.35),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Text(
              '$value',
              style: GoogleFonts.aBeeZee(
                fontSize: 22,
                color: Colors.white,
              ),
            ),
          ),
        ),
      );
    });
  }

  // ── Feedback Strip ───────────────────────────────
  Widget _buildFeedback() {
    return Obx(() {
      if (!controller.showFeedback.value) {
        return const SizedBox(height: 40);
      }
      final correct = controller.isCorrect.value;
      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: Container(
          key: ValueKey(correct),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 10,
          ),
          decoration: BoxDecoration(
            color: correct
                ? AppColors.mintGreen.withValues(alpha: 0.12)
                : AppColors.coralColor.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: correct
                  ? AppColors.mintGreen.withValues(alpha: 0.4)
                  : AppColors.coralColor.withValues(alpha: 0.3),
              width: 1.5,
            ),
          ),
          child: Text(
            correct
                ? AppStrings.correctWellDone
                : '❌ Not quite! Try again 😊',
            textAlign: TextAlign.center,
            style: GoogleFonts.aBeeZee(
              fontSize: 16,
              color: correct
                  ? AppColors.mintGreen
                  : AppColors.coralColor,
            ),
          ),
        ),
      );
    });
  }

  // ══════════════════════════════════════════════
  // CELEBRATION SCREEN
  // ══════════════════════════════════════════════
  Widget _buildCelebration() {
    return Scaffold(
      bottomNavigationBar: const BannerAdWidget(),
      backgroundColor: const Color(0xFF1A1A2E),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            // Animated owl
            const Text(
              '🦉',
              style: TextStyle(fontSize: 80),
            ),

            const SizedBox(height: 20),

            // Stars
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                controller.story['stars'] ?? 2,
                    (index) => const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: Text('⭐', style: TextStyle(fontSize: 36)),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Text(
              AppStrings.storyComplete,
              style: GoogleFonts.aBeeZee(
                fontSize: 32,
                color: AppColors.yellowColor,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              controller.story['title'] ?? '',
              textAlign: TextAlign.center,
              style: GoogleFonts.nunito(
                fontSize: 16,
                color: Colors.white.withValues(alpha: 0.7),
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 10),

            // Stars earned
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 28, vertical: 12,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.12),
                ),
              ),
              child: Text(
                '⭐ +${controller.story['stars'] ?? 2} Stars Earned!',
                style: GoogleFonts.aBeeZee(
                  fontSize: 20,
                  color: AppColors.yellowColor,
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Back to stories button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: GestureDetector(
                onTap: () async {
                  final starsService = Get.find<StarsService>();
                  final starsEarned = controller.story['stars'] ?? 2;
                  await starsService.addStars(starsEarned);

                  AdManager.instance.load();
                  Future.delayed(const Duration(milliseconds: 1800), () {
                    if (AdManager.instance.isReady) {
                      AdManager.instance.show();
                    }
                    Get.back();
                  });
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFFEF476F),
                        Color(0xFFFF9F1C),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFEF476F).withValues(alpha: 0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      '← Back to Stories',
                      style: GoogleFonts.aBeeZee(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}