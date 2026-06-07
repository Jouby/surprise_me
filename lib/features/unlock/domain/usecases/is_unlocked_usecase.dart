import '../repositories/i_unlock_repository.dart';

class IsUnlockedUseCase {
  final IUnlockRepository _repository;
  const IsUnlockedUseCase(this._repository);

  bool call(String surpriseId, String code) =>
      _repository.isUnlocked(surpriseId, code.toUpperCase());
}
