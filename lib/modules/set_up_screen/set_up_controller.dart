// setup_screen_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../core/routes/routes.dart';
import '../home_screen/home_screen_controller.dart';

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

    // Pre-fill the saved name so it never has to be typed again.
    if (savedName.isNotEmpty) {
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

    if (name.isNotEmpty) {
      box.write('childName', name);
      if (!isAlreadySetup) box.write('setupDone', true);
    }

    // HomeScreenController is permanent and was created at app start with the
    // default name, so its onReady/loadUserData already ran before this setup.
    // Refresh it now so the freshly-saved name/avatar show immediately on the
    // very first navigation to home (otherwise it shows the default until relaunch).
    if (Get.isRegistered<HomeScreenController>()) {
      Get.find<HomeScreenController>().loadUserData();
    }

    if (isAlreadySetup) {
      Get.back();
    } else {
      Get.offNamed(Routes.homeScreen);
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    super.onClose();
  }
}