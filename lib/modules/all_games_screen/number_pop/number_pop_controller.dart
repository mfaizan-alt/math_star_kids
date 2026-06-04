import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:get/get.dart';

import '../../../core/commonWidgets/ads/ad_Manager.dart';

class Bubble {
  double x;
  double y;
  int value;
  Color color;
  double size;
  double speed;
  int id;

  Bubble({
    required this.x,
    required this.y,
    required this.value,
    required this.color,
    required this.size,
    required this.speed,
    required this.id,
  });
}

class NumberPopController extends GetxController {
  final Random random = Random();
  Timer? _spawnTimer;
  Timer? _moveTimer;

  late ConfettiController confettiController;

  // ── Game state ──
  var score = 0.obs;
  var lives = 3.obs;
  var isGameStarted = false.obs;
  var isGameOver = false.obs;
  var questionsAnswered = 0.obs;

  // ── Question state ──
  var num1 = 0.obs;
  var num2 = 0.obs;
  var operator_ = '+'.obs;
  var correctAnswer = 0.obs;

  // ── Bubbles ──
  var bubbles = <Bubble>[].obs;
  double _spawnRate = 1200;

  // ── Screen size (set by UI before startGame) ──
  double screenWidth = 400;
  var level = 1.obs;
  double screenHeight = 800;

  static const List<Color> _bubbleColors = [
    Color(0xFFFF6B6B),
    Color(0xFF4ECDC4),
    Color(0xFFFFD93D),
    Color(0xFF6BCB77),
    Color(0xFF4D96FF),
    Color(0xFFAD6BFF),
    Color(0xFFFF6EB4),
  ];

  @override
  void onInit() {
    super.onInit();
    confettiController = ConfettiController(
      duration: const Duration(seconds: 2),
    );
  }

  @override
  void onClose() {
    _spawnTimer?.cancel();
    _moveTimer?.cancel();
    confettiController.dispose();
    super.onClose();
  }

  // ── Public API ──

  void startGame() {
    score.value = 0;
    lives.value = 3;
    questionsAnswered.value = 0;
    isGameOver.value = false;
    isGameStarted.value = true;
    _spawnRate = 1200;
    bubbles.clear();

    generateQuestion();
    _startSpawning();
    _startMoving();
  }

  void generateQuestion() {
    final operators = ['+', '-', '×'];
    operator_.value = operators[random.nextInt(operators.length)];

    int maxNum = 10 + (questionsAnswered.value ~/ 5) * 5;
    maxNum = maxNum.clamp(10, 50);

    switch (operator_.value) {
      case '+':
        num1.value = random.nextInt(maxNum) + 1;
        num2.value = random.nextInt(maxNum) + 1;
        correctAnswer.value = num1.value + num2.value;
        break;
      case '-':
        num1.value = random.nextInt(maxNum) + 2;
        num2.value = random.nextInt(num1.value - 1) + 1;
        correctAnswer.value = num1.value - num2.value;
        break;
      case '×':
        num1.value = random.nextInt(min(maxNum, 12)) + 1;
        num2.value = random.nextInt(10) + 1;
        correctAnswer.value = num1.value * num2.value;
        break;
    }
  }

  void popBubble(Bubble bubble) {
    if (isGameOver.value) return;

    if (bubble.value == correctAnswer.value) {
      score.value += 10;
      questionsAnswered.value++;
      bubbles.remove(bubble);

      if (score.value % 50 == 0) confettiController.play();

      _spawnRate = (_spawnRate * 0.95).clamp(600, 1200);
      _startSpawning();
      generateQuestion();
    } else {
      lives.value--;
      bubbles.remove(bubble);
      if (lives.value <= 0) _gameOver();
    }
  }

  // ── Computed getters ──

  String get gameOverEmoji {
    if (score.value >= 100) return '🏆';
    if (score.value >= 50) return '🌟';
    return '💪';
  }

  // ── Private ──

  void _startSpawning() {
    _spawnTimer?.cancel();
    _spawnTimer = Timer.periodic(
      Duration(milliseconds: _spawnRate.round()),
          (_) {
        if (!isGameOver.value && isGameStarted.value) _spawnBubble();
      },
    );
  }

  void _spawnBubble() {
    final x = random.nextDouble() * (screenWidth - 80) + 20;

    int value;
    if (random.nextDouble() < 0.3) {
      value = correctAnswer.value;
    } else {
      value = correctAnswer.value + random.nextInt(21) - 10;
      if (value == correctAnswer.value) value += 1;
      if (value < 0) value = random.nextInt(20) + 1;
    }

    bubbles.add(Bubble(
      x: x,
      y: screenHeight,
      value: value,
      color: _bubbleColors[random.nextInt(_bubbleColors.length)],
      size: 60.0 + random.nextDouble() * 20,
      speed: 1.5 + random.nextDouble() * 1.5,
      id: DateTime.now().millisecondsSinceEpoch + random.nextInt(1000),
    ));
  }

  void _startMoving() {
    _moveTimer?.cancel();
    _moveTimer = Timer.periodic(const Duration(milliseconds: 16), (_) {
      if (isGameOver.value || !isGameStarted.value) return;

      for (var bubble in bubbles) {
        bubble.y -= bubble.speed;
      }

      final escaped = bubbles.where((b) => b.y < -80).toList();
      for (var b in escaped) {
        if (b.value == correctAnswer.value) {
          lives.value--;
          if (lives.value <= 0) {
            _gameOver();
            return;
          }
          bubbles.clear();
          generateQuestion();
          _spawnRate = (_spawnRate * 0.95).clamp(600, 1200);
          _startSpawning();
        }
      }

      bubbles.removeWhere((b) => b.y < -80);
      bubbles.refresh(); // notify UI of position changes
    });
  }

  void _gameOver() {
    _spawnTimer?.cancel();
    _moveTimer?.cancel();
    isGameOver.value = true;
    isGameStarted.value = false;

    Future.delayed(const Duration(milliseconds: 300), () {
      level.value++;
      if(level.value % 3 == 0){
        AdManager.instance.show();
        AdManager.instance.load();
      }
    });
  }
}