import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:math_carnival_kids/modules/set_up_screen/set_up_controller.dart';

import '../../core/colors/colors.dart';

class SetupScreenView extends GetView<SetUpScreenController> {
  const SetupScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 28),
              _buildNameField(),
              const SizedBox(height: 28),
              _buildAvatarSection(),
              const SizedBox(height: 40),
              _buildLetsGoButton(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // ── Header ──────────────────────────────────────
  Widget _buildHeader() {
    return Column(
      children: [
        const Center(
          child: Text('👋', style: TextStyle(fontSize: 55)),
        ),
        const SizedBox(height: 12),
        Center(
          child: Text(
            "What's Your Name?",
            style: GoogleFonts.aBeeZee(
              fontSize: 28,
              color: AppColors.navy,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Center(
          child: Text(
            'Your parent can set this up for you!',
            style: GoogleFonts.nunito(
              fontSize: 14,
              color: AppColors.grey,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  // ── Name Field ──────────────────────────────────
  Widget _buildNameField() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.black, width: 2.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
          color: AppColors.navy,
        ),
        decoration: InputDecoration(
          hintText: 'Enter name here...',
          hintStyle: GoogleFonts.aBeeZee(
            fontSize: 18,
            color: Colors.black,
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

  // ── Avatar Section ──────────────────────────────
  Widget _buildAvatarSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pick Your Avatar 😊',
          style: GoogleFonts.aBeeZee(
            fontSize: 18,
            color: AppColors.navy,
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
                        ? AppColors.coralColor.withOpacity(0.08)
                        : AppColors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.coralColor        // ← clean
                          : AppColors.lightGrey,   // ← clean
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isSelected
                            ? AppColors.coralColor.withOpacity(0.25)  // ← clean
                            : Colors.black.withOpacity(0.05),
                        blurRadius: isSelected ? 14 : 6,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      avatar,
                      style: TextStyle(
                        fontSize: isSelected ? 32 : 28,
                      ),
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
  //         'Choose Language 🌍',
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
            "Let's Go! 🚀",
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