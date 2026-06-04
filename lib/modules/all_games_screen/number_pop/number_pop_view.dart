import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:confetti/confetti.dart';
import 'package:get/get.dart';
import '../../../core/colors/colors.dart';
import 'number_pop_controller.dart';

class NumberPopScreen extends StatefulWidget {
  const NumberPopScreen({super.key});

  @override
  State<NumberPopScreen> createState() => _NumberPopScreenState();
}

// StatefulWidget kept only for _buildStars() — random positions
// must be generated once and never regenerated on rebuild
class _NumberPopScreenState extends State<NumberPopScreen> {
  final NumberPopController controller = Get.put(NumberPopController());

  // Generated once; purely decorative, needs no reactivity
  late final List<({double x, double y})> _starPositions;

  @override
  void initState() {
    super.initState();
    _starPositions = List.generate(20, (_) => (
    x: (controller.random.nextDouble() * 400),
    y: (controller.random.nextDouble() * 800),
    ));
  }

  void _onStartGame(BuildContext context) {
    final size = MediaQuery.of(context).size;
    controller.screenWidth = size.width;
    controller.screenHeight = size.height;
    controller.startGame();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
          _buildBackground(),
          // Stars (static, no Obx needed)
          ..._buildStars(),
          // Game content
          SafeArea(
            child: Obx(() {
              if (controller.isGameStarted.value) return _buildGameContent();
              if (controller.isGameOver.value) return _buildGameOver();
              return _buildStartScreen();
            }),
          ),
          // Floating bubbles
          Obx(() => Stack(
            children: controller.bubbles.map((bubble) => Positioned(
              left: bubble.x,
              top: bubble.y,
              child: GestureDetector(
                onTap: () => controller.popBubble(bubble),
                child: _buildBubbleWidget(bubble),
              ),
            )).toList(),
          )),
          // Top bar
          SafeArea(child: Obx(() => _buildTopBar())),
          // Confetti
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: controller.confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              colors: const [
                AppColors.correct,
                AppColors.star,
                Colors.pink,
                Colors.blue,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1A1A2E), Color(0xFF16213E), Color(0xFF0F3460)],
        ),
      ),
    );
  }

  List<Widget> _buildStars() {
    return _starPositions.map((pos) => Positioned(
      left: pos.x,
      top: pos.y,
      child: Container(
        width: 3,
        height: 3,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.5),
          shape: BoxShape.circle,
        ),
      ),
    )).toList();
  }

  Widget _buildTopBar() {
    // Already inside Obx from build()
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
            style: IconButton.styleFrom(backgroundColor: Colors.white12),
          ),
          if (controller.isGameStarted.value) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '⭐ ${controller.score.value}',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Row(
              children: List.generate(3, (i) => Icon(
                i < controller.lives.value
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: i < controller.lives.value ? Colors.red : Colors.grey,
                size: 26,
              )),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildGameContent() {
    // Already inside Obx
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.only(top: 80),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryLight.withValues(alpha: 0.3),
                blurRadius: 16,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Pop the correct bubble! 🫧',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${controller.num1.value} ${controller.operator_.value} ${controller.num2.value} = ?',
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2D3142),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBubbleWidget(Bubble bubble) {
    return Container(
      width: bubble.size,
      height: bubble.size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            bubble.color.withValues(alpha: 0.8),
            bubble.color,
          ],
          center: const Alignment(-0.3, -0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: bubble.color.withValues(alpha: 0.4),
            blurRadius: 12,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Center(
        child: Text(
          '${bubble.value}',
          style: GoogleFonts.poppins(
            fontSize: bubble.size * 0.35,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildStartScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🫧', style: TextStyle(fontSize: 80)),
          const SizedBox(height: 24),
          Text(
            'Number Pop!',
            style: GoogleFonts.poppins(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ).animate().fadeIn().slideY(begin: -0.2),
          const SizedBox(height: 12),
          Text(
            'Pop the bubble with the\ncorrect answer!',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(fontSize: 16, color: Colors.white70),
          ).animate().fadeIn(delay: 200.ms),
          const SizedBox(height: 40),
          GestureDetector(
            onTap: () => _onStartGame(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF6EB4), Color(0xFFAD6BFF)],
                ),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF6EB4).withValues(alpha: 0.5),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Text(
                '▶  START',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ).animate().fadeIn(delay: 400.ms).scale(begin: const Offset(0.8, 0.8)),
        ],
      ),
    );
  }

  Widget _buildGameOver() {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(32),
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 24,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              controller.gameOverEmoji,
              style: const TextStyle(fontSize: 64),
            ),
            const SizedBox(height: 16),
            Text(
              'Game Over!',
              style: GoogleFonts.poppins(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'You popped ${controller.questionsAnswered.value} bubbles correctly!',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.star.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                '⭐ Score: ${controller.score.value}',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildBtn('🏠 Home', () => Navigator.pop(context)),
                const SizedBox(width: 16),
                _buildBtn(
                  '🔄 Retry',
                      () => _onStartGame(context),
                  isPrimary: true,
                ),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn().scale(begin: const Offset(0.8, 0.8));
  }

  Widget _buildBtn(String label, VoidCallback onTap, {bool isPrimary = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        decoration: BoxDecoration(
          gradient: isPrimary
              ? const LinearGradient(
            colors: [Color(0xFFFF6EB4), Color(0xFFAD6BFF)],
          )
              : null,
          color: isPrimary ? null : Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: isPrimary ? Colors.white : const Color(0xFF2D3142),
          ),
        ),
      ),
    );
  }
}