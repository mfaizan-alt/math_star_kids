// math_quiz_controller.dart
import 'dart:math';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../core/services/stars_service.dart';

class QuizGameController extends GetxController {
  final box = GetStorage();
  final random = Random();
  final List<String> operations = ['+', '-', '×', '÷'];

  RxInt currentIndex = 0.obs;
  RxInt score = 0.obs;
  RxInt selectedAnswer = (-1).obs;
  RxBool answered = false.obs;
  RxList<String> progressStatus = <String>[].obs;

  final int totalQuestions = 10;
  late List<Map<String, dynamic>> questions;

  RxString feedbackMessage = ''.obs;
  RxString hintMessage = ''.obs;
  RxBool showFeedback = false.obs;
  RxBool isCorrectFeedback = false.obs;
  Map<String, dynamic> get currentQuestion => questions[currentIndex.value];

  @override
  void onInit() {
    super.onInit();
    generateQuestions();
    progressStatus.value = List.generate(totalQuestions, (_) => 'empty');
  }

  void generateQuestions() {
    questions = List.generate(totalQuestions, (_) {
      final op = operations[random.nextInt(operations.length)];
      int a, b, correctAnswer;

      switch (op) {
        case '+':
          a = random.nextInt(50) + 1;
          b = random.nextInt(50) + 1;
          correctAnswer = a + b;
          break;
        case '-':
          a = random.nextInt(50) + 2;
          b = random.nextInt(a - 1) + 1; // ensure no negative result
          correctAnswer = a - b;
          break;
        case '×':
          a = random.nextInt(10) + 1;
          b = random.nextInt(10) + 1;
          correctAnswer = a * b;
          break;
        case '÷':
          b = random.nextInt(9) + 1;         // divisor 1–10
          correctAnswer = random.nextInt(10) + 1; // quotient 1–10
          a = b * correctAnswer;              // ensure clean division
          break;
        default:
          a = 1; b = 1; correctAnswer = 2;
      }

      final wrongAnswers = <int>{};
      while (wrongAnswers.length < 3) {
        final wrong = correctAnswer + random.nextInt(20) - 10;
        if (wrong > 0 && wrong != correctAnswer) wrongAnswers.add(wrong);
      }

      final options = [...wrongAnswers, correctAnswer]..shuffle();

      return {
        'a': a,
        'b': b,
        'op': op,           // ← new field
        'answer': correctAnswer,
        'options': options,
      };
    });
  }

  final List<String> correctMessages = [
    '🌟 Excellent!',
    '🔥 Amazing!',
    '💪 Well Done!',
    '🎉 Fantastic!',
    '⭐ Brilliant!',
    '🚀 Outstanding!',
    '👏 Perfect!',
  ];

  final List<String> wrongMessages = [
    'Almost There! 💡',
    'Not Quite! 🤔',
    'Try Again! 😊',
    'So Close! 🎯',
    'Keep Going! 💪',
  ];


  void checkAnswer(int selected) {
    if (answered.value) return;

    selectedAnswer.value = selected;
    answered.value = true;

    if (selected == currentQuestion['answer']) {
      score.value++;
      progressStatus[currentIndex.value] = 'correct';

      // Pick random correct message
      feedbackMessage.value =
          correctMessages[random.nextInt(correctMessages.length)];
      hintMessage.value = '';
      isCorrectFeedback.value = true;
    } else {
      progressStatus[currentIndex.value] = 'wrong';

      // Pick random wrong message
      feedbackMessage.value =
          wrongMessages[random.nextInt(wrongMessages.length)];

      // Show hint — the correct answer
      final a = currentQuestion['a'];
      final b = currentQuestion['b'];
      final ans = currentQuestion['answer'];
      final op = currentQuestion['op'];
      hintMessage.value = '💡 Hint: $a $op $b = $ans';
      isCorrectFeedback.value = false;
    }

    showFeedback.value = true;

    // Hide feedback and move next after 1.5 seconds
    Future.delayed(const Duration(milliseconds: 1600), () {
      showFeedback.value = false;
      nextQuestion();
    });
  }

  void nextQuestion() {
    if (currentIndex.value < totalQuestions - 1) {
      currentIndex.value++;
      selectedAnswer.value = -1;
      answered.value = false;
    } else {
      // Save stars using StarsService
      final earned = score.value;
      if (Get.isRegistered<StarsService>()) {
        StarsService.to.addStars(earned, sourceName: 'Quiz Game');
      } else {
        final current = box.read('totalStars') ?? 0;
        box.write('totalStars', current + earned);
      }

      // Navigate directly to result (NO AD HERE)
      Get.offNamed(
        '/quizResult',
        arguments: {'score': score.value, 'total': totalQuestions},
      );
    }
  }

  double get progressValue => (currentIndex.value + 1) / totalQuestions;
}
