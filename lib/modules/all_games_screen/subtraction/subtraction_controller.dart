import 'dart:math';
import 'package:confetti/confetti.dart';
import 'package:get/get.dart';
import '../../../core/commonWidgets/ads/ad_Manager.dart';
import '../../../core/commonWidgets/result_dialog.dart';
import '../../progress/progress_controller.dart';

class SubtractionController extends GetxController {
  final Random random = Random();
  late ConfettiController confettiController;

  int num1 = 0;
  int num2 = 0;
  int correctAnswer = 0;
  List<int> options = [];
  int score = 0;
  int questionNumber = 0;
  final int totalQuestions = 10;
  int? selectedOption;
  bool? isCorrect;
  int difficulty = 1;

  @override
  void onInit() {
    super.onInit();
    confettiController = ConfettiController(
      duration: const Duration(seconds: 2),
    );
    generateQuestion();
  }

  @override
  void onClose() {
    confettiController.dispose();
    super.onClose();
  }

  void generateQuestion() {
    int maxNum;

    switch (difficulty) {
      case 1:
        maxNum = 10;
        break;
      case 2:
        maxNum = 50;
        break;
      default:
        maxNum = 100;
    }

    num1 = random.nextInt(maxNum) + 2;
    num2 = random.nextInt(num1 - 1) + 1;
    correctAnswer = num1 - num2;

    options = [correctAnswer];

    while (options.length < 4) {
      int option = correctAnswer + random.nextInt(11) - 5;

      if (option != correctAnswer &&
          option >= 0 &&
          !options.contains(option)) {
        options.add(option);
      }
    }

    options.shuffle();
    selectedOption = null;
    isCorrect = null;

    update();
  }

  void checkAnswer(int selected) {
    if (selectedOption != null) return;

    selectedOption = selected;
    isCorrect = selected == correctAnswer;

    if (isCorrect!) {
      score++;
      confettiController.play();
    }

    update();

    Future.delayed(const Duration(milliseconds: 1200), () {
      questionNumber++;

      if (questionNumber >= totalQuestions) {
        showResults();
      } else {
        generateQuestion();
      }
    });
  }

  void changeDifficulty(int level) {
    difficulty = level;
    score = 0;
    questionNumber = 0;
    generateQuestion();
  }

  void playAgain() {
    Get.back();                    // close dialog first
    AdManager.instance.show();     // show() preloads the next ad on dismiss
    score = 0;
    questionNumber = 0;
    generateQuestion();
  }

  void goHome() {
    Get.back();
    Get.back();
  }

  void showResults() {
    final provider = Get.find<ProgressController>();

    int stars = score >= 9
        ? 3
        : score >= 7
        ? 2
        : score >= 5
        ? 1
        : 0;

    provider.addStars('subtraction', stars);

    Get.dialog(
      ResultDialog(
        score: score,
        total: totalQuestions,
        stars: stars,
        onPlayAgain: playAgain,
        onHome: goHome, title: '', color: Get.theme.primaryColor,
      ),
      barrierDismissible: false,
    );
  }
}