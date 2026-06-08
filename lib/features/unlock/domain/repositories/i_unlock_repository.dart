abstract class IUnlockRepository {
  bool isUnlocked(String surpriseId, String code);
  Future<void> unlock(String surpriseId, String code);
  Future<void> loadCodesForSurprise(String surpriseId);

  /// Vide le cache mémoire et les données persistées.
  Future<void> clearAll();
}
