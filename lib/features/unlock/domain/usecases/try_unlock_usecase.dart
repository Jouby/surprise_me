import '../repositories/i_unlock_repository.dart';

class TryUnlockUseCase {
  final IUnlockRepository _repository;
  const TryUnlockUseCase(this._repository);

  Future<bool> call(String surpriseId, String code) async {
    final upper = code.trim().toUpperCase();
    if (upper.isEmpty) return false;
    await _repository.unlock(surpriseId, upper);
    return true;
  }
}
