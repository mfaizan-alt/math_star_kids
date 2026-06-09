import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/colors/colors.dart';
import 'number_builder_controller.dart';

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
                      'Level ${controller.level.value}',
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

                  _blockControl('Hundreds',controller.hundreds,controller.updateHundreds,),

                  _blockControl('Tens', controller.tens, controller.updateTens),

                  _blockControl('Ones', controller.ones, controller.updateOnes),

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

                        child: Center(child: Text("Next Level",style: TextStyle(fontSize: 17,color: Colors.white,fontWeight: FontWeight.w500),)),
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

  Widget _targetBox() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const Text("Build this number"),
          Obx(
            () => Text(
              "${controller.targetNumber.value}",
              style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildTutorial() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green.shade300, width: 1.5),
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
                  color: Colors.green.shade800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildTutorialStep('1️⃣', 'Look at the target number shown at the top'),
          _buildTutorialStep('2️⃣', 'Use the sliders to set Hundreds, Tens and Ones'),
          _buildTutorialStep('3️⃣', 'Example: 253 = 2 Hundreds + 5 Tens + 3 Ones'),
          _buildTutorialStep('4️⃣', 'Match the number exactly to move to next level! 🎉'),
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
                color: Colors.green.shade900,
              ),
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
          "Your Number: ${controller.currentNumber}",
          style: const TextStyle(color: Colors.white, fontSize: 22),
        ),
      ),
    );
  }

  Widget _blockControl(String label, RxInt value, Function(int) onChanged) {
    return Obx(
      () => Container(
        margin: const EdgeInsets.only(top: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Text(label, style: GoogleFonts.aBeeZee(fontSize: 16)),
            const Spacer(),
            IconButton(
              onPressed: value.value > 0
                  ? () => onChanged(value.value - 1)
                  : null,
              icon: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: AppColors.lightRed,
                ),
                child: const Icon(Icons.remove),
              ),
            ),
            Text("${value.value}",style: TextStyle(fontSize: 20),),
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
      ),
    );
  }
}
