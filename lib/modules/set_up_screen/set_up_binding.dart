import 'package:get/get.dart';
import 'package:math_carnival_kids/modules/set_up_screen/set_up_controller.dart';

class SetUpScreenBinding implements Bindings{
  @override
  void dependencies() {
    // Get.lazyPut<SetUpScreenController>(()=> SetUpScreenController());
    Get.put<SetUpScreenController>(SetUpScreenController());
  }

}