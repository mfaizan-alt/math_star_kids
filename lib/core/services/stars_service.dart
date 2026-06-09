import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StarsService extends GetxService {
  static StarsService get to => Get.find();

  final box = GetStorage();
  late SharedPreferences _prefs;

  final RxInt totalStars = 0.obs;
  final RxBool premiumStoriesUnlocked = false.obs;

  static const int masteryThreshold = 100;

  Function? onMasteryReached;

  @override
  Future<void> onInit() async {
    super.onInit();
    _prefs = await SharedPreferences.getInstance();
    await loadTotalStars();
  }

  Future<void> loadTotalStars() async {
    final starsFromGetStorage = box.read('totalStars') as int?;
    final starsFromPrefs = _prefs.getInt('totalStars');
    final unlockedFromBox = box.read('premiumStoriesUnlocked') as bool?;
    final unlockedFromPrefs = _prefs.getBool('premiumStoriesUnlocked');

    int maxStars = 0;
    if (starsFromGetStorage != null) maxStars = starsFromGetStorage;
    if (starsFromPrefs != null && starsFromPrefs > maxStars) maxStars = starsFromPrefs;

    totalStars.value = maxStars;
    premiumStoriesUnlocked.value =
        (unlockedFromBox ?? false) ||
            (unlockedFromPrefs ?? false) ||
            maxStars >= masteryThreshold;

    if (premiumStoriesUnlocked.value) {
      await unlockPremiumStories();
    }
  }

  Future<void> addStars(int earnedStars, {String? sourceName}) async {
    if (earnedStars <= 0) return;

    final previousTotal = totalStars.value;
    final newTotal = totalStars.value + earnedStars;

    totalStars.value = newTotal;

    await box.write('totalStars', newTotal);
    await _prefs.setInt('totalStars', newTotal);

    if (previousTotal < masteryThreshold && newTotal >= masteryThreshold) {
      await unlockPremiumStories();
      onMasteryReached?.call();
    }
  }

  Future<bool> spendStars(int requiredStars) async {
    if (requiredStars <= 0) return true;
    if (totalStars.value < requiredStars) return false;

    totalStars.value -= requiredStars;
    await box.write('totalStars', totalStars.value);
    await _prefs.setInt('totalStars', totalStars.value);
    return true;
  }

  int getTotalStars() => totalStars.value;

  bool arePremiumStoriesUnlocked() => premiumStoriesUnlocked.value;

  Future<void> unlockPremiumStories() async {
    premiumStoriesUnlocked.value = true;
    await box.write('premiumStoriesUnlocked', true);
    await _prefs.setBool('premiumStoriesUnlocked', true);
  }

  Future<void> resetStars() async {
    totalStars.value = 0;
    premiumStoriesUnlocked.value = false;
    await box.write('totalStars', 0);
    await _prefs.setInt('totalStars', 0);
    await box.write('premiumStoriesUnlocked', false);
    await _prefs.setBool('premiumStoriesUnlocked', false);
  }
}