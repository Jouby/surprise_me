import '../entities/element_draft.dart';
import '../entities/surprise_element.dart';
import '../repositories/i_surprise_repository.dart';

class UpdateSurpriseParams {
  final String surpriseId;
  final String emoji;
  final String title;
  final String subtitle;
  final String color;
  final List<SurpriseElement> originalElements;
  final List<ElementDraft> updatedElements;

  const UpdateSurpriseParams({
    required this.surpriseId,
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.originalElements,
    required this.updatedElements,
  });
}

class UpdateSurpriseUseCase {
  final ISurpriseRepository _repository;
  const UpdateSurpriseUseCase(this._repository);

  Future<void> call(UpdateSurpriseParams params) async {
    final token = await _repository.getCreatorToken(params.surpriseId);
    if (token == null)
      throw Exception('creator_token introuvable pour cette surprise.');

    // 1. Mise à jour de l'identité
    await _repository.updateSurprise(
      id: params.surpriseId,
      creatorToken: token,
      emoji: params.emoji,
      title: params.title,
      subtitle: params.subtitle,
      color: params.color,
    );

    // 2. Diff : IDs originaux vs IDs encore présents
    final originalIds = params.originalElements.map((e) => e.id).toSet();
    final currentIds = params.updatedElements
        .where((e) => !e.isNew)
        .map((e) => e.id!)
        .toSet();

    // 3. Supprimer les éléments retirés
    for (final id in originalIds.difference(currentIds)) {
      await _repository.deleteElement(id: id, creatorToken: token);
    }

    // 4. Mettre à jour ou créer chaque élément
    for (var i = 0; i < params.updatedElements.length; i++) {
      final draft = params.updatedElements[i];
      if (draft.isNew) {
        await _repository.addElement(
          surpriseId: params.surpriseId,
          creatorToken: token,
          type: draft.type.dbName,
          label: draft.label,
          content: draft.content,
          unlockCode: draft.unlockCode,
          sortOrder: i,
        );
      } else {
        await _repository.updateElement(
          id: draft.id!,
          creatorToken: token,
          type: draft.type.dbName,
          label: draft.label,
          content: draft.content,
          unlockCode: draft.unlockCode,
        );
      }
    }
  }
}
