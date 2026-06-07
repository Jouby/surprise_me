abstract class IUnlockRepository {
  bool isUnlocked(String surpriseId, String code);
  Future<void> unlock(String surpriseId, String code);
  Future<void> loadCodesForSurprise(String surpriseId);
}
