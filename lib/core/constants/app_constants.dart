class AppConstants {
  AppConstants._();

  static const String appName = 'Math Kids';
  static const int maxLevel = 10;
  static const int questionsPerRound = 10;
  static const int quizTimeSeconds = 60;
  static const int quizTotalQuestions = 10;

  // Difficulty ranges
  static const int easyMax = 10;
  static const int mediumMax = 50;
  static const int hardMax = 100;

  // Points
  static const int correctPoints = 10;
  static const int bonusPoints = 5;
  static const int streakBonus = 20;

  // Shared Preferences Keys
  static const String keyThemeMode = 'theme_mode';
  static const String keyTotalStars = 'total_stars';
  static const String keyHighScore = 'high_score';
  static const String keyCompletedLevels = 'completed_levels';
  static const String keyCurrentStreak = 'current_streak';
  static const String keySelectedAge = 'selected_age';
}

