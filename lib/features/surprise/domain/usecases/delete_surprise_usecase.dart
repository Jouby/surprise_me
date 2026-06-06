import '../repositories/i_surprise_repository.dart';

class DeleteSurpriseUseCase {
  final ISurpriseRepository _repository;
  const DeleteSurpriseUseCase(this._repository);

  Future<void> call({
    required String surpriseId,
    required String shareCode,
    required bool isOwner,
  }) async {
    // Supprimer côté serveur uniquement si on est propriétaire
    if (isOwner) {
      await _repository.deleteSurprise(surpriseId);
      await _repository.removeCreatedCode(shareCode);
    }
    // Dans tous les cas, retirer du stockage local (propriétaire ou visiteur)
    await _repository.removeSavedCode(shareCode);
  }
}
