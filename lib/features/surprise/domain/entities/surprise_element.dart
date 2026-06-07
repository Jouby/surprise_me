enum ElementType { text, image, date, location, wordGame, puzzle }

extension ElementTypeX on ElementType {
  /// Serialized name used in the database (snake_case).
  String get dbName {
    switch (this) {
      case ElementType.wordGame:
        return 'word_game';
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

  const SurpriseElement({
    required this.id,
    required this.type,
    required this.unlockCode,
    required this.content,
    required this.label,
  });
}
