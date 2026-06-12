// Logic tests for Math Carnival Kids game controllers and story data.

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:math_carnival_kids/modules/all_games_screen/frog_jump/frog_jump_controller.dart';
import 'package:math_carnival_kids/modules/all_games_screen/number_pop/number_pop_controller.dart';
import 'package:math_carnival_kids/modules/all_games_screen/runner_game/runner_controller.dart';
import 'package:math_carnival_kids/modules/all_games_screen/subtraction/subtraction_controller.dart';
import 'package:math_carnival_kids/modules/math_question_view/math_Tablegame_view/math_table_game_controller.dart';
import 'package:math_carnival_kids/modules/story_detail_screen/story_detail_controller.dart';
import 'package:math_carnival_kids/modules/story_mode_screen/story_mode_controller.dart';

void main() {
  group('SubtractionController.generateQuestion', () {
    test('produces 4 unique non-negative options including the answer', () {
      final controller = SubtractionController();
      for (var i = 0; i < 200; i++) {
        controller.generateQuestion();
        expect(controller.correctAnswer, greaterThanOrEqualTo(1));
        expect(controller.options.length, 4);
        expect(controller.options.toSet().length, 4);
        expect(controller.options, contains(controller.correctAnswer));
        expect(controller.options.every((o) => o >= 0), isTrue);
        expect(controller.num1 - controller.num2, controller.correctAnswer);
      }
    });
  });

  group('FrogJumpController.generateQuestion', () {
    test('pads are 5 distinct positive numbers with the answer present', () {
      final controller = FrogJumpController();
      for (var i = 0; i < 200; i++) {
        controller.generateQuestion();
        final pads = controller.padAnswers;
        expect(pads.length, 5);
        expect(pads.toSet().length, 5);
        expect(pads, contains(controller.correctAnswer.value));
        expect(pads.every((p) => p > 0), isTrue);
      }
    });
  });

  group('RunnerGameController.generateQuestion', () {
    test('3 unique lane answers, answer present, subtraction never negative',
        () {
      final controller = RunnerGameController();
      for (var i = 0; i < 200; i++) {
        controller.generateQuestion();
        expect(controller.answers.length, 3);
        expect(controller.answers.toSet().length, 3);
        expect(controller.answers, contains(controller.correctAnswer.value));
        expect(controller.correctAnswer.value, greaterThanOrEqualTo(0));
      }
    });
  });

  group('NumberPopController.generateQuestion', () {
    test('answers are never negative', () {
      final controller = NumberPopController();
      for (var i = 0; i < 200; i++) {
        controller.generateQuestion();
        expect(controller.correctAnswer.value, greaterThanOrEqualTo(0));
      }
    });
  });

  group('MathTableController', () {
    test('quiz options are 4 unique positive values including the answer', () {
      final controller = MathTableController();
      controller.startQuiz([3, 7]);
      for (var i = 0; i < 100; i++) {
        expect(controller.options.length, 4);
        expect(controller.options.toSet().length, 4);
        expect(controller.options, contains(controller.correctAnswer));
        expect(controller.options.every((o) => o > 0), isTrue);
        expect([3, 7], contains(controller.num1.value));
        controller.startQuiz([3, 7]);
      }
    });

    test('startQuiz with no tables returns to picker instead of crashing', () {
      final controller = MathTableController();
      controller.startQuiz([]);
      expect(controller.screen.value, ScreenState.picker);
    });
  });

  group('StoryDetailController.checkAnswer', () {
    test('handles int answers', () {
      final controller = StoryDetailController();
      controller.story.value = {
        'scenes': [
          {
            'hasQuestion': true,
            'options': [1, 2, 3, 4],
            'answer': 3,
          },
        ],
      };
      controller.checkAnswer(3);
      expect(controller.isCorrect.value, isTrue);
      expect(controller.answered.value, isTrue);
    });

    test('handles string answers (fractions story)', () {
      final controller = StoryDetailController();
      controller.story.value = {
        'scenes': [
          {
            'hasQuestion': true,
            'options': ['1/8', '1/4', '1/2', '3/4'],
            'answer': '1/4',
          },
        ],
      };
      controller.checkAnswer('1/4');
      expect(controller.isCorrect.value, isTrue);
      expect(controller.selectedAnswer.value, '1/4');
    });
  });

  group('Story data integrity', () {
    test('every question scene has options that include the answer', () {
      final controller = StoryModeController();
      for (final story in controller.stories) {
        final scenes = story['scenes'] as List<dynamic>;
        for (final scene in scenes) {
          if (scene['hasQuestion'] == true) {
            final options = scene['options'] as List<dynamic>;
            expect(options, contains(scene['answer']),
                reason: 'Story "${story['title']}" has a question whose '
                    'answer is not among its options');
          }
        }
      }
    });

    test('every referenced story image exists on disk', () {
      final controller = StoryModeController();
      for (final story in controller.stories) {
        final paths = <String>[story['cover'] as String];
        for (final scene in story['scenes'] as List<dynamic>) {
          if (scene['image'] != null) paths.add(scene['image'] as String);
        }
        for (final path in paths) {
          expect(File(path).existsSync(), isTrue,
              reason: 'Story "${story['title']}" references missing '
                  'asset: $path');
        }
      }
    });
  });
}
