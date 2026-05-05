import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/high_score.dart';
import '../utils/constants.dart';

class HighScoreService {
  static const String _keyPrefix = 'high_scores_';
  static const int maxScores = maxHighScores;

  Future<List<HighScore>> getHighScores(String gameType) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _keyPrefix + gameType;
    final scoresJson = prefs.getStringList(key) ?? [];
    
    final scores = scoresJson
        .map((json) => HighScore.fromJson(jsonDecode(json)))
        .toList();
    scores.sort((a, b) => b.score.compareTo(a.score));
    return scores;
  }

  Future<bool> isHighScore(String gameType, int score) async {
    final scores = await getHighScores(gameType);
    if (scores.length < maxScores) return true;
    return score > scores.last.score;
  }

  Future<void> saveHighScore(String gameType, HighScore highScore) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _keyPrefix + gameType;
    final scores = await getHighScores(gameType);
    
    scores.add(highScore);
    scores.sort((a, b) => b.score.compareTo(a.score));
    
    if (scores.length > maxScores) {
      scores.removeRange(maxScores, scores.length);
    }
    
    final scoresJson = scores
        .map((score) => jsonEncode(score.toJson()))
        .toList();
    
    await prefs.setStringList(key, scoresJson);
  }

  Future<void> clearAllHighScores() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys().where((key) => key.startsWith(_keyPrefix));
    for (final key in keys) {
      await prefs.remove(key);
    }
  }
}