import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:math_carnival_kids/core/services/stars_service.dart';
import '../../../core/constants/app_strings.dart';

class AdventureMapController extends GetxController {
  late StarsService starsService;

  final RxSet<String> unlockedLevels = <String>{}.obs;
  final RxString pendingRoute = ''.obs;

  @override
  void onInit() {
    super.onInit();
    starsService = Get.find<StarsService>();
    loadUnlockedLevels();
  }

  void loadUnlockedLevels() {
    final saved = starsService.box.read('unlockedLevels');
    if (saved is List) {
      unlockedLevels.addAll(saved.cast<String>());
    }
  }

  Future<void> saveUnlockedLevels() async {
    await starsService.box.write('unlockedLevels', unlockedLevels.toList());
  }

  int get totalStars => starsService.totalStars.value;

  bool isUnlocked(String route) => unlockedLevels.contains(route);

  Future<void> unlockLevel(String route) async {
    unlockedLevels.add(route);
    pendingRoute.value = route;
    await saveUnlockedLevels();
  }

  void onLevelTap({
    required String route,
    required String name,
    required Widget screen,
    required int starsRequired,
  }) {
    if (isUnlocked(route)) {
      Get.to(() => screen);
      return;
    }

    if (totalStars < starsRequired) {
      Get.dialog(
        LockedLevelDialog(starsRequired: starsRequired),
        barrierDismissible: false,
      );
      return;
    }

    Get.dialog(
      UnlockLevelDialog(
        levelName: name,
        starsRequired: starsRequired,
        onUnlock: () async {
          final ok = await starsService.spendStars(starsRequired);
          if (!ok) return;

          await unlockLevel(route);

          Get.back();
          Future.microtask(() {
            Get.to(() => screen);
          });
        },
      ),
      barrierDismissible: false,
    );
  }
}

class UnlockLevelDialog extends StatelessWidget {
  final String levelName;
  final int starsRequired;
  final VoidCallback onUnlock;

  const UnlockLevelDialog({
    super.key,
    required this.levelName,
    required this.starsRequired,
    required this.onUnlock,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🔓', style: TextStyle(fontSize: 56)),
            const SizedBox(height: 12),
            Text(
              '${AppStrings.unlock} $levelName',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Spend $starsRequired ⭐ to unlock this level?',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Get.back(),
                    child: const Text(AppStrings.cancel),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onUnlock,
                    child: const Text(AppStrings.unlock),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class LockedLevelDialog extends StatelessWidget {
  final int starsRequired;

  const LockedLevelDialog({
    super.key,
    required this.starsRequired,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🔒', style: TextStyle(fontSize: 56)),
            const SizedBox(height: 12),
            const Text(
              'Level Locked',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Earn $starsRequired ⭐ to unlock this level.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Get.back(),
              child: const Text('OK'),
            ),
          ],
        ),
      ),
    );
  }
}