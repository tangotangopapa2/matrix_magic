import 'package:flutter/material.dart';
import '../models/game_type.dart';

abstract class MathGame {
  GameType get type;
  String get name;
  String get description;

  void generateQuestion();
  bool checkAnswer(dynamic userAnswer);
  Widget buildInputWidget({
    required BuildContext context,
    required dynamic currentInput,
    required Function(dynamic) onInputChanged,
    required VoidCallback onSubmit,
  });
  dynamic get question;
  dynamic get correctAnswer;
}