/// All user-facing strings in one place.
///
/// Screens must reference these constants instead of hardcoding text, so
/// copy changes (and future localization) only ever touch this file.
/// Story content lives in [StoryModeController] — it is data, not UI copy.
class AppStrings {
  AppStrings._();

  // ── General ──────────────────────────────────────
  static const String appName = 'Math Stars: Kids Learning Games';
  static const String back = 'Back';
  static const String home = '🏠 Home';
  static const String retry = '🔄 Retry';
  static const String playAgain = 'Play Again';
  static const String playNow = '▶  Play Now';
  static const String nextLevel = 'Next Level';
  static const String submitAnswer = 'Submit Answer';
  static const String gameOver = 'Game Over';
  static const String watchAdGetLife = 'Watch Ad → Get 1 Life';
  static const String score = 'Score';
  static const String stars = 'Stars';
  static const String bestScore = 'Best Score';
  static const String streak = 'Streak';

  // ── Home Screen ──────────────────────────────────
  static const String welcomeBack = 'Welcome Back,';
  static const String subjects = '📚 Subjects';
  static const String todaysMission = "Today's Mission";
  static const String subjectStoryMode = 'Story Mode';
  static const String subjectStoryCount = '11 stories';
  static const String subjectMath = 'Math';
  static const String subjectMathCount = 'Tables & more';
  static const String subjectGames = 'Games';
  static const String subjectGamesCount = 'Play & Learn';

  // ── Story Mode ───────────────────────────────────
  static const String storyTitle = 'Kids Stories';
  static const String storySubtitle = 'Read, Learn and Have Fun!';
  static const String mathStoriesTab = '🧮   Math Stories';
  static const String readingStoriesTab = '📖   Reading Stories';
  static const String finishStory = 'Finish Story 🎉';
  static const String next = 'Next →';

  // ── Math Section ─────────────────────────────────
  static const String mathTitle = 'Math Time!';
  static const String mathSubtitle = 'Numbers are super fun 🌟';
  static const String pickAMode = 'Pick a Mode! 🎯';
  static const String whatToLearn = 'What do you want to learn today?';
  static const String funMathFact = 'Fun Math Fact!';
  static const String quizGame = '🎮 Quiz Game';
  static const String quizGameDesc =
      'Answer questions and earn stars!\nBeat your high score!';
  static const String mostPopular = '🔥 MOST POPULAR';
  static const String learnAndPractice = '📚 LEARN & PRACTICE';
  static const String tablesCardTitle = '✖️ Tables';
  static const String tablesCardDesc = 'Learn multiplication tables\nfrom 1 to 20!';
  static const String startLearning = 'Start Learning';
  static const String chipFast = '⏱️ Fast';
  static const String chipEarnStars = '⭐ Earn Stars';
  static const String chipCompete = '🏆 Compete';
  static const String chipOneToTwenty = '🔢 1 to 20';
  static const String chipRhythm = '🎵 Rhythm';
  static const String chipProgress = '📈 Progress';

  // ── Quiz Game ────────────────────────────────────
  static const String progress = 'Progress';

  // ── Times Tables ─────────────────────────────────
  static const String timesTables = 'Times Tables';
  static const String timesTablesSubtitle = 'Tables from 1 to 20 🌟';
  static const String tapTableToExplore = 'Tap a table to explore 👇';
  static const String table = 'Table';
  static const String tableOf = 'Table of';
  static const String multiplicationsToMaster = '10 multiplications to master!';
  static const String startQuizForTable = 'Start Quiz for Table';
  static const String pickAnotherTable = '← Pick Another Table';
  static const String whatIs = 'What is';

  // ── Games Hub ────────────────────────────────────
  static const String letsPlayGames = "Let's Play Games";
  static const String playAndLearn = 'Play & Learn!';
  static const String learningModules = '🎮 Learning Modules';
  static const String miniGames = '🎮 Mini Games';
  static const String mathRunnerGame = '🏃 Math Runner Game';
  static const String mathRunnerDesc = 'Run & pick the correct answer!';
  static const String adventureMap = '🗺 Adventure Map';
  static const String adventureMapDesc = 'Unlock games by earning stars!';

  // ── Progress Screen ──────────────────────────────
  static const String myProgress = 'My Progress';
  static const String myProgressSubtitle = 'Track your stars and achievements!';
  static const String totalStarsEarned = 'Total Stars Earned';
  static const String highScore = 'High Score';
  static const String moduleProgress = 'Module Progress';
  static const String achievements = 'Achievements';

  // ── Counting Game ────────────────────────────────
  static const String countingTitle = 'Counting 🔢';
  static const String countTheItems = 'Count the items!';
  static const String round = 'Round';
  static const String of = 'of';
  static const String amazing = '🎉 Amazing!';
  static const String correctTick = '✅ Correct!';
  static const String tryAgainCross = '❌ Try again!';
  static const String goodJob = '👍 Good Job!';
  static const String keepTrying = '💪 Keep Trying!';

  // ── Shared game UI ───────────────────────────────
  static const String easy = 'Easy';
  static const String medium = 'Medium';
  static const String hard = 'Hard';
  static const String homeShort = 'Home';
  static const String again = 'Again';
  static const String question = 'Question';
  static const String howToPlay = 'How to Play';
  static const String level = 'Level';
  static const String start = 'START';
  static const String gameOverExcl = 'Game Over!';
  static const String greatJob = '🎉 Great Job!';
  static const String goodTry = '👍 Good Try!';
  static const String keepPracticing = '💪 Keep Practicing!';

  // ── Module game titles ───────────────────────────
  static const String additionTitle = 'Addition ➕';
  static const String subtractionTitle = 'Subtraction ➖';
  static const String multiplicationTitle = 'Multiplication ✖️';
  static const String divisionTitle = 'Division ➗';
  static const String timesTablesEmojiTitle = 'Times Tables 📊';

  // ── Frog Jump ────────────────────────────────────
  static const String frogJumpTitle = 'Frog Jump';
  static const String frogJumpTagline =
      'Hop to the correct answer before time runs out!';
  static const String chooseLilyPad = 'Choose the right lily pad!';
  static const String correctExcl = 'Correct 🎉';
  static const String oopsTryAgain = 'Oops, try again!';

  // ── Math Runner ──────────────────────────────────
  static const String runnerTitle = '🏃 Math Runner';
  static const String runnerTagline =
      'Move the character to the\ncorrect answer!';
  static const String solveIt = 'Solve it! 🤔';
  static const String left = 'LEFT';
  static const String right = 'RIGHT';
  static const String speed = 'Speed';
  static const String runnerMsgChampion = "Amazing! You're a Math Champion!";
  static const String runnerMsgGreat = 'Great job! Keep practicing!';
  static const String runnerMsgGoodTry =
      "Good try! You'll do better next time!";

  // ── Number Pop ───────────────────────────────────
  static const String numberPopTitle = 'Number Pop!';
  static const String numberPopTagline =
      'Pop the bubble with the\ncorrect answer!';
  static const String popCorrectBubble = 'Pop the correct bubble! 🫧';
  static const String needStarsToPlay =
      'You need 10 stars to play this game!';

  // ── Math Puzzle ──────────────────────────────────
  static const String puzzleHowTo =
      'Tap the tiles below to fill the empty boxes and make a correct math equation!';
  static const String tapFilledBoxBack =
      '👆 Tap a filled box to put the tile back';
  static const String reset = 'Reset';

  // ── Math Circus ──────────────────────────────────
  static const String balance = 'Balance!';
  static const String circusHowTo1 =
      'See the target weight on the left side of the scale';
  static const String circusHowTo2 =
      'Tap weights below to place them on the right side';
  static const String circusHowTo3 =
      'Make both sides equal to balance the scale! ⚖️';
  static const String circusHowTo4 =
      'Added too much? Tap Reset to clear the scale and try again';
  static const String target = 'Target';
  static const String now = 'Now';

  // ── Number Builder ───────────────────────────────
  static const String buildThisNumber = 'Build this number';
  static const String yourNumber = 'Your Number';
  static const String hundreds = 'Hundreds';
  static const String tens = 'Tens';
  static const String ones = 'Ones';
  static const String builderHowTo1 =
      'Look at the target number shown at the top';
  static const String builderHowTo2 =
      'Use the sliders to set Hundreds, Tens and Ones';
  static const String builderHowTo3 =
      'Match the number exactly to move to next level! 🎉';
  static const String builderExample =
      'Example: 253 = 2 Hundreds + 5 Tens + 3 Ones';

  // ── Adventure Map ────────────────────────────────
  static const String unlockByStars = 'Unlock new games by earning stars!';
  static const String playNowShort = 'Play now!';
  static const String gameMathRunner = 'Math Runner';
  static const String gameNumberPop = 'Number Pop';
  static const String gameMathPuzzle = 'Math Puzzle';
  static const String gameMathCircus = 'Math Circus';
  static const String gameNumberBuilder = 'Number Builder';
  static const String gameFrogJump = 'Frog Jump';
  static const String gameSpeedBattle = 'Speed Battle';
  static const String unlock = 'Unlock';
  static const String cancel = 'Cancel';
  static const String playerOne = 'P1';
  static const String playerTwo = 'P2';

  // ── Quiz Result ──────────────────────────────────
  static const String yourScore = 'Your Score';
  static const String continueToGame = 'Continue to Game Screen';
  static const String mathChampion = '🏆 Math Champion!';
  static const String greatJobStar = '🌟 Great Job!';

  // ── Story Detail ─────────────────────────────────
  static const String scene = 'Scene';
  static const String storyComplete = 'Story Complete! 🎉';
  static const String correctWellDone = '🌟 Correct! Well Done!';
  static const String imageNotFound = 'Image not found';

  // ── Setup Screen ─────────────────────────────────
  static const String whatsYourName = "What's Your Name?";
  static const String parentSetupHint = 'Your parent can set this up for you!';
  static const String enterNameHint = 'Enter name here...';
  static const String pickYourAvatar = 'Pick Your Avatar 😊';
  static const String chooseLanguage = 'Choose Language 🌍';
  static const String letsGo = "Let's Go! 🚀";

  // ── Splash ───────────────────────────────────────
  static const String splashTitle = 'Math Stars';
  static const String splashTagline = 'Learn · Play · Shine ⭐';
}
