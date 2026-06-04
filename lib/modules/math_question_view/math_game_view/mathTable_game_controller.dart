import 'dart:math';
import 'package:confetti/confetti.dart';
import 'package:get/get.dart';

enum ScreenState { picker, table, quiz, result }

class MathTableController extends GetxController {
  final Random random = Random();
  late ConfettiController confettiController;

  // ── Observables ──────────────────────────────
  Rx<ScreenState> screen = ScreenState.picker.obs;
  RxInt selectedTable = 2.obs;
  RxList<int> selectedTables = <int>[].obs; // for multi-table quiz

  // ── Quiz state ───────────────────────────────
  RxInt currentQuestion = 0.obs;
  RxInt score = 0.obs;
  RxInt? selectedOption = RxInt(-1);
  RxBool answered = false.obs;
  RxBool isCorrect = false.obs;

  final int totalQuestions = 10;
  int correctAnswer = 0;
  List<int> options = [];

  // current question data
  RxInt num1 = 0.obs;
  RxInt num2 = 0.obs;

  final List<int> tables = List.generate(20, (i) => i + 1);

  @override
  void onInit() {
    super.onInit();
    confettiController = ConfettiController(
      duration: const Duration(seconds: 2),
    );
  }

  @override
  void onClose() {
    confettiController.dispose();
    super.onClose();
  }

  // ── Navigation ───────────────────────────────
  void selectTable(int number) {
    selectedTable.value = number;
    screen.value = ScreenState.table;
  }

  void goToPicker() {
    screen.value = ScreenState.picker;
    selectedTables.clear();
  }

  void goBack() {
    if (screen.value == ScreenState.quiz ||
        screen.value == ScreenState.result) {
      screen.value = ScreenState.table;
    } else {
      screen.value = ScreenState.picker;
    }
  }

  // ── Table view ───────────────────────────────
  List<Map<String, dynamic>> getTableRows(int number) {
    return List.generate(10, (index) {
      final multiplier = index + 1;
      return {
        'expression': '$number × ${multiplier}',
        'result': number * multiplier,
      };
    });
  }

  // ── Quiz ─────────────────────────────────────
  void startQuiz(List<int> tables) {
    selectedTables.assignAll(tables);
    score.value = 0;
    currentQuestion.value = 0;
    answered.value = false;
    selectedOption!.value = -1;
    screen.value = ScreenState.quiz;
    _generateQuestion();
  }

  void startSingleTableQuiz() {
    startQuiz([selectedTable.value]);
  }

  void _generateQuestion() {
    final table = selectedTables[random.nextInt(selectedTables.length)];
    num1.value = table;
    num2.value = random.nextInt(10) + 1;
    correctAnswer = num1.value * num2.value;

    options = [correctAnswer];
    while (options.length < 4) {
      int fake = correctAnswer + random.nextInt(20) - 10;
      if (fake > 0 && fake != correctAnswer && !options.contains(fake)) {
        options.add(fake);
      }
    }
    options.shuffle();
    answered.value = false;
    selectedOption!.value = -1;
  }

  void checkAnswer(int selected) {
    if (answered.value) return;

    selectedOption!.value = selected;
    isCorrect.value = selected == correctAnswer;
    answered.value = true;

    if (isCorrect.value) {
      score.value++;
      confettiController.play();
    }

    Future.delayed(const Duration(milliseconds: 1200), () {
      currentQuestion.value++;
      if (currentQuestion.value >= totalQuestions) {
        screen.value = ScreenState.result;
      } else {
        _generateQuestion();
      }
    });
  }

  void resetQuiz() {
    score.value = 0;
    currentQuestion.value = 0;
    answered.value = false;
    selectedOption!.value = -1;
    screen.value = ScreenState.quiz;
    _generateQuestion();
  }

  int get stars {
    if (score.value >= 9) return 3;
    if (score.value >= 7) return 2;
    if (score.value >= 5) return 1;
    return 0;
  }

  String get resultMessage {
    if (score.value >= 9) return '🏆 Math Champion!';
    if (score.value >= 7) return '🌟 Great Job!';
    if (score.value >= 5) return '👍 Good Try!';
    return '💪 Keep Practicing!';
  }
}