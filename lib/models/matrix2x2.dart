class Matrix2x2 {
  final int topLeft;
  final int topRight;
  final int bottomLeft;
  final int bottomRight;

  const Matrix2x2({
    required this.topLeft,
    required this.topRight,
    required this.bottomLeft,
    required this.bottomRight,
  });

  Matrix2x2 operator +(Matrix2x2 other) {
    return Matrix2x2(
      topLeft: topLeft + other.topLeft,
      topRight: topRight + other.topRight,
      bottomLeft: bottomLeft + other.bottomLeft,
      bottomRight: bottomRight + other.bottomRight,
    );
  }

  List<int> toList() => [topLeft, topRight, bottomLeft, bottomRight];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Matrix2x2 &&
          topLeft == other.topLeft &&
          topRight == other.topRight &&
          bottomLeft == other.bottomLeft &&
          bottomRight == other.bottomRight;

  @override
  int get hashCode => Object.hash(topLeft, topRight, bottomLeft, bottomRight);

  @override
  String toString() {
    return '[$topLeft, $topRight]\n[$bottomLeft, $bottomRight]';
  }
}