import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service to manage stars across the entire app
/// Provides a centralized way to add, track, and persist stars
class StarsService extends GetxService {
  static StarsService get to => Get.find();

  final box = GetStorage();
  late SharedPreferences _prefs;

  // Reactive total stars
  final RxInt totalStars = 0.obs;

  // Callback when 40 stars reached (for unlocking premium content)
  Function? onMasteryReached;

  /// Initialize storage and load the persisted total.
  /// Call via `Get.putAsync` so dependents never read `_prefs` before it's set.
  Future<StarsService> init() async {
    _prefs = await SharedPreferences.getInstance();
    await loadTotalStars();
    return this;
  }

  /// Load total stars from storage
  Future<void> loadTotalStars() async {
    // Try GetStorage first (used by stories and quiz)
    int? starsFromGetStorage = box.read('totalStars');
    
    // Try SharedPreferences (used by mini games)
    int? starsFromPrefs = _prefs.getInt('totalStars');

    // Use the maximum of both sources to ensure data isn't lost
    int maxStars = 0;
    if (starsFromGetStorage != null) maxStars = starsFromGetStorage;
    if (starsFromPrefs != null && starsFromPrefs > maxStars) maxStars = starsFromPrefs;

    totalStars.value = maxStars;
  }

  /// Add stars from a story or game
  Future<void> addStars(int earnedStars, {String? sourceName}) async {
    if (earnedStars <= 0) return;

    final newTotal = totalStars.value + earnedStars;
    totalStars.value = newTotal;

    // Save to both storage systems to ensure consistency
    await box.write('totalStars', newTotal);
    await _prefs.setInt('totalStars', newTotal);

    // Check if mastery (40 stars) reached for first time
    final previousTotal = newTotal - earnedStars;
    if (previousTotal < 40 && newTotal >= 40) {
      await unlockPremiumStories();
      // Trigger callback if registered
      if (onMasteryReached != null) {
        onMasteryReached!();
      }
    }
  }

  /// Get current total stars
  int getTotalStars() => totalStars.value;

  /// Check if premium stories are unlocked (40+ stars)
  bool arePremiumStoriesUnlocked() {
    return box.read('premiumStoriesUnlocked') ?? false;
  }

  /// Unlock premium stories (2 math + 3 reading)
  Future<void> unlockPremiumStories() async {
    await box.write('premiumStoriesUnlocked', true);
    // Also save to SharedPreferences for backup
    await _prefs.setBool('premiumStoriesUnlocked', true);
  }

  /// Reset stars and lock premium content (for testing)
  Future<void> resetStars() async {
    totalStars.value = 0;
    await box.write('totalStars', 0);
    await _prefs.setInt('totalStars', 0);
    await box.write('premiumStoriesUnlocked', false);
    await _prefs.setBool('premiumStoriesUnlocked', false);
  }
}

