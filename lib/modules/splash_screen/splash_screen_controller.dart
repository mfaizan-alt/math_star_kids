import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../core/routes/routes.dart';

class SplashScreenController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    timer();
  }

  void timer() {
    final box = GetStorage();
    final setupDone = box.read<bool>('setupDone') ?? false;

    print('setupDone value: $setupDone'); // 👈 check this in console

    Future.delayed(const Duration(seconds: 3), () {
      if (setupDone) {
        Get.offNamed(Routes.homeScreen);
      } else {
        Get.offNamed(Routes.setUpScreen);
      }
    });
  }
}