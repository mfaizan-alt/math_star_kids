import 'package:get/get.dart';
import '../../core/routes/routes.dart';

class SplashScreenController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    timer();
  }

  void timer() {
    Future.delayed(Duration(seconds: 3), () {
      Get.offNamed(Routes.setUpScreen);
    });
  }
}
