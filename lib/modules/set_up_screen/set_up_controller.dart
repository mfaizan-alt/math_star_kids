// setup_screen_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../core/routes/routes.dart';

class SetUpScreenController extends GetxController {

  final nameController = TextEditingController();
  final box = GetStorage();

  // Reactive variables
  RxString selectedAvatar = '🦊'.obs;
  RxString selectedLanguage = 'en'.obs;

  final List<String> avatars = [
    '🦊', '🦁', '🐨', '🐼',
    '🐸', '🦄', '🐶', '🐱',
  ];

  void selectAvatar(String avatar) {
    selectedAvatar.value = avatar;
  }

  void selectLanguage(String lang) {
    selectedLanguage.value = lang;
  }

  void onLetsGo() {

    final name = nameController.text.trim().isEmpty
        ? 'Champ'
        : nameController.text.trim();

    box.write('isFirstTime', false);
    box.write('childName', name);
    box.write('avatar', selectedAvatar.value);
    box.write('language', selectedLanguage.value);

    Get.offNamed(Routes.homeScreen);
  }

  @override
  void onClose() {
    nameController.dispose();
    super.onClose();
  }
}