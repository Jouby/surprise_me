import 'dart:math';

/// State for a sliding-tile puzzle (taquin).
///
/// The grid is [gridSize]×[gridSize]. Tiles are numbered 0 … n-2,
/// and [blankTile] (= n-1) represents the empty slot.
/// [tiles[i]] = which tile is at position i.
/// Solved when tiles == [0, 1, 2, …, n-1].
class PuzzleGameState {
  static const int gridSize = 3;
  static const int blankTile = gridSize * gridSize - 1;

  final List<int> tiles;

  const PuzzleGameState._(this.tiles);

  factory PuzzleGameState.initial() {
    final solved = List<int>.generate(gridSize * gridSize, (i) => i);
    return PuzzleGameState._(solved)._shuffle();
  }

  bool get isSolved {
    for (int i = 0; i < tiles.length; i++) {
      if (tiles[i] != i) return false;
    }
    return true;
  }

  int get blankIndex => tiles.indexOf(blankTile);

  /// Returns true if the tile at [pos] can slide into the blank.
  bool canSlide(int pos) {
    final blank = blankIndex;
    final dr = (pos ~/ gridSize) - (blank ~/ gridSize);
    final dc = (pos % gridSize) - (blank % gridSize);
    return (dr.abs() + dc.abs()) == 1;
  }

  /// Slides the tile at [pos] into the blank. No-op if not adjacent.
  PuzzleGameState slide(int pos) {
    if (!canSlide(pos)) return this;
    final next = List<int>.from(tiles);
    final blank = blankIndex;
    next[blank] = next[pos];
    next[pos] = blankTile;
    return PuzzleGameState._(next);
  }

  PuzzleGameState reset() => PuzzleGameState.initial();

  // ── Shuffle via random valid moves (guarantees solvability) ───────────────

  PuzzleGameState _shuffle() {
    final rng = Random();
    PuzzleGameState state = this;
    int lastBlank = -1;
    for (int i = 0; i < 200; i++) {
      final blank = state.blankIndex;
      final neighbors = _neighbors(blank)
          .where((n) => n != lastBlank)
          .toList();
      final pick = neighbors[rng.nextInt(neighbors.length)];
      lastBlank = blank;
      state = state.slide(pick);
    }
    // Edge case: if accidentally solved, shuffle once more.
    return state.isSolved ? state._shuffle() : state;
  }

  static List<int> _neighbors(int pos) {
    final r = pos ~/ gridSize;
    final c = pos % gridSize;
    return [
      if (r > 0) pos - gridSize,
      if (r < gridSize - 1) pos + gridSize,
      if (c > 0) pos - 1,
      if (c < gridSize - 1) pos + 1,
    ];
  }
}
