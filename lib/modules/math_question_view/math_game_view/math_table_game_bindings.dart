import 'package:get/get.dart';

import 'math_table_game_controller.dart';

class MathTableBindings implements Bindings{
  @override
  void dependencies() {
    Get.put<MathTableController>(MathTableController());
  }

}