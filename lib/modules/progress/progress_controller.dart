import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_constants.dart';
import '../../core/services/stars_service.dart';

class ProgressController extends GetxController {
  var totalStars = 0.obs;
  int highScore = 0;
  int currentStreak = 0;

  final Map<String, int> moduleLevels = {};
  final Map<String, int> moduleStars = {};

  @override
  void onInit() {
    super.onInit();
    loadProgress();
  }

  int getModuleLevel(String module) => moduleLevels[module] ?? 1;
  int getModuleStars(String module) => moduleStars[module] ?? 0;

  Future<void> loadProgress() async {
    final prefs = await SharedPreferences.getInstance();

    totalStars.value = prefs.getInt(AppConstants.keyTotalStars) ?? 0;
    highScore = prefs.getInt(AppConstants.keyHighScore) ?? 0;
    currentStreak = prefs.getInt(AppConstants.keyCurrentStreak) ?? 0;

    for (final module in [
      'addition',
      'subtraction',
      'multiplication',
      'division',
      'counting',
      'numbers'
    ]) {
      moduleLevels[module] = prefs.getInt('${module}_level') ?? 1;
      moduleStars[module] = prefs.getInt('${module}_stars') ?? 0;
    }

    update();
  }

  Future<void> addStars(String module, int stars) async {
    totalStars.value += stars;

    moduleStars[module] = (moduleStars[module] ?? 0) + stars;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(AppConstants.keyTotalStars, totalStars.value);
    await prefs.setInt('${module}_stars', moduleStars[module]!);

    if (Get.isRegistered<StarsService>()) {
      await StarsService.to.addStars(stars, sourceName: module);
    }

    update();
  }

  Future<void> completeLevel(String module) async {
    final currentLevel = moduleLevels[module] ?? 1;

    if (currentLevel < AppConstants.maxLevel) {
      moduleLevels[module] = currentLevel + 1;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('${module}_level', moduleLevels[module]!);
    }

    update();
  }

  Future<void> updateHighScore(int score) async {
    if (score > highScore) {
      highScore = score;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(AppConstants.keyHighScore, highScore);

      update();
    }
  }

  Future<void> incrementStreak() async {
    currentStreak++;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(AppConstants.keyCurrentStreak, currentStreak);

    update();
  }

  Future<void> resetStreak() async {
    currentStreak = 0;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(AppConstants.keyCurrentStreak, 0);

    update();
  }
}