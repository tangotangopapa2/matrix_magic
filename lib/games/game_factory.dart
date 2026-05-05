import '../models/game_type.dart';
import 'game_interface.dart';
import 'add_numbers_game.dart';
import 'add_matrices_game.dart';
import 'determinant_game.dart';

class GameFactory {
  static MathGame createGame(GameType type) {
    switch (type) {
      case GameType.addNumbers:
        return AddNumbersGame();
      case GameType.addMatrices:
        return AddMatricesGame();
      case GameType.determinant:
        return DeterminantGame();
    }
  }
}
