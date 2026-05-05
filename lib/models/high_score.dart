class HighScore {
  final String name;
  final int score;
  final int timeInSeconds;
  final String gameType;

  HighScore({
    required this.name,
    required this.score,
    required this.timeInSeconds,
    required this.gameType,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'score': score,
      'timeInSeconds': timeInSeconds,
      'gameType': gameType,
    };
  }

  factory HighScore.fromJson(Map<String, dynamic> json) {
    return HighScore(
      name: json['name'] ?? '-',
      score: json['score'] ?? 0,
      timeInSeconds: json['timeInSeconds'] ?? 0,
      gameType: json['gameType'] ?? '',
    );
  }
}