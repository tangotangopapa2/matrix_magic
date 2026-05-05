import 'package:flutter/material.dart';
import '../models/matrix2x2.dart';
import '../utils/constants.dart';

/// A reusable widget to display a 2x2 matrix with consistent styling
class MatrixDisplay extends StatelessWidget {
  final Matrix2x2 matrix;
  final double? bracketSize;
  final double? cellWidth;
  final double? cellPadding;
  final double? fontSize;
  final double? cellSpacing;
  final double? rowSpacing;
  final bool showDeterminantBars;

  const MatrixDisplay({
    super.key,
    required this.matrix,
    this.bracketSize,
    this.cellWidth,
    this.cellPadding,
    this.fontSize,
    this.cellSpacing,
    this.rowSpacing,
    this.showDeterminantBars = false,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bp = bracketSize ??
        (screenWidth < smallScreenBreakpoint
            ? matrixBracketSizeSmall
            : matrixBracketSize);
    final cw = cellWidth ??
        (screenWidth < smallScreenBreakpoint
            ? matrixCellWidthSmall
            : matrixCellWidth);
    final cp = cellPadding ??
        (screenWidth < smallScreenBreakpoint
            ? matrixCellPaddingSmall
            : matrixCellPadding);
    final fs = fontSize ??
        (screenWidth < smallScreenBreakpoint
            ? matrixFontSizeSmall
            : matrixFontSize);
    final cs = cellSpacing ??
        (screenWidth < smallScreenBreakpoint
            ? matrixCellSpacingSmall
            : matrixCellSpacing);
    final rs = rowSpacing ??
        (screenWidth < smallScreenBreakpoint
            ? matrixRowSpacingSmall
            : matrixRowSpacing);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (showDeterminantBars) ...[
          Text('|',
              style: TextStyle(
                  fontSize: bp + 8,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple)),
          SizedBox(width: cs / 2),
        ] else ...[
          Text('[',
              style: TextStyle(
                  fontSize: bp,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple)),
          SizedBox(width: cs),
        ],
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildCell(matrix.topLeft, cw, fs),
                SizedBox(width: cs),
                _buildCell(matrix.topRight, cw, fs),
              ],
            ),
            SizedBox(height: rs),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildCell(matrix.bottomLeft, cw, fs),
                SizedBox(width: cs),
                _buildCell(matrix.bottomRight, cw, fs),
              ],
            ),
          ],
        ),
        if (showDeterminantBars) ...[
          SizedBox(width: cs / 2),
          Text('|',
              style: TextStyle(
                  fontSize: bp + 8,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple)),
        ] else ...[
          SizedBox(width: cs),
          Text(']',
              style: TextStyle(
                  fontSize: bp,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple)),
        ],
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
}