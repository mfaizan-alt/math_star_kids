// home_screen_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:math_carnival_kids/core/commonWidgets/ads/banner_ads.dart';
import '../../core/colors/colors.dart';
import '../../core/commonWidgets/theme.dart';
import '../../core/models/subject_model/subject_models.dart';
import '../../core/routes/routes.dart';
import '../progress/progress.dart';
import '../progress/progress_controller.dart';
import 'home_screen_controller.dart';

class HomeScreenView extends GetView<HomeScreenController> {
  const HomeScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, ThemeController(), ProgressController()),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMissionCard(),
                  const SizedBox(height: 20),
                  Text(
                    '📚 Subjects',
                    style: GoogleFonts.aBeeZee(
                      fontSize: 20,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 15),
                  _buildSubjectsGrid(),
                  const SizedBox(height: 20),
                  _buildStarsStrip(context),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BannerAdWidget(),
    );
  }

  Widget _buildHeader(BuildContext context, ThemeController themeProvider,
      ProgressController progress) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 45, 20, 28),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: AppColors.headerGradient, // gradient stays same
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -40,
            right: -30,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.1),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome Back,',
                        style: GoogleFonts.aBeeZee(
                          fontSize: 17,
                          color: Colors.white, // ✅ on gradient — always white
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      // Obx(() => GestureDetector(
                      //   onTap: () {
                      //     Get.toNamed(Routes.setUpScreen)
                      //         ?.then((_) => controller.loadUserData());
                      //   },
                      //   child: Container(
                      //     height: 40,
                      //     width: 120,
                      //     decoration: BoxDecoration(
                      //       borderRadius: BorderRadius.circular(10),
                      //       color: isDark // ✅
                      //           ? AppColors.cardDark
                      //           : Colors.white,
                      //       border: Border.all(
                      //         color: isDark
                      //             ? AppColors.textSecondaryDark
                      //             : Colors.black,
                      //       ),
                      //     ),
                      //     child: Center(
                      //       child: Text(
                      //         ' ${controller.childName.value} ${controller.childAvatar.value} ',
                      //         style: GoogleFonts.aBeeZee(
                      //           fontSize: 26,
                      //           color: isDark // ✅
                      //               ? AppColors.textPrimaryDark
                      //               : Colors.black,
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // )),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Obx(() => GestureDetector(
                            onTap: () {
                              Get.toNamed(Routes.setUpScreen)
                                  ?.then((_) => controller.loadUserData());
                            },
                            child: Container(
                              height: 40,
                              width: 120,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: isDark // ✅
                                    ? AppColors.cardDark
                                    : Colors.white,
                                border: Border.all(
                                  color: isDark
                                      ? AppColors.textSecondaryDark
                                      : Colors.black,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  ' ${controller.childName.value} ${controller.childAvatar.value} ',
                                  style: GoogleFonts.aBeeZee(
                                    fontSize: 26,
                                    color: isDark // ✅
                                        ? AppColors.textPrimaryDark
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          )),
                          SizedBox(width: 100,),
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const ProgressScreen()));
                            },
                            icon: const Icon(Icons.emoji_events_rounded,
                                size: 28, color: Colors.white),
                          ),
                          GetBuilder<ThemeController>(
                            builder: (themeProvider) => IconButton(
                              onPressed: () {
                                themeProvider.toggleTheme();
                                print('isDark: ${themeProvider.isDarkMode}');
                                print('themeMode: ${themeProvider.themeMode}');
                              },
                              icon: Icon(
                                themeProvider.isDarkMode
                                    ? Icons.light_mode_rounded
                                    : Icons.dark_mode_rounded,
                                size: 28,
                                color: Colors.white, // ✅ on gradient
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Obx(() => Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '🔥 ${controller.streakDays.value} Day Streak',
                      style: GoogleFonts.nunito(
                        fontSize: 13,
                        color: Colors.white, // ✅ on gradient
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text('·',
                        style: TextStyle(color: Colors.white54)),
                    const SizedBox(width: 10),
                    Text(
                      '⭐ ${controller.totalStars.value} / 100 Stars',
                      style: GoogleFonts.nunito(
                        fontSize: 13,
                        color: Colors.white, // ✅ on gradient
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              )),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMissionCard() {
    // gradient card — all text stays white, no changes needed
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: AppColors.headerGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Stack(
        children: [
          Positioned(
            right: 16,
            top: 0,
            bottom: 0,
            child: Center(
              child: Text(
                '🎯',
                style: TextStyle(
                    fontSize: 50,
                    color: Colors.white.withValues(alpha: 0.3)),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() => Text(
                '⚡ ${controller.todayMissionTitle.value.toUpperCase()}',
                style: GoogleFonts.nunito(
                  fontSize: 11,
                  color: Colors.white.withValues(alpha: 0.85),
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                ),
              )),
              const SizedBox(height: 6),
              Obx(() => Text(
                controller.todayMissionSubtitle.value,
                style: GoogleFonts.aBeeZee(
                  fontSize: 20,
                  color: Colors.white,
                  height: 1.3,
                ),
              )),
              const SizedBox(height: 14),
              GestureDetector(
                onTap: () =>
                    Get.toNamed(controller.currentMissionRoute.value),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 18, vertical: 9),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Text(
                    '▶  Play Now',
                    style: GoogleFonts.aBeeZee(
                      fontSize: 15,
                      color: AppColors.orangeColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectsGrid() {
    final List<SubjectModel> subjects = [
      SubjectModel(
        icon: Icons.menu_book,
        name: 'Story Mode',
        count: '11 stories',
        gradient: [const Color(0xFFEF476F), const Color(0xFFFF9F1C)],
        route: '/storyModeScreen',
      ),
      SubjectModel(
        icon: Icons.calculate,
        name: 'Math',
        count: 'Tables & more',
        gradient: [const Color(0xFF4CC9F0), const Color(0xFF7B2FBE)],
        route: '/mathScreen',
      ),
      SubjectModel(
        icon: Icons.videogame_asset,
        name: 'Games',
        count: 'Play & Learn',
        gradient: [const Color(0xFF7B2FF7), const Color(0xFFF107A3)],
        route: '/gameScreen',
      ),
    ];

    return Column(
      children: [
        // Top row: 2 normal containers
        Row(
          children: [
            Expanded(
              child: _buildSubjectCard(subjects[0]),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSubjectCard(subjects[1]),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Bottom row: Games full width
        _buildSubjectCard(subjects[2], fullWidth: true),
      ],
    );
  }

  Widget _buildSubjectCard(SubjectModel subject, {bool fullWidth = false}) {
    return GestureDetector(
      onTap: () => Get.toNamed(subject.route),
      child: Container(
        padding: const EdgeInsets.all(16),
        height: 160,
        width: fullWidth ? double.infinity : null,  // ✅ Full width if true
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: subject.gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(subject.icon, size: 34, color: Colors.white),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(subject.name,
                    style: GoogleFonts.aBeeZee(
                        textStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w600))),
                Text(subject.count,
                    style: GoogleFonts.aBeeZee(
                        textStyle: const TextStyle(
                            color: Colors.white, fontSize: 13))),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ✅ context added as parameter
  Widget _buildStarsStrip(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color, // ✅ white → cardDark
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Obx(() => Text(
            '⭐ ${controller.totalStars.value} / 100 Stars',
            style: GoogleFonts.aBeeZee(
              fontSize: 16,
              color: Theme.of(context).colorScheme.onSurface, // ✅
            ),
          )),
          const SizedBox(width: 16),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Obx(() => LinearProgressIndicator(
                value: (controller.totalStars.value / 100)
                    .clamp(0.0, 1.0),
                backgroundColor:
                Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.15), // ✅
                valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.yellowColor),
                minHeight: 10,
              )),
            ),
          ),
        ],
      ),
    );
  }
}