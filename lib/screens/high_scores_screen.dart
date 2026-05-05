import 'package:flutter/material.dart';
import '../models/game_type.dart';
import '../models/high_score.dart';
import '../services/high_score_service.dart';

class HighScoresScreen extends StatefulWidget {
  const HighScoresScreen({super.key});

  @override
  State<HighScoresScreen> createState() => _HighScoresScreenState();
}

class _HighScoresScreenState extends State<HighScoresScreen> {
  final _service = HighScoreService();
  Map<String, List<HighScore>> _highScores = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHighScores();
  }

  Future<void> _loadHighScores() async {
    final scores = <String, List<HighScore>>{};
    for (final gameType in GameType.values) {
      final gameScores = await _service.getHighScores(gameType.name);
      if (gameScores.isNotEmpty) {
        scores[gameType.name] = gameScores;
      }
    }
    setState(() {
      _highScores = scores;
      _isLoading = false;
    });
  }

  Future<void> _clearAllScores() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All High Scores?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Clear', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _service.clearAllHighScores();
      _loadHighScores();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('High Scores'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _clearAllScores,
            tooltip: 'Clear All Scores',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _highScores.isEmpty
              ? const Center(
                  child: Text(
                    'No high scores yet!\nPlay Speed Mode to set records.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: GameType.values.length,
                  itemBuilder: (context, index) {
                    final gameType = GameType.values[index];
                    final scores = _highScores[gameType.name] ?? [];
                    if (scores.isEmpty) return const SizedBox.shrink();
                    return _buildGameScoreSection(gameType, scores);
                  },
                ),
    );
  }

  Widget _buildGameScoreSection(GameType gameType, List<HighScore> scores) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              gameType.name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            scores.isEmpty
                ? const Text('No scores yet', style: TextStyle(color: Colors.grey))
                : Table(
                    columnWidths: const {
                      0: FixedColumnWidth(40),
                      1: FlexColumnWidth(2),
                      2: FlexColumnWidth(1),
                      3: FlexColumnWidth(1.5),
                    },
                    children: [
                      const TableRow(
                        decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: Colors.grey)),
                        ),
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Text('#', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Text('Name', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Text('Score', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Text('Time', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                      ...scores.asMap().entries.map((entry) {
                        final index = entry.key;
                        final score = entry.value;
                        return TableRow(
                          decoration: BoxDecoration(
                            color: index.isOdd ? Colors.grey[50] : null,
                          ),
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Text('${index + 1}'),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Text(score.name),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Text('${score.score}'),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Text(_formatTime(score.timeInSeconds)),
                            ),
                          ],
                        );
                      }),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  String _formatTime(int seconds) {
    final mins = seconds ~/ 60;
    final secs = seconds % 60;
    return '${mins}:${secs.toString().padLeft(2, '0')}';
  }
}