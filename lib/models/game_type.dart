enum GameType {
  addNumbers('Add Two Numbers', 'Add two numbers together'),
  addMatrices('Add 2x2 Matrices', 'Add two 2x2 matrices together'),
  determinant('Determinant', 'Calculate the determinant of a 2x2 matrix');

  final String name;
  final String description;

  const GameType(this.name, this.description);
}
