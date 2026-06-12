import 'dart:io';
import 'dart:math';

import '../../domain/entities/surprise.dart';
import '../../domain/repositories/i_surprise_repository.dart';
import '../datasources/surprise_local_datasource.dart';
import '../datasources/surprise_remote_datasource.dart';

class SurpriseRepositoryImpl implements ISurpriseRepository {
  final SurpriseRemoteDatasource _remote;
  final SurpriseLocalDatasource _local;

  const SurpriseRepositoryImpl(this._remote, this._local);

  @override
  Future<({List<Surprise> owned, List<Surprise> joined})> getSurprises(
    List<String> codes,
  ) async {
    final userToken = await _local.getUserToken();
    return _remote.getSurprises(codes, userToken);
  }

  @override
  Future<Surprise?> fetchByShareCode(String code) =>
      _remote.fetchByShareCode(code);

  @override
  Future<String> createSurprise({
    required String emoji,
    required String title,
    required String subtitle,
    required String color,
    required List<Map<String, dynamic>> elements,
  }) async {
    final userToken = await _local.getUserToken();
    final shareCode = _generateShareCode();
    final result = await _remote.createSurprise(
      emoji: emoji,
      title: title,
      subtitle: subtitle,
      color: color,
      elements: elements,
      creatorToken: userToken,
      shareCode: shareCode,
    );
    return result.shareCode;
  }

  @override
  Future<void> updateSurprise({
    required String id,
    required String creatorToken,
    required String emoji,
    required String title,
    required String subtitle,
    required String color,
  }) => _remote.updateSurprise(
    id: id,
    creatorToken: creatorToken,
    emoji: emoji,
    title: title,
    subtitle: subtitle,
    color: color,
  );

  @override
  Future<void> updateElement({
    required String id,
    required String creatorToken,
    required String type,
    required String label,
    required String content,
    required String unlockCode,
    required String solveCode,
    required int sortOrder,
  }) => _remote.updateElement(
    id: id,
    creatorToken: creatorToken,
    type: type,
    label: label,
    content: content,
    unlockCode: unlockCode,
    solveCode: solveCode,
    sortOrder: sortOrder,
  );

  @override
  Future<void> deleteSurprise({
    required String id,
    required String creatorToken,
  }) => _remote.deleteSurprise(id: id, creatorToken: creatorToken);

  @override
  Future<void> deleteElement({
    required String id,
    required String creatorToken,
  }) => _remote.deleteElement(id: id, creatorToken: creatorToken);

  @override
  Future<void> addElement({
    required String surpriseId,
    required String creatorToken,
    required String type,
    required String label,
    required String content,
    required String unlockCode,
    required String solveCode,
    required int sortOrder,
  }) => _remote.addElement(
    surpriseId: surpriseId,
    creatorToken: creatorToken,
    type: type,
    label: label,
    content: content,
    unlockCode: unlockCode,
    solveCode: solveCode,
    sortOrder: sortOrder,
  );

  @override
  Future<String> uploadImage(File file) => _remote.uploadImage(file);

  @override
  Future<List<String>> getSavedCodes() => _local.getSavedCodes();

  @override
  Future<void> saveCode(String code) => _local.saveCode(code);

  @override
  Future<void> removeCode(String code) => _local.removeCode(code);

  @override
  Future<void> clearJoinedCodes() => _local.clearJoinedCodes();

  @override
  Future<String> getUserToken() => _local.getUserToken();

  @override
  Future<String?> getCreatorToken(String surpriseId) =>
      _local.getCreatorToken(surpriseId);

  /// Génère un code de partage de 6 caractères (logique métier, sans réseau).
  static String _generateShareCode() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final rng = Random.secure();
    return List.generate(6, (_) => chars[rng.nextInt(chars.length)]).join();
  }
}
