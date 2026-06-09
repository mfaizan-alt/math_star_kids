// import 'dart:async';
// import 'dart:math';
// import 'package:get/get.dart';
// import '../../../core/constants/app_constants.dart';
//
// enum QuizOperation { addition, subtraction, multiplication, division }
//
// class QuizController extends GetxController {
//   final Random _random = Random();
//   Timer? timer;
//
//   // ── plain int, passed directly to ResultDialog ──
//   final int totalQuestions = AppConstants.quizTotalQuestions; // add this constant
//
//   // states
//   var gameStarted = false.obs;
//   var gameOver = false.obs;
//
//   var score = 0.obs;
//   var questionsAnswered = 0.obs;
//   var correctAnswers = 0.obs;
//   var timeLeft = AppConstants.quizTimeSeconds.obs;
//
//   var num1 = 0.obs;
//   var num2 = 0.obs;
//   var correctAnswer = 0.obs;
//   var operationSymbol = '+'.obs;
//
//   var options = <int>[].obs;
//   var selectedOption = Rxn<int>();
//
//   // ── computed stars based on correctAnswers ──
//   int get stars {
//     final ratio = correctAnswers.value / totalQuestions;
//     if (ratio >= 0.8) return 3;
//     if (ratio >= 0.5) return 2;
//     if (ratio > 0) return 1;
//     return 0;
//   }
//
//   @override
//   void onClose() {
//     timer?.cancel();
//     super.onClose();
//   }
//
//   void startGame() {
//     gameStarted.value = true;
//     gameOver.value = false;
//
//     score.value = 0;
//     questionsAnswered.value = 0;
//     correctAnswers.value = 0;
//     timeLeft.value = AppConstants.quizTimeSeconds;
//
//     generateQuestion();
//     startTimer();
//   }
//
//   // ── restartGame resets state and starts fresh ──
//   void restartGame() {
//     gameOver.value = false;
//     startGame();
//   }
//
//   void startTimer() {
//     timer?.cancel();
//
//     timer = Timer.periodic(const Duration(seconds: 1), (_) {
//       timeLeft.value--;
//
//       if (timeLeft.value <= 0) {
//         endGame();
//       }
//     });
//   }
//
//   void endGame() {
//     timer?.cancel();
//     gameOver.value = true;
//   }
//
//   void generateQuestion() {
//     final op = QuizOperation.values[_random.nextInt(4)];
//
//     switch (op) {
//       case QuizOperation.addition:
//         num1.value = _random.nextInt(20) + 1;
//         num2.value = _random.nextInt(20) + 1;
//         correctAnswer.value = num1.value + num2.value;
//         operationSymbol.value = '+';
//         break;
//
//       case QuizOperation.subtraction:
//         num1.value = _random.nextInt(20) + 5;
//         num2.value = _random.nextInt(num1.value - 1) + 1;
//         correctAnswer.value = num1.value - num2.value;
//         operationSymbol.value = '-';
//         break;
//
//       case QuizOperation.multiplication:
//         num1.value = _random.nextInt(10) + 1;
//         num2.value = _random.nextInt(10) + 1;
//         correctAnswer.value = num1.value * num2.value;
//         operationSymbol.value = '×';
//         break;
//
//       case QuizOperation.division:
//         num2.value = _random.nextInt(8) + 2;
//         correctAnswer.value = _random.nextInt(8) + 1;
//         num1.value = num2.value * correctAnswer.value;
//         operationSymbol.value = '÷';
//         break;
//     }
//
//     options.value = [correctAnswer.value];
//
//     while (options.length < 4) {
//       int option = correctAnswer.value + _random.nextInt(15) - 7;
//       if (option > 0 && !options.contains(option)) {
//         options.add(option);
//       }
//     }
//
//     options.shuffle();
//     selectedOption.value = null;
//   }
//
//   void checkAnswer(int value) {
//     if (selectedOption.value != null) return;
//
//     selectedOption.value = value;
//     questionsAnswered.value++;
//
//     if (value == correctAnswer.value) {
//       correctAnswers.value++;
//       score.value += AppConstants.correctPoints;
//
//       // FIX: bonus for answering while more than half time remains
//       if (timeLeft.value > (AppConstants.quizTimeSeconds / 2)) {
//         score.value += AppConstants.bonusPoints;
//       }
//     }
//
//     Future.delayed(const Duration(milliseconds: 800), () {
//       if (!gameOver.value) generateQuestion();
//     });
//   }
// }