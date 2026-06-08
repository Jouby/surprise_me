import '../../domain/repositories/i_unlock_repository.dart';
import '../datasources/unlock_local_datasource.dart';

class UnlockRepositoryImpl implements IUnlockRepository {
  final UnlockLocalDatasource _local;

  // Cache en mémoire : surpriseId → Set<code>
  final Map<String, Set<String>> _cache = {};

  UnlockRepositoryImpl(this._local);

  @override
  bool isUnlocked(String surpriseId, String code) =>
      _cache[surpriseId]?.contains(code.toUpperCase()) ?? false;

  @override
  Future<void> unlock(String surpriseId, String code) async {
    final upper = code.toUpperCase();
    _cache.putIfAbsent(surpriseId, () => {}).add(upper);
    await _local.saveCode(surpriseId, upper);
  }

  @override
  Future<void> loadCodesForSurprise(String surpriseId) async {
    if (_cache.containsKey(surpriseId)) return; // déjà chargé
    _cache[surpriseId] = await _local.loadCodes(surpriseId);
  }

  @override
  Future<void> clearAll() async {
    _cache.clear();
    await _local.clearAll();
  }

  @override
  Future<void> clearForSurprise(String surpriseId) async {
    _cache.remove(surpriseId);
    await _local.clearCodes(surpriseId);
  }
}
