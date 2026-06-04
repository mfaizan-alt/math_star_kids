import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:math_carnival_kids/modules/all_games_screen/table/table_controller.dart';

import '../../../core/colors/colors.dart';

class TablesScreen extends StatelessWidget {
  TablesScreen({super.key});

  final TablesController controller = Get.put(TablesController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TablesController>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(title: const Text('Times Tables 📊')),
          body: Column(
            children: [
              const SizedBox(height: 16),
              _buildTableSelector(controller),
              const SizedBox(height: 24),
              Expanded(child: _buildTableContent(controller)),
            ],
          ),
        );
      },
    );
  }

  // ---------------- SELECTOR ----------------

  Widget _buildTableSelector(TablesController c) {
    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: 12,
        itemBuilder: (context, index) {
          final tableNum = index + 1;
          final isSelected = tableNum == c.selectedTable;

          return GestureDetector(
            onTap: () => c.changeTable(tableNum),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 56,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.numbers
                    : AppColors.numbers.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
                boxShadow: isSelected
                    ? [
                  BoxShadow(
                    color: AppColors.numbers.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  )
                ]
                    : [],
              ),
              child: Center(
                child: Text(
                  '$tableNum',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : AppColors.numbers,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ---------------- TABLE CONTENT ----------------

  Widget _buildTableContent(TablesController c) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: 12,
      itemBuilder: (context, index) {
        final multiplier = index + 1;
        final result = c.selectedTable * multiplier;

        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.numbers.withValues(alpha: 0.1),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${c.selectedTable}',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.numbers,
                ),
              ),
              Text(' × ',
                  style: GoogleFonts.poppins(
                      fontSize: 22, color: Colors.grey)),
              Text(
                '$multiplier',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.multiplication,
                ),
              ),
              Text(' = ',
                  style: GoogleFonts.poppins(
                      fontSize: 22, color: Colors.grey)),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.correct.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$result',
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.correct,
                  ),
                ),
              ),
            ],
          ),
        )
            .animate()
            .fadeIn(duration: 300.ms, delay: Duration(milliseconds: 50 * index))
            .slideX(begin: 0.1);
      },
    );
  }
}