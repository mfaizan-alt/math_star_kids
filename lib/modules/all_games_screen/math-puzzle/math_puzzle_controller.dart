import 'dart:math';
import 'package:get/get.dart';
import 'package:confetti/confetti.dart';

import '../../../core/commonWidgets/ads/ad_Manager.dart';

class MathPuzzleController extends GetxController {
  final Random _random = Random();

  // state
  var level = 1.obs;
  var score = 0.obs;
  var isComplete = false.obs;

  var correctOrder = <String>[].obs;
  var current = <String>[].obs;
  var tiles = <String>[].obs;

  late ConfettiController confettiController;

  @override
  void onInit() {
    super.onInit();
    confettiController = ConfettiController(duration: const Duration(seconds: 2));
    generatePuzzle();
  }

  @override
  void onClose() {
    confettiController.dispose();
    super.onClose();
  }

  // ---------------- PUZZLE ----------------
  void generatePuzzle() {
    final ops = ['+', '-'];
    if (level.value > 3) ops.add('×');

    final op = ops[_random.nextInt(ops.length)];

    int a, b, result;

    if (op == '+') {
      a = _random.nextInt(10) + 1;
      b = _random.nextInt(10) + 1;
      result = a + b;
    } else if (op == '-') {
      a = _random.nextInt(15) + 5;
      b = _random.nextInt(a) + 1;
      result = a - b;
    } else {
      a = _random.nextInt(8) + 1;
      b = _random.nextInt(8) + 1;
      result = a * b;
    }

    correctOrder.value = [
      a.toString(),
      op,
      b.toString(),
      '=',
      result.toString()
    ];

    tiles.value = List.from(correctOrder)..shuffle();
    current.value = List.filled(5, '');
    isComplete.value = false;
  }

  // ---------------- ACTIONS ----------------
  void placeTile(String tile) {
    if (isComplete.value) return;

    int index = current.indexOf('');
    if (index == -1) return;

    current[index] = tile;
    tiles.remove(tile);

    current.refresh();

    if (!current.contains('')) {
      checkSolution();
    }
  }

  void removeTile(int index) {
    if (isComplete.value) return;
    if (current[index].isEmpty) return;

    tiles.add(current[index]);
    current[index] = '';

    current.refresh();
  }

  void checkSolution() {
    try {
      final a = int.parse(current[0]);
      final op = current[1];
      final b = int.parse(current[2]);
      final res = int.parse(current[4]);

      int calc = 0;

      if (op == '+') calc = a + b;
      if (op == '-') calc = a - b;
      if (op == '×') calc = a * b;

      if (calc == res) {
        isComplete.value = true;
        score += 10 * level.value;
        confettiController.play();
      }
    } catch (_) {}
  }

  void nextLevel() {
    Future.delayed(const Duration(milliseconds: 300), () {
      AdManager.instance.show();
    });
    level++;
    generatePuzzle();
  }

  void reset() {
    tiles.value = List.from(correctOrder)..shuffle();
    current.value = List.filled(5, '');
    isComplete.value = false;
  }
}