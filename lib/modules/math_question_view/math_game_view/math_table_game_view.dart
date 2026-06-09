import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/commonWidgets/ads/ad_manager.dart';
import 'math_table_game_controller.dart';

class MathTablesView extends GetView<MathTableController> {
  const MathTablesView({super.key});

  // ── Per-table color palette ──────────────────
  List<Color> _tableColors(int number) {
    final palettes = [
      [const Color(0xFFFF6B6B), const Color(0xFFFF8E53)],
      [const Color(0xFF4FACFE), const Color(0xFF00F2FE)],
      [const Color(0xFF43E97B), const Color(0xFF38F9D7)],
      [const Color(0xFFF093FB), const Color(0xFFF5576C)],
      [const Color(0xFF4481EB), const Color(0xFF04BEFE)],
      [const Color(0xFFFA709A), const Color(0xFFFEE140)],
      [const Color(0xFFA18CD1), const Color(0xFFFBC2EB)],
      [const Color(0xFFFFD200), const Color(0xFFF7971E)],
    ];
    return palettes[number % palettes.length];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      body: Stack(
        children: [
          // Soft background blobs
          Positioned(top: -60, right: -60,
            child: Container(width: 200, height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF4FACFE).withValues(alpha: 0.12),
              ),
            ),
          ),
          Positioned(bottom: 100, left: -40,
            child: Container(width: 160, height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFA709A).withValues(alpha: 0.10),
              ),
            ),
          ),

          SafeArea(
            child: Obx(() {
              switch (controller.screen.value) {
                case ScreenState.picker:
                  return _buildPicker();
                case ScreenState.table:
                  return _buildTableDetail();
                case ScreenState.quiz:
                  return _buildQuiz();
                case ScreenState.result:
                  return _buildResult();
              }
            }),
          ),

          // Confetti
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: controller.confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [
                Color(0xFFFF6B6B), Color(0xFF4FACFE),
                Color(0xFF43E97B), Color(0xFFFFD200), Color(0xFFF093FB),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════
  // SCREEN 1 — TABLE PICKER
  // ════════════════════════════════════════════
  Widget _buildPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _pickerHeader(),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text('Tap a table to explore 👇',
            style: GoogleFonts.nunito(
              fontSize: 15, color: Colors.grey[600],
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.05,
              ),
              itemCount: controller.tables.length,
              itemBuilder: (_, i) => _tableChip(controller.tables[i]),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _pickerHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF4481EB), Color(0xFF04BEFE)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Stack(children: [
        Positioned(top: -20, right: -10,
          child: Text('✖', style: TextStyle(
            fontSize: 100,
            color: Colors.white.withValues(alpha: 0.07),
            fontWeight: FontWeight.bold,
          )),
        ),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.white, size: 18),
            ),
          ),
          const SizedBox(height: 14),
          Row(children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Text('✖️', style: TextStyle(fontSize: 32)),
            ),
            const SizedBox(width: 14),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Times Tables',
                style: GoogleFonts.baloo2(
                  fontSize: 26, color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text('Tables from 1 to 20 🌟',
                style: GoogleFonts.nunito(
                  fontSize: 13, color: Colors.white.withValues(alpha: 0.85),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ]),
          ]),
        ]),
      ]),
    );
  }

  Widget _tableChip(int number) {
    final colors = _tableColors(number);
    return GestureDetector(
      onTap: () => controller.selectTable(number),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: colors[0].withValues(alpha: 0.4),
              blurRadius: 10, offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text('$number',
            style: GoogleFonts.baloo2(
              fontSize: 26, color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text('Table',
            style: GoogleFonts.nunito(
              fontSize: 10, color: Colors.white.withValues(alpha: 0.85),
              fontWeight: FontWeight.w700,
            ),
          ),
        ]),
      ),
    );
  }

  // ════════════════════════════════════════════
  // SCREEN 2 — TABLE DETAIL
  // ════════════════════════════════════════════
  Widget _buildTableDetail() {
    return Obx(() {
      final number = controller.selectedTable.value;
      final rows = controller.getTableRows(number);
      final colors = _tableColors(number);

      return Column(children: [
        _detailHeader(number, colors),
        const SizedBox(height: 12),

        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: rows.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (_, i) =>
                _tableRow(
                  index: i,
                  expression: rows[i]['expression'],
                  result: rows[i]['result'],
                  colors: colors,
                ),
          ),
        ),

        const SizedBox(height: 12),

        // Quiz button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GestureDetector(
            onTap: () => controller.startSingleTableQuiz(),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: colors),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: colors[0].withValues(alpha: 0.45),
                    blurRadius: 20, offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center, children: [
                const Icon(Icons.quiz_rounded, color: Colors.white, size: 22),
                const SizedBox(width: 8),
                Text('Start Quiz for Table $number',
                  style: GoogleFonts.baloo2(
                    fontSize: 18, color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ]),
            ),
          ),
        ),

        const SizedBox(height: 10),

        // Back button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GestureDetector(
            onTap: controller.goToPicker,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: colors[0].withValues(alpha: 0.4), width: 2),
              ),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(Icons.grid_view_rounded, color: colors[0], size: 20),
                const SizedBox(width: 8),
                Text('← Pick Another Table',
                  style: GoogleFonts.nunito(
                    fontSize: 16, color: colors[0],
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ]),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ]);
    });
  }

  Widget _detailHeader(int number, List<Color> colors) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Stack(children: [
        Positioned(right: 0, top: -15,
          child: Text('$number',
            style: GoogleFonts.baloo2(
              fontSize: 90, color: Colors.white.withValues(alpha: 0.1),
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          GestureDetector(
            onTap: controller.goToPicker,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.white, size: 18),
            ),
          ),
          const SizedBox(height: 12),
          Row(children: [
            Container(
              width: 64, height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.25),
                border: Border.all(
                    color: Colors.white.withValues(alpha: 0.4), width: 2),
              ),
              child: Center(
                child: Text('$number',
                  style: GoogleFonts.baloo2(
                    fontSize: 30, color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Table of $number',
                style: GoogleFonts.baloo2(
                  fontSize: 24, color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text('10 multiplications to master!',
                style: GoogleFonts.nunito(
                  fontSize: 12, color: Colors.white.withValues(alpha: 0.85),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ]),
          ]),
        ]),
      ]),
    );
  }

  Widget _tableRow({
    required int index,
    required String expression,
    required int result,
    required List<Color> colors,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8, offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(children: [
        Container(
          width: 32, height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colors[0].withValues(alpha: 0.12),
          ),
          child: Center(
            child: Text('${index + 1}',
              style: GoogleFonts.baloo2(
                fontSize: 14, color: colors[0],
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(expression,
            style: GoogleFonts.baloo2(
              fontSize: 20, color: const Color(0xFF1A1A2E),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Text('=',
          style: GoogleFonts.baloo2(
            fontSize: 20, color: Colors.grey[400],
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: colors),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: colors[0].withValues(alpha: 0.3),
                blurRadius: 8, offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Text('$result',
            style: GoogleFonts.baloo2(
              fontSize: 20, color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ]),
    );
  }

  // ════════════════════════════════════════════
  // SCREEN 3 — QUIZ
  // ════════════════════════════════════════════
  Widget _buildQuiz() {
    return Obx(() {
      final colors = _tableColors(controller.num1.value);
      final progress = (controller.currentQuestion.value + 1) /
          controller.totalQuestions;

      return Column(children: [
        _quizHeader(colors, progress),
        const SizedBox(height: 28),

        // Question card
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: colors[0].withValues(alpha: 0.2),
                  blurRadius: 24, offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(children: [
              Text('What is',
                style: GoogleFonts.nunito(
                  fontSize: 16, color: Colors.grey[500],
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              ShaderMask(
                shaderCallback: (bounds) =>
                    LinearGradient(
                      colors: colors,
                    ).createShader(bounds),
                child: Text(
                  '${controller.num1.value} × ${controller.num2.value} = ?',
                  style: GoogleFonts.baloo2(
                    fontSize: 42, color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ]),
          ),
        ),

        const SizedBox(height: 28),

        // Answer options
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 2.0,
              physics: const NeverScrollableScrollPhysics(),
              children: controller.options.map((opt) {
                return _optionButton(opt, colors);
              }).toList(),
            ),
          ),
        ),

        const SizedBox(height: 20),
      ]);
    });
  }

  Widget _quizHeader(List<Color> colors, double progress) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(children: [
        Row(children: [
          GestureDetector(
            onTap: controller.goBack,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.close_rounded,
                  color: Colors.white, size: 20),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                'Table${controller.selectedTables.length > 1
                    ? "s"
                    : ""} of ${controller.selectedTables.join(", ")}',
                style: GoogleFonts.baloo2(
                  fontSize: 18, color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                'Q ${controller.currentQuestion.value + 1} / ${controller
                    .totalQuestions}',
                style: GoogleFonts.nunito(
                  fontSize: 13, color: Colors.white.withValues(alpha: 0.85),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ]),
          ),
          // Score badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(children: [
              const Text('⭐', style: TextStyle(fontSize: 16)),
              const SizedBox(width: 4),
              Text('${controller.score.value}',
                style: GoogleFonts.baloo2(
                  fontSize: 18, color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ]),
          ),
        ]),
        const SizedBox(height: 14),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: Colors.white.withValues(alpha: 0.25),
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
      ]),
    );
  }

  Widget _optionButton(int option, List<Color> colors) {
    final answered = controller.answered.value;
    final selected = controller.selectedOption!.value;
    final correct = controller.correctAnswer;

    Color bgColor = Colors.white;
    Color textColor = const Color(0xFF1A1A2E);
    Color borderColor = Colors.transparent;
    IconData? icon;

    if (answered) {
      if (option == correct) {
        bgColor = const Color(0xFF43E97B).withValues(alpha: 0.15);
        borderColor = const Color(0xFF43E97B);
        textColor = const Color(0xFF1E8449);
        icon = Icons.check_circle_rounded;
      } else if (option == selected && option != correct) {
        bgColor = const Color(0xFFFF6B6B).withValues(alpha: 0.12);
        borderColor = const Color(0xFFFF6B6B);
        textColor = const Color(0xFFCC0000);
        icon = Icons.cancel_rounded;
      }
    }

    return GestureDetector(
      onTap: () => controller.checkAnswer(option),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: answered && option == correct
                ? borderColor
                : answered && option == selected
                ? borderColor
                : colors[0].withValues(alpha: 0.2),
            width: answered && (option == correct || option == selected)
                ? 2.5
                : 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 8, offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          if (icon != null) ...[
            Icon(icon, color: borderColor, size: 20),
            const SizedBox(width: 6),
          ],
          Text('$option',
            style: GoogleFonts.baloo2(
              fontSize: 24, color: textColor,
              fontWeight: FontWeight.w800,
            ),
          ),
        ]),
      ),
    );
  }

  // ════════════════════════════════════════════
  // SCREEN 4 — RESULT
  // ════════════════════════════════════════════
  Widget _buildResult() {
    return Obx(() {
      final colors = _tableColors(controller.selectedTable.value);
      final stars = controller.stars;

      return SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(children: [
          const SizedBox(height: 20),

          // Trophy / emoji
          Container(
            width: 120, height: 120,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: colors),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: colors[0].withValues(alpha: 0.4),
                  blurRadius: 30, offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Center(
              child: Text(
                stars == 3 ? '🏆' : stars == 2 ? '🌟' : stars == 1 ? '👍' : '💪',
                style: const TextStyle(fontSize: 52),
              ),
            ),
          ),

          const SizedBox(height: 24),

          Text(controller.resultMessage,
            style: GoogleFonts.baloo2(
              fontSize: 28, color: const Color(0xFF1A1A2E),
              fontWeight: FontWeight.w900,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 20),

          // Stars row
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            ...List.generate(3, (i) =>
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Obx(() {
                    return Icon(
                      i < controller.stars ? Icons.star_rounded : Icons
                          .star_outline_rounded,
                      color: const Color(0xFFFFD200),
                      size: 44,
                    );
                  }),
                )),
          ]),

          const SizedBox(height: 20),

          // Score card
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.07),
                  blurRadius: 20, offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(children: [
              Text('Your Score',
                style: GoogleFonts.nunito(
                  fontSize: 14, color: Colors.grey[500],
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              ShaderMask(
                shaderCallback: (b) =>
                    LinearGradient(colors: colors).createShader(b),
                child: Text(
                  '${controller.score.value} / ${controller.totalQuestions}',
                  style: GoogleFonts.baloo2(
                    fontSize: 48, color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ]),
          ),

          const SizedBox(height: 32),

          // Play Again
          GestureDetector(
            onTap: () {
              AdManager.instance.load();
              Future.delayed(const Duration(milliseconds: 1800), () {
                if (AdManager.instance.isReady) {
                  AdManager.instance.show();
                }
                controller.resetQuiz();
              });
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: colors),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: colors[0].withValues(alpha: 0.45),
                    blurRadius: 20, offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center, children: [
                const Icon(Icons.replay_rounded, color: Colors.white, size: 22),
                const SizedBox(width: 8),
                Text('Play Again',
                  style: GoogleFonts.baloo2(
                    fontSize: 20, color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ]),
            ),
          ),

          const SizedBox(height: 12),

          // Home
          GestureDetector(
            onTap: () {
              AdManager.instance.load();
              Future.delayed(const Duration(milliseconds: 1800), () {
                if (AdManager.instance.isReady) {
                  AdManager.instance.show();
                }
                controller.goToPicker();
              });
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: colors[0].withValues(alpha: 0.35), width: 2),
              ),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(Icons.grid_view_rounded, color: colors[0], size: 20),
                const SizedBox(width: 8),
                Text('Pick Another Table',
                  style: GoogleFonts.nunito(
                    fontSize: 16, color: colors[0],
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ]),
            ),
          ),

          const SizedBox(height: 20),
        ]),
      );
    });
  }
}