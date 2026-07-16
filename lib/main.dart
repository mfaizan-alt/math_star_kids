import 'dart:async';

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

  // ── Firebase core (fast — reads google-services.json, no network) ────────
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Crashlytics error handlers must be wired up before any UI runs.
  FlutterError.onError = (details) {
    if (_isBenignFontFetchError(details.exception)) return;
    FirebaseCrashlytics.instance.recordFlutterFatalError(details);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    // google_fonts downloads typefaces from fonts.gstatic.com the first time
    // they're used. On an offline device that download throws — but the text
    // simply falls back to a system font, so it is NOT a crash and must not be
    // reported as fatal (it was previously the top "Fatal Exception").
    if (_isBenignFontFetchError(error)) {
      if (kDebugMode) debugPrint('Ignored offline google_fonts fetch: $error');
      return true;
    }
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  // Fire-and-forget — doesn't need to block launch.
  unawaited(FirebaseCrashlytics.instance
      .setCrashlyticsCollectionEnabled(!kDebugMode));

  // ── System UI (synchronous) ───────────────────────────────────────────────
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  // ── Local storage (fast — no network) ────────────────────────────────────
  await GetStorage.init();

  // ── AdMob init (local SDK init, fast) ────────────────────────────────────
  await MobileAds.instance.initialize();
  // Kids-compliant ad config: COPPA child-directed + GDPR under-age-of-consent,
  // G-rated content only. Forces non-personalized ads and no Advertising ID use.
  MobileAds.instance.updateRequestConfiguration(
    RequestConfiguration(
      tagForChildDirectedTreatment: TagForChildDirectedTreatment.yes,
      tagForUnderAgeOfConsent: TagForUnderAgeOfConsent.yes,
      maxAdContentRating: MaxAdContentRating.g,
    ),
  );

  // ── GetX services ─────────────────────────────────────────────────────────
  Get.put(StarsService());
  Get.put(PremiumService(), permanent: true);
  Get.put(ThemeController());
  Get.put(ProgressController(), permanent: true);
  Get.put(HomeScreenController(), permanent: true);

  // After PremiumService so a paid device never preloads an interstitial.
  AdManager.instance.load();

  // ── Launch the app immediately ────────────────────────────────────────────
  runApp(const MyApp());

  // ── Deferred network-dependent init (runs after first frame) ─────────────
  // These are safe to run after launch — all have sensible defaults.
  unawaited(_initAfterLaunch());
}

/// True for the harmless "couldn't download a Google font while offline" error.
/// google_fonts throws a plain [Exception] whose message begins with
/// "Failed to load font", wrapping a SocketException/ClientException. When this
/// happens the text just renders in a fallback system font, so it should never
/// be recorded as a fatal crash.
bool _isBenignFontFetchError(Object? error) {
  if (error == null) return false;
  final message = error.toString();
  return message.contains('Failed to load font') ||
      (message.contains('fonts.gstatic.com') &&
          (message.contains('SocketException') ||
              message.contains('ClientException') ||
              message.contains('Failed host lookup')));
}

/// Network-dependent services that must NOT block the initial frame render.
/// Remote Config uses local defaults until fetch completes; Notifications and
/// Review service have no visible effect until the user reaches the home screen.
Future<void> _initAfterLaunch() async {
  try {
    await ReviewService.instance.recordInstall();
    await RemoteConfigService.instance.init();
    await NotificationService.instance.init();
  } catch (e) {
    if (kDebugMode) debugPrint('Post-launch init error: $e');
  }
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
            AnalyticsService.instance.observer,
          ],
        ));
  }
}
