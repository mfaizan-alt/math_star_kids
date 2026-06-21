import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:get/get.dart';

import '../../../core/commonWidgets/ads/ad_manager.dart';
import '../../../core/commonWidgets/ads/reward_ad.dart';
import '../../progress/progress_controller.dart';

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

  // Spawns are random, but we never let the player go more than this many
  // bubbles without the correct answer appearing — guarantees the answer
  // always comes while keeping each bubble (including the first) random.
  int _spawnsSinceCorrect = 0;
  static const int _maxSpawnsWithoutCorrect = 3;

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
    RewardedAdService.instance.loadAd();
    AdManager.instance.load();
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
    _spawnsSinceCorrect = 0;
    bubbles.clear();

    generateQuestion();
    _startSpawning();
    _startMoving();
    // Spawn one bubble immediately so play begins without an empty pause; the
    // forced-correct rule in _spawnBubble guarantees it is the answer.
    _spawnBubble();
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
    // Ignore taps on a bubble that is no longer on screen. Taps are queued on
    // the event loop, so a tap can arrive a frame after the bubble escaped or
    // was cleared by a question change; without this guard that stale tap
    // would be processed against the wrong state.
    if (!bubbles.contains(bubble)) return;

    // Wrong taps are harmless — no life lost, nothing happens. A life is only
    // ever lost when the CORRECT bubble drifts off the top of the screen
    // (handled in _startMoving), so kids are never punished for a misjudged tap.
    if (bubble.value != correctAnswer.value) return;

    score.value += 10;
    questionsAnswered.value++;

    if (score.value % 50 == 0) confettiController.play();

    _nextQuestion();
  }

  /// Advance to a fresh question: drop the now-stale bubbles (they belonged to
  /// the previous equation), pick a new question, speed up slightly, and make
  /// sure a correct-answer bubble is immediately available. Used by both the
  /// correct-pop path and the missed-bubble path so the screen always reflects
  /// the equation currently shown.
  void _nextQuestion() {
    bubbles.clear();
    generateQuestion();
    _spawnsSinceCorrect = 0;
    _spawnRate = (_spawnRate * 0.95).clamp(600, 1200);
    _startSpawning();
    _spawnBubble();
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
  void reviveWithLife() {
    lives.value = 1;
    isGameOver.value = false;
    isGameStarted.value = true;
    _spawnsSinceCorrect = 0;
    bubbles.clear();
    generateQuestion();
    _startSpawning();
    _startMoving();
    _spawnBubble();
  }

  void _spawnBubble() {
    final x = random.nextDouble() * (screenWidth - 80) + 20;

    // Each bubble's value is random (the first one is NOT automatically the
    // answer). To still guarantee the answer always shows up, we force a correct
    // bubble only when none is on screen AND we've already spawned
    // _maxSpawnsWithoutCorrect bubbles without one.
    final hasCorrectOnScreen =
        bubbles.any((b) => b.value == correctAnswer.value);
    final mustForceCorrect = !hasCorrectOnScreen &&
        _spawnsSinceCorrect >= _maxSpawnsWithoutCorrect;

    int value;
    if (mustForceCorrect || random.nextDouble() < 0.3) {
      value = correctAnswer.value;
      _spawnsSinceCorrect = 0;
    } else {
      value = correctAnswer.value + random.nextInt(21) - 10;
      if (value <= 0) value = correctAnswer.value + random.nextInt(10) + 1;
      if (value == correctAnswer.value) value += 1;
      _spawnsSinceCorrect++;
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
      if (escaped.isEmpty) {
        bubbles.refresh(); // notify UI of position changes
        return;
      }

      // A missed correct bubble costs exactly ONE life per frame, no matter how
      // many escape together — the old loop could deduct several lives in a
      // single tick (the "had lives left but game suddenly ended" bug).
      final missedCorrect =
          escaped.any((b) => b.value == correctAnswer.value);
      bubbles.removeWhere((b) => b.y < -80);

      if (missedCorrect) {
        lives.value--;
        if (lives.value <= 0) {
          _gameOver();
          return;
        }
        _nextQuestion();
      }

      bubbles.refresh();
    });
  }

  void _gameOver() {
    _spawnTimer?.cancel();
    _moveTimer?.cancel();
    isGameOver.value = true;
    isGameStarted.value = false;
    if (Get.isRegistered<ProgressController>()) {
      Get.find<ProgressController>().updateHighScore(score.value);
    }

    Future.delayed(const Duration(milliseconds: 300), () {
      if (isClosed) return;
      level.value++;
      if(level.value % 3 == 0){
        AdManager.instance.show();
      }
    });
  }
}