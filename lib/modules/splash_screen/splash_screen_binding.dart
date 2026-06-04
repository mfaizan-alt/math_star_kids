import 'package:get/get.dart';
import 'package:math_carnival_kids/modules/splash_screen/splash_screen_controller.dart';

class SplashScreenBinding implements Bindings{
  @override
  void dependencies() {
    // Get.lazyPut<SplashScreenController>(() => SplashScreenController());
    Get.put<SplashScreenController>(SplashScreenController());
  }

}