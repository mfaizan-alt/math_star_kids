import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/colors/colors.dart';
import 'number_builder_controller.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/commonWidgets/ads/banner_ads.dart';

class NumberBuilderScreen extends StatefulWidget {
  const NumberBuilderScreen({super.key});

  @override
  State<NumberBuilderScreen> createState() => _NumberBuilderScreenState();
}

class _NumberBuilderScreenState extends State<NumberBuilderScreen> {
  final controller = Get.put(NumberBuilderController());

  @override
  void initState() {
    super.initState();
    controller.initGame();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BannerAdWidget(),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF667eea), Color(0xFF764ba2)],
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _topBar(),

                  const SizedBox(height: 20),

                  Text(
                    '🏗️ Number Builder',
                    style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ).animate().fadeIn(),
                  const SizedBox(height: 20),
                  Obx(
                    () => Text(
                      '${AppStrings.level} ${controller.level.value}',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  _targetBox(),
                  const SizedBox(height: 20),
                  _currentBox(),

                  _blockControl(AppStrings.hundreds,controller.hundreds,controller.updateHundreds,),

                  _blockControl(AppStrings.tens, controller.tens, controller.updateTens),

                  _blockControl(AppStrings.ones, controller.ones, controller.updateOnes),

                  const SizedBox(height: 20),
                  Obx(() => controller.showTutorial ? _buildTutorial() : const SizedBox.shrink()),

                  const SizedBox(height: 100),
                  // ✅ ONLY reactive button
                  Obx(() {
                    return controller.isCorrect.value
                        ? InkWell(
                      onTap: ()=> controller.nextLevel(),
                      child: Container(
                        height: 45,
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppColors.blueShadow,
                        ),

                        child: Center(child: Text(AppStrings.nextLevel,style: TextStyle(fontSize: 17,color: Colors.white,fontWeight: FontWeight.w500),)),
                      ),
                    )
                        : const SizedBox();
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _topBar() {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          Obx(
            () => Text(
              "⭐ ${controller.score.value}",
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
  Widget _currentBox() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Obx(
            () => Text(
          '${AppStrings.yourNumber}: ${controller.currentNumber}',
          style: const TextStyle(color: Colors.white, fontSize: 22),
        ),
      ),
    );
  }

  // 1. _targetBox() — Colors.white hardcoded
  Widget _targetBox() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color, // ✅
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            AppStrings.buildThisNumber,
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface), // ✅
          ),
          Obx(() => Text(
            "${controller.targetNumber.value}",
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface, // ✅
            ),
          )),
        ],
      ),
    );
  }

// 2. _blockControl() — Colors.white hardcoded on container
  Widget _blockControl(String label, RxInt value, Function(int) onChanged) {
    return Obx(() => Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color, // ✅
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Text(
            label,
            style: GoogleFonts.aBeeZee(
              fontSize: 16,
              color: Theme.of(context).colorScheme.onSurface, // ✅
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: value.value > 0 ? () => onChanged(value.value - 1) : null,
            icon: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: AppColors.lightRed,
              ),
              child: const Icon(Icons.remove),
            ),
          ),
          Text(
            "${value.value}",
            style: TextStyle(
              fontSize: 20,
              color: Theme.of(context).colorScheme.onSurface, // ✅
            ),
          ),
          IconButton(
            onPressed: () => onChanged(value.value + 1),
            icon: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: AppColors.yellowColor,
              ),
              child: const Icon(Icons.add),
            ),
          ),
        ],
      ),
    ));
  }

// 3. _buildTutorial() — Colors.green.shade50/800 hardcoded
  Widget _buildTutorial() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color, // ✅
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.4), // ✅
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                  color: Theme.of(context).colorScheme.primary, // ✅
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildTutorialStep('1️⃣', AppStrings.builderHowTo1),
          _buildTutorialStep('2️⃣', AppStrings.builderHowTo2),
          _buildTutorialStep('3️⃣', AppStrings.builderExample),
          _buildTutorialStep('4️⃣', AppStrings.builderHowTo3),
        ],
      ),
    );
  }

// 4. _buildTutorialStep() — Colors.green.shade900 hardcoded
  Widget _buildTutorialStep(String emoji, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: Theme.of(context).colorScheme.onSurface, // ✅
              ),
            ),
          ),
        ],
      ),
    );
  }
}
