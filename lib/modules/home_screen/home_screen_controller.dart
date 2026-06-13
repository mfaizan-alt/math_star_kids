import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../core/services/stars_service.dart';
import '../progress/progress_controller.dart';

class HomeScreenController extends GetxController {
  final box = GetStorage();

  final todayMissionTitle = 'Today\'s Mission'.obs;
  final todayMissionSubtitle = 'Finish the current story and earn stars'.obs;
  final currentMissionRoute = '/storyModeScreen'.obs;

  final RxString childName = ''.obs;
  final RxString childAvatar = '🦊'.obs;
  final RxInt totalStars = 0.obs;
  final RxInt streakDays = 0.obs;

  late StarsService starsService;
  bool masteryDialogShown = false;

  @override
  void onInit() {
    super.onInit();

    if (!Get.isRegistered<StarsService>()) {
      Get.put(StarsService());
    }
    starsService = StarsService.to;

    loadChildData();

    starsService.onMasteryReached = _showMasteryDialog;

    ever(starsService.totalStars, (_) {
      totalStars.value = starsService.getTotalStars();
    });
  }
  @override
  void onReady() {
    super.onReady();
    refreshStars();
    loadUserData();
    _syncStreak();
  }

  /// Record today's visit and mirror the single source of truth
  /// (ProgressController.currentStreak) into the home header chip.
  Future<void> _syncStreak() async {
    if (!Get.isRegistered<ProgressController>()) return;
    final p = Get.find<ProgressController>();
    await p.recordDailyActivity();
    streakDays.value = p.currentStreak;
  }

// call this every time screen comes into focus
  void loadUserData() {
    final box = GetStorage();
    childName.value = box.read<String>('childName') ?? 'Champ';
    childAvatar.value = box.read<String>('avatar') ?? '🦊';
  }

  void loadChildData() {
    childName.value = box.read('childName') ?? 'Friend';
    childAvatar.value = box.read('avatar') ?? '🦊';
    totalStars.value = starsService.getTotalStars();
    streakDays.value = box.read('streakDays') ?? 0;
    updateMissionText();
  }

  void updateMissionText() {
    final stars = totalStars.value;

    if (stars < 20) {
      todayMissionTitle.value = 'Today\'s Mission';
      todayMissionSubtitle.value = 'Practice and learn simple tables';
    } else if (stars < 50) {
      todayMissionTitle.value = 'Today\'s Mission';
      todayMissionSubtitle.value = 'Finish Mango Orchard Adventure — Tables ×2';
    } else if (stars < 100) {
      todayMissionTitle.value = 'Today\'s Mission';
      todayMissionSubtitle.value = 'Unlock premium math stories';
    } else {
      todayMissionTitle.value = 'Master Learner!';
      todayMissionSubtitle.value = 'Premium stories are ready to explore';
    }
  }

  Future<void> refreshStars() async {
    await starsService.loadTotalStars();
    totalStars.value = starsService.getTotalStars();
    updateMissionText();
  }

  void _showMasteryDialog() {
    if (masteryDialogShown) return;
    masteryDialogShown = true;

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
                color: Colors.black.withValues(alpha: 0.3),
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
                  const Text(
                    '🏆',
                    style: TextStyle(fontSize: 80),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Master Learner!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFFD166),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '100 ⭐ COMPLETED',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFFFFD166).withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      'You have reached enough stars to access premium stories!\n\n2 advanced math stories\n3 premium reading stories\n\nTap to explore and enjoy your new stories 🚀',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withValues(alpha: 0.9),
                        height: 1.6,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      5,
                          (index) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Text(
                          '⭐',
                          style: TextStyle(
                            fontSize: 24,
                            color: const Color(0xFFFFD166)
                                .withValues(alpha: 0.8 + (index * 0.04)),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
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
                            color: const Color(0xFFEF476F).withValues(alpha: 0.4),
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