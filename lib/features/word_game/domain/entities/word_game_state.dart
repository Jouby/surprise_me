import 'dart:math';

/// Tracks the mutable state of a word-guessing drag-and-drop game.
///
/// [word]     – the target word (uppercase, letters only).
/// [slots]    – current letter placed in each position (null = empty).
/// [pool]     – letters still available to drag (keyed by pool index).
class WordGameState {
  final String word;
  final List<String?> slots;
  final List<String?> pool; // null = already placed

  WordGameState._({
    required this.word,
    required this.slots,
    required this.pool,
  });

  factory WordGameState.initial(String word) {
    final upper = word.toUpperCase().replaceAll(RegExp(r'[^A-Z]'), '');
    final letters = upper.split('');
    final shuffled = List<String>.from(letters)..shuffle(Random());
    return WordGameState._(
      word: upper,
      slots: List.filled(upper.length, null),
      pool: shuffled,
    );
  }

  bool get isSolved =>
      slots.every((s) => s != null) &&
      List.generate(word.length, (i) => slots[i] == word[i]).every((v) => v);

  /// Places [poolIndex] letter into [slotIndex].
  /// If the slot is already occupied, swaps back the occupant to the pool.
  WordGameState place(int poolIndex, int slotIndex) {
    if (pool[poolIndex] == null) return this;

    final newPool = List<String?>.from(pool);
    final newSlots = List<String?>.from(slots);

    // If slot already has a letter, return it to the first free pool spot.
    if (newSlots[slotIndex] != null) {
      final freePool = newPool.indexWhere((e) => e == null);
      if (freePool != -1) {
        newPool[freePool] = newSlots[slotIndex];
      }
    }

    newSlots[slotIndex] = newPool[poolIndex];
    newPool[poolIndex] = null;

    return WordGameState._(word: word, slots: newSlots, pool: newPool);
  }

  /// Removes the letter from [slotIndex] and returns it to the pool.
  WordGameState recall(int slotIndex) {
    if (slots[slotIndex] == null) return this;

    final newPool = List<String?>.from(pool);
    final newSlots = List<String?>.from(slots);

    final freePool = newPool.indexWhere((e) => e == null);
    if (freePool != -1) {
      newPool[freePool] = newSlots[slotIndex];
    }
    newSlots[slotIndex] = null;

    return WordGameState._(word: word, slots: newSlots, pool: newPool);
  }

  WordGameState reset() => WordGameState.initial(word);
}
