import 'dart:async';
import 'dart:math';
import 'package:get/get.dart';
import 'package:confetti/confetti.dart';

import '../../../core/commonWidgets/ads/reward_ad.dart';

class RunnerGameController extends GetxController {
  final Random _random = Random();
  Timer? _gameTimer;

  // ── Confetti (UI-adjacent but needs controller lifecycle) ──
  late ConfettiController confettiController;

  // ── Game state ──
  var score = 0.obs;
  var lives = 3.obs;
  var currentLane = 1.obs; // 0=left, 1=center, 2=right
  var isGameOver = false.obs;
  var isGameStarted = false.obs;
  var showFeedback = false.obs;
  var isCorrect = false.obs;
  var gameSpeed = 1.0.obs;

  // ── Question state ──
  var num1 = 0.obs;
  var num2 = 0.obs;
  var operator_ = '+'.obs;
  var correctAnswer = 0.obs;
  var answers = <int>[0, 0, 0].obs;

  @override
  void onInit() {
    super.onInit();
    confettiController = ConfettiController(duration: const Duration(seconds: 2));
    RewardedAdService.instance.loadAd();
  }

  @override
  void onClose() {
    _gameTimer?.cancel();
    confettiController.dispose();
    super.onClose();
  }

  // ── Public API ──

  void startGame() {
    score.value = 0;
    lives.value = 3;
    gameSpeed.value = 1.0;
    currentLane.value = 1;
    isGameOver.value = false;
    isGameStarted.value = true;
    showFeedback.value = false;

    generateQuestion();
  }

  void endGame() {
    _gameTimer?.cancel();
    isGameOver.value = true;
    isGameStarted.value = false;
  }
  void reviveWithLife() {
    lives.value = 1;
    isGameOver.value = false;
    isGameStarted.value = true;
    showFeedback.value = false;
    generateQuestion();
  }

  void replayWithAd() {
    startGame();
  }

  void generateQuestion() {
    int maxNum = 10;
    if (score.value > 50) maxNum = 20;
    if (score.value > 100) maxNum = 50;

    final operators = ['+', '-', '×'];
    operator_.value = operators[_random.nextInt(operators.length)];

    switch (operator_.value) {
      case '+':
        num1.value = _random.nextInt(maxNum) + 1;
        num2.value = _random.nextInt(maxNum) + 1;
        correctAnswer.value = num1.value + num2.value;
        break;
      case '-':
        num1.value = _random.nextInt(maxNum) + 1;
        num2.value = _random.nextInt(num1.value) + 1;
        correctAnswer.value = num1.value - num2.value;
        break;
      case '×':
        num1.value = _random.nextInt(min(maxNum, 12)) + 1;
        num2.value = _random.nextInt(10) + 1;
        correctAnswer.value = num1.value * num2.value;
        break;
    }

    final wrongAnswers = <int>{};
    while (wrongAnswers.length < 2) {
      int wrong = correctAnswer.value + _random.nextInt(11) - 5;
      if (wrong != correctAnswer.value && wrong >= 0) {
        wrongAnswers.add(wrong);
      }
    }

    answers.value = [correctAnswer.value, ...wrongAnswers]..shuffle();
  }

  void checkAnswer() {
    if (isGameOver.value) return;

    final selected = answers[currentLane.value];
    final correct = selected == correctAnswer.value;

    isCorrect.value = correct;
    showFeedback.value = true;

    if (correct) {
      score.value += 10;
      gameSpeed.value = 1.0 + (score.value / 100) * 0.5;
      if (score.value % 50 == 0) {
        confettiController.play();
      }
    } else {
      lives.value--;
      if (lives.value <= 0) {
        endGame();
        return;
      }
    }

    // UI will call onFeedbackDone() after its animation finishes
  }

  // Called by UI after feedback animation completes
  void onFeedbackDone() {
    if (isGameOver.value) return;
    showFeedback.value = false;
    generateQuestion();
  }

  void moveLeft() {
    if (currentLane.value > 0 && isGameStarted.value && !isGameOver.value) {
      currentLane.value--;
    }
  }

  void moveRight() {
    if (currentLane.value < 2 && isGameStarted.value && !isGameOver.value) {
      currentLane.value++;
    }
  }

  // ── Computed getters (used in UI, no .obs needed) ──

  String get gameOverEmoji {
    if (score.value >= 100) return '🏆';
    if (score.value >= 50) return '🌟';
    return '💪';
  }

  String get gameOverMessage {
    if (score.value >= 100) return 'Amazing! You\'re a Math Champion!';
    if (score.value >= 50) return 'Great job! Keep practicing!';
    return 'Good try! You\'ll do better next time!';
  }
}