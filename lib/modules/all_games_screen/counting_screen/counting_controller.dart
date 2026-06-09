import 'dart:math';
import 'package:get/get.dart';
import '../../../core/commonWidgets/ads/interstitial_ad.dart';
import '../../progress/progress_controller.dart';
import 'counting_view.dart';

class CountingController extends GetxController {
  final InterstitialAdService interstitial = InterstitialAdService();
  final Random random = Random();

  int currentNumber = 1;
  int targetNumber = 0;

  int score = 0;
  int round = 0;
  final int totalRounds = 10;

  bool showFeedback = false;
  bool isCorrect = false;

  final List<String> emojis = [
    '🍎', '🌟', '🎈', '🐱', '🦋',
    '🌸', '🍕', '🎨', '🚀', '🐶'
  ];

  @override
  void onInit() {
    super.onInit();
    interstitial.loadAd();
    generateRound();
  }

  @override
  void onClose() {
    interstitial.dispose();
    super.onClose();
  }

  void generateRound() {
    targetNumber = (round % 9) + 2 + (round ~/ 3);
    if (targetNumber > 15) targetNumber = 15;

    currentNumber = 1;
    showFeedback = false;

    update();
  }

  void increment() {
    if (currentNumber < 20) {
      currentNumber++;
      update();
    }
  }

  void decrement() {
    if (currentNumber > 1) {
      currentNumber--;
      update();
    }
  }

  void submitAnswer() {
    showFeedback = true;
    isCorrect = currentNumber == targetNumber;

    if (isCorrect) score++;

    update();

    Future.delayed(const Duration(milliseconds: 1500), () {
      round++;

      if (round >= totalRounds) {
        showResultDialog();
      } else {
        generateRound();
      }

      update();
    });
  }

  // test commit

  void showResultDialog() {
    final progress = Get.find<ProgressController>();

    int stars = 0;
    if (score >= 8) {
      stars = 3;
    } else if (score >= 5) {
      stars = 2;
    } else if (score >= 3) {
      stars = 1;
    }

    progress.addStars('counting', stars);

    Get.dialog(
      CountingResultDialog(
        score: score,
        total: totalRounds,
      ),
      barrierDismissible: false,
    );
  }

  void resetGame() {
    score = 0;
    round = 0;
    generateRound();
    update();
  }

  String get emoji => emojis[round % emojis.length];
}