abstract class IUnlockRepository {
  bool isUnlocked(String code);
  Future<void> unlock(String code);
  Future<void> loadCodes();
}
