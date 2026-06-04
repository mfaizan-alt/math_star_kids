import 'package:get/get.dart';
import 'package:math_carnival_kids/modules/story_detail_screen/story_detail_controller.dart';

class StoryDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StoryDetailController>(() => StoryDetailController());
  }
}