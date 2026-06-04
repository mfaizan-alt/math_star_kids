import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/colors/colors.dart';

class CountingScreen extends StatefulWidget {
  const CountingScreen({super.key});

  @override
  State<CountingScreen> createState() => _CountingScreenState();
}

class _CountingScreenState extends State<CountingScreen> {
  int _currentNumber = 1;
  int _targetNumber = 0;
  int _score = 0;
  int _round = 0;
  final int _totalRounds = 10;
  bool _showFeedback = false;
  bool _isCorrect = false;

  final List<String> _emojis = ['🍎', '🌟', '🎈', '🐱', '🦋', '🌸', '🍕', '🎨', '🚀', '🐶'];

  @override
  void initState() {
    super.initState();
    _generateRound();
  }

  void _generateRound() {
    _targetNumber = (_round % 9) + 2 + (_round ~/ 3); // Gradually harder
    if (_targetNumber > 15) _targetNumber = 15;
    _currentNumber = 1;
    _showFeedback = false;
  }

  void _incrementCount() {
    setState(() {
      if (_currentNumber < 20) _currentNumber++;
    });
  }

  void _decrementCount() {
    setState(() {
      if (_currentNumber > 1) _currentNumber--;
    });
  }

  void _submitAnswer() {
    setState(() {
      _showFeedback = true;
      _isCorrect = _currentNumber == _targetNumber;
      if (_isCorrect) _score++;
    });

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      setState(() {
        _round++;
        if (_round >= _totalRounds) {
          _showResultDialog();
        } else {
          _generateRound();
        }
      });
    });
  }

  void _showResultDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _score >= 8 ? '🎉 Amazing!' : _score >= 5 ? '👍 Good Job!' : '💪 Keep Trying!',
                style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text('You got $_score/$_totalRounds correct!', style: GoogleFonts.poppins(fontSize: 18)),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () { Navigator.pop(context); Navigator.pop(context); },
                      child: const Text('Home'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() { _score = 0; _round = 0; _generateRound(); });
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.counting),
                      child: const Text('Play Again'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final emoji = _emojis[_round % _emojis.length];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Counting 🔢'),
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: AppColors.counting.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '⭐ $_score/$_totalRounds',
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: AppColors.counting),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              'Round ${_round + 1} of $_totalRounds',
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: (_round + 1) / _totalRounds,
                minHeight: 8,
                backgroundColor: AppColors.counting.withValues(alpha: 0.1),
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.counting),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Count the items!',
              style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardTheme.color,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.counting.withValues(alpha: 0.2), width: 2),
                ),
                child: Center(
                  child: Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    alignment: WrapAlignment.center,
                    children: List.generate(_targetNumber, (index) {
                      return Text(emoji, style: const TextStyle(fontSize: 36))
                          .animate()
                          .fadeIn(delay: Duration(milliseconds: 100 * index))
                          .scale(begin: const Offset(0, 0));
                    }),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            if (_showFeedback)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: (_isCorrect ? AppColors.correct : AppColors.incorrect).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  _isCorrect ? '✅ Correct! There are $_targetNumber items!' : '❌ Not quite! There are $_targetNumber items.',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: _isCorrect ? AppColors.correct : AppColors.incorrect,
                  ),
                  textAlign: TextAlign.center,
                ),
              ).animate().fadeIn().shake()
            else ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildCountButton(Icons.remove_rounded, _decrementCount),
                  const SizedBox(width: 24),
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.counting.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.counting, width: 2),
                    ),
                    child: Center(
                      child: Text(
                        '$_currentNumber',
                        style: GoogleFonts.poppins(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.counting),
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),
                  _buildCountButton(Icons.add_rounded, _incrementCount),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _submitAnswer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.counting,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text('Submit Answer', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildCountButton(IconData icon, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: AppColors.coralColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: AppColors.coralColor.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 4)),
          ],
        ),
        child: Icon(icon, color: Colors.white, size: 28),
      ),
    );
  }
}

