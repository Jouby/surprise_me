import 'package:flutter/foundation.dart';

import '../../domain/repositories/i_unlock_repository.dart';
import '../../domain/usecases/is_unlocked_usecase.dart';
import '../../domain/usecases/try_unlock_usecase.dart';

class UnlockProvider extends ChangeNotifier {
  final TryUnlockUseCase _tryUnlock;
  final IsUnlockedUseCase _isUnlocked;
  final IUnlockRepository _repository;

  UnlockProvider({
    required TryUnlockUseCase tryUnlock,
    required IsUnlockedUseCase isUnlocked,
    required IUnlockRepository repository,
  })  : _tryUnlock = tryUnlock,
        _isUnlocked = isUnlocked,
        _repository = repository;

  /// Charge les codes débloqués pour une surprise donnée (idempotent).
  Future<void> loadCodesForSurprise(String surpriseId) async {
    await _repository.loadCodesForSurprise(surpriseId);
    notifyListeners();
  }

  bool isUnlocked(String surpriseId, String code) =>
      _isUnlocked(surpriseId, code);

  Future<bool> tryUnlock(String surpriseId, String code) async {
    final ok = await _tryUnlock(surpriseId, code);
    if (ok) notifyListeners();
    return ok;
  }
}
