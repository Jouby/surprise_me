import '../../domain/entities/surprise_element.dart';

class SurpriseElementModel extends SurpriseElement {
  const SurpriseElementModel({
    required super.id,
    required super.type,
    required super.label,
    required super.content,
    required super.unlockCode,
  });

  factory SurpriseElementModel.fromJson(Map<String, dynamic> json) =>
      SurpriseElementModel(
        id: json['id'] as String,
        type: _parseType(json['type'] as String),
        label: json['label'] as String,
        content: json['content'] as String,
        unlockCode: json['unlock_code'] as String,
      );

  static ElementType _parseType(String type) {
    switch (type) {
      case 'image':
        return ElementType.image;
      case 'date':
        return ElementType.date;
      case 'location':
        return ElementType.location;
      case 'word_game':
        return ElementType.wordGame;
      case 'puzzle':
        return ElementType.puzzle;
      case 'motus_game':
        return ElementType.motusGame;
      default:
        return ElementType.text;
    }
  }
}
