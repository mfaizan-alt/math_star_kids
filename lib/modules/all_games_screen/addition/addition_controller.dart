import 'dart:math';
import 'package:confetti/confetti.dart';
import 'package:get/get.dart';
import '../../../core/services/stars_service.dart';
import '../../progress/progress_controller.dart';
import 'addition_view.dart';

class AdditionController extends GetxController {
  final Random _random = Random();

  late ConfettiController confettiController;
  late ProgressController progressController;

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
    confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
    
    // Initialize or get ProgressController
    if (!Get.isRegistered<ProgressController>()) {
      Get.put(ProgressController());
    }
    progressController = Get.find<ProgressController>();
    
    // Initialize StarsService if needed
    if (!Get.isRegistered<StarsService>()) {
      Get.put(StarsService());
    }
    
    generateQuestion();
  }

  @override
  void onClose() {
    confettiController.dispose();
    super.onClose();
  }

  void changeDifficulty(int level) {
    difficulty = level;
    score = 0;
    questionNumber = 0;
    generateQuestion();
    update();
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

    num1 = _random.nextInt(maxNum) + 1;
    num2 = _random.nextInt(maxNum) + 1;
    correctAnswer = num1 + num2;

    final Set<int> optionSet = {correctAnswer};

    while (optionSet.length < 4) {
      int offset = _random.nextInt(11) - 5;
      if (offset == 0) continue;

      int option = correctAnswer + offset;
      if (option > 0) optionSet.add(option);
    }

    options = optionSet.toList()..shuffle();

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

      update();
    });
  }

  void showResults() {
    int stars = 0;
    if (score >= 9) stars = 3;
    else if (score >= 7) stars = 2;
    else if (score >= 5) stars = 1;

    progressController.addStars('addition', stars);

    if (score == totalQuestions) {
      progressController.completeLevel('addition');
    }

    Get.dialog(
      AdditionResultDialog(),
      barrierDismissible: false,
    );
  }

  void resetGame() {
    score = 0;
    questionNumber = 0;
    generateQuestion();
    update();
  }
}