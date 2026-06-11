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
  Get.put(ThemeController()); // ← register here

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