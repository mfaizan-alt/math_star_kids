import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:math_carnival_kids/modules/progress/progress_controller.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../../core/colors/colors.dart';
import '../../core/commonWidgets/screen_header.dart';
import '../../core/constants/app_strings.dart';
import '../../core/commonWidgets/ads/banner_ads.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final progress = Provider.of<ProgressController>(context);
    final progress = Get.find<ProgressController>();

    return Scaffold(
      bottomNavigationBar: const BannerAdWidget(),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            const ScreenHeader(
              colors: AppColors.headerGradient,
              emoji: '🏆',
              title: AppStrings.myProgress,
              subtitle: AppStrings.myProgressSubtitle,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildOverallStats(context, progress),
            const SizedBox(height: 32),
            Text(
              AppStrings.moduleProgress,
              style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildModuleProgress(context, progress),
            const SizedBox(height: 32),
            Text(
              AppStrings.achievements,
              style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
            ),
                    const SizedBox(height: 16),
                    _buildAchievements(context, progress),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverallStats(BuildContext context, ProgressController progress) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primaryLight, AppColors.primaryLight.withValues(alpha: 0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryLight.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(AppStrings.totalStarsEarned, style: GoogleFonts.poppins(fontSize: 14, color: Colors.white70)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('⭐', style: TextStyle(fontSize: 32)),
              const SizedBox(width: 8),
              Text(
                '${progress.totalStars}',
                style: GoogleFonts.poppins(fontSize: 42, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildMiniStat('🏆', AppStrings.highScore, '${progress.highScore}'),
              _buildMiniStat('🔥', AppStrings.streak, '${progress.currentStreak}'),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms).slideY(begin: -0.05);
  }

  Widget _buildMiniStat(String emoji, String label, String value) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 20)),
        Text(value, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
        Text(label, style: GoogleFonts.poppins(fontSize: 12, color: Colors.white70)),
      ],
    );
  }

  Widget _buildModuleProgress(BuildContext context, ProgressController progress) {
    final modules = [
      _ModuleInfo('Addition', '➕', AppColors.addition, 'addition'),
      _ModuleInfo('Subtraction', '➖', AppColors.subtraction, 'subtraction'),
      _ModuleInfo('Multiplication', '✖️', AppColors.multiplication, 'multiplication'),
      _ModuleInfo('Division', '➗', AppColors.division, 'division'),
      _ModuleInfo('Counting', '🔢', AppColors.counting, 'counting'),
    ];

    return Column(
      children: modules.asMap().entries.map((entry) {
        final index = entry.key;
        final module = entry.value;
        final stars = progress.getModuleStars(module.key);
        final level = progress.getModuleLevel(module.key);

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: module.color.withValues(alpha: 0.2)),
          ),
          child: Row(
            children: [
              CircularPercentIndicator(
                radius: 28,
                lineWidth: 5,
                percent: (level / 10).clamp(0.0, 1.0),
                center: Text(module.emoji, style: const TextStyle(fontSize: 18)),
                progressColor: module.color,
                backgroundColor: module.color.withValues(alpha: 0.1),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(module.title, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
                    Text('${AppStrings.level} $level • ⭐ $stars stars', style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: module.color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Lv.$level',
                  style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold, color: module.color),
                ),
              ),
            ],
          ),
        ).animate().fadeIn(duration: 400.ms, delay: Duration(milliseconds: 100 * index)).slideX(begin: 0.05);
      }).toList(),
    );
  }

  Widget _buildAchievements(BuildContext context, ProgressController progress) {
    final achievements = [
      _Achievement('First Steps', '🎯', 'Complete your first question', progress.totalStars.value >= 1),
      _Achievement('Star Collector', '⭐', 'Earn 10 stars', progress.totalStars.value >= 10),
      _Achievement('Math Wizard', '🧙', 'Earn 50 stars', progress.totalStars.value >= 50),
      _Achievement('On Fire', '🔥', 'Get a 3-day streak', progress.currentStreak >= 3),
      _Achievement('High Scorer', '🏆', 'Score 80+ in quiz', progress.highScore >= 80),
      _Achievement('Math Master', '👑', 'Earn 100 stars', progress.totalStars.value >= 100),
    ];

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: achievements.map((achievement) {
        return Container(
          width: (MediaQuery.of(context).size.width - 52) / 2,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: achievement.unlocked
                ? AppColors.gold.withValues(alpha: 0.1)
                : Colors.grey.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: achievement.unlocked ? AppColors.gold.withValues(alpha: 0.3) : Colors.grey.withValues(alpha: 0.2),
            ),
          ),
          child: Column(
            children: [
              Text(
                achievement.emoji,
                style: TextStyle(
                  fontSize: 32,
                  color: achievement.unlocked ? null : Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                achievement.title,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: achievement.unlocked ? null : Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                achievement.description,
                style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _ModuleInfo {
  final String title;
  final String emoji;
  final Color color;
  final String key;

  _ModuleInfo(this.title, this.emoji, this.color, this.key);
}

class _Achievement {
  final String title;
  final String emoji;
  final String description;
  final bool unlocked;

  _Achievement(this.title, this.emoji, this.description, this.unlocked);
}



