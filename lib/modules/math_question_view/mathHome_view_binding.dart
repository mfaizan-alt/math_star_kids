import 'package:get/get.dart';
import 'mathHome_view_controller.dart';

class MathHomeBindings implements Bindings{
  @override
  void dependencies() {
    // Get.put<MathHomeController>(MathHomeController());
    Get.lazyPut<MathHomeController>(()=> MathHomeController());
  }

}