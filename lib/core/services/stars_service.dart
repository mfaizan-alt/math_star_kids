import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StarsService extends GetxService {
  static StarsService get to => Get.find();

  final box = GetStorage();

  // _prefs is resolved asynchronously. onInit() is async, but GetX runs dependent
  // controllers' onReady() on the same frame WITHOUT awaiting it — so methods like
  // loadTotalStars() can run before _prefs is assigned (this crashed in production
  // with a LateInitializationError). _getPrefs() resolves it once and lazily; every
  // accessor awaits it, so call order no longer matters.
  Future<SharedPreferences>? _prefsFuture;

  Future<SharedPreferences> _getPrefs() =>
      _prefsFuture ??= SharedPreferences.getInstance();

  final RxInt totalStars = 0.obs;
  final RxBool premiumStoriesUnlocked = false.obs;

  static const int masteryThreshold = 100;

  Function? onMasteryReached;

  @override
  Future<void> onInit() async {
    super.onInit();
    await loadTotalStars();
  }

  Future<void> loadTotalStars() async {
    final prefs = await _getPrefs();
    final starsFromGetStorage = box.read('totalStars') as int?;
    final starsFromPrefs = prefs.getInt('totalStars');
    final unlockedFromBox = box.read('premiumStoriesUnlocked') as bool?;
    final unlockedFromPrefs = prefs.getBool('premiumStoriesUnlocked');

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

    final prefs = await _getPrefs();
    final previousTotal = totalStars.value;
    final newTotal = totalStars.value + earnedStars;

    totalStars.value = newTotal;

    await box.write('totalStars', newTotal);
    await prefs.setInt('totalStars', newTotal);

    if (previousTotal < masteryThreshold && newTotal >= masteryThreshold) {
      await unlockPremiumStories();
      onMasteryReached?.call();
    }
  }

  Future<bool> spendStars(int requiredStars) async {
    if (requiredStars <= 0) return true;
    if (totalStars.value < requiredStars) return false;

    final prefs = await _getPrefs();
    totalStars.value -= requiredStars;
    await box.write('totalStars', totalStars.value);
    await prefs.setInt('totalStars', totalStars.value);
    return true;
  }

  int getTotalStars() => totalStars.value;

  bool arePremiumStoriesUnlocked() => premiumStoriesUnlocked.value;

  Future<void> unlockPremiumStories() async {
    final prefs = await _getPrefs();
    premiumStoriesUnlocked.value = true;
    await box.write('premiumStoriesUnlocked', true);
    await prefs.setBool('premiumStoriesUnlocked', true);
  }

  Future<void> resetStars() async {
    final prefs = await _getPrefs();
    totalStars.value = 0;
    premiumStoriesUnlocked.value = false;
    await box.write('totalStars', 0);
    await prefs.setInt('totalStars', 0);
    await box.write('premiumStoriesUnlocked', false);
    await prefs.setBool('premiumStoriesUnlocked', false);
  }
}