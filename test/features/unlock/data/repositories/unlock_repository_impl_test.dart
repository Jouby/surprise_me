import 'package:flutter_test/flutter_test.dart';
import 'package:surprise_me/features/unlock/data/datasources/unlock_local_datasource.dart';
import 'package:surprise_me/features/unlock/data/repositories/unlock_repository_impl.dart';

/// Datasource en mémoire pour les tests — pas de SharedPreferences.
class _FakeUnlockDatasource implements UnlockLocalDatasource {
  final Map<String, Set<String>> _store = {};

  @override
  Future<Set<String>> loadCodes(String surpriseId) async =>
      Set.from(_store[surpriseId] ?? {});

  @override
  Future<void> saveCode(String surpriseId, String code) async =>
      _store.putIfAbsent(surpriseId, () => {}).add(code);

  @override
  Future<void> clearCodes(String surpriseId) async => _store.remove(surpriseId);

  @override
  Future<void> clearAll() async => _store.clear();
}

void main() {
  late _FakeUnlockDatasource datasource;
  late UnlockRepositoryImpl repo;

  setUp(() {
    datasource = _FakeUnlockDatasource();
    repo = UnlockRepositoryImpl(datasource);
  });

  group('isUnlocked', () {
    test('retourne false avant tout unlock', () {
      expect(repo.isUnlocked('surprise-1', 'SECRET'), isFalse);
    });

    test('retourne true après unlock', () async {
      await repo.unlock('surprise-1', 'SECRET');
      expect(repo.isUnlocked('surprise-1', 'SECRET'), isTrue);
    });

    test('est insensible à la casse', () async {
      await repo.unlock('surprise-1', 'SECRET');
      expect(repo.isUnlocked('surprise-1', 'secret'), isTrue);
    });

    test('les codes sont isolés par surpriseId', () async {
      await repo.unlock('surprise-1', 'CODE_A');
      expect(repo.isUnlocked('surprise-2', 'CODE_A'), isFalse);
    });
  });

  group('loadCodesForSurprise', () {
    test('charge les codes persistés', () async {
      await datasource.saveCode('surprise-1', 'PERSISTED');
      await repo.loadCodesForSurprise('surprise-1');
      expect(repo.isUnlocked('surprise-1', 'PERSISTED'), isTrue);
    });

    test('est idempotent (ne réinitialise pas le cache)', () async {
      await repo.unlock('surprise-1', 'IN_MEMORY');
      await repo.loadCodesForSurprise('surprise-1'); // déjà en cache
      expect(repo.isUnlocked('surprise-1', 'IN_MEMORY'), isTrue);
    });
  });
}
