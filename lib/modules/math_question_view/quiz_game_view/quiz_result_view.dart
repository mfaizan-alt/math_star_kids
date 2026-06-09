import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/colors/colors.dart';
import '../../../core/commonWidgets/ads/ad_Manager.dart';
import '../../../core/routes/routes.dart';

class QuizResultScreen extends StatelessWidget {
  const QuizResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final score = Get.arguments['score'] as int;
    final total = Get.arguments['total'] as int;
    final stars = score >= 9 ? 3 : score >= 7 ? 2 : score >= 5 ? 1 : 0;

    return Scaffold(
      backgroundColor: const Color(0xFFE8E8FF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 40),

              // Trophy
              Container(
                width: 120, height: 120,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF7B2FBE), Color(0xFF4CC9F0)],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    stars == 3 ? '🏆' : stars == 2 ? '🌟' : stars == 1 ? '👍' : '💪',
                    style: const TextStyle(fontSize: 52),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              Text(
                stars == 3 ? '🏆 Math Champion!' : stars == 2 ? '🌟 Great Job!' : stars == 1 ? '👍 Good Try!' : '💪 Keep Practicing!',
                style: GoogleFonts.aBeeZee(
                  fontSize: 28,
                  color: const Color(0xFF7B2FBE),
                  fontWeight: FontWeight.w900,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 30),

              // Score Card
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.07),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'Your Score',
                      style: GoogleFonts.nunito(
                        fontSize: 14,
                        color: Colors.grey[500],
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '$score / $total',
                      style: GoogleFonts.aBeeZee(
                        fontSize: 48,
                        color: const Color(0xFF7B2FBE),
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Stars Row
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                ...List.generate(3, (i) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Icon(
                    i < stars ? Icons.star_rounded : Icons.star_outline_rounded,
                    color: const Color(0xFFFFD200),
                    size: 44,
                  ),
                )),
              ]),

              const SizedBox(height: 40),

              // Continue to Adventure Map Button
              GestureDetector(
                onTap: () {
                  AdManager.instance.load();
                  Future.delayed(const Duration(milliseconds: 1800), () {
                    if (AdManager.instance.isReady) {
                      AdManager.instance.show();
                    }
                    Get.offNamed('/mathScreen');
                  });
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF7B2FBE), Color(0xFF4CC9F0)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF7B2FBE).withOpacity(0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    const Icon(Icons.map_rounded, color: Colors.white, size: 22),
                    const SizedBox(width: 8),
                    Text('Continue to Game Screen',
                      style: GoogleFonts.aBeeZee(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ]),
                ),
              ),

              const SizedBox(height: 12),

              // Play Again Button
              GestureDetector(
                onTap: () {
                  AdManager.instance.load();
                  Future.delayed(const Duration(milliseconds: 1800), () {
                    if (AdManager.instance.isReady) {
                      AdManager.instance.show();
                    }
                    Get.offNamed(Routes.quizGameScreen);
                  });
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFF7B2FBE).withOpacity(0.35),
                      width: 2,
                    ),
                  ),
                  child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Icon(Icons.replay_rounded, color: const Color(0xFF7B2FBE), size: 20),
                    const SizedBox(width: 8),
                    Text('Play Again',
                      style: GoogleFonts.aBeeZee(
                        fontSize: 16,
                        color: const Color(0xFF7B2FBE),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ]),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}