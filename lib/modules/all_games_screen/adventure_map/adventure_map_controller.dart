import 'package:get/get.dart';
import 'package:math_carnival_kids/modules/progress/progress_controller.dart';

class AdventureMapController extends GetxController {
  final ProgressController progressProvider = Get.find<ProgressController>();

  int get totalStars => progressProvider.totalStars.value;
}