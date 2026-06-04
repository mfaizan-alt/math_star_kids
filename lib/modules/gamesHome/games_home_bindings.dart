import 'package:get/get.dart';

import '../../core/services/stars_service.dart';
import 'games_home_controller.dart';
import '../progress/progress_controller.dart';

class GamesHomeBinding implements Bindings {
  @override
  void dependencies() {
    // Initialize ProgressController for tracking game progress and stars
    Get.lazyPut<ProgressController>(() => ProgressController());
    
    // Initialize GamesHomeController
    Get.lazyPut<GamesHomeController>(() => GamesHomeController());
    
    // Ensure StarsService is available
    if (!Get.isRegistered<StarsService>()) {
      Get.put(StarsService());
    }
  }
}
