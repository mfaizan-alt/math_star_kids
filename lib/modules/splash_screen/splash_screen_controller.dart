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
    _navigationTimer = Timer(const Duration(seconds: 3), () {
      // First-time users go through setup; returning users skip straight home.
      final isFirstTime = box.read('isFirstTime') ?? true;
      Get.offNamed(isFirstTime ? Routes.setUpScreen : Routes.homeScreen);
    });
  }

  @override
  void onClose() {
    _navigationTimer?.cancel();
    super.onClose();
  }
}
