import 'dart:math';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/colors/colors.dart';
import '../../core/commonWidgets/ads/ad_Manager.dart';
import '../../core/commonWidgets/all_widgets.dart';
import '../progress/progress.dart';
import '../progress/progress_controller.dart';

class DivisionScreen extends StatefulWidget {
  const DivisionScreen({super.key});

  @override
  State<DivisionScreen> createState() => _DivisionScreenState();
}

class _DivisionScreenState extends State<DivisionScreen> {
  final Random _random = Random();
  late ConfettiController _confettiController;

  int _num1 = 0;
  int _num2 = 0;
  int _correctAnswer = 0;
  List<int> _options = [];
  int _score = 0;
  int _questionNumber = 0;
  final int _totalQuestions = 10;
  int? _selectedOption;
  int _difficulty = 1;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
    _generateQuestion();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _generateQuestion() {
    int maxDivisor;
    switch (_difficulty) {
      case 1:
        maxDivisor = 5;
        break;
      case 2:
        maxDivisor = 10;
        break;
      default:
        maxDivisor = 12;
    }

    _num2 = _random.nextInt(maxDivisor) + 1;
    _correctAnswer = _random.nextInt(maxDivisor) + 1;
    _num1 = _num2 * _correctAnswer;

    _options = [_correctAnswer];
    while (_options.length < 4) {
      int option = _correctAnswer + _random.nextInt(11) - 5;
      if (option != _correctAnswer && option > 0 && !_options.contains(option)) {
        _options.add(option);
      }
    }
    _options.shuffle();
    _selectedOption = null;
  }

  void _checkAnswer(int selected) {
    if (_selectedOption != null) return;
    setState(() {
      _selectedOption = selected;
      if (selected == _correctAnswer) {
        _score++;
        _confettiController.play();
      }
    });

    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      setState(() {
        _questionNumber++;
        if (_questionNumber >= _totalQuestions) {
          _showResults();
        } else {
          _generateQuestion();
        }
      });
    });
  }

  void _showResults() {
    final provider = Get.find<ProgressController>();

    int stars = _score >= 9 ? 3 : _score >= 7 ? 2 : _score >= 5 ? 1 : 0;
    provider.addStars('division', stars);

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
                _score >= 7 ? '🎉 Great Job!' : _score >= 5 ? '👍 Good Try!' : '💪 Keep Practicing!',
                style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (index) {
                  return Icon(index < stars ? Icons.star_rounded : Icons.star_outline_rounded, color: AppColors.star, size: 40);
                }),
              ),
              const SizedBox(height: 16),
              Text('Score: $_score / $_totalQuestions', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600)),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: FunButton(
                      text: 'Home',
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      color: Colors.grey,
                      icon: Icons.home_rounded,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FunButton(
                      text: 'Again',
                      onPressed: () {
                        Navigator.pop(context);
                        AdManager.instance.show();
                        setState(() {
                          _score = 0;
                          _questionNumber = 0;
                          _generateQuestion();
                        });
                      },
                      color: AppColors.division,
                      icon: Icons.replay_rounded,
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Division ➗'),
        actions: [
          AnimatedScoreCard(score: _score, total: _totalQuestions, color: AppColors.division),
          const SizedBox(width: 16),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _buildDifficultySelector(),
                const SizedBox(height: 16),
                _buildProgressBar(),
                const SizedBox(height: 32),
                _buildQuestion(),
                const Spacer(),
                _buildOptions(),
                const SizedBox(height: 40),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [AppColors.star, AppColors.correct, AppColors.division],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDifficultySelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildDifficultyChip('Easy', 1),
        const SizedBox(width: 8),
        _buildDifficultyChip('Medium', 2),
        const SizedBox(width: 8),
        _buildDifficultyChip('Hard', 3),
      ],
    );
  }

  Widget _buildDifficultyChip(String label, int level) {
    final isSelected = _difficulty == level;
    return GestureDetector(
      onTap: () => setState(() {
        _difficulty = level;
        _score = 0;
        _questionNumber = 0;
        _generateQuestion();
      }),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.division : AppColors.division.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            color: isSelected ? Colors.white : AppColors.division,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    return Column(
      children: [
        Text('Question ${_questionNumber + 1}/$_totalQuestions', style: GoogleFonts.poppins(fontSize: 14)),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: (_questionNumber + 1) / _totalQuestions,
            minHeight: 8,
            backgroundColor: AppColors.division.withValues(alpha: 0.1),
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.division),
          ),
        ),
      ],
    );
  }

  Widget _buildQuestion() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: AppColors.division.withValues(alpha: 0.15), blurRadius: 20, offset: const Offset(0, 8)),
        ],
      ),
      child: Column(
        children: [
          Text('What is', style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey)),
          const SizedBox(height: 8),
          Text(
            '$_num1 ÷ $_num2 = ?',
            style: GoogleFonts.poppins(fontSize: 36, fontWeight: FontWeight.bold, color: AppColors.division),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).scale(begin: const Offset(0.9, 0.9));
  }

  Widget _buildOptions() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 2.5,
      physics: const NeverScrollableScrollPhysics(),
      children: _options.map((option) {
        bool isSelected = _selectedOption == option;
        bool? isCorrectOption;
        if (_selectedOption != null) isCorrectOption = option == _correctAnswer;

        return AnswerButton(
          text: '$option',
          onPressed: () => _checkAnswer(option),
          isSelected: isSelected || (_selectedOption != null && option == _correctAnswer),
          isCorrect: isCorrectOption,
        );
      }).toList(),
    );
  }
}