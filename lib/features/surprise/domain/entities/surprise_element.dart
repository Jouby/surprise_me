enum ElementType {
  text,
  image,
  date,
  location,
  wordGame,
  puzzle,
  motusGame,
  scratchGame,
  codeGame,
}

extension ElementTypeX on ElementType {
  bool get isGame => const {
    ElementType.wordGame,
    ElementType.motusGame,
    ElementType.scratchGame,
    ElementType.codeGame,
    ElementType.puzzle,
  }.contains(this);

  /// Serialized name used in the database (snake_case).
  String get dbName {
    switch (this) {
      case ElementType.wordGame:
        return 'word_game';
      case ElementType.motusGame:
        return 'motus_game';
      case ElementType.scratchGame:
        return 'scratch_game';
      case ElementType.codeGame:
        return 'code_game';
      default:
        return name;
    }
  }
}

class SurpriseElement {
  final String id;
  final ElementType type;
  final String unlockCode;
  final String content;
  final String label;
  /// Code auto-entré quand le jeu est résolu (vide si non défini).
  final String solveCode;

  const SurpriseElement({
    required this.id,
    required this.type,
    required this.unlockCode,
    required this.content,
    required this.label,
    this.solveCode = '',
  });
}
