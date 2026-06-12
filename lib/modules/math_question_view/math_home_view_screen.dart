import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:math_carnival_kids/core/commonWidgets/theme.dart';

import '../../core/colors/colors.dart';
import '../../core/commonWidgets/ads/banner_ads.dart';
import '../../core/commonWidgets/screen_header.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/models/mini_game_data_model/mani_game_model.dart';
import '../../core/routes/routes.dart';
import '../../core/services/stars_service.dart';
import '../all_games_screen/addition/addition_view.dart';
import '../all_games_screen/counting_screen/counting_view.dart';
import '../all_games_screen/division_screen.dart';
import '../all_games_screen/multiplication/multiplication_view.dart';
import '../all_games_screen/subtraction/subtraction_view.dart';
import '../progress/progress_controller.dart';
import 'math_home_view_controller.dart';

class MathHomeView extends GetView <MathHomeController>{
  const MathHomeView({super.key});


  @override
  Widget build(BuildContext context) {
    final isDark = Get.find<ThemeController>().isDarkMode;
    return Scaffold(
      // backgroundColor: AppColors.cream,
      backgroundColor: TC.bg(context),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            children: [

              // ── Header ─────────────────────────────
              _buildHeader(context),

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // ── Section Title
                    Text(
                      AppStrings.pickAMode,
                      style: AppTextStyles.sectionTitle(
                              isDark ? Colors.white : Colors.black)
                          .copyWith(fontSize: 22),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      AppStrings.whatToLearn,
                      style: AppTextStyles.body(
                          isDark ? Colors.white : Colors.black),
                    ),
                    const SizedBox(height: 20),
                    _buildFunFactStrip(),

                    const SizedBox(height: 20),

                    // ── Quiz Card
                    _buildQuizCard(),
                    const SizedBox(height: 16),

                    // ── Tables Card
                    _buildTablesCard(),
                    const SizedBox(height: 24),

                    // ── Learning Modules (same as Games section)
                    Text(
                      AppStrings.learningModules,
                      style: AppTextStyles.sectionTitle(
                              isDark ? Colors.white : Colors.black)
                          .copyWith(fontSize: 22),
                    ),
                    const SizedBox(height: 16),
                    _buildModuleGrid(context),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BannerAdWidget(),
    );
  }

  // ── Header ─────────────────────────────────────
  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
          20, MediaQuery.of(context).padding.top + 12, 20, 30),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF4CC9F0), Color(0xFF7B2FBE)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(34),
          bottomRight: Radius.circular(34),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            bottom: -20,
            left: -10,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // Back button
              const CircleBackButton(),

              const SizedBox(height: 16),

              // Mascot + Title Row
              Row(
                children: [
                  const Text('🧮', style: TextStyle(fontSize: 52)),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppStrings.mathTitle,
                        style: AppTextStyles.button(Colors.white, size: 30),
                      ),
                      Text(
                        AppStrings.mathSubtitle,
                        style: AppTextStyles.screenSubtitle,
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 18),

              // Stats row
              Obx(() {
                final progress = Get.find<ProgressController>();
                return Row(
                  children: [
                    _statChip('🏆', 'Best: ${progress.highScore}'),
                    const SizedBox(width: 10),
                    _statChip('⭐', '${StarsService.to.totalStars.value} Stars'),
                    const SizedBox(width: 10),
                    _statChip('🔥', '${progress.currentStreak} Streak'),
                  ],
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statChip(String emoji, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 13)),
          const SizedBox(width: 5),
          Text(
            label,
            style: GoogleFonts.nunito(
              fontSize: 12,
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  // ── Quiz Card ───────────────────────────────────
  Widget _buildQuizCard() {
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.quizGameScreen),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFEF476F), Color(0xFFFF9F1C)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFEF476F).withValues(alpha: 0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [

            // Background decoration
            Positioned(
              right: -10,
              top: -10,
              child: Text(
                '🎮',
                style: TextStyle(
                  fontSize: 80,
                  color: Colors.white.withValues(alpha: 0.15),
                ),
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // Tag
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    AppStrings.mostPopular,
                    style: GoogleFonts.nunito(
                      fontSize: 10,
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  AppStrings.quizGame,
                  style: GoogleFonts.aBeeZee(
                    fontSize: 28,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  AppStrings.quizGameDesc,
                  style: GoogleFonts.nunito(
                    fontSize: 14,
                    color: Colors.white.withValues(alpha: 0.85),
                    fontWeight: FontWeight.w600,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 16),

                // Info chips row
                Row(
                  children: [
                    _cardChip(AppStrings.chipFast),
                    const SizedBox(width: 8),
                    _cardChip(AppStrings.chipEarnStars),
                    const SizedBox(width: 8),
                    _cardChip(AppStrings.chipCompete),
                  ],
                ),

                const SizedBox(height: 18),

                // Play button
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.12),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.play_arrow_rounded,
                        color: Color(0xFFEF476F),
                        size: 22,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Play Now',
                        style: GoogleFonts.aBeeZee(
                          fontSize: 16,
                          color: const Color(0xFFEF476F),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ── Tables Card ─────────────────────────────────
  Widget _buildTablesCard() {
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.mathTable),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF4CC9F0), Color(0xFF7B2FBE)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF4CC9F0).withValues(alpha: 0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [

            // Background decoration
            Positioned(
              right: -10,
              top: -10,
              child: Text(
                '✖️',
                style: TextStyle(
                  fontSize: 80,
                  color: Colors.white.withValues(alpha: 0.15),
                ),
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // Tag
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    AppStrings.learnAndPractice,
                    style: GoogleFonts.nunito(
                      fontSize: 10,
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  '✖️ Tables',
                  style: GoogleFonts.aBeeZee(
                    fontSize: 28,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  AppStrings.tablesCardDesc,
                  style: GoogleFonts.nunito(
                    fontSize: 14,
                    color: Colors.white.withValues(alpha: 0.85),
                    fontWeight: FontWeight.w600,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 16),

                // Info chips row
                Row(
                  children: [
                    _cardChip(AppStrings.chipOneToTwenty),
                    const SizedBox(width: 8),
                    _cardChip(AppStrings.chipRhythm),
                    const SizedBox(width: 8),
                    _cardChip(AppStrings.chipProgress),
                  ],
                ),

                const SizedBox(height: 18),

                // Start button
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.12),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.menu_book_rounded,
                        color: Color(0xFF4CC9F0),
                        size: 22,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        AppStrings.startLearning,
                        style: GoogleFonts.aBeeZee(
                          fontSize: 16,
                          color: const Color(0xFF4CC9F0),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ── Learning Modules Grid (mirrors the Games section) ──
  Widget _buildModuleGrid(BuildContext context) {
    final modules = [
      ModuleData('Counting', '🔢', AppColors.counting, CountingScreen()),
      ModuleData('Addition', '➕', AppColors.addition, AdditionScreen()),
      ModuleData('Subtraction', '➖', AppColors.subtraction, SubtractionScreen()),
      ModuleData('Multiply', '✖️', AppColors.multiplication, MultiplicationScreen()),
      ModuleData('Division', '➗', AppColors.division, const DivisionScreen()),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.9,
      ),
      itemCount: modules.length,
      itemBuilder: (context, index) =>
          _buildModuleCard(context, modules[index], index),
    );
  }

  Widget _buildModuleCard(BuildContext context, ModuleData module, int index) {
    final isDark = Get.find<ThemeController>().isDarkMode;
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => module.screen));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(24),
          border:
              Border.all(color: module.color.withValues(alpha: 0.2), width: 2),
          boxShadow: [
            BoxShadow(
              color: module.color.withValues(alpha: 0.4),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Center(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: module.color.withValues(alpha: 0.25),
                      shape: BoxShape.circle,
                    ),
                    child: Text(module.emoji,
                        style: const TextStyle(fontSize: 36)),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    module.title,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms, delay: Duration(milliseconds: 100 * index))
        .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1));
  }

  // ── Fun Fact Strip ──────────────────────────────
  Widget _buildFunFactStrip() {
    final isDark = Get.find<ThemeController>().isDarkMode;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.yellowColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.yellowColor.withValues(alpha: 0.4),
          width: 2,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('💡', style: TextStyle(fontSize: 28)),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // Title + dots
                Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppStrings.funMathFact,
                      style: GoogleFonts.fredoka(
                        fontSize: 15,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),

                    Row(
                      children: List.generate(
                        controller.mathFacts.length > 5
                            ? 5
                            : controller.mathFacts.length,
                            (index) => Container(
                          margin: const EdgeInsets.only(left: 4),
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: index ==
                                controller.currentIndex.value % 5
                                ? AppColors.orangeColor
                                : AppColors.orangeColor.withValues(alpha: 0.25),
                          ),
                        ),
                      ),
                    ),
                  ],
                )),

                const SizedBox(height: 6),

                // Fact text
                Obx(() => GestureDetector(
                  onHorizontalDragEnd: (details) {
                    if (details.primaryVelocity == null) return;

                    if (details.primaryVelocity! < 0) {
                      controller.nextFact();
                    } else {
                      controller.prevFact();
                    }

                    controller.restartProgress(); // 🔥 FIX
                  },
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    child: Text(
                      controller.currentFact,
                      key: ValueKey(controller.currentIndex.value),
                      style: GoogleFonts.nunito(
                        fontSize: 13,
                        color: isDark ? Colors.white : Colors.black,
                        fontWeight: FontWeight.w600,
                        height: 1.5,
                      ),
                    ),
                  ),
                )),

                const SizedBox(height: 8),

                // 🔥 FIX: progress bar (REPLACES TweenAnimationBuilder)
                Obx(() => LinearProgressIndicator(
                  value: controller.progress.value,
                  backgroundColor:
                  AppColors.orangeColor.withValues(alpha: 0.15),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.orangeColor.withValues(alpha: 0.6),
                  ),
                  minHeight: 3,
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Helper Chip ─────────────────────────────────
  Widget _cardChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: GoogleFonts.nunito(
          fontSize: 11,
          color: Colors.white,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}