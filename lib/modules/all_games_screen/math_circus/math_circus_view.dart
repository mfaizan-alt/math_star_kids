import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:confetti/confetti.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/colors/colors.dart';
import 'math_circus_controller.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/commonWidgets/ads/banner_ads.dart';

class MathCircusScreen extends StatefulWidget {
  const MathCircusScreen({super.key});

  @override
  State<MathCircusScreen> createState() => _MathCircusScreenState();
}

class _MathCircusScreenState extends State<MathCircusScreen> {
  final controller = Get.put(MathCircusController());
  late ConfettiController confetti;

  @override
  void initState() {
    super.initState();
    confetti = ConfettiController(duration: const Duration(seconds: 2));
    controller.initGame();
  }

  @override
  void dispose() {
    confetti.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isBalanced.value) {
        Future.microtask(() => confetti.play());
      }

      return SafeArea(
        child: Scaffold(
          bottomNavigationBar: const BannerAdWidget(),
          body: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF8B0000),
                      Color(0xFFDC143C),
                      Color(0xFFFFF8DC)
                    ],
                    stops: [0.0, 0.3, 0.5],
                  ),
                ),
              ),
        
              SafeArea(
                child: Column(
                  children: [
                    _topBar(),
                    Text(
                      '🎪 Math Circus',
                      style: GoogleFonts.poppins(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ).animate().fadeIn(),
        
                    Text(
                      '${AppStrings.level} ${controller.level.value} - ${AppStrings.balance}',
                      style: GoogleFonts.poppins(
                          fontSize: 14, color: Colors.white),
                    ),
        
                    const Spacer(),
        
                    _balanceView(),
        
                    const SizedBox(height: 20),
        
                    _stats(),
        
                    const SizedBox(height: 20),
        
                    _weights(),
        
                    const SizedBox(height: 20),

                    Obx(() => controller.showTutorial ? _buildTutorial() : const SizedBox.shrink()),
                    if (controller.isBalanced.value)
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: AppColors.coralColor,
                        ),
                        child: TextButton(
                            onPressed: controller.nextLevel,
                            child: Text(AppStrings.nextLevel, style: TextStyle(fontSize: 16,color: Colors.white),)),
                      ),
        
                    const SizedBox(height: 20),
                  ],
                ),
              ),
        
              Align(
                alignment: Alignment.topCenter,
                child: ConfettiWidget(
                  confettiController: confetti,
                  blastDirectionality: BlastDirectionality.explosive,
                  colors: const [Colors.red, Colors.white],
                ),
              )
            ],
          ),
        ),
      );
    });
  }

  Widget _topBar() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          Obx(() => Text(
            "⭐ ${controller.score.value}",
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ))
        ],
      ),
    );
  }

  Widget _balanceView() {
    return Obx(() => Transform.rotate(
      angle: controller.tiltAngle.value,
      child: Container(
        height: 12,
        width: 300,
        color: Colors.brown,
      ),
    ));
  }

  // 1. _stats() — text has no color, will be invisible on dark bg in dark mode
// Replace _stats() with:
  Widget _stats() {
    return Obx(() => Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          '${AppStrings.target}: ${controller.targetWeight.value}',
          style: TextStyle(fontSize: 18, color: Colors.black), // ✅
        ),
        Text(
          '${AppStrings.now}: ${controller.currentWeight.value}',
          style: TextStyle(fontSize: 18, color: Colors.black), // ✅
        ),
      ],
    ));
  }

// 2. _weights() — Colors.black on coralShadow won't work in dark mode
// Replace _weights() with:
  Widget _weights() {
    return Obx(() => Wrap(
      spacing: 10,
      children: controller.availableWeights
          .map((w) => GestureDetector(
        onTap: () => controller.addWeight(w),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.coralColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            "$w",
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white, // ✅
            ),
          ),
        ),
      ))
          .toList(),
    ));
  }

// 3. _buildTutorial() — hardcoded Colors.blue.shade50/800/900
// Replace _buildTutorial() with:
  Widget _buildTutorial() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,   // ✅
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
          _buildTutorialStep('1️⃣', AppStrings.circusHowTo1),
          _buildTutorialStep('2️⃣', AppStrings.circusHowTo2),
          _buildTutorialStep('3️⃣', AppStrings.circusHowTo3),
          _buildTutorialStep('4️⃣', AppStrings.circusHowTo4),
        ],
      ),
    );
  }

// 4. _buildTutorialStep() — hardcoded Colors.blue.shade900
// Replace _buildTutorialStep() with:
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