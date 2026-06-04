import 'dart:math';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'multiplication_view.dart';

class MultiplicationController extends GetxController {
  final Random _random = Random();

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
    confettiController = ConfettiController(duration: const Duration(seconds: 2));
    generateQuestion();
  }

  void changeDifficulty(int level) {
    difficulty = level;
    score = 0;
    questionNumber = 0;
    generateQuestion();
    update();
  }

  void generateQuestion() {
    switch (difficulty) {
      case 1:
        num1 = _random.nextInt(5) + 1;
        num2 = _random.nextInt(5) + 1;
        break;
      case 2:
        num1 = _random.nextInt(10) + 1;
        num2 = _random.nextInt(10) + 1;
        break;
      default:
        num1 = _random.nextInt(12) + 1;
        num2 = _random.nextInt(12) + 1;
    }

    correctAnswer = num1 * num2;

    options = [correctAnswer];

    while (options.length < 4) {
      int option = correctAnswer + _random.nextInt(21) - 10;
      if (option > 0 && !options.contains(option)) {
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

    if (isCorrect == true) {
      score++;
      confettiController.play();
    }

    update();

    Future.delayed(const Duration(milliseconds: 1200), () {
      questionNumber++;

      if (questionNumber >= totalQuestions) {
        showResultDialog();
      } else {
        generateQuestion();
      }
    });
  }

  void showResultDialog() {
    Get.dialog(
      MultiplicationResultDialog(),
      barrierDismissible: false,
    );
  }

  void resetGame() {
    score = 0;
    questionNumber = 0;
    generateQuestion();
    Get.back();
    update();
  }

  @override
  void onClose() {
    confettiController.dispose();
    super.onClose();
  }
}
