import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:confetti/confetti.dart';
import 'package:get/get.dart';
import '../../../core/colors/colors.dart';
import '../../../core/commonWidgets/ads/ad_badge.dart';
import '../../../core/commonWidgets/ads/ad_manager.dart';
import '../../../core/commonWidgets/ads/reward_ad.dart';
import '../../../core/services/stars_service.dart';
import 'number_pop_controller.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/commonWidgets/ads/banner_ads.dart';

class NumberPopScreen extends StatefulWidget {
  const NumberPopScreen({super.key});

  @override
  State<NumberPopScreen> createState() => _NumberPopScreenState();
}

// StatefulWidget kept only for _buildStars() — random positions
// must be generated once and never regenerated on rebuild
class _NumberPopScreenState extends State<NumberPopScreen> {
  final NumberPopController controller = Get.put(NumberPopController());
  late final StarsService starsService;

  // Generated once; purely decorative, needs no reactivity
  late final List<({double x, double y})> _starPositions;

  @override
  void initState() {
    super.initState();
    starsService = Get.find<StarsService>();
    _starPositions = List.generate(20, (_) => (
    x: (controller.random.nextDouble() * 400),
    y: (controller.random.nextDouble() * 800),
    ));
  }

  void _onStartGame(Size size) {
    // if (starsService.totalStars.value < 10) {
    //   Get.snackbar(
    //     '🔒 Locked',
    //     AppStrings.needStarsToPlay,
    //     snackPosition: SnackPosition.BOTTOM,
    //     backgroundColor: Colors.red,
    //     colorText: Colors.white,
    //   );
    //   return;
    // }

    controller.screenWidth = size.width;
    controller.screenHeight = size.height;
    controller.startGame();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BannerAdWidget(),
      body: Stack(
        children: [
          // 1. Background
          _buildBackground(),

          // 2. Stars
          ..._buildStars(),

          // 3. Floating bubbles — BEFORE SafeArea so dialog goes on top ✅
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

          // 4. Game content — AFTER bubbles so it renders on top ✅
          SafeArea(
            child: Obx(() {
              if (controller.isGameStarted.value) return _buildGameContent();
              if (controller.isGameOver.value) {
                return Stack(
                children: [
                  Container(color: Colors.black.withValues(alpha: 0.6)),
                  _buildGameOver(),
                ],
              );
              }
              return _buildStartScreen();
            }),
          ),

          // 5. Top bar — always on top
          SafeArea(child: Obx(() => _buildTopBar())),

          // 6. Confetti — always on top
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
                AppStrings.popCorrectBubble,
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
          // Drawn bubble (not an emoji) so it renders identically on every
          // device — the 🫧 glyph (Emoji 14.0) is missing on many phones
          // such as Infinix/XOS and showed as an empty box.
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const RadialGradient(
                center: Alignment(-0.3, -0.3),
                colors: [Color(0xFF80DEEA), Color(0xFF26C6DA)],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF26C6DA).withValues(alpha: 0.45),
                  blurRadius: 18,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Align(
              alignment: const Alignment(-0.4, -0.4),
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.65),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            AppStrings.numberPopTitle,
            style: GoogleFonts.poppins(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ).animate().fadeIn().slideY(begin: -0.2),
          const SizedBox(height: 12),
          Text(
            AppStrings.numberPopTagline,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(fontSize: 16, color: Colors.white70),
          ).animate().fadeIn(delay: 200.ms),
          const SizedBox(height: 40),
          GestureDetector(
            onTap: () => _onStartGame(MediaQuery.of(context).size),
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
              AppStrings.gameOverExcl,
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
                '⭐ ${AppStrings.score}: ${controller.score.value}',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // ── Rewarded ad button (only when an ad is available) ──
            Obx(() => RewardedAdService.instance.isLoadedRx.value
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _buildRewardedButton(
                      emoji: '❤️',
                      label: AppStrings.watchAdGetLife,
                      onTap: () {
                        RewardedAdService.instance.showAd(() {
                          controller.reviveWithLife();
                        });
                      },
                    ),
                  )
                : const SizedBox()),

            // ── Free buttons ──
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildBtn(AppStrings.home, () {
                  AdManager.instance.show();
                  Future.delayed(const Duration(milliseconds: 300),(){
                    if (mounted) Navigator.pop(context);
                  });
                }),
                const SizedBox(width: 16),
                _buildBtn(AppStrings.retry, () {
                  final size = MediaQuery.of(context).size;
                  AdManager.instance.show();
                  Future.delayed(const Duration(milliseconds: 300), () {
                    if (mounted) _onStartGame(size);
                  });
                }, isPrimary: true),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn().scale(begin: const Offset(0.8, 0.8));
  }

  Widget _buildRewardedButton({
    required String emoji,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        // Neutral ad styling + "Ad" badge — an ad entry point must never look
        // like a game reward button (Play Families ad-format requirement).
        decoration: BoxDecoration(
          color: AdSurfaceStyle.background,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AdSurfaceStyle.border, width: 1.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const AdBadge(),
            const SizedBox(width: 10),
            Text(emoji, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AdSurfaceStyle.foreground,
                ),
              ),
            ),
          ],
        ),
      ),
    );
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