import 'dart:math';
import 'package:get/get.dart';

import '../../../core/commonWidgets/ads/ad_Manager.dart';

class NumberBuilderController extends GetxController {
  final Random _random = Random();

  RxInt score = 0.obs;
  RxInt level = 1.obs;

  RxInt targetNumber = 0.obs;

  RxInt hundreds = 0.obs;
  RxInt tens = 0.obs;
  RxInt ones = 0.obs;

  RxBool isCorrect = false.obs;

  int get currentNumber =>
      hundreds.value * 100 +
          tens.value * 10 +
          ones.value;

  void initGame() {
    generateQuestion();
  }

  void generateQuestion() {
    if (level.value <= 3) {
      targetNumber.value = _random.nextInt(90) + 10;
    } else {
      targetNumber.value = _random.nextInt(900) + 100;
    }

    hundreds.value = 0;
    tens.value = 0;
    ones.value = 0;
    isCorrect.value = false;
  }

  void updateHundreds(int v) {
    hundreds.value = v;
    checkAnswer();
  }

  void updateTens(int v) {
    tens.value = v;
    checkAnswer();
  }

  void updateOnes(int v) {
    ones.value = v;
    checkAnswer();
  }

  void checkAnswer() {
    if (currentNumber == targetNumber.value) {
      isCorrect.value = true;
      score.value += 10 + level.value * 5;
    }
  }

  void nextLevel() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if(level.value % 3 == 0){
        AdManager.instance.show();
      }
    });
    level.value++;
    generateQuestion();
  }
}