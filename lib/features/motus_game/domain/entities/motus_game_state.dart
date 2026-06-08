/// Résultat d'une case dans une tentative Motus.
enum TileResult {
  /// Bonne lettre, bonne position.
  correct,

  /// Bonne lettre, mauvaise position.
  present,

  /// Lettre absente du mot.
  absent,
}

/// Une tentative soumise avec ses résultats.
class MotusGuess {
  final String letters;
  final List<TileResult> results;

  const MotusGuess({required this.letters, required this.results});
}

/// État immutable d'une partie de Motus.
///
/// [word]         – le mot à trouver (majuscules, lettres A-Z uniquement).
/// [guesses]      – tentatives soumises avec leurs résultats.
/// [currentInput] – saisie en cours (commence toujours par la 1re lettre du mot).
class MotusGameState {
  static const int maxAttempts = 6;

  final String word;
  final List<MotusGuess> guesses;
  final String currentInput;

  const MotusGameState._({
    required this.word,
    required this.guesses,
    required this.currentInput,
  });

  factory MotusGameState.initial(String word) {
    final upper = word.toUpperCase().replaceAll(RegExp(r'[^A-Z]'), '');
    return MotusGameState._(
      word: upper,
      guesses: [],
      currentInput: upper.isNotEmpty ? upper[0] : '',
    );
  }

  int get wordLength => word.length;
  bool get isWon => guesses.isNotEmpty && guesses.last.letters == word;
  bool get isLost => !isWon && guesses.length >= maxAttempts;
  bool get isOver => isWon || isLost;

  /// Ajoute une lettre à la saisie en cours (ignorée si la partie est terminée
  /// ou si le mot est déjà complet).
  MotusGameState addLetter(String letter) {
    if (isOver || currentInput.length >= wordLength) return this;
    return MotusGameState._(
      word: word,
      guesses: guesses,
      currentInput: currentInput + letter.toUpperCase(),
    );
  }

  /// Supprime la dernière lettre saisie. La 1re lettre (toujours révélée)
  /// ne peut pas être effacée.
  MotusGameState removeLetter() {
    if (isOver || currentInput.length <= 1) return this;
    return MotusGameState._(
      word: word,
      guesses: guesses,
      currentInput: currentInput.substring(0, currentInput.length - 1),
    );
  }

  /// Soumet la tentative courante. Ignorée si le mot n'est pas complet.
  MotusGameState submitGuess() {
    if (isOver || currentInput.length != wordLength) return this;
    final results = _evaluate(currentInput);
    final guess = MotusGuess(letters: currentInput, results: results);
    return MotusGameState._(
      word: word,
      guesses: [...guesses, guess],
      currentInput: word[0],
    );
  }

  /// Résultats lettre par lettre pour [guess] (algorithme standard Wordle).
  List<TileResult> _evaluate(String guess) {
    final results = List.filled(wordLength, TileResult.absent);
    final wordChars = word.split('');
    final guessChars = guess.split('');

    // 1er passage : positions correctes.
    for (int i = 0; i < wordLength; i++) {
      if (guessChars[i] == wordChars[i]) {
        results[i] = TileResult.correct;
        wordChars[i] = '';
        guessChars[i] = '';
      }
    }

    // 2e passage : lettres présentes à la mauvaise position.
    for (int i = 0; i < wordLength; i++) {
      if (guessChars[i].isEmpty) continue;
      final idx = wordChars.indexOf(guessChars[i]);
      if (idx != -1) {
        results[i] = TileResult.present;
        wordChars[idx] = '';
      }
    }

    return results;
  }

  /// Meilleur résultat connu pour chaque lettre (utilisé pour colorier le
  /// clavier).
  Map<String, TileResult> get usedLetters {
    const order = [TileResult.correct, TileResult.present, TileResult.absent];
    final map = <String, TileResult>{};
    for (final guess in guesses) {
      for (int i = 0; i < guess.letters.length; i++) {
        final letter = guess.letters[i];
        final result = guess.results[i];
        final current = map[letter];
        if (current == null || order.indexOf(result) < order.indexOf(current)) {
          map[letter] = result;
        }
      }
    }
    return map;
  }
}
