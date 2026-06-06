enum ElementType { text, image, date, location }

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
