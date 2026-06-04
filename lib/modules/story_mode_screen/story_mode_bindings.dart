import 'package:get/get.dart';
import 'package:math_carnival_kids/modules/story_mode_screen/story_mode_controller.dart';

class StoryModeBindings implements Bindings{
  @override
  void dependencies() {
    Get.put<StoryModeController>(StoryModeController());
  }

}