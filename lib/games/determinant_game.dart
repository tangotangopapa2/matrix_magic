import 'dart:math';
import 'package:flutter/material.dart';
import 'game_interface.dart';
import '../models/game_type.dart';
import '../models/matrix2x2.dart';

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
      topLeft: random.nextInt(21) - 10,
      topRight: random.nextInt(21) - 10,
      bottomLeft: random.nextInt(21) - 10,
      bottomRight: random.nextInt(21) - 10,
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
    final bracketSize = screenWidth < 350 ? 28.0 : 36.0;
    final cellWidth = screenWidth < 350 ? 40.0 : 50.0;
    final cellPadding = screenWidth < 350 ? 6.0 : 8.0;
    final fontSize = screenWidth < 350 ? 16.0 : 20.0;
    final cellSpacing = screenWidth < 350 ? 4.0 : 8.0;
    final rowSpacing = screenWidth < 350 ? 2.0 : 4.0;
    final answerFontSize = screenWidth < 350 ? 24.0 : 32.0;

    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Left determinant bar
              Text('|',
                  style: TextStyle(fontSize: bracketSize + 8, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
              SizedBox(width: cellSpacing / 2),
              Container(
                padding: EdgeInsets.symmetric(horizontal: cellPadding, vertical: cellPadding),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!, width: 2),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildCell(_matrix.topLeft, cellWidth, fontSize),
                            SizedBox(width: cellSpacing),
                            _buildCell(_matrix.topRight, cellWidth, fontSize),
                          ],
                        ),
                        SizedBox(height: rowSpacing),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildCell(_matrix.bottomLeft, cellWidth, fontSize),
                            SizedBox(width: cellSpacing),
                            _buildCell(_matrix.bottomRight, cellWidth, fontSize),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: cellSpacing / 2),
              // Right determinant bar
              Text('|',
                  style: TextStyle(fontSize: bracketSize + 8, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
              SizedBox(width: cellSpacing * 2),
              Text(' = ', style: TextStyle(fontSize: bracketSize, fontWeight: FontWeight.bold)),
              // Display current input
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
  dynamic get question => _matrix;

  @override
  dynamic get correctAnswer => _correctAnswer;
}