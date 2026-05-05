import 'dart:math';
import 'package:flutter/material.dart';
import 'game_interface.dart';
import '../models/game_type.dart';
import '../models/matrix2x2.dart';
import '../utils/constants.dart';
import '../widgets/matrix_display.dart';

class AddMatricesGame implements MathGame {
  late Matrix2x2 _matrix1;
  late Matrix2x2 _matrix2;
  late Matrix2x2 _correctAnswer;

  @override
  GameType get type => GameType.addMatrices;

  @override
  String get name => type.name;

  @override
  String get description => type.description;

  @override
  void generateQuestion() {
    final random = Random();
    _matrix1 = _generateRandomMatrix(random);
    _matrix2 = _generateRandomMatrix(random);
    _correctAnswer = _matrix1 + _matrix2;
  }

  Matrix2x2 _generateRandomMatrix(Random random) {
    return Matrix2x2(
      topLeft: random.nextInt(matrixRandomRange) - matrixValueOffset,
      topRight: random.nextInt(matrixRandomRange) - matrixValueOffset,
      bottomLeft: random.nextInt(matrixRandomRange) - matrixValueOffset,
      bottomRight: random.nextInt(matrixRandomRange) - matrixValueOffset,
    );
  }

  @override
  bool checkAnswer(dynamic userAnswer) {
    if (userAnswer is Matrix2x2) {
      return userAnswer == _correctAnswer;
    }
    if (userAnswer is List<int> && userAnswer.length == 4) {
      return Matrix2x2(
            topLeft: userAnswer[0],
            topRight: userAnswer[1],
            bottomLeft: userAnswer[2],
            bottomRight: userAnswer[3],
          ) ==
          _correctAnswer;
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
    final matrixSpacing = screenWidth < smallScreenBreakpoint
        ? matrixCellSpacingSmall
        : matrixCellSpacing;
    final operatorSize = screenWidth < smallScreenBreakpoint
        ? 20.0
        : 32.0;

    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MatrixDisplay(matrix: _matrix1),
              SizedBox(width: matrixSpacing),
              Text(' + ',
                  style: TextStyle(
                      fontSize: operatorSize, fontWeight: FontWeight.bold)),
              SizedBox(width: matrixSpacing),
              MatrixDisplay(matrix: _matrix2),
              SizedBox(width: matrixSpacing),
              Text(' = ?',
                  style: TextStyle(
                      fontSize: operatorSize, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ],
    );
  }

  @override
  dynamic get question => [_matrix1, _matrix2];

  @override
  dynamic get correctAnswer => _correctAnswer;
}
