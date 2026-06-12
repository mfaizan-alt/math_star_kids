import 'dart:async';
import 'dart:math';
import 'package:get/get.dart';
import '../../../core/commonWidgets/ads/ad_manager.dart';

class SpeedBattleController extends GetxController {
  int score1 = 0;
  int score2 = 0;

  int num1 = 0;
  int num2 = 0;
  int correctAnswer = 0;
  String operator = '+';

  List<int> options = [];

  bool isPlaying = false;
  bool isGameOver = false;

  String feedbackP1 = '';
  String feedbackP2 = '';

  int round = 0;
  int timeLeft = 5;
  final int totalRounds = 10;

  Timer? _timer;
  final Random _random = Random();

  void startGame() {
    score1 = 0;
    score2 = 0;
    round = 0;
    isPlaying = true;
    isGameOver = false;
    update();
    nextRound();
  }

  void nextRound() {
    if (round >= totalRounds) {
      endGame();
      return;
    }

    round++;

    final ops = ['+', '-', '×'];
    operator = ops[_random.nextInt(ops.length)];

    switch (operator) {
      case '+':
        num1 = _random.nextInt(20) + 1;
        num2 = _random.nextInt(20) + 1;
        correctAnswer = num1 + num2;
        break;

      case '-':
        num1 = _random.nextInt(20) + 2;
        num2 = _random.nextInt(num1 - 1) + 1;
        correctAnswer = num1 - num2;
        break;

      case '×':
        num1 = _random.nextInt(12) + 1;
        num2 = _random.nextInt(10) + 1;
        correctAnswer = num1 * num2;
        break;
    }

    final wrong = <int>{};
    while (wrong.length < 3) {
      int w = correctAnswer + _random.nextInt(11) - 5;
      if (w != correctAnswer && w >= 0) wrong.add(w);
    }

    options = [correctAnswer, ...wrong].toList()..shuffle();

    feedbackP1 = '';
    feedbackP2 = '';
    timeLeft = 5;

    update();

    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      timeLeft--;
      update();

      if (timeLeft <= 0) {
        t.cancel();
        Future.delayed(const Duration(milliseconds: 500), nextRound);
      }
    });
  }

  void answer(int player, int value) {
    _timer?.cancel();

    bool correct = value == correctAnswer;

    if (player == 1) {
      feedbackP1 = correct ? '✅' : '❌';
      if (correct) score1 += 10;
    } else {
      feedbackP2 = correct ? '✅' : '❌';
      if (correct) score2 += 10;
    }

    update();

    Future.delayed(const Duration(milliseconds: 800), nextRound);
  }

  void endGame() {
    _timer?.cancel();
    isPlaying = false;
    isGameOver = true;
    update();
    AdManager.instance.showOnGameEnd();
  }

  void reset() {
    _timer?.cancel();
    startGame();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}