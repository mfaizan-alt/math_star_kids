import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'core/commonWidgets/ads/ad_manager.dart';
import 'core/commonWidgets/theme.dart';
import 'core/routes/routes.dart';
import 'core/services/stars_service.dart';

// adUnitId: 'ca-app-pub-2983283750660362/8109778088'),real unit id,

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();
  AdManager.instance.load();
  await GetStorage.init();

  Get.put(StarsService());
  Get.put(ThemeController());

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
    ));
  }
}



// import 'package:flutter/material.dart';
// import 'package:flutter/foundation.dart'; // for kReleaseMode
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:device_preview/device_preview.dart';
//
// import 'core/commonWidgets/ads/ad_manager.dart';
// import 'core/commonWidgets/theme.dart';
// import 'core/routes/routes.dart';
// import 'core/services/stars_service.dart';
// import 'modules/home_screen/home_screen_controller.dart';
//
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//
//   // Initialize ads only on mobile (not web)
//   if (!kIsWeb) {
//     await MobileAds.instance.initialize();
//     AdManager.instance.load();
//   }
//
//   await GetStorage.init();
//
//   Get.put(StarsService());
//   Get.put(ThemeController());
//   Get.put(HomeScreenController());
//
//   runApp(
//     DevicePreview(
//       enabled: !kReleaseMode,
//       builder: (context) => const MyApp(),
//     ),
//   );
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: AppTheme.light,
//       darkTheme: AppTheme.dark,
//       themeMode: ThemeMode.system,
//       initialRoute: Routes.splashScreen,
//       getPages: Routes.getPage,
//       useInheritedMediaQuery: true,
//       locale: DevicePreview.locale(context),
//       builder: DevicePreview.appBuilder,
//     );
//   }
// }