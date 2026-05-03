import 'dart:math';
import 'package:flutter/material.dart';
import 'game_interface.dart';
import '../models/game_type.dart';
import '../models/matrix2x2.dart';

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
    _matrix1 = Matrix2x2(
      topLeft: random.nextInt(21) - 10,
      topRight: random.nextInt(21) - 10,
      bottomLeft: random.nextInt(21) - 10,
      bottomRight: random.nextInt(21) - 10,
    );
    _matrix2 = Matrix2x2(
      topLeft: random.nextInt(21) - 10,
      topRight: random.nextInt(21) - 10,
      bottomLeft: random.nextInt(21) - 10,
      bottomRight: random.nextInt(21) - 10,
    );
    _correctAnswer = _matrix1 + _matrix2;
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
    final matrixSpacing = screenWidth < 350 ? 4.0 : 8.0;
    final operatorSize = screenWidth < 350 ? 20.0 : 32.0;
    
    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildMatrixDisplay(_matrix1, screenWidth),
              SizedBox(width: matrixSpacing),
              Text(' + ', style: TextStyle(fontSize: operatorSize, fontWeight: FontWeight.bold)),
              SizedBox(width: matrixSpacing),
              _buildMatrixDisplay(_matrix2, screenWidth),
              SizedBox(width: matrixSpacing),
              Text(' = ?', style: TextStyle(fontSize: operatorSize, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMatrixDisplay(Matrix2x2 matrix, double screenWidth) {
    final bracketSize = screenWidth < 350 ? 28.0 : 36.0;
    final cellWidth = screenWidth < 350 ? 40.0 : 50.0;
    final cellPadding = screenWidth < 350 ? 6.0 : 8.0;
    final fontSize = screenWidth < 350 ? 16.0 : 20.0;
    final cellSpacing = screenWidth < 350 ? 4.0 : 8.0;
    final rowSpacing = screenWidth < 350 ? 2.0 : 4.0;
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: cellPadding, vertical: cellPadding),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!, width: 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('[',
              style: TextStyle(fontSize: bracketSize, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
          SizedBox(width: cellSpacing),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildCell(matrix.topLeft, cellWidth, fontSize),
                  SizedBox(width: cellSpacing),
                  _buildCell(matrix.topRight, cellWidth, fontSize),
                ],
              ),
              SizedBox(height: rowSpacing),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildCell(matrix.bottomLeft, cellWidth, fontSize),
                  SizedBox(width: cellSpacing),
                  _buildCell(matrix.bottomRight, cellWidth, fontSize),
                ],
              ),
            ],
          ),
          SizedBox(width: cellSpacing),
          Text(']',
              style: TextStyle(fontSize: bracketSize, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
        ],
      ),
    );
  }

  Widget _buildCell(int value, double width, double fontSize) {
    return Container(
      width: width,
      padding: EdgeInsets.symmetric(vertical: fontSize * 0.4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey[400]!),
      ),
      child: Center(
        child: Text('$value',
            style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold)),
      ),
    );
  }

  @override
  dynamic get question => [_matrix1, _matrix2];

  @override
  dynamic get correctAnswer => _correctAnswer;
}