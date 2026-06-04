import 'package:get/get.dart';

import 'mathTable_game_controller.dart';

class MathTableBindings implements Bindings{
  @override
  void dependencies() {
    Get.put<MathTableController>(MathTableController());
  }

}