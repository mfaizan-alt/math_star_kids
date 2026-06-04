import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/colors/colors.dart';
import '../../core/routes/routes.dart';
import 'mathHome_view_controller.dart';

class MathHomeView extends GetView <MathHomeController>{
  const MathHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [

              // ── Header ─────────────────────────────
              _buildHeader(),

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // ── Section Title ───────────────
                    Text(
                      'Pick a Mode! 🎯',
                      style: GoogleFonts.aBeeZee(
                        fontSize: 22,
                        color: AppColors.navy,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'What do you want to learn today?',
                      style: GoogleFonts.nunito(
                        fontSize: 14,
                        color: AppColors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildFunFactStrip(),

                    const SizedBox(height: 20),

                    // ── Quiz Card ───────────────────
                    _buildQuizCard(),
                    const SizedBox(height: 16),

                    // ── Tables Card ─────────────────
                    _buildTablesCard(),
                    const SizedBox(height: 16),

                    // ── Fun Fact Strip ──────────────


                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Header ─────────────────────────────────────
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 30),
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

          // Decorative circles
          Positioned(
            top: -30,
            right: -20,
            child: Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.08),
              ),
            ),
          ),
          Positioned(
            bottom: -20,
            left: -10,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.08),
              ),
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // Back button
              GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),

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
                        'Math Time!',
                        style: GoogleFonts.aBeeZee(
                          fontSize: 30,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Numbers are super fun 🌟',
                        style: GoogleFonts.nunito(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.8),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 18),

              // Stats row
              Row(
                children: [
                  _statChip('🏆', 'Best: 10'),
                  const SizedBox(width: 10),
                  _statChip('⭐', '24 Stars'),
                  const SizedBox(width: 10),
                  _statChip('🔥', '3 Streak'),
                ],
              ),
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
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.25)),
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
              color: const Color(0xFFEF476F).withOpacity(0.4),
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
                  color: Colors.white.withOpacity(0.15),
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
                    color: Colors.white.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '🔥 MOST POPULAR',
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
                  '🎮 Quiz Game',
                  style: GoogleFonts.aBeeZee(
                    fontSize: 28,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  'Answer questions and earn stars!\nBeat your high score!',
                  style: GoogleFonts.nunito(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.85),
                    fontWeight: FontWeight.w600,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 16),

                // Info chips row
                Row(
                  children: [
                    _cardChip('⏱️ Fast'),
                    const SizedBox(width: 8),
                    _cardChip('⭐ Earn Stars'),
                    const SizedBox(width: 8),
                    _cardChip('🏆 Compete'),
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
                        color: Colors.black.withOpacity(0.12),
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
              color: const Color(0xFF4CC9F0).withOpacity(0.4),
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
                  color: Colors.white.withOpacity(0.15),
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
                    color: Colors.white.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '📚 LEARN & PRACTICE',
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
                  'Learn multiplication tables\nfrom 1 to 20!',
                  style: GoogleFonts.nunito(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.85),
                    fontWeight: FontWeight.w600,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 16),

                // Info chips row
                Row(
                  children: [
                    _cardChip('🔢 1 to 20'),
                    const SizedBox(width: 8),
                    _cardChip('🎵 Rhythm'),
                    const SizedBox(width: 8),
                    _cardChip('📈 Progress'),
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
                        color: Colors.black.withOpacity(0.12),
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
                        'Start Learning',
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

  // ── Fun Fact Strip ──────────────────────────────
  Widget _buildFunFactStrip() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.yellowColor.withOpacity(0.15),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.yellowColor.withOpacity(0.4),
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

                // Title row with fact counter
                Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Fun Math Fact!',
                      style: GoogleFonts.fredoka(
                        fontSize: 15,
                        color: AppColors.navy,
                      ),
                    ),
                    // Fact counter dots
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
                            color: index == controller.factIndex.value % 5
                                ? AppColors.orangeColor
                                : AppColors.orangeColor.withOpacity(0.25),
                          ),
                        ),
                      ),
                    ),
                  ],
                )),

                const SizedBox(height: 6),

                // Animated fact text
                Obx(() => AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  transitionBuilder: (child, animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.3),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      ),
                    );
                  },
                  child: Text(
                    controller.currentFact.value,
                    key: ValueKey(controller.currentFact.value),
                    style: GoogleFonts.nunito(
                      fontSize: 13,
                      color: AppColors.grey,
                      fontWeight: FontWeight.w600,
                      height: 1.5,
                    ),
                  ),
                )),

                const SizedBox(height: 8),

                // Timer indicator bar
                Obx(() => TweenAnimationBuilder<double>(
                  key: ValueKey(controller.factIndex.value),
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(seconds: 15),
                  builder: (context, value, _) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: value,
                        backgroundColor: AppColors.orangeColor.withOpacity(0.15),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.orangeColor.withOpacity(0.6),
                        ),
                        minHeight: 3,
                      ),
                    );
                  },
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
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
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