import 'dart:math';
import 'package:flutter/material.dart';
import 'game_interface.dart';
import '../models/game_type.dart';

class AddNumbersGame implements MathGame {
  late int _num1;
  late int _num2;
  late int _correctAnswer;

  @override
  GameType get type => GameType.addNumbers;

  @override
  String get name => type.name;

  @override
  String get description => type.description;

  @override
  void generateQuestion() {
    final random = Random();
    _num1 = random.nextInt(21) - 10;  // Range: -10 to 10
    _num2 = random.nextInt(21) - 10;  // Range: -10 to 10
    _correctAnswer = _num1 + _num2;
  }

  @override
  bool checkAnswer(dynamic userAnswer) {
    if (userAnswer is int) {
      return userAnswer == _correctAnswer;
    }
    if (userAnswer is String) {
      return int.tryParse(userAnswer) == _correctAnswer;
    }
    return false;
  }

  @override
  Widget buildInputWidget({
    required BuildContext context,
    required dynamic currentInput,
    required Function(dynamic) onInputChanged,
    required VoidCallback onSubmit,
  }) {
    return Column(
      children: [
        Text(
          '$_num1 + $_num2 = ?',
          style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        Text(
          currentInput?.toString() ?? '0',
          style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  @override
  dynamic get question => [_num1, _num2];

  @override
  dynamic get correctAnswer => _correctAnswer;
}