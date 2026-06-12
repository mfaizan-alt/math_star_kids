import 'dart:async';
import 'dart:math';
import 'package:get/get.dart';

import '../../../core/commonWidgets/ads/reward_ad.dart';
import '../../progress/progress_controller.dart';

class FrogJumpController extends GetxController {
  final Random _random = Random();

  var score = 0.obs;
  var lives = 3.obs;
  var frogPosition = 2.obs;

  var isGameStarted = false.obs;
  var isGameOver = false.obs;
  var showFeedback = false.obs;
  var isCorrect = false.obs;

  var num1 = 0.obs;
  var num2 = 0.obs;
  var correctAnswer = 0.obs;

  var operator = '+'.obs;

  var padAnswers = List<int>.filled(5, 0).obs;

  Timer? _timer;
  var timeLeft = 8.obs;
  bool get showTutorial => score.value == 0 && !isGameOver.value;


  @override
  void onInit() {
    super.onInit();
    // Preload the rewarded ad so the "watch ad for a life" revive works.
    RewardedAdService.instance.loadAd();
  }



  void reviveWithLife() {
    lives.value = 1;
    isGameOver.value = false;
    isGameStarted.value = true;
    showFeedback.value = false;
    generateQuestion();
    startTimer();
  }

  void startGame() {
    score.value = 0;
    lives.value = 3;
    frogPosition.value = 2;

    isGameStarted.value = true;
    isGameOver.value = false;

    generateQuestion();
    startTimer();
  }

  void startTimer() {
    timeLeft.value = 8;
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      timeLeft.value--;

      if (timeLeft.value <= 0) {
        timer.cancel();
        wrongAnswer();
      }
    });
  }

  void generateQuestion() {
    final ops = ['+', '-', '×'];
    operator.value = ops[_random.nextInt(ops.length)];

    int maxNum = 10 + (score.value ~/ 30) * 5;

    if (operator.value == '+') {
      num1.value = _random.nextInt(maxNum) + 1;
      num2.value = _random.nextInt(maxNum) + 1;
      correctAnswer.value = num1.value + num2.value;
    } else if (operator.value == '-') {
      num1.value = _random.nextInt(maxNum) + 2;
      num2.value = _random.nextInt(num1.value - 1) + 1;
      correctAnswer.value = num1.value - num2.value;
    } else {
      num1.value = _random.nextInt(min(maxNum, 12)) + 1;
      num2.value = _random.nextInt(10) + 1;
      correctAnswer.value = num1.value * num2.value;
    }

    // Build 4 distinct, positive wrong answers around the correct one.
    final wrong = <int>{};
    while (wrong.length < 4) {
      int candidate = correctAnswer.value + _random.nextInt(21) - 10;
      if (candidate > 0 && candidate != correctAnswer.value) {
        wrong.add(candidate);
      }
    }

    List<int> temp = wrong.toList();
    temp.insert(_random.nextInt(5), correctAnswer.value);

    padAnswers.value = temp;
  }

  void jumpTo(int pad) {
    if (isGameOver.value || !isGameStarted.value || showFeedback.value) return;

    _timer?.cancel(); // stop the countdown while feedback is showing

    frogPosition.value = pad;

    if (padAnswers[pad] == correctAnswer.value) {
      score.value += 10;
      isCorrect.value = true;
      showFeedback.value = true;

      if (score.value % 50 == 0) {
        // confetti handled in UI
      }

      Future.delayed(const Duration(milliseconds: 800), () {
        showFeedback.value = false;
        generateQuestion();
        startTimer();
      });
    } else {
      wrongAnswer();
    }
  }

  void wrongAnswer() {
    _timer?.cancel();
    lives.value--;

    isCorrect.value = false;
    showFeedback.value = true;

    if (lives.value <= 0) {
      isGameOver.value = true;
      isGameStarted.value = false;
      if (Get.isRegistered<ProgressController>()) {
        Get.find<ProgressController>().updateHighScore(score.value);
      }
    } else {
      Future.delayed(const Duration(milliseconds: 800), () {
        showFeedback.value = false;
        generateQuestion();
        startTimer();
      });
    }
  }

  void restart() {
    startGame();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}