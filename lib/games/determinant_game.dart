import 'dart:math';
import 'package:flutter/material.dart';
import 'game_interface.dart';
import '../models/game_type.dart';
import '../models/matrix2x2.dart';
import '../utils/constants.dart';
import '../widgets/matrix_display.dart';

class DeterminantGame implements MathGame {
  late Matrix2x2 _matrix;
  late int _correctAnswer;

  @override
  GameType get type => GameType.determinant;

  @override
  String get name => type.name;

  @override
  String get description => type.description;

  @override
  void generateQuestion() {
    final random = Random();
    _matrix = Matrix2x2(
      topLeft: random.nextInt(matrixRandomRange) - matrixValueOffset,
      topRight: random.nextInt(matrixRandomRange) - matrixValueOffset,
      bottomLeft: random.nextInt(matrixRandomRange) - matrixValueOffset,
      bottomRight: random.nextInt(matrixRandomRange) - matrixValueOffset,
    );
    _correctAnswer = _matrix.determinant();
  }

  @override
  bool checkAnswer(dynamic userAnswer) {
    if (userAnswer is int) {
      return userAnswer == _correctAnswer;
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
    final screenWidth = MediaQuery.of(context).size.width;
    final answerFontSize = screenWidth < smallScreenBreakpoint
        ? 24.0
        : 32.0;

    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              MatrixDisplay(
                matrix: _matrix,
                showDeterminantBars: true,
              ),
              SizedBox(
                  width: screenWidth < smallScreenBreakpoint
                      ? matrixCellSpacingSmall * 2
                      : matrixCellSpacing * 2),
              Text(' = ',
                  style: TextStyle(
                      fontSize: screenWidth < smallScreenBreakpoint
                          ? matrixBracketSizeSmall
                          : matrixBracketSize,
                      fontWeight: FontWeight.bold)),
              // Display current input
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[400]!, width: 2),
                ),
                child: Text(
                  currentInput.isEmpty ? '?' : currentInput,
                  style: TextStyle(
                    fontSize: answerFontSize,
                    fontWeight: FontWeight.bold,
                    color: currentInput.isEmpty ? Colors.grey : Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  dynamic get question => _matrix;

  @override
  dynamic get correctAnswer => _correctAnswer;
}
