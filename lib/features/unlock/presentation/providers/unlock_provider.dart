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
        _repository = repository {
    _repository.loadCodes().then((_) => notifyListeners());
  }

  bool isUnlocked(String code) => _isUnlocked(code);

  Future<bool> tryUnlock(String code) async {
    final ok = await _tryUnlock(code);
    if (ok) notifyListeners();
    return ok;
  }
}
