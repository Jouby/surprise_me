/// Résultat d'un chiffre dans une tentative Code Secret.
enum PegResult {
  /// Bon chiffre, bonne position.
  correct,

  /// Bon chiffre, mauvaise position.
  present,

  /// Chiffre absent du code.
  absent,
}

/// Une tentative soumise avec ses résultats.
class CodeGuess {
  final String digits; // ex. "1234"
  final List<PegResult> results;

  const CodeGuess({required this.digits, required this.results});
}

/// État immutable d'une partie de Code Secret (Mastermind simplifié).
///
/// [code]         – le code à trouver (4 chiffres, ex. "4729").
/// [guesses]      – tentatives soumises avec leurs résultats.
/// [currentInput] – chiffres saisis en cours (max [codeLength]).
class CodeGameState {
  static const int codeLength = 4;
  static const int maxAttempts = 8;

  final String code;
  final List<CodeGuess> guesses;
  final String currentInput;

  const CodeGameState._({
    required this.code,
    required this.guesses,
    required this.currentInput,
  });

  factory CodeGameState.initial(String code) {
    final digits = code.replaceAll(RegExp(r'[^0-9]'), '');
    assert(
      digits.length == codeLength,
      'Le code doit contenir $codeLength chiffres',
    );
    return CodeGameState._(code: digits, guesses: [], currentInput: '');
  }

  bool get isWon => guesses.isNotEmpty && guesses.last.digits == code;
  bool get isLost => !isWon && guesses.length >= maxAttempts;
  bool get isOver => isWon || isLost;

  /// Ajoute un chiffre à la saisie en cours.
  CodeGameState addDigit(String digit) {
    if (isOver || currentInput.length >= codeLength) return this;
    return CodeGameState._(
      code: code,
      guesses: guesses,
      currentInput: currentInput + digit,
    );
  }

  /// Supprime le dernier chiffre saisi.
  CodeGameState removeDigit() {
    if (isOver || currentInput.isEmpty) return this;
    return CodeGameState._(
      code: code,
      guesses: guesses,
      currentInput: currentInput.substring(0, currentInput.length - 1),
    );
  }

  /// Soumet la tentative courante. Ignorée si la saisie est incomplète.
  CodeGameState submitGuess() {
    if (isOver || currentInput.length != codeLength) return this;
    final results = _evaluate(currentInput);
    final guess = CodeGuess(digits: currentInput, results: results);
    return CodeGameState._(
      code: code,
      guesses: [...guesses, guess],
      currentInput: '',
    );
  }

  /// Évaluation Mastermind standard : deux passes pour éviter le double-comptage.
  List<PegResult> _evaluate(String guess) {
    final results = List.filled(codeLength, PegResult.absent);
    final codeChars = code.split('');
    final guessChars = guess.split('');

    // 1re passe : positions correctes.
    for (int i = 0; i < codeLength; i++) {
      if (guessChars[i] == codeChars[i]) {
        results[i] = PegResult.correct;
        codeChars[i] = '';
        guessChars[i] = '';
      }
    }

    // 2e passe : bons chiffres, mauvaise position.
    for (int i = 0; i < codeLength; i++) {
      if (guessChars[i].isEmpty) continue;
      final idx = codeChars.indexOf(guessChars[i]);
      if (idx != -1) {
        results[i] = PegResult.present;
        codeChars[idx] = '';
      }
    }

    return results;
  }
}
