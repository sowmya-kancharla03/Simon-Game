class GameState {
  final List<int> sequence;
  final int currentLevel;
  final int score;
  final bool isGameOver;
  final bool isShowingSequence;

  GameState({
    this.sequence = const [],
    this.currentLevel = 1,
    this.score = 0,
    this.isGameOver = false,
    this.isShowingSequence = false,
  });

  GameState copyWith({
    List<int>? sequence,
    int? currentLevel,
    int? score,
    bool? isGameOver,
    bool? isShowingSequence,
  }) {
    return GameState(
      sequence: sequence ?? this.sequence,
      currentLevel: currentLevel ?? this.currentLevel,
      score: score ?? this.score,
      isGameOver: isGameOver ?? this.isGameOver,
      isShowingSequence: isShowingSequence ?? this.isShowingSequence,
    );
  }
}