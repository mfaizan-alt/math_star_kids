import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:math_carnival_kids/modules/set_up_screen/set_up_controller.dart';

import '../../core/colors/colors.dart';
import '../../core/commonWidgets/ads/banner_ads.dart';
import '../../core/commonWidgets/theme.dart';
import '../../core/commonWidgets/screen_header.dart';
import '../../core/constants/app_strings.dart';

class SetupScreenView extends GetView<SetUpScreenController> {
  const SetupScreenView({super.key});

// 1. isDark must come from Obx, not just Get.find (won't rebuild)
// Replace the build method start:
  @override
  Widget build(BuildContext context) {
    return StatusBarIcons(
      light: Theme.of(context).brightness == Brightness.dark,
      child: _buildScreen(context),
    );
  }

  Widget _buildScreen(BuildContext context) {
    return Obx(() {
      final isDark = Get.find<ThemeController>().isDarkMode;
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor, // ✅
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(isDark),        // ✅ pass isDark
                const SizedBox(height: 28),
                _buildNameField(isDark),     // ✅ pass isDark
                const SizedBox(height: 28),
                _buildAvatarSection(isDark), // ✅ pass isDark
                const SizedBox(height: 40),
                _buildLetsGoButton(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BannerAdWidget(
            adUnitId: 'ca-app-pub-3940256099942544/6300978111'),
      );
    });
  }

// 2. _buildHeader — AppColors.navy hardcoded
  Widget _buildHeader(bool isDark) {
    return Column(
      children: [
        const Center(child: Text('👋', style: TextStyle(fontSize: 55))),
        const SizedBox(height: 12),
        Center(
          child: Text(
            AppStrings.whatsYourName,
            style: GoogleFonts.aBeeZee(
              fontSize: 28,
              color: isDark ? Colors.white : AppColors.navy, // ✅
            ),
          ),
        ),
        const SizedBox(height: 6),
        Center(
          child: Text(
            AppStrings.parentSetupHint,
            style: GoogleFonts.nunito(
              fontSize: 14,
              color: AppColors.grey, // grey works on both themes
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

// 3. _buildNameField — AppColors.white bg, AppColors.navy text
  Widget _buildNameField(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1F1F1F) : AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? Colors.white24 : Colors.black,
          width: 2.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller.nameController,
        textAlign: TextAlign.center,
        style: GoogleFonts.aBeeZee(
          fontSize: 22,
          color: isDark ? Colors.white : AppColors.navy,
        ),
        decoration: InputDecoration(
          hintText: AppStrings.enterNameHint,
          hintStyle: GoogleFonts.aBeeZee(
            fontSize: 18,
            color: isDark ? Colors.white38 : Colors.black,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 18,
            horizontal: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarSection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.pickYourAvatar,
          style: GoogleFonts.aBeeZee(
            fontSize: 18,
            color: isDark ? Colors.white : AppColors.navy, // ✅
          ),
        ),
        const SizedBox(height: 14),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: controller.avatars.length,
          itemBuilder: (context, index) {
            final avatar = controller.avatars[index];
            return Obx(() {
              final isSelected = controller.selectedAvatar.value == avatar;
              return GestureDetector(
                onTap: () => controller.selectAvatar(avatar),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.coralColor.withValues(alpha: 0.08)
                        : isDark ? const Color(0xFF1F1F1F) : AppColors.white, // ✅
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected ? AppColors.coralColor : AppColors.lightGrey,
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isSelected
                            ? AppColors.coralColor.withValues(alpha: 0.25)
                            : Colors.black.withValues(alpha: 0.05),
                        blurRadius: isSelected ? 14 : 6,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      avatar,
                      style: TextStyle(fontSize: isSelected ? 32 : 28),
                    ),
                  ),
                ),
              );
            });
          },
        ),
      ],
    );
  }

  // ── Language Section ────────────────────────────
  // Widget _buildLanguageSection() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text(
  //         AppStrings.chooseLanguage,
  //         style: GoogleFonts.aBeeZee(
  //           fontSize: 18,
  //           color: AppColors.navy,
  //         ),
  //       ),
  //       const SizedBox(height: 14),
  //       Row(
  //         children: [
  //           Expanded(child: _langButton('🇬🇧  English', 'en')),
  //           const SizedBox(width: 12),
  //           Expanded(child: _langButton('🇵🇰  اردو', 'ur')),
  //         ],
  //       ),
  //     ],
  //   );
  // }
  // Widget _langButton(String label, String value) {
  //   return Obx(() {
  //     final isSelected = controller.selectedLanguage.value == value;
  //     return GestureDetector(
  //       onTap: () => controller.selectLanguage(value),
  //       child: AnimatedContainer(
  //         duration: const Duration(milliseconds: 200),
  //         padding: const EdgeInsets.symmetric(vertical: 14),
  //         decoration: BoxDecoration(
  //           color: isSelected
  //               ? AppColors.skyBlue.withOpacity(0.08)
  //               : AppColors.white,
  //           borderRadius: BorderRadius.circular(14),
  //           border: Border.all(
  //             color: isSelected
  //                 ? AppColors.skyBlue      // ← clean
  //                 : AppColors.lightGrey,   // ← clean
  //             width: 3,
  //           ),
  //           boxShadow: [
  //             BoxShadow(
  //               color: isSelected
  //                   ? AppColors.blueShadow  // ← clean
  //                   : Colors.black.withOpacity(0.04),
  //               blurRadius: 10,
  //               offset: const Offset(0, 4),
  //             ),
  //           ],
  //         ),
  //         child: Center(
  //           child: Text(
  //             label,
  //             style: GoogleFonts.aBeeZee(
  //               fontSize: 16,
  //               color: isSelected
  //                   ? AppColors.skyBlue   // ← clean
  //                   : AppColors.grey,     // ← clean
  //             ),
  //           ),
  //         ),
  //       ),
  //     );
  //   });
  // }

  // ── Lets Go Button ──────────────────────────────

  Widget _buildLetsGoButton() {
    return GestureDetector(
      onTap: controller.onLetsGo,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: AppColors.successGradient,  // ← clean
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: AppColors.greenShadow,     // ← clean
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Center(
          child: Text(
            AppStrings.letsGo,
            style: GoogleFonts.aBeeZee(
              fontSize: 22,
              color: AppColors.white,
            ),
          ),
        ),
      ),
    );
  }
}