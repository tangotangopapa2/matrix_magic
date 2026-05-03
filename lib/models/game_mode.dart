enum GameMode {
  accuracy('Accuracy Mode', '10 questions. How many can you get right?'),
  speed('Speed Mode', '2 minutes. How many can you solve?');

  final String name;
  final String description;

  const GameMode(this.name, this.description);
}