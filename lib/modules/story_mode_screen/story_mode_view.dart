import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:math_carnival_kids/modules/story_mode_screen/story_mode_controller.dart';

import '../../core/colors/colors.dart';
import '../../core/routes/routes.dart';
import '../story_detail_screen/story_detail_view.dart';

class StoryModeView extends GetView<StoryModeController> {
  const StoryModeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),

            _buildTabs(),
            // Story List
            Expanded(
              child: Obx(
                () => ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.filteredStories.length,
                  itemBuilder: (context, index) {
                    final story = controller.filteredStories[index];
                    return _buildStoryCard(story);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Header ───────────────────────────────────────
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFEF476F), Color(0xFFFF9F1C)],
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
            top: -30,
            right: -20,
            child: Container(
              width: 120,
              height: 120,
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

              Row(
                children: [
                  const Text('📖', style: TextStyle(fontSize: 40)),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Kids Stories',
                        style: GoogleFonts.fredoka(
                          fontSize: 28,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Read, Learn and Have Fun!',
                        style: GoogleFonts.nunito(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.85),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => controller.changeTab('math'),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: controller.selectedType.value == 'math'
                        ? const Color(0xFFEF476F)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Center(child: Text('🧮   Math Stories',style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600),)),
                ),
              ),
            ),

            const SizedBox(width: 10),

            Expanded(
              child: GestureDetector(
                onTap: () => controller.changeTab('reading'),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: controller.selectedType.value == 'reading'
                        ? Color(0xFFEF476F)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Center(child: Text('📖   Reading Stories',style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600,),)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Story Card ───────────────────────────────────
  Widget _buildStoryCard(Map<String, dynamic> story) {
    final isLocked = (story["isPremium"] == true) && !controller.isStoryUnlocked();
    
    return GestureDetector(
      onTap: () => controller.openStory(story),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
          // ✅ Safe null check — uses cover key
          image: story["cover"] != null
              ? DecorationImage(
                  image: AssetImage(story["cover"] as String),
                  fit: BoxFit.cover,
                  onError: (error, stack) {},
                )
              : null,
          // Fallback color if image missing
          color: story["cover"] == null ? const Color(0xFFEF476F) : null,
        ),
        child: Stack(
          children: [
            // Gradient overlay
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.transparent,
                    Colors.black54,
                    Colors.black87.withOpacity(isLocked ? 0.7 : 0.87),
                  ],
                ),
              ),
            ),

            // Lock overlay (if premium and not unlocked)
            if (isLocked)
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: Colors.black.withOpacity(0.4),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        '🔒',
                        style: TextStyle(fontSize: 48),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'UNLOCK AT 40⭐',
                        style: GoogleFonts.aBeeZee(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // Type badge — top left
            Positioned(
              top: 12,
              left: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: story["type"] == "math"
                      ? const Color(0xFF4CC9F0).withOpacity(0.9)
                      : const Color(0xFF06D6A0).withOpacity(0.9),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  story["type"] == "math" ? '➕ Math Story' : '📖 Reading',
                  style: GoogleFonts.nunito(
                    fontSize: 11,
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),

            // Premium badge or Stars badge — top right
            Positioned(
              top: 12,
              right: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: (story["isPremium"] == true)
                      ? const Color(0xFFFFD166).withOpacity(0.9)
                      : Colors.black.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  (story["isPremium"] == true)
                      ? '⭐ Premium ${story["stars"]}'
                      : '⭐ ${story["stars"]}',
                  style: GoogleFonts.nunito(
                    fontSize: 11,
                    color: (story["isPremium"] == true) ? Colors.black87 : Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),

            // Bottom info
            Positioned(
              left: 14,
              right: 14,
              bottom: 14,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    story["title"] ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.fredoka(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),

                  const SizedBox(height: 2),

                  // Description
                  Text(
                    story["description"] ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.nunito(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
