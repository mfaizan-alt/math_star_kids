import 'dart:math';
import 'package:get/get.dart';

import '../../../core/commonWidgets/ads/ad_manager.dart';

class MathCircusController extends GetxController {
  final Random _random = Random();

  RxInt score = 0.obs;
  RxInt level = 1.obs;
  RxInt targetWeight = 0.obs;
  RxInt currentWeight = 0.obs;

  RxList<int> availableWeights = <int>[].obs;
  RxList<int> placedWeights = <int>[].obs;

  RxBool isBalanced = false.obs;
  RxDouble tiltAngle = 0.0.obs;
  bool get showTutorial => level.value == 1 && !isBalanced.value;

  @override
  void onInit() {
    super.onInit();
    AdManager.instance.load();
    generateLevel();
  }

  void nextLevel() {
    if (level.value % 3 == 0) {
      Future.delayed(const Duration(milliseconds: 300), () {
        AdManager.instance.show();
      });
    }
    level.value++;
    generateLevel();
  }

  void initGame() {
    generateLevel();
  }

  void generateLevel() {
    int lvl = level.value;

    targetWeight.value = _random.nextInt(5 + lvl * 3) + 5;

    List<int> temp = [];
    int remaining = targetWeight.value;

    while (remaining > 0) {
      int w = _random.nextInt(min(remaining, 10)) + 1;
      temp.add(w);
      remaining -= w;
    }

    for (int i = 0; i < 3; i++) {
      temp.add(_random.nextInt(10) + 1);
    }

    temp.shuffle();

    availableWeights.value = temp;
    placedWeights.clear();
    currentWeight.value = 0;
    isBalanced.value = false;

    updateTilt();
  }

  void addWeight(int weight) {
    if (isBalanced.value) return;

    placedWeights.add(weight);
    availableWeights.remove(weight);
    currentWeight.value += weight;

    updateTilt();

    if (currentWeight.value == targetWeight.value) {
      isBalanced.value = true;
      score.value += 5 + level.value * 5;
    }
  }

  void removeWeight(int index) {
    if (isBalanced.value) return;

    int w = placedWeights.removeAt(index);
    availableWeights.add(w);
    currentWeight.value -= w;

    updateTilt();
  }

  void updateTilt() {
    tiltAngle.value =
        ((currentWeight.value - targetWeight.value) /
                max(targetWeight.value, 1))
            .clamp(-1.0, 1.0) *
        0.15;
  }
}
