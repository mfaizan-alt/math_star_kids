import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'core/commonWidgets/ads/ad_manager.dart';
import 'core/commonWidgets/theme.dart';
import 'core/routes/routes.dart';
import 'core/services/analytics_service.dart';
import 'core/services/notification_service.dart';
import 'core/services/premium_service.dart';
import 'core/services/remote_config_service.dart';
import 'core/services/review_service.dart';
import 'core/services/stars_service.dart';
import 'firebase_options.dart';
import 'modules/home_screen/home_screen_controller.dart';
import 'modules/progress/progress_controller.dart';

// AdMob App ID: ca-app-pub-3807575016898926~5841641734 (set in AndroidManifest + Info.plist)

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ── Firebase ──────────────────────────────────────
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Crashlytics — catch all Flutter framework errors.
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  // Catch async errors outside Flutter (e.g. in isolates).
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  // Disable Crashlytics in debug so test crashes don't pollute dashboard.
  await FirebaseCrashlytics.instance
      .setCrashlyticsCollectionEnabled(!kDebugMode);

  // Record install date for review prompt eligibility.
  await ReviewService.instance.recordInstall();

  // Remote Config — fetch latest values before app renders.
  await RemoteConfigService.instance.init();

  // Push Notifications
  await NotificationService.instance.init();

  // ── System UI ────────────────────────────────────
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  // ── AdMob ────────────────────────────────────────
  await MobileAds.instance.initialize();
  // Kids app: child-directed, G-rated ads (Play Families policy).
  MobileAds.instance.updateRequestConfiguration(
    RequestConfiguration(
      tagForChildDirectedTreatment: TagForChildDirectedTreatment.yes,
      maxAdContentRating: MaxAdContentRating.g,
    ),
  );

  await GetStorage.init();

  // ── GetX services ────────────────────────────────
  Get.put(StarsService());
  Get.put(PremiumService(), permanent: true);
  Get.put(ThemeController());
  Get.put(ProgressController(), permanent: true);
  Get.put(HomeScreenController(), permanent: true);

  // After PremiumService so a paid device never preloads an interstitial.
  AdManager.instance.load();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return Obx(() => GetMaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: themeController.themeMode,
          initialRoute: Routes.splashScreen,
          getPages: Routes.getPage,
          navigatorObservers: [
            AdNavigationObserver(),
            AnalyticsService.instance.observer, // auto screen tracking
          ],
        ));
  }
}
