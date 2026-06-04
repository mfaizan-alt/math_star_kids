// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import '../../../core/commonWidgets/result_dialog.dart';
// import 'quiz_controller.dart';
//
// class QuizScreen extends StatelessWidget {
//   QuizScreen({super.key});
//
//   final QuizController controller = Get.put(QuizController());
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       // Trigger dialog outside build frame safely
//       if (controller.gameOver.value) {
//         Future.microtask(() {
//           if (Get.isDialogOpen != true) {
//             Get.dialog(
//               ResultDialog(
//                 score: controller.score.value,
//                 total: controller.totalQuestions, // plain int, no .value
//                 stars: controller.stars,
//                 title: "Great Job!",
//                 color: Colors.blue,
//                 onHome: () {
//                   Get.back(); // close dialog
//                   Get.back(); // go to home
//                 },
//                 onPlayAgain: () {
//                   Get.back(); // close dialog first
//                   controller.restartGame();
//                 },
//               ),
//               barrierDismissible: false,
//             );
//           }
//         });
//       }
//
//       // Show start screen if game hasn't started
//       if (!controller.gameStarted.value) {
//         return _startScreen();
//       }
//
//       // Main game UI
//       return Scaffold(
//         backgroundColor: Colors.blue.shade50,
//         body: SafeArea(
//           child: Padding(
//             padding: const EdgeInsets.all(20),
//             child: Column(
//               children: [
//                 _topBar(),
//                 const SizedBox(height: 40),
//                 _question(),
//                 const SizedBox(height: 40),
//                 _options(),
//               ],
//             ),
//           ),
//         ),
//       );
//     });
//   }
//
//   Widget _startScreen() {
//     return Scaffold(
//       body: Center(
//         child: ElevatedButton(
//           onPressed: controller.startGame,
//           child: const Text("Start Quiz"),
//         ),
//       ),
//     );
//   }
//
//   Widget _topBar() {
//     // Already inside parent Obx, so no need for nested Obx
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text("${controller.timeLeft.value}s"),   // .value required
//         Text("⭐ ${controller.score.value}"),     // .value required
//       ],
//     );
//   }
//
//   Widget _question() {
//     return Column(
//       children: [
//         const Text("Solve"),
//         Text(
//           "${controller.num1.value} ${controller.operationSymbol} ${controller.num2.value}",
//           style: GoogleFonts.poppins(fontSize: 32),
//         ),
//       ],
//     );
//   }
//
//   Widget _options() {
//     return GridView.count(
//       shrinkWrap: true,
//       crossAxisCount: 2,
//       children: controller.options.map((e) {
//         return ElevatedButton(
//           onPressed: () => controller.checkAnswer(e),
//           child: Text("$e"),
//         );
//       }).toList(),
//     );
//   }
// }