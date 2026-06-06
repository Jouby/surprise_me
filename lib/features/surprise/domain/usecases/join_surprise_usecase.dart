import '../entities/surprise.dart';
import '../repositories/i_surprise_repository.dart';

class JoinSurpriseUseCase {
  final ISurpriseRepository _repository;
  const JoinSurpriseUseCase(this._repository);

  /// Retourne la surprise si le code est valide, null sinon.
  Future<Surprise?> call(String shareCode) async {
    final upper = shareCode.trim().toUpperCase();
    final surprise = await _repository.fetchByShareCode(upper);
    if (surprise == null) return null;

    final saved = await _repository.getSavedCodes();
    if (!saved.contains(upper)) {
      await _repository.saveCode(upper);
    }
    return surprise;
  }
}
