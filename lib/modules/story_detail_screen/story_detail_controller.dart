// story_detail_controller.dart
import 'dart:ui';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../core/services/stars_service.dart';

class StoryDetailController extends GetxController {

  final box = GetStorage();

  RxInt currentScene = 0.obs;
  RxBool answered = false.obs;
  RxInt selectedAnswer = (-1).obs;
  RxBool showFeedback = false.obs;
  RxBool isCorrect = false.obs;
  RxBool storyCompleted = false.obs;

  late Map<String, dynamic> story;
  late List<dynamic> scenes;

  @override
  void onInit() {
    super.onInit();
    story = Get.arguments as Map<String, dynamic>;
    scenes = story['scenes'] as List<dynamic>;
  }

  Map<String, dynamic> get currentSceneData =>
      scenes[currentScene.value] as Map<String, dynamic>;

  bool get isLastScene => currentScene.value == scenes.length - 1;

  bool get hasQuestion =>
      currentSceneData['hasQuestion'] == true;

  void nextScene() {
    if (isLastScene) {
      storyCompleted.value = true;
      _saveStars();
    } else {
      currentScene.value++;
      answered.value = false;
      selectedAnswer.value = -1;
      showFeedback.value = false;
    }
  }

  void checkAnswer(int selected) {
    if (answered.value) return;

    selectedAnswer.value = selected;
    answered.value = true;

    if (selected == currentSceneData['answer']) {
      isCorrect.value = true;
      showFeedback.value = true;
      // Auto advance after 1.2 seconds
      Future.delayed(const Duration(milliseconds: 1200), () {
        showFeedback.value = false;
        nextScene();
      });
    } else {
      isCorrect.value = false;
      showFeedback.value = true;
      // Reset after 1.5 seconds — let them try again
      Future.delayed(const Duration(milliseconds: 1500), () {
        answered.value = false;
        selectedAnswer.value = -1;
        showFeedback.value = false;
      });
    }
  }

  void _saveStars() {
    final earned = story['stars'] ?? 2;
    // Use StarsService to save stars
    if (Get.isRegistered<StarsService>()) {
      StarsService.to.addStars(earned, sourceName: story['title']);
    } else {
      // Fallback to direct storage if service not available
      final current = box.read('totalStars') ?? 0;
      box.write('totalStars', current + earned);
    }
  }

  // Background color per scene
  Color sceneBackground(String bg) {
    switch (bg) {
      case 'green':   return const Color(0xFFE8F8F0);
      case 'yellow':  return const Color(0xFFFFF8E1);
      case 'orange':  return const Color(0xFFFFF0E0);
      case 'coral':   return const Color(0xFFFFECEC);
      case 'blue':    return const Color(0xFFE8F4FF);
      case 'purple':  return const Color(0xFFF3EEFF);
      case 'pink':    return const Color(0xFFFFECF5);
      default:        return const Color(0xFFFFFBF0);
    }
  }

  // Accent color per scene bg
  Color sceneAccent(String bg) {
    switch (bg) {
      case 'green':   return const Color(0xFF06D6A0);
      case 'yellow':  return const Color(0xFFFFD166);
      case 'orange':  return const Color(0xFFFF9F1C);
      case 'coral':   return const Color(0xFFEF476F);
      case 'blue':    return const Color(0xFF4CC9F0);
      case 'purple':  return const Color(0xFF7B2FBE);
      case 'pink':    return const Color(0xFFEF476F);
      default:        return const Color(0xFF4CC9F0);
    }
  }
}