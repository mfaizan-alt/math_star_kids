import 'dart:async';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../core/routes/routes.dart';

class SplashScreenController extends GetxController {
  final box = GetStorage();
  Timer? _navigationTimer;

  @override
  void onInit() {
    super.onInit();
    _scheduleNavigation();
  }

  void _scheduleNavigation() {
    final setupDone = box.read<bool>('setupDone') ?? false;

    _navigationTimer = Timer(const Duration(seconds: 2), () {
      Get.offNamed(setupDone ? Routes.homeScreen : Routes.setUpScreen);
    });
  }

  @override
  void onClose() {
    _navigationTimer?.cancel();
    super.onClose();
  }
}
