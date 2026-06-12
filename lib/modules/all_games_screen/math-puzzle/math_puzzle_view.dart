import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:confetti/confetti.dart';
import '../../../core/colors/colors.dart';
import '../../../core/commonWidgets/theme.dart';
import 'math_puzzle_controller.dart';
import '../../../core/commonWidgets/screen_header.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/commonWidgets/ads/banner_ads.dart';

class MathPuzzleScreen extends GetView<MathPuzzleController> {
  const MathPuzzleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StatusBarIcons(
      light: false,
      child: _buildScreen(context),
    );
  }

  Widget _buildScreen(BuildContext context) {
    final controller = Get.put(MathPuzzleController());

    return Obx(() {
      final isDark = Get.find<ThemeController>().isDarkMode;

      return Scaffold(
        bottomNavigationBar: const BannerAdWidget(),
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFFFF3E0), Color(0xFFFFCC80)],
                ),
              ),
            ),
            SafeArea(
              child: Obx(() {
                return Column(
                  children: [
                    _topBar(),
                    const SizedBox(height: 20),
                    Text('${AppStrings.level} ${controller.level.value}',
                        style: GoogleFonts.poppins(fontSize: 22)),
                    const SizedBox(height: 30),
                    _slots(isDark),
                    const SizedBox(height: 40),
                    _tiles(isDark),
                    const Spacer(),
                    Obx(() => controller.showTutorial
                        ? _buildTutorial()
                        : const SizedBox.shrink()),
                    const SizedBox(height: 20),
                    controller.isComplete.value ? _nextBtn() : _resetBtn(),
                    const SizedBox(height: 20),
                  ],
                );
              }),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: controller.confettiController,
                blastDirectionality: BlastDirectionality.explosive,
              ),
            ),
          ],
        ),
      );
    });
  }

  // ---------------- UI PARTS ----------------

  Widget _topBar() => Padding(
    padding: const EdgeInsets.all(16),
    child: Padding(
      padding: const EdgeInsets.only(right: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back),
          ),
          Obx(() => Text('⭐ ${controller.score.value}',
              style: GoogleFonts.poppins(
                  fontSize: 22, fontWeight: FontWeight.bold))),
        ],
      ),
    ),
  );

  Widget _slots(bool isDark) => Obx(() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (i) {
        return GestureDetector(
          onTap: () => controller.removeTile(i),
          child: Container(
            width: 60,
            height: 70,
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: controller.current[i].isEmpty
                  ? isDark ? const Color(0xFF2C2C2C) : Colors.white70  // ✅ solid dark
                  : isDark ? const Color(0xFF1F1F1F) : Colors.white,   // ✅ solid dark
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                controller.current[i].isEmpty ? '?' : controller.current[i],
                style: TextStyle(
                  fontSize: 22,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
        );
      }),
    );
  });

  Widget _tiles(bool isDark) => Obx(() {
    return Wrap(
      spacing: 10,
      children: controller.tiles.map((t) {
        return GestureDetector(
          onTap: () => controller.placeTile(t),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1F1F1F) : Colors.white, // ✅ solid dark
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              t,
              style: TextStyle(
                fontSize: 20,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
          ),
        );
      }).toList(),
    );
  });


  Widget _nextBtn() => InkWell(
    onTap: ()=> controller.nextLevel(),
    child: Container(
      height: 45,
      width: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.yellowColor,
      ),

      child: Center(child: Text("Next Level",style: TextStyle(fontSize: 16,color: Colors.black,fontWeight: FontWeight.w500),)),
    ),
  );

  Widget _buildTutorial() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.amber.shade300, width: 1.5),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Text('💡', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text(
                AppStrings.howToPlay,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber.shade800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            AppStrings.puzzleHowTo,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: Colors.amber.shade900,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildExampleBox('3'),
              _buildExampleBox('+'),
              _buildExampleBox('4'),
              _buildExampleBox('='),
              _buildExampleBox('7'),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            AppStrings.tapFilledBoxBack,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.amber.shade800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExampleBox(String value) {
    final isOperator = value == '+' || value == '-' || value == '×' || value == '=';
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 3),
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: isOperator ? Colors.amber.shade200 : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.amber.shade400),
      ),
      child: Center(
        child: Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.amber.shade900,
          ),
        ),
      ),
    );
  }

  Widget _resetBtn() => InkWell(
    onTap: ()=> controller.reset(),
    child: Container(
      height: 45,
      width: 100,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        color: AppColors.yellowColor,
      ),

      child: Center(child: Text(AppStrings.reset,style: TextStyle(fontSize: 17,color: Colors.black,fontWeight: FontWeight.w500),)),
    ),
  );

  // Widget _resetBtn() => ElevatedButton(
  //   onPressed: controller.reset,
  //   child: const Text("Reset"),
  // );
}