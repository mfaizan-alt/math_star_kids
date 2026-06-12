import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'core/commonWidgets/ads/ad_manager.dart';
import 'core/commonWidgets/theme.dart';
import 'core/routes/routes.dart';
import 'core/services/stars_service.dart';
import 'modules/progress/progress_controller.dart';

// adUnitId: 'ca-app-pub-2983283750660362/8109778088'),real unit id,

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Draw behind the status bar so each screen's top color shows through.
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  await MobileAds.instance.initialize();
  // Kids app: request only child-directed, G-rated ads (Play Families policy).
  MobileAds.instance.updateRequestConfiguration(
    RequestConfiguration(
      tagForChildDirectedTreatment: TagForChildDirectedTreatment.yes,
      maxAdContentRating: MaxAdContentRating.g,
    ),
  );
  AdManager.instance.load();
  await GetStorage.init();

  Get.put(StarsService());
  Get.put(ThemeController()); // ← register here
  Get.put(ProgressController(), permanent: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return Obx(() => GetMaterialApp( // ✅ Obx not GetBuilder
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeController.themeMode,
      initialRoute: Routes.splashScreen,
      getPages: Routes.getPage,
      navigatorObservers: [AdNavigationObserver()],
    ));
  }
}