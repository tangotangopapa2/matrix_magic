import 'package:flutter/material.dart';

class MatrixInput extends StatelessWidget {
  final List<String> values;
  final int selectedPosition;
  final Function(int) onPositionSelected;

  const MatrixInput({
    super.key,
    required this.values,
    required this.selectedPosition,
    required this.onPositionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildMatrixRow([0, 1]),
        const SizedBox(height: 8),
        _buildMatrixRow([2, 3]),
      ],
    );
  }

  Widget _buildMatrixRow(List<int> positions) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: positions.map((pos) {
        return Expanded(
          child: GestureDetector(
            onTap: () => onPositionSelected(pos),
            child: Container(
              margin: const EdgeInsets.all(4),
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                border: Border.all(
                  color: selectedPosition == pos
                      ? Colors.deepPurple
                      : Colors.grey,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(8),
                color: selectedPosition == pos
                    ? Colors.deepPurple.withOpacity(0.1)
                    : null,
              ),
              child: Center(
                child: Text(
                  values[pos],
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
