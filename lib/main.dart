import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'core/commonWidgets/ads/ad_manager.dart';
import 'core/routes/routes.dart';
import 'core/services/stars_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();
  AdManager.instance.load();
  await GetStorage.init();
  
  // Initialize StarsService
  Get.put(StarsService());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.splashScreen, // ← use Routes constant
      getPages: Routes.getPage,          // ← point to Routes.getPage
    );
  }
}