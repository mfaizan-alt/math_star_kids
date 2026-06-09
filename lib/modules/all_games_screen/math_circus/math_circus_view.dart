import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:confetti/confetti.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/colors/colors.dart';
import 'math_circus_controller.dart';

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
                      'Level ${controller.level.value} - Balance!',
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
                            child: Text('Next Level', style: TextStyle(fontSize: 16,color: Colors.white),)),
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

  Widget _stats() {
    return Obx(() => Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text("Target: ${controller.targetWeight.value}",style: TextStyle(fontSize: 17),),
        Text("Now: ${controller.currentWeight.value}",style: TextStyle(fontSize: 17),),
      ],
    ));
  }
  Widget _buildTutorial() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.shade300, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('💡', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text(
                'How to Play',
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildTutorialStep('1️⃣', 'See the target weight on the left side of the scale'),
          _buildTutorialStep('2️⃣', 'Tap weights below to place them on the right side'),
          _buildTutorialStep('3️⃣', 'Make both sides equal to balance the scale! ⚖️'),
          _buildTutorialStep('4️⃣', 'Tap a placed weight to remove it if needed'),
        ],
      ),
    );
  }

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
                color: Colors.blue.shade900,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _weights() {
    return Obx(() => Wrap(
      spacing: 10,
      children: controller.availableWeights
          .map(
            (w) => GestureDetector(
          onTap: () => controller.addWeight(w),
          child: Container(
            padding: const EdgeInsets.all(12),
            color: AppColors.coralShadow,
            child: Text("$w",style: TextStyle(fontSize: 16,color: Colors.black),),
          ),
        ),
      )
          .toList(),
    ));
  }
}