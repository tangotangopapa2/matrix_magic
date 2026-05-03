import 'package:flutter/material.dart';

class NumberInput extends StatelessWidget {
  final String currentInput;
  final bool hasFocus;

  const NumberInput({
    super.key,
    required this.currentInput,
    this.hasFocus = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        border: Border.all(
          color: hasFocus ? Colors.deepPurple : Colors.grey,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        currentInput.isEmpty ? '0' : currentInput,
        style: const TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}