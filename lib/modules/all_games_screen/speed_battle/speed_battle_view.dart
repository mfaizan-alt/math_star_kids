import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:math_carnival_kids/modules/all_games_screen/speed_battle/speed_battle_controlelr.dart';


class SpeedBattleScreen extends StatelessWidget {
  SpeedBattleScreen({super.key});

  final controller = Get.put(SpeedBattleController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SpeedBattleController>(
      builder: (c) {
        if (!c.isPlaying && !c.isGameOver) return _startScreen(c);
        if (c.isGameOver) return _gameOver(c);

        return Scaffold(
          body: Column(
            children: [
              // Player 1 (rotated)
              Expanded(
                child: Transform.rotate(
                  angle: pi,
                  child: _playerArea(c, 1),
                ),
              ),

              // Middle
              Container(
                height: 60,
                color: Colors.black87,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text('P1: ${c.score1}',
                        style: GoogleFonts.poppins(color: Colors.redAccent)),
                    Text('${c.num1} ${c.operator} ${c.num2} = ?',
                        style: GoogleFonts.poppins(color: Colors.white)),
                    Text('P2: ${c.score2}',
                        style: GoogleFonts.poppins(color: Colors.cyan)),
                  ],
                ),
              ),

              // Player 2
              Expanded(child: _playerArea(c, 2)),
            ],
          ),
        );
      },
    );
  }

  Widget _playerArea(SpeedBattleController c, int player) {
    final feedback = player == 1 ? c.feedbackP1 : c.feedbackP2;

    return Container(
      color: Colors.grey.withValues(alpha: 0.1),
      child: Center(
        child: feedback.isNotEmpty
            ? Text(feedback, style: const TextStyle(fontSize: 40))
            .animate()
            .scale()
            : Wrap(
          spacing: 10,
          children: c.options.map((e) {
            return GestureDetector(
              onTap: () => c.answer(player, e),
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.blue),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(child: Text('$e')),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _startScreen(SpeedBattleController c) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: c.startGame,
          child: const Text("Start Game"),
        ),
      ),
    );
  }

  Widget _gameOver(SpeedBattleController c) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              c.score1 == c.score2
                  ? "Tie"
                  : c.score1 > c.score2
                  ? "Player 1 Wins"
                  : "Player 2 Wins",
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: c.reset,
              child: const Text("Restart"),
            ),
          ],
        ),
      ),
    );
  }
}