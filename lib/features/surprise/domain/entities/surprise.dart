import 'surprise_element.dart';

class Surprise {
  final String id;
  final String emoji;
  final String title;
  final String subtitle;
  final String shareCode;
  final List<SurpriseElement> elements;
  /// Couleur thème au format hex (#RRGGBB). Par défaut : bleu de l'app.
  final String color;

  const Surprise({
    required this.id,
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.shareCode,
    required this.elements,
    this.color = '#2E6DA4',
  });
}
