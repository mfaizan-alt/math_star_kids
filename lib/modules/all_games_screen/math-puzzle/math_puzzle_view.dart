import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:confetti/confetti.dart';
import '../../../core/colors/colors.dart';
import 'math_puzzle_controller.dart';

class MathPuzzleScreen extends GetView<MathPuzzleController> {
  const MathPuzzleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MathPuzzleController());
    return Scaffold(
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
                  Text('Level ${controller.level.value}',
                      style: GoogleFonts.poppins(fontSize: 22)),
                  const SizedBox(height: 30),
                  _slots(),
                  const SizedBox(height: 40),
                  _tiles(),
                  const Spacer(),
                  controller.isComplete.value
                      ? _nextBtn()
                      : _resetBtn(),
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

  Widget _slots() => Obx(() {
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
                  ? Colors.white70
                  : Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                controller.current[i].isEmpty
                    ? '?'
                    : controller.current[i],
                style: const TextStyle(fontSize: 22),
              ),
            ),
          ),
        );
      }),
    );
  });

  Widget _tiles() => Obx(() {
    return Wrap(
      spacing: 10,
      children: controller.tiles.map((t) {
        return GestureDetector(
          onTap: () => controller.placeTile(t),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(t, style: const TextStyle(fontSize: 20)),
          ),
        );
      }).toList(),
    );
  });

  // Widget _nextBtn() => ElevatedButton(
  //   onPressed: controller.nextLevel,
  //   child: const Text("Next Level"),
  // );
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


  Widget _resetBtn() => InkWell(
    onTap: ()=> controller.reset(),
    child: Container(
      height: 45,
      width: 100,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        color: AppColors.yellowColor,
      ),

      child: Center(child: Text("Reset",style: TextStyle(fontSize: 17,color: Colors.black,fontWeight: FontWeight.w500),)),
    ),
  );

  // Widget _resetBtn() => ElevatedButton(
  //   onPressed: controller.reset,
  //   child: const Text("Reset"),
  // );
}