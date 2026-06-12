import 'package:pocketbase/pocketbase.dart';

import '../../domain/entities/surprise_element.dart';

class SurpriseElementModel extends SurpriseElement {
  const SurpriseElementModel({
    required super.id,
    required super.type,
    required super.label,
    required super.content,
    required super.unlockCode,
  });

  factory SurpriseElementModel.fromRecord(RecordModel record) =>
      SurpriseElementModel(
        id: record.id,
        type: _parseType(record.getStringValue('type')),
        label: record.getStringValue('label'),
        content: record.getStringValue('content'),
        unlockCode: record.getStringValue('unlock_code'),
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
      case 'scratch_game':
        return ElementType.scratchGame;
      case 'code_game':
        return ElementType.codeGame;
      default:
        return ElementType.text;
    }
  }
}
