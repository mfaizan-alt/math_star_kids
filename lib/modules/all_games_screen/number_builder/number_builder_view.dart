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

                  _blockControl(
                    'Hundreds',
                    controller.hundreds,
                    controller.updateHundreds,
                  ),

                  _blockControl('Tens', controller.tens, controller.updateTens),

                  _blockControl('Ones', controller.ones, controller.updateOnes),

                  const SizedBox(height: 20),

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
          style: const TextStyle(color: Colors.white, fontSize: 20),
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
            Text("${value.value}"),
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
