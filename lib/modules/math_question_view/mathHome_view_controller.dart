import 'package:get/get.dart';

class MathHomeController extends GetxController {

  var score = 0.obs;
  var currentIndex = 0.obs;

  // final questions = [
  //   {
  //     "q": "2 + 2 = ?",
  //     "options": [3, 4, 5],
  //     "answer": 4
  //   },
  //   {
  //     "q": "5 - 2 = ?",
  //     "options": [1, 2, 3],
  //     "answer": 3
  //   }
  // ];
  //
  // Map<String, dynamic> get currentQuestion =>
  //     questions[currentIndex.value];
  //
  // void checkAnswer(int selected) {
  //   if (selected == currentQuestion["answer"]) {
  //     score.value++;
  //   }
  //
  //   nextQuestion();
  // }

  // void nextQuestion() {
  //   if (currentIndex.value < questions.length - 1) {
  //     currentIndex.value++;
  //   } else {
  //     Get.snackbar("Done", "Quiz Finished!");
  //   }
  // }

  @override
  void onInit() {
    super.onInit();
    startFactRotation(); // ← add this
  }
// Add this inside MathHomeController
  final List<String> mathFacts = [
    'Zero is the only number that cannot be represented in Roman numerals!',
    'A pizza that has radius "z" and height "a" has the volume Pi × z × z × a!',
    'The word "hundred" comes from the Old Norse word "hundrath" which means 120!',
    'If you shuffle a deck of cards the order has never existed before in history!',
    'The number 5 is the only prime number that ends in 5!',
    '111,111,111 × 111,111,111 = 12,345,678,987,654,321!',
    'A googol is 1 followed by 100 zeros!',
    'The equals sign = was invented in 1557 by Robert Recorde!',
    'Most mathematical symbols were not invented until the 16th century!',
    'There are 43 quintillion possible moves on a Rubik\'s cube!',
  ];

  RxString currentFact = ''.obs;
  RxInt factIndex = 0.obs;

// Call this in onInit
  void startFactRotation() {
    // Show first fact immediately
    currentFact.value = mathFacts[0];

    // Change every 5 seconds
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 15));
      // Check if controller still active
      if (!isClosed) {
        factIndex.value = (factIndex.value + 1) % mathFacts.length;
        currentFact.value = mathFacts[factIndex.value]; // ← directly update here
      }
      return !isClosed; // stops loop when controller disposed
    });
  }


}