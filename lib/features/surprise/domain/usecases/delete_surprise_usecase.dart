import '../repositories/i_surprise_repository.dart';

class DeleteSurpriseUseCase {
  final ISurpriseRepository _repository;
  const DeleteSurpriseUseCase(this._repository);

  Future<void> call({
    required String surpriseId,
    required String shareCode,
    required bool isOwner,
  }) async {
    if (isOwner) {
      final token = await _repository.getCreatorToken(surpriseId);
      if (token == null) {
        throw Exception('creator_token introuvable pour cette surprise.');
      }
      await _repository.deleteSurprise(id: surpriseId, creatorToken: token);
    }
    // Retire le code de la liste locale unifiée.
    await _repository.removeCode(shareCode);
  }
}
