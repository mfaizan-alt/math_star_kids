import 'package:get/get.dart';
import '../../core/services/stars_service.dart';

class GamesHomeController extends GetxController {
  
  late StarsService starsService;

  @override
  void onInit() {
    super.onInit();
    
    // Get or create StarsService
    if (!Get.isRegistered<StarsService>()) {
      Get.put(StarsService());
    }
    starsService = StarsService.to;
  }

  @override
  void onReady() {
    super.onReady();
    // Refresh stars when screen comes into focus
    refreshStars();
  }

  /// Refresh stars from service (called when returning from games)
  Future<void> refreshStars() async {
    await starsService.loadTotalStars();
  }
}