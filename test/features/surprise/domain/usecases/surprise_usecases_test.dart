import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:surprise_me/features/surprise/domain/entities/surprise.dart';
import 'package:surprise_me/features/surprise/domain/repositories/i_surprise_repository.dart';
import 'package:surprise_me/features/surprise/domain/usecases/create_surprise_usecase.dart';
import 'package:surprise_me/features/surprise/domain/usecases/delete_surprise_usecase.dart';

// ─── Fake repository ─────────────────────────────────────────────────────────

class _FakeSurpriseRepository implements ISurpriseRepository {
  final List<String> savedCodes = [];
  final List<String> deletedSurpriseIds = [];
  String? creatorToken = 'user-token-uuid';

  // Surprises "créées" simulées
  @override
  Future<String> createSurprise({
    required String emoji,
    required String title,
    required String subtitle,
    required String color,
    required List<Map<String, dynamic>> elements,
  }) async => 'SHARE1';

  @override
  Future<void> saveCode(String code) async => savedCodes.add(code);

  @override
  Future<void> removeCode(String code) async => savedCodes.remove(code);

  @override
  Future<void> clearJoinedCodes() async => savedCodes.clear();

  @override
  Future<String?> getCreatorToken(String surpriseId) async => creatorToken;

  @override
  Future<void> deleteSurprise({
    required String id,
    required String creatorToken,
  }) async => deletedSurpriseIds.add(id);

  // ── Stubs non utilisés dans ces tests ────────────────────────────────────

  @override
  Future<({List<Surprise> owned, List<Surprise> joined})> getSurprises(
    List<String> codes,
  ) async => (owned: <Surprise>[], joined: <Surprise>[]);

  @override
  Future<Surprise?> fetchByShareCode(String code) async => null;

  @override
  Future<void> updateSurprise({
    required String id,
    required String creatorToken,
    required String emoji,
    required String title,
    required String subtitle,
    required String color,
  }) async {}

  @override
  Future<void> updateElement({
    required String id,
    required String creatorToken,
    required String type,
    required String label,
    required String content,
    required String unlockCode,
    required int sortOrder,
  }) async {}

  @override
  Future<void> deleteElement({
    required String id,
    required String creatorToken,
  }) async {}

  @override
  Future<void> addElement({
    required String surpriseId,
    required String creatorToken,
    required String type,
    required String label,
    required String content,
    required String unlockCode,
    required int sortOrder,
  }) async {}

  @override
  Future<String> uploadImage(File file) async => '';

  @override
  Future<List<String>> getSavedCodes() async => List.from(savedCodes);

  @override
  Future<String> getUserToken() async => creatorToken ?? 'user-token-uuid';
}

// ─── Tests ───────────────────────────────────────────────────────────────────

void main() {
  late _FakeSurpriseRepository repo;

  setUp(() => repo = _FakeSurpriseRepository());

  group('CreateSurpriseUseCase', () {
    test('retourne le share code', () async {
      final useCase = CreateSurpriseUseCase(repo);
      final code = await useCase(
        emoji: '🎁',
        title: 'Test',
        subtitle: '',
        color: '#000000',
        elements: [],
      );
      expect(code, equals('SHARE1'));
    });

    test('sauvegarde le share code en local', () async {
      final useCase = CreateSurpriseUseCase(repo);
      await useCase(
        emoji: '🎁',
        title: 'Test',
        subtitle: '',
        color: '#000000',
        elements: [],
      );
      expect(repo.savedCodes, contains('SHARE1'));
    });
  });

  group('DeleteSurpriseUseCase', () {
    test(
      'propriétaire : supprime sur Supabase et retire le code local',
      () async {
        repo.savedCodes.add('SHARE1');
        final useCase = DeleteSurpriseUseCase(repo);
        await useCase(surpriseId: 'id-1', shareCode: 'SHARE1', isOwner: true);

        expect(repo.deletedSurpriseIds, contains('id-1'));
        expect(repo.savedCodes, isNot(contains('SHARE1')));
      },
    );

    test('non-propriétaire : retire uniquement le code local', () async {
      repo.savedCodes.add('SHARE1');
      final useCase = DeleteSurpriseUseCase(repo);
      await useCase(surpriseId: 'id-1', shareCode: 'SHARE1', isOwner: false);

      expect(repo.deletedSurpriseIds, isEmpty);
      expect(repo.savedCodes, isNot(contains('SHARE1')));
    });

    test(
      'lève une exception si le token est manquant pour un propriétaire',
      () async {
        repo.creatorToken = null;
        final useCase = DeleteSurpriseUseCase(repo);
        expect(
          () => useCase(surpriseId: 'id-1', shareCode: 'SHARE1', isOwner: true),
          throwsException,
        );
      },
    );
  });
}
