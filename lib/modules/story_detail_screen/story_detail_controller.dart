import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StoryDetailController extends GetxController {
  final RxMap<String, dynamic> story = <String, dynamic>{}.obs;
  final currentScene = 0.obs;
  final answered = false.obs;
  final showFeedback = false.obs;
  final selectedAnswer = Rx<dynamic>(-1);
  final isCorrect = false.obs;
  final storyCompleted = false.obs;

  List<dynamic> get scenes => story['scenes'] ?? [];

  Map<String, dynamic> get currentSceneData {
    if (scenes.isEmpty) return {};
    return Map<String, dynamic>.from(scenes[currentScene.value]);
  }

  bool get isLastScene => currentScene.value >= scenes.length - 1;

  @override
  void onInit() {
    super.onInit();
    final data = Get.arguments as Map<String, dynamic>?;
    if (data != null) {
      story.value = data;
    }
  }

  Color sceneBackground(String bg) {
    switch (bg) {
      case 'green':
        return const Color(0xFFE8F5E9);
      case 'yellow':
        return const Color(0xFFFFF9C4);
      case 'orange':
        return const Color(0xFFFFE0B2);
      case 'coral':
        return const Color(0xFFFFE4E1);
      case 'pink':
        return const Color(0xFFFCE4EC);
      case 'blue':
        return const Color(0xFFE3F2FD);
      case 'teal':
        return const Color(0xFFE0F2F1);
      case 'cyan':
        return const Color(0xFFE0F7FA);
      case 'purple':
        return const Color(0xFFF3E5F5);
      case 'brown':
        return const Color(0xFFEFEBE9);
      case 'gold':
        return const Color(0xFFFFF8E1);
      default:
        return const Color(0xFFFDF6EC);
    }
  }

  Color sceneAccent(String bg) {
    switch (bg) {
      case 'green':
        return const Color(0xFF2E7D32);
      case 'yellow':
        return const Color(0xFFF9A825);
      case 'orange':
        return const Color(0xFFEF6C00);
      case 'coral':
        return const Color(0xFFE76F51);
      case 'pink':
        return const Color(0xFFD81B60);
      case 'blue':
        return const Color(0xFF1976D2);
      case 'teal':
        return const Color(0xFF00897B);
      case 'cyan':
        return const Color(0xFF00ACC1);
      case 'purple':
        return const Color(0xFF8E24AA);
      case 'brown':
        return const Color(0xFF6D4C41);
      case 'gold':
        return const Color(0xFFB8860B);
      default:
        return const Color(0xFFEF476F);
    }
  }

  void nextScene() {
    if (isLastScene) {
      storyCompleted.value = true;
      return;
    }
    currentScene.value++;
    answered.value = false;
    showFeedback.value = false;
    selectedAnswer.value = -1;
    isCorrect.value = false;
  }

  void checkAnswer(dynamic value) {
    if (answered.value) return;

    selectedAnswer.value = value;
    final correctAnswer = currentSceneData['answer'];

    isCorrect.value = value == correctAnswer;
    answered.value = true;
    showFeedback.value = true;

    Future.delayed(const Duration(milliseconds: 1200), () {
      if (isCorrect.value) {
        nextScene();
      } else {
        answered.value = false;
        showFeedback.value = false;
        selectedAnswer.value = -1;
      }
    });
  }
}