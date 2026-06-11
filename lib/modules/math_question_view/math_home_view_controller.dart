import 'dart:async';
import 'package:get/get.dart';

class MathHomeController extends GetxController {
  var score = 0.obs;
  var currentIndex = 0.obs;

  // progress for UI bar (0 → 1)
  var progress = 0.0.obs;

  Timer? _progressTimer;

  final List<String> mathFacts = [
    'Zero is the only number that cannot be represented in Roman numerals!',
    'A pizza volume formula uses Pi × r² × h!',
    'Hundred originally meant 120 in Old Norse!',
    'A shuffled deck order is almost certainly unique in history!',
    '5 is the only prime ending in 5!',
    '111,111,111 × itself = 12,345,678,987,654,321!',
    'A googol is 1 followed by 100 zeros!',
    'Equals sign was invented in 1557!',
    'Most math symbols came in the 16th century!',
    'Rubik’s cube has 43 quintillion moves!',
  ];

  String get currentFact => mathFacts[currentIndex.value];

  @override
  void onInit() {
    super.onInit();
    startRotation();
  }

  // ─────────────────────────────
  // MAIN TIMER (ONLY ONE TIMER)
  // ─────────────────────────────
  void startRotation() {
    _progressTimer?.cancel();

    progress.value = 0;

    _progressTimer = Timer.periodic(
      const Duration(milliseconds: 100),
          (_) {
        progress.value = progress.value + (1 / 150);

        if (progress.value >= 1) {
          progress.value = 0;
          nextFact();
        }
      },
    );
  }

  // ─────────────────────────────
  // FACT CONTROL
  // ─────────────────────────────
  void nextFact() {
    currentIndex.value =
        (currentIndex.value + 1) % mathFacts.length;
  }

  void prevFact() {
    currentIndex.value =
        (currentIndex.value - 1 + mathFacts.length) %
            mathFacts.length;
  }

  // ─────────────────────────────
  // SWIPE RESET
  // ─────────────────────────────
  void restartProgress() {
    progress.value = 0;
  }

  @override
  void onClose() {
    _progressTimer?.cancel();
    super.onClose();
  }
}