// home_screen_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:math_carnival_kids/core/commonWidgets/ads/banner_ads.dart';
import '../../core/colors/colors.dart';
import '../../core/commonWidgets/premium_dialog.dart';
import '../../core/services/premium_service.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_text_styles.dart';
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
            _buildHeader(context, Get.find<ThemeController>(),
                Get.find<ProgressController>()),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMissionCard(),
                  const SizedBox(height: 20),
                  Text(
                    AppStrings.subjects,
                    style: AppTextStyles.sectionTitle(
                        Theme.of(context).colorScheme.onSurface),
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
    final topPad = MediaQuery.of(context).padding.top;

    return Container(
      width: double.infinity,
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
          // Shape hugging the top-right device corner (no padding offset)
          Positioned(
            top: -55,
            right: -55,
            child: Container(
              width: 195,
              height: 195,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.12),
              ),
            ),
          ),
          // Colorful quick actions centered on the visible part of the shape
          Positioned(
            top: topPad + 2,
            right: 12,
            child: Row(
              children: [
                // Hidden once premium is owned — nothing left to sell.
                Obx(() => PremiumService.to.isPremium.value
                    ? const SizedBox.shrink()
                    : IconButton(
                        onPressed: PremiumDialog.show,
                        icon: const Icon(Icons.workspace_premium_rounded,
                            size: 28, color: Color(0xFFFFE066)),
                      )),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const ProgressScreen()));
                  },
                  icon: const Icon(Icons.emoji_events_rounded,
                      size: 28, color: Color(0xFFFFD166)),
                ),
                GetBuilder<ThemeController>(
                  builder: (themeProvider) => IconButton(
                    onPressed: themeProvider.toggleTheme,
                    icon: Icon(
                      themeProvider.isDarkMode
                          ? Icons.light_mode_rounded
                          : Icons.dark_mode_rounded,
                      size: 28,
                      color: themeProvider.isDarkMode
                          ? const Color(0xFFFFE066)
                          : const Color(0xFF8DF6FF),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20, topPad + 16, 20, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.welcomeBack,
                  style: AppTextStyles.button(Colors.white, size: 17)
                      .copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Obx(() => GestureDetector(
                  onTap: () {
                    Get.toNamed(Routes.setUpScreen)
                        ?.then((_) => controller.loadUserData());
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [Color(0xFFFFF3B0), Color(0xFFFFC15E)],
                        ).createShader(bounds),
                        child: Text(
                          controller.childName.value,
                          style: GoogleFonts.aBeeZee(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: const [
                              Shadow(
                                color: Colors.black26,
                                blurRadius: 6,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        controller.childAvatar.value,
                        style: const TextStyle(fontSize: 30),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.edit_rounded,
                        size: 16,
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ],
                  ),
                )),
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
                    AppStrings.playNow,
                    style: AppTextStyles.button(AppColors.orangeColor,
                        size: 15),
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
        name: AppStrings.subjectStoryMode,
        count: AppStrings.subjectStoryCount,
        gradient: [const Color(0xFFEF476F), const Color(0xFFFF9F1C)],
        route: '/storyModeScreen',
      ),
      SubjectModel(
        icon: Icons.calculate,
        name: AppStrings.subjectMath,
        count: AppStrings.subjectMathCount,
        gradient: [const Color(0xFF4CC9F0), const Color(0xFF7B2FBE)],
        route: '/mathScreen',
      ),
      SubjectModel(
        icon: Icons.videogame_asset,
        name: AppStrings.subjectGames,
        count: AppStrings.subjectGamesCount,
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
        child: Stack(
          children: [
            // Big alpha icon as background decoration (mission-card style)
            Positioned(
              right: -10,
              bottom: -10,
              child: Icon(
                subject.icon,
                size: 96,
                color: Colors.white.withValues(alpha: 0.22),
              ),
            ),
            Column(
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