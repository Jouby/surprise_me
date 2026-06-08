import 'package:flutter_test/flutter_test.dart';
import 'package:surprise_me/features/unlock/domain/repositories/i_unlock_repository.dart';
import 'package:surprise_me/features/unlock/domain/usecases/is_unlocked_usecase.dart';
import 'package:surprise_me/features/unlock/domain/usecases/try_unlock_usecase.dart';

class _FakeUnlockRepository implements IUnlockRepository {
  final Map<String, Set<String>> _codes = {};

  @override
  bool isUnlocked(String surpriseId, String code) =>
      _codes[surpriseId]?.contains(code.toUpperCase()) ?? false;

  @override
  Future<void> unlock(String surpriseId, String code) async =>
      _codes.putIfAbsent(surpriseId, () => {}).add(code.toUpperCase());

  @override
  Future<void> loadCodesForSurprise(String surpriseId) async {}

  @override
  Future<void> clearAll() async => _codes.clear();

  @override
  Future<void> clearForSurprise(String surpriseId) async =>
      _codes.remove(surpriseId);
}

void main() {
  late _FakeUnlockRepository repo;
  late TryUnlockUseCase tryUnlock;
  late IsUnlockedUseCase isUnlocked;

  setUp(() {
    repo = _FakeUnlockRepository();
    tryUnlock = TryUnlockUseCase(repo);
    isUnlocked = IsUnlockedUseCase(repo);
  });

  group('TryUnlockUseCase', () {
    test('retourne false pour un code vide', () async {
      expect(await tryUnlock('surprise-1', ''), isFalse);
      expect(await tryUnlock('surprise-1', '   '), isFalse);
    });

    test('retourne true pour un code valide', () async {
      expect(await tryUnlock('surprise-1', 'SECRET'), isTrue);
    });

    test('stocke le code en majuscules', () async {
      await tryUnlock('surprise-1', 'secret');
      expect(repo.isUnlocked('surprise-1', 'SECRET'), isTrue);
    });

    test('scope le code à la surprise', () async {
      await tryUnlock('surprise-1', 'CODE');
      expect(repo.isUnlocked('surprise-2', 'CODE'), isFalse);
    });
  });

  group('IsUnlockedUseCase', () {
    test('retourne false si le code n\'a pas été débloqué', () {
      expect(isUnlocked('surprise-1', 'SECRET'), isFalse);
    });

    test('retourne true après déverrouillage', () async {
      await repo.unlock('surprise-1', 'SECRET');
      expect(isUnlocked('surprise-1', 'SECRET'), isTrue);
    });

    test('est insensible à la casse', () async {
      await repo.unlock('surprise-1', 'SECRET');
      expect(isUnlocked('surprise-1', 'secret'), isTrue);
    });

    test('isole les surprises', () async {
      await repo.unlock('surprise-1', 'SECRET');
      expect(isUnlocked('surprise-2', 'SECRET'), isFalse);
    });
  });
}
