import 'package:pocketbase/pocketbase.dart';

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

  factory SurpriseModel.fromRecord(RecordModel record) {
    final rawElements =
        record.get<List<RecordModel>>('expand.surprise_elements_via_surprise')
          ..sort(
            (a, b) => a
                .getIntValue('sort_order')
                .compareTo(b.getIntValue('sort_order')),
          );

    return SurpriseModel(
      id: record.id,
      emoji: record.getStringValue('emoji'),
      title: record.getStringValue('title'),
      subtitle: record.getStringValue('subtitle'),
      shareCode: record.getStringValue('share_code'),
      color: record.getStringValue('color').isNotEmpty
          ? record.getStringValue('color')
          : '#2E6DA4',
      elements: rawElements
          .map((e) => SurpriseElementModel.fromRecord(e))
          .toList(),
    );
  }
}
