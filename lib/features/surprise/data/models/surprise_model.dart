import '../../domain/entities/surprise.dart';
import 'surprise_element_model.dart';

class SurpriseModel extends Surprise {
  const SurpriseModel({
    required super.id,
    required super.emoji,
    required super.title,
    required super.subtitle,
    required super.shareCode,
    required super.elements,
    super.color,
  });

  factory SurpriseModel.fromJson(Map<String, dynamic> json) {
    final rawElements = (json['surprise_elements'] as List? ?? [])
      ..sort((a, b) =>
          (a['sort_order'] as int).compareTo(b['sort_order'] as int));

    return SurpriseModel(
      id: json['id'] as String,
      emoji: json['emoji'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String? ?? '',
      shareCode: json['share_code'] as String,
      color: json['color'] as String? ?? '#2E6DA4',
      elements: rawElements
          .map((e) => SurpriseElementModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
