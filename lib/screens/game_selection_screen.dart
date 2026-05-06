import 'package:flutter/material.dart';
import '../models/game_type.dart';
import '../models/game_mode.dart';
import 'game_screen.dart';

class GameSelectionScreen extends StatelessWidget {
  const GameSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Game'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: GameType.values.length,
        itemBuilder: (context, index) {
          final gameType = GameType.values[index];
          return _buildGameCard(context, gameType);
        },
      ),
    );
  }

  Widget _buildGameCard(BuildContext context, GameType gameType) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    gameType.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.info_outline, color: Colors.blue),
                  onPressed: () => _showGameInfo(context, gameType),
                  tooltip: 'How to play',
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              gameType.description,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildModeButton(
                    context,
                    'Accuracy Mode',
                    '10 questions',
                    GameMode.accuracy,
                    gameType,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildModeButton(
                    context,
                    'Speed Mode',
                    '30 seconds',
                    GameMode.speed,
                    gameType,
                    Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showGameInfo(BuildContext context, GameType gameType) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.info, color: Colors.blue),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                gameType.name,
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: _buildFormattedInstructions(gameType.instructions),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Got it!'),
          ),
        ],
      ),
    );
  }

  Widget _buildFormattedInstructions(String instructions) {
    // Convert LaTeX-like notation to formatted text
    String formatted = instructions.replaceAllMapped(
      RegExp(r'\$([^$]+)\$'),
      (match) => _formatMath(match.group(1)!),
    );

    return Text(
      formatted,
      style: const TextStyle(fontSize: 14, height: 1.5),
    );
  }

  String _formatMath(String latex) {
    String result = latex;

    // Format matrices in a clear visual format
    result = result.replaceAllMapped(
      RegExp(r'\\begin\{pmatrix\}(.*?)\\end\{pmatrix\}', dotAll: true),
      (match) {
        final content = match.group(1)!;
        final rows = content.split(r'\\').map((r) => r.trim()).where((r) => r.isNotEmpty).toList();
        final matrixLines = rows.map((row) {
          final elements = row.split('&').map((e) => e.trim()).toList();
          return '│ ${elements.join('  ')} │';
        }).join('\n');
        return '\n┌─────────────┐\n$matrixLines\n└─────────────┘\n';
      },
    );

    // Replace LaTeX commands with readable text
    result = result.replaceAll(r'\times', ' × ');
    result = result.replaceAll(r'\det', 'det');
    result = result.replaceAll('^2', '²');
    result = result.replaceAll(r'\begin{pmatrix}', '');
    result = result.replaceAll(r'\end{pmatrix}', '');
    result = result.replaceAll(r'\\', '\n');
    result = result.replaceAll('&', '  ');
    result = result.replaceAll(r'\left(', '(');
    result = result.replaceAll(r'\right)', ')');

    return result;
  }

  Widget _buildModeButton(
    BuildContext context,
    String title,
    String subtitle,
    GameMode mode,
    GameType gameType,
    Color color,
  ) {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => GameScreen(
              gameType: gameType,
              gameMode: mode,
            ),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}