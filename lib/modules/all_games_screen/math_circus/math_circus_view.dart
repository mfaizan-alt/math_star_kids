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
        
                    if (controller.isBalanced.value)
                      // ElevatedButton(
                      //   onPressed: controller.nextLevel,
                      //   child: const Text("Next Level"),
                      // ),
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
        Text("Target: ${controller.targetWeight.value}"),
        Text("Now: ${controller.currentWeight.value}"),
      ],
    ));
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