import 'surprise_element.dart';

class ElementDraft {
  final String? id;
  final ElementType type;
  final String label;
  final String content;
  final String unlockCode;
  final String solveCode;

  const ElementDraft({
    this.id,
    required this.type,
    required this.label,
    required this.content,
    required this.unlockCode,
    this.solveCode = '',
  });

  factory ElementDraft.fromElement(SurpriseElement e) => ElementDraft(
    id: e.id,
    type: e.type,
    label: e.label,
    content: e.content,
    unlockCode: e.unlockCode,
    solveCode: e.solveCode,
  );

  ElementDraft copyWith({
    String? id,
    ElementType? type,
    String? label,
    String? content,
    String? unlockCode,
    String? solveCode,
  }) => ElementDraft(
    id: id ?? this.id,
    type: type ?? this.type,
    label: label ?? this.label,
    content: content ?? this.content,
    unlockCode: unlockCode ?? this.unlockCode,
    solveCode: solveCode ?? this.solveCode,
  );

  bool get isNew => id == null;

  bool get isValid =>
      label.trim().isNotEmpty &&
      content.trim().isNotEmpty &&
      unlockCode.trim().isNotEmpty;

  Map<String, dynamic> toMap() => {
    'type': type.dbName,
    'label': label.trim(),
    'content': content.trim(),
    'unlock_code': unlockCode.trim().toUpperCase(),
    'solve_code': solveCode.trim().toUpperCase(),
  };
}
