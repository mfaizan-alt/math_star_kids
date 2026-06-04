import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../core/services/stars_service.dart';

class HomeScreenController extends GetxController {

  final box = GetStorage();

  // Reactive variables
  RxString childName = ''.obs;
  RxString childAvatar = '🦊'.obs;
  RxInt totalStars = 0.obs;
  RxInt streakDays = 0.obs;

  late StarsService starsService;
  bool masteryDialogShown = false;

  @override
  void onInit() {
    super.onInit();
    // Initialize StarsService if not already initialized
    if (!Get.isRegistered<StarsService>()) {
      Get.put(StarsService());
    }
    starsService = StarsService.to;
    
    loadChildData();
    
    // Register callback for mastery achievement
    starsService.onMasteryReached = _showMasteryDialog;
    
    // Listen to stars updates from the service
    ever(starsService.totalStars, (_) {
      totalStars.value = starsService.getTotalStars();
    });
  }

  @override
  void onReady() {
    super.onReady();
    // Refresh stars when screen comes into focus to ensure latest data
    refreshStars();
    
    // If already unlocked and not shown yet, show dialog once
    if (starsService.arePremiumStoriesUnlocked() && !masteryDialogShown) {
      Future.delayed(const Duration(milliseconds: 500), () {
        _showMasteryDialog();
      });
    }
  }

  void loadChildData() {
    childName.value  = box.read('childName')  ?? 'Friend';
    childAvatar.value = box.read('avatar')    ?? '🦊';
    totalStars.value = starsService.getTotalStars();
    streakDays.value = box.read('streakDays') ?? 0;
  }

  /// Refresh stars from service (called when returning to home screen)
  Future<void> refreshStars() async {
    await starsService.loadTotalStars();
    totalStars.value = starsService.getTotalStars();
  }

  /// Show celebration dialog when reaching 40 stars
  void _showMasteryDialog() {
    if (masteryDialogShown) return;
    masteryDialogShown = true;
    
    // Show dialog with celebration
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A2E),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Trophy emoji with animation
                  const Text(
                    '🏆',
                    style: TextStyle(fontSize: 80),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Title
                  Text(
                    'Master Learner!',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFFD166),
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Subtitle
                  Text(
                    '40 ⭐ COMPLETED',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Achievement message
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFFFFD166).withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      'You\'ve unlocked premium content!\n\n2 advanced math stories\n3 premium reading stories\n\nKeep up your amazing progress! 🚀',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.9),
                        height: 1.6,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Stars earned badges
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ...List.generate(
                        5,
                        (index) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Text(
                            '⭐',
                            style: TextStyle(
                              fontSize: 24,
                              color: const Color(0xFFFFD166).withOpacity(0.8 + (index * 0.04)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Button
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFFEF476F),
                            Color(0xFFFF9F1C),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFEF476F).withOpacity(0.4),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          'Continue Your Adventure',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }
}