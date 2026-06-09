import 'package:get/get.dart';
import 'math_home_view_controller.dart';

class MathHomeBindings implements Bindings{
  @override
  void dependencies() {
    // Get.put<MathHomeController>(MathHomeController());
    Get.lazyPut<MathHomeController>(()=> MathHomeController());
  }

}