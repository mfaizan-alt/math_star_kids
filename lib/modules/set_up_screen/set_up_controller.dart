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


  final List<String> avatars = [
    '🦊', '🦁', '🐨', '🐼',
    '🐸', '🦄', '🐶', '🐱',
  ];

  @override
  void onInit() {
    super.onInit();
    final savedName = box.read<String>('childName') ?? '';
    final savedAvatar = box.read<String>('avatar') ?? '🦊';

    if (savedName.isNotEmpty && savedName != 'Champ') {
      nameController.text = savedName;
    }
    selectedAvatar.value = savedAvatar;
  }

  void selectAvatar(String avatar) {
    selectedAvatar.value = avatar;
  }



  void onLetsGo() {
    final name = nameController.text.trim();
    final isAlreadySetup = box.read<bool>('setupDone') ?? false;

    box.write('avatar', selectedAvatar.value); // always save avatar

    if (isAlreadySetup) {
      if (name.isNotEmpty) {
        box.write('childName', name);
      }
      Get.back();
    } else {
      if (name.isNotEmpty) {
        box.write('childName', name);
        box.write('setupDone', true);
      }
      Get.offNamed(Routes.homeScreen);
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    super.onClose();
  }
}