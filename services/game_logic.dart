import 'dart:math';
import '../models/game_state.dart';

class GameLogic {
  static final Random _random = Random();
  
  static GameState startNewGame() {
    final firstColor = _random.nextInt(4);
    return GameState(
      sequence: [firstColor],
      currentLevel: 1,
      score: 0,
      isGameOver: false,
      isShowingSequence: true,
    );
  }

  static GameState nextLevel(GameState currentState) {
    final newColor = _random.nextInt(4);
    final newSequence = [...currentState.sequence, newColor];
    
    return currentState.copyWith(
      sequence: newSequence,
      currentLevel: currentState.currentLevel + 1,
      score: currentState.score + 10,
      isShowingSequence: true,
    );
  }

  static bool validateInput(List<int> userSequence, List<int> gameSequence) {
    if (userSequence.length > gameSequence.length) return false;
    
    for (int i = 0; i < userSequence.length; i++) {
      if (userSequence[i] != gameSequence[i]) return false;
    }
    return true;
  }

  static GameState gameOver(GameState currentState) {
    return currentState.copyWith(isGameOver: true);
  }
}