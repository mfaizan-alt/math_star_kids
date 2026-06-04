import 'package:get/get_navigation/src/routes/get_route.dart';
import '../../modules/gamesHome/games_home_bindings.dart';
import '../../modules/gamesHome/games_home_screen_view.dart';
import '../../modules/home_screen/home_screen_binding.dart';
import '../../modules/home_screen/home_screen_view.dart';
import '../../modules/math_question_view/mathHome_view_binding.dart';
import '../../modules/math_question_view/mathHome_view_screen.dart';
import '../../modules/math_question_view/math_game_view/mathTable_game_bindings.dart';
import '../../modules/math_question_view/math_game_view/mathTable_game_view.dart';
import '../../modules/math_question_view/quiz_game_view/quiz_game_binding.dart';
import '../../modules/math_question_view/quiz_game_view/quiz_game_view.dart';
import '../../modules/set_up_screen/set_up_binding.dart';
import '../../modules/set_up_screen/set_up_view.dart';
import '../../modules/splash_screen/splash_screen_binding.dart';
import '../../modules/splash_screen/splash_screen_view.dart';
import '../../modules/story_detail_screen/story_detail_bindings.dart';
import '../../modules/story_detail_screen/story_detail_view.dart';
import '../../modules/story_mode_screen/story_mode_bindings.dart';
import '../../modules/story_mode_screen/story_mode_view.dart';

abstract class Routes {

  // ── Route Names ──────────────────────────────────
  static const String splashScreen  = '/splashScreen';
  static const String setUpScreen   = '/setUpScreen';
  static const String homeScreen    = '/homeScreen';
  static const String mathScreen    = '/mathScreen';
  static const String mathTable      = '/mathTable';
  static const String quizGameScreen      = '/quizGameScreen';
  static const String storyModeScreen      = '/storyModeScreen';
  static const String storyDetail = '/story-detail';
  static const String gameScreen = '/gameScreen';

  // ── Pages ────────────────────────────────────────
  static List<GetPage> getPage = [
    GetPage(
      name: splashScreen,
      page: () => const SplashScreenView(),
      binding: SplashScreenBinding(),
    ),
    GetPage(
      name: setUpScreen,
      page: () => const SetupScreenView(),
      binding: SetUpScreenBinding(),
    ),
    GetPage(
      name: homeScreen,
      page: () => const HomeScreenView(),
      binding: HomeScreenBinding(),
    ),
    GetPage(
      name: mathScreen,
      page: () => const MathHomeView(),
      binding: MathHomeBindings(),
    ),
    GetPage(
      name: mathTable,
      page: () => const MathTablesView(),     // ← quiz game screen
      binding: MathTableBindings(),
    ),
    GetPage(
      name: quizGameScreen,
      page: () => const QuizGameView(),     // ← quiz game screen
      binding: QuizGameBinding(),
    ),
    GetPage(
      name: storyModeScreen,
      page: () => const StoryModeView(),     // ← quiz game screen
      binding: StoryModeBindings(),
    ),
    GetPage(
      name: storyDetail,
      page: () => const StoryDetailView(),
      binding: StoryDetailBinding(),
    ),
    GetPage(
      name: gameScreen,
      page: () => GamesHomeScreenView(),
      binding: GamesHomeBinding(),
    ),
  ];
}