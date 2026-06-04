import 'package:get/get.dart';
import 'package:math_carnival_kids/modules/math_question_view/quiz_game_view/quiz_game_controller.dart';

class QuizGameBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<QuizGameController>(QuizGameController());
  }
}