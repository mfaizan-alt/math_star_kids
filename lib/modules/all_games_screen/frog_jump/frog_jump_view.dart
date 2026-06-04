import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:confetti/confetti.dart';

import 'frog_jump_controller.dart';

class FrogJumpScreen extends StatelessWidget {
  FrogJumpScreen({super.key});

  final controller = Get.put(FrogJumpController());
  final confetti = ConfettiController(duration: const Duration(seconds: 2));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        return Stack(
          children: [
            // Container(color: Colors.green.shade300),
            Container(color: Color(0xFF81C784)),

            SafeArea(
              child: Column(
                children: [
                  _topBar(),

                  if (!controller.isGameStarted.value &&
                      !controller.isGameOver.value)
                    _startScreen(),

                  if (controller.isGameStarted.value) _gameUI(),

                  if (controller.isGameOver.value) _gameOver(),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _topBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back),
          ),

          Text("⭐ ${controller.score.value}",style: TextStyle(fontSize: 22),),

          Row(
            children: List.generate(
              3,
                  (i) => Icon(
                i < controller.lives.value
                    ? Icons.favorite
                    : Icons.favorite_border,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _startScreen() {
    // SizedBox(height: 400);
    return Column(
      children: [
        SizedBox(height: 400),
        Container(
          width: 100,
          height: 50,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.green
          ),
          child: TextButton(onPressed:controller.startGame, child: Text('START',style:TextStyle(fontSize: 16,color: Colors.white))),
        ),
      ],
    );
  }

  Widget _gameUI() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 100,horizontal: 10),
        child: Column(
          children: [
            Text(
              "${controller.num1.value} ${controller.operator.value} ${controller.num2.value}",
              style: GoogleFonts.poppins(fontSize: 35),
            ),

            const SizedBox(height: 20),

            Text("⏱ ${controller.timeLeft.value}'s ",style: TextStyle(fontSize: 30),),

            const Spacer(),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                5,
                    (i) => GestureDetector(
                  onTap: () => controller.jumpTo(i),
                  child: CircleAvatar(
                    child: Text("${controller.padAnswers[i]}"),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10,),
            if (controller.showFeedback.value)
              Text(
                controller.isCorrect.value ? "Correct" : "Wrong",
              ),
          ],
        ),
      ),
    );
  }

  Widget _gameOver() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
           Text("Game Over",style: GoogleFonts.aBeeZee(fontSize: 35),),
          Text("Score: ${controller.score.value}",style: GoogleFonts.abel(fontSize: 25),),
          SizedBox(height: 400,),
          Container(
            width: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.green
            ),
            child: TextButton(onPressed: controller.restart, child: Text('Restart',style:TextStyle(fontSize: 16,color: Colors.white))),
          ),
          SizedBox(height: 10,),
          Container(
            width: 100,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.green
            ),
            child: TextButton(onPressed:()=> Get.back(), child: Text('Home',style:TextStyle(fontSize: 16,color: Colors.white))),
          ),
        ],
      ),
    );
  }
}