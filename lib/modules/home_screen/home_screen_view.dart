// home_screen_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:math_carnival_kids/core/commonWidgets/ads/banner_ads.dart';
import '../../core/colors/colors.dart';
import '../../core/models/subject_model/subject_models.dart';
import '../../core/routes/routes.dart';
import 'home_screen_controller.dart';

class HomeScreenView extends GetView<HomeScreenController> {
  const HomeScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            _buildHeader(),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Mission Card
                  _buildMissionCard(),
                  const SizedBox(height: 10),

                  // Subjects Title
                  Text(
                    '📚 Subjects',
                    style: GoogleFonts.aBeeZee(
                      fontSize: 20,
                      color: AppColors.navy,
                    ),
                  ),
                  // Subjects Grid
                  _buildSubjectsGrid(),
                  const SizedBox(height: 20),
                  // Stars Strip
                  _buildStarsStrip(),
                  const SizedBox(height: 20),

                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BannerAdWidget(

          // adUnitId: 'ca-app-pub-2983283750660362/8109778088'),real unit id,

             adUnitId: 'ca-app-pub-3940256099942544/6300978111'), //test id
    );
  }

  // ── Header ───────────────────────────────────────
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 45, 20, 28),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: AppColors.headerGradient,
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
          // Decorative circle
          Positioned(
            top: -40,
            right: -30,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // Top row — greeting + lang toggle
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
                          // color: Colors.white,
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Obx(() => GestureDetector(
                        onTap: () {
                          Get.toNamed(Routes.setUpScreen)?.then((_) {
                            controller.loadUserData();
                          });
                        },
                        child: Container(
                          height: 40,
                          width: 120,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            border: Border.all(
                                // color: AppColors.coralColor,
                                color: Colors.black,
                            )
                          ),
                          child: Center(
                            child: Text(
                              ' ${controller.childName.value} ${controller.childAvatar.value} ',
                              style: GoogleFonts.aBeeZee(
                                fontSize: 26,
                                // color: AppColors.coralColor,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      )),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 14),
              // Streak chip
              Obx(() => Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '🔥 ${controller.streakDays.value} Day Streak',
                      style: GoogleFonts.nunito(
                        fontSize: 13,
                        color: AppColors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text('·', style: TextStyle(color: Colors.white54)),
                    const SizedBox(width: 10),
                    Text(
                      '⭐ ${controller.totalStars.value} / 100 Stars',
                      style: GoogleFonts.nunito(
                        fontSize: 13,
                        color: AppColors.white,
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

  // ── Mission Card ─────────────────────────────────
  Widget _buildMissionCard() {
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
        boxShadow: [
          BoxShadow(
            color: AppColors.orangeColor.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [

          // Background emoji
          Positioned(
            right: 16,
            top: 0,
            bottom: 0,
            child: Center(
              child: Text(
                '🎯',
                style: TextStyle(
                  fontSize: 50,
                  color: Colors.white.withOpacity(0.3),
                ),
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
                  color: Colors.white.withOpacity(0.85),
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                ),
              )),
              const SizedBox(height: 6),
              Obx(() => Text(
                controller.todayMissionSubtitle.value,
                style: GoogleFonts.aBeeZee(
                  fontSize: 20,
                  color: AppColors.white,
                  height: 1.3,
                ),
              )),
              const SizedBox(height: 14),
              GestureDetector(
                onTap: () {
                  Get.toNamed(controller.currentMissionRoute.value);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
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

  // ── Subjects Grid ────────────────────────────────
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
        icon: Icons.mosque,
        name: 'Quran & Duas',
        count: 'Coming Soon',
        gradient: [const Color(0xFF06D6A0), const Color(0xFF118AB2)],
        route: '/islamicScreen',
      ),
      SubjectModel(
        icon: Icons.videogame_asset,
        name: 'Games',
        count: 'Play & Learn',
        gradient: [const Color(0xFF7B2FF7), const Color(0xFFF107A3)],
        route: '/gameScreen',
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.1,
      ),
      itemCount: subjects.length,
      itemBuilder: (context, index) {
        final subject = subjects[index];
        return _buildSubjectCard(subject);
      },
    );
  }

  Widget _buildSubjectCard(SubjectModel subject) {
    return GestureDetector(
      onTap: () => Get.toNamed(subject.route),
      child: Container(
        padding: const EdgeInsets.all(16),
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
            Icon(
              subject.icon,
              size: 34,
              color: Colors.white,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subject.name,
                  style:  GoogleFonts.aBeeZee(textStyle: TextStyle(color: Colors.white, fontSize: 17,fontWeight: FontWeight.w600)),
                ),
                Text(
                  subject.count,
                  style:  GoogleFonts.aBeeZee(textStyle: TextStyle(color: Colors.white, fontSize: 13,)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ── Stars Strip ──────────────────────────────────
  Widget _buildStarsStrip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
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
              color: AppColors.navy,
            ),
          )),

          const SizedBox(width: 16),

          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Obx(() => LinearProgressIndicator(
                value: (controller.totalStars.value / 100).clamp(0.0, 1.0),
                backgroundColor: AppColors.lightGrey,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppColors.yellowColor,
                ),
                minHeight: 10,
              )),
            ),
          ),
        ],
      ),
    );
  }
}