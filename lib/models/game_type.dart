enum GameType {
  addNumbers('Add Two Numbers', 'Add two numbers together'),
  addMatrices('Add 2x2 Matrices', 'Add two 2x2 matrices together');

  final String name;
  final String description;

  const GameType(this.name, this.description);
}