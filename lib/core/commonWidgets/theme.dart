import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../colors/colors.dart';
import '../constants/app_constants.dart';

class ThemeController extends GetxController {
  final _box = GetStorage();
  final _isDark = false.obs; // ✅

  bool get isDarkMode => _isDark.value;
  ThemeMode get themeMode => _isDark.value ? ThemeMode.dark : ThemeMode.light;

  @override
  void onInit() {
    super.onInit();
    _isDark.value = _box.read<bool>(AppConstants.keyThemeMode) ?? false; // ✅ load saved
  }

  Future<void> toggleTheme() async {
    _isDark.value = !_isDark.value; // ✅ triggers Obx
    await _box.write(AppConstants.keyThemeMode, _isDark.value);
    update(); // ✅ triggers GetBuilder
  }
}
 // adjust path

class AppTheme {
  static ThemeData get light => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.backgroundLight,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primaryLight,
      primaryContainer: AppColors.primaryVariantLight,
      secondary: AppColors.secondaryLight,
      surface: AppColors.surfaceLight,
      onPrimary: AppColors.white,
      onSurface: AppColors.textPrimaryLight,
      onSurfaceVariant: AppColors.textSecondaryLight,
    ),
    cardTheme: const CardThemeData(
      color: AppColors.cardLight,
      elevation: 4,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.backgroundLight,
      foregroundColor: AppColors.textPrimaryLight,
      elevation: 0,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.textPrimaryLight),
      bodyMedium: TextStyle(color: AppColors.textSecondaryLight),
      titleLarge: TextStyle(color: AppColors.textPrimaryLight),
      titleMedium: TextStyle(color: AppColors.textPrimaryLight),
    ),
    iconTheme: const IconThemeData(color: AppColors.textPrimaryLight),
  );

  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.backgroundDark,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primaryDark,
      primaryContainer: AppColors.primaryVariantDark,
      secondary: AppColors.secondaryDark,
      surface: AppColors.surfaceDark,
      onPrimary: AppColors.white,
      onSurface: AppColors.textPrimaryDark,
      onSurfaceVariant: AppColors.textSecondaryDark,
    ),
    cardTheme: const CardThemeData(
      color: AppColors.cardDark,
      elevation: 4,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.backgroundDark,
      foregroundColor: AppColors.textPrimaryDark,
      elevation: 0,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.textPrimaryDark),
      bodyMedium: TextStyle(color: AppColors.textSecondaryDark),
      titleLarge: TextStyle(color: AppColors.textPrimaryDark),
      titleMedium: TextStyle(color: AppColors.textPrimaryDark),
    ),
    iconTheme: const IconThemeData(color: AppColors.textPrimaryDark),
  );
}