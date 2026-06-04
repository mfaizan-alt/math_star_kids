import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/colors/colors.dart';
import '../../core/commonWidgets/theme.dart';
import '../../core/models/mini_game_data_model/mani_game_model.dart';
import '../../core/services/stars_service.dart';
import '../all_games_screen/addition/addition_view.dart';
import '../all_games_screen/adventure_map/adventure_map_view.dart';
import '../all_games_screen/counting_screen.dart';
import '../all_games_screen/division_screen.dart';
import '../all_games_screen/frog_jump/frog_jump_view.dart';
import '../all_games_screen/math-puzzle/math_puzzle_view.dart';
import '../all_games_screen/math_circus/math_circus_view.dart';
import '../all_games_screen/multiplication/multiplication_view.dart';
import '../all_games_screen/number_builder/number_builder_view.dart';
import '../all_games_screen/number_pop/number_pop_view.dart';
import '../all_games_screen/runner_game/runner_view.dart';
import '../all_games_screen/subtraction/subtraction_view.dart';
import '../all_games_screen/table/table_view.dart';
import '../home_screen/home_screen_controller.dart';
import '../progress/progress.dart';
import '../progress/progress_controller.dart';
import 'games_home_controller.dart';

class GamesHomeScreenView extends GetView<GamesHomeController>{
   GamesHomeScreenView({super.key});

   final HomeScreenController cont = Get.find<HomeScreenController>();
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(context, ThemeController(), ProgressController()),
                    const SizedBox(height: 24),
                    _buildStatsCard(context, ProgressController()),
                    const SizedBox(height: 24),
                    Text(
                      '🎮 Learning Modules',
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.9,
                ),
                delegate: SliverChildListDelegate(
                  _buildModuleCards(context),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildRunnerGameBanner(context),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  '🎮 Mini Games',
                  style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 12)),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 140,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: _buildMiniGameCards(context),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildAdventureMapBanner(context),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ThemeController themeProvider, ProgressController progress) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Column(
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   children: [
        //     Text(
        //       'Hello, Champ! 👋',
        //       style: GoogleFonts.poppins(
        //         fontSize: 26,
        //         fontWeight: FontWeight.bold,
        //       ),
        //     ),
        //     Text(
        //       "Let's learn math today!",
        //       style: GoogleFonts.poppins(
        //         fontSize: 14,
        //         color: Theme.of(context).textTheme.bodySmall?.color,
        //       ),
        //     ),
        //   ],
        // ).animate().fadeIn(duration: 500.ms).slideX(begin: -0.1),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Let's Play Games",
              style: GoogleFonts.aBeeZee(
                fontSize: 15,
                color: Colors.black,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 2),
            Obx(() => Text(
              '${cont.childName.value} ${cont.childAvatar.value}',
              style: GoogleFonts.aBeeZee(
                fontSize: 26,
                color: Colors.black,
              ),
            )),
          ],
        ),
        Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const ProgressScreen()));
              },
              icon: const Icon(Icons.emoji_events_rounded, size: 28),
            ),
            IconButton(
              onPressed: themeProvider.toggleTheme,
              icon: Icon(
                themeProvider.isDarkMode ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                size: 28,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatsCard(BuildContext context, ProgressController progress) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.coralColor, AppColors.coralShadow.withValues(alpha: 0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.coralColor.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Stars - using StarsService for real-time updates (OBSERVABLE)
          Expanded(
            child: Obx(() => _buildStatItem(
              '⭐',
              '${StarsService.to.getTotalStars()}',
              'Stars',
            )),
          ),
          Container(height: 40, width: 1, color: Colors.white30),
          // Best Score - static value (NOT OBSERVABLE - no Obx needed)
          Expanded(
            child: _buildStatItem(
              '🏆',
              '${progress.highScore}',
              'Best Score',
            ),
          ),
          Container(height: 40, width: 1, color: Colors.white30),
          // Streak - static value (NOT OBSERVABLE - no Obx needed)
          Expanded(
            child: _buildStatItem(
              '🔥',
              '${progress.currentStreak}',
              'Streak',
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.1);
  }

  Widget _buildStatItem(String emoji, String value, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(emoji, style: const TextStyle(fontSize: 24)),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: 12, color: Colors.white70),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  List<Widget> _buildModuleCards(BuildContext context) {
    final modules = [
      ModuleData('Counting', '🔢', AppColors.counting, const CountingScreen()),
      ModuleData('Addition', '➕', AppColors.addition,  AdditionScreen()),
      ModuleData('Subtraction', '➖', AppColors.subtraction,  SubtractionScreen()),
      ModuleData('Multiply', '✖️', AppColors.multiplication,  MultiplicationScreen()),
      ModuleData('Division', '➗', AppColors.division, const DivisionScreen()),
      ModuleData('Tables', '📊', AppColors.numbers,  TablesScreen()),
    ];

    return modules.asMap().entries.map((entry) {
      final index = entry.key;
      final module = entry.value;
      return _buildModuleCard(context, module, index);
    }).toList();
  }

  Widget _buildModuleCard(BuildContext context, ModuleData module, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => module.screen));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: module.color.withValues(alpha: 0.2), width: 2),
          boxShadow: [
            BoxShadow(
              color: module.color.withValues(alpha: 0.15),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: module.color.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Text(module.emoji, style: const TextStyle(fontSize: 36)),
            ),
            const SizedBox(height: 12),
            Text(
              module.title,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(
      duration: 400.ms,
      delay: Duration(milliseconds: 100 * index),
    ).scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1));
  }

  Widget _buildRunnerGameBanner(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const RunnerGameScreen()));
      },
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF6BCB77), Color(0xFF4ECDC4)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6BCB77).withValues(alpha: 0.4),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '🏃 Math Runner Game',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Run & pick the correct answer!',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Text('🎮', style: TextStyle(fontSize: 28)),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.2);
  }

  List<Widget> _buildMiniGameCards(BuildContext context) {
    final games = [
      MiniGameData('Number Pop', '🫧', const Color(0xFFFF6EB4), const NumberPopScreen()),
      MiniGameData('Math Puzzle', '🧩', const Color(0xFFFFD93D), const MathPuzzleScreen()),
      MiniGameData('Math Circus', '🎪', const Color(0xFFDC143C), const MathCircusScreen()),
      MiniGameData('Number Builder', '🏗️', const Color(0xFF764ba2), const NumberBuilderScreen()),
      MiniGameData('Frog Jump', '🐸', const Color(0xFF2E7D32),  FrogJumpScreen()),
      // MiniGameData('Speed Battle', '⚡', const Color(0xFFFF6B6B), const SpeedBattleScreen()),
    ];

    return games.asMap().entries.map((entry) {
      final index = entry.key;
      final game = entry.value;
      return Padding(
        padding: const EdgeInsets.only(right: 12),
        child: GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => game.screen)),
          child: Container(
            width: 120,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).cardTheme.color,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: game.color.withValues(alpha: 0.3), width: 2),
              boxShadow: [BoxShadow(color: game.color.withValues(alpha: 0.15), blurRadius: 8, offset: const Offset(0, 4))],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: game.color.withValues(alpha: 0.15), shape: BoxShape.circle),
                  child: Text(game.emoji, style: const TextStyle(fontSize: 28)),
                ),
                const SizedBox(height: 8),
                Text(game.title, textAlign: TextAlign.center, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ),
      ).animate().fadeIn(delay: Duration(milliseconds: 80 * index)).slideX(begin: 0.2);
    }).toList();
  }

  Widget _buildAdventureMapBanner(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) =>  AdventureMapScreen())),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF667eea), Color(0xFF764ba2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [BoxShadow(color: const Color(0xFF667eea).withValues(alpha: 0.4), blurRadius: 16, offset: const Offset(0, 8))],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('🗺️ Adventure Map', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 4),
                  Text('Unlock games by earning stars!', style: GoogleFonts.poppins(fontSize: 13, color: Colors.white70)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(16)),
              child: const Icon(Icons.explore_rounded, color: Colors.white, size: 28),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 900.ms).slideY(begin: 0.2);
  }

}