import 'dart:io';

import '../../domain/entities/surprise.dart';
import '../../domain/repositories/i_surprise_repository.dart';
import '../datasources/surprise_local_datasource.dart';
import '../datasources/surprise_remote_datasource.dart';

class SurpriseRepositoryImpl implements ISurpriseRepository {
  final SurpriseRemoteDatasource _remote;
  final SurpriseLocalDatasource _local;

  const SurpriseRepositoryImpl(this._remote, this._local);

  @override
  Future<List<Surprise>> getSurprises(List<String> codes) =>
      _remote.getSurprises(codes);

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
    // Utilise le token utilisateur unique (généré à la première création si absent).
    final userToken = await _local.getUserToken();
    final result = await _remote.createSurprise(
      emoji: emoji,
      title: title,
      subtitle: subtitle,
      color: color,
      elements: elements,
      creatorToken: userToken,
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
  }) =>
      _remote.updateSurprise(
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
  }) =>
      _remote.updateElement(
        id: id,
        creatorToken: creatorToken,
        type: type,
        label: label,
        content: content,
        unlockCode: unlockCode,
      );

  @override
  Future<void> deleteSurprise({required String id, required String creatorToken}) =>
      _remote.deleteSurprise(id: id, creatorToken: creatorToken);

  @override
  Future<void> deleteElement({required String id, required String creatorToken}) =>
      _remote.deleteElement(id: id, creatorToken: creatorToken);

  @override
  Future<void> addElement({
    required String surpriseId,
    required String creatorToken,
    required String type,
    required String label,
    required String content,
    required String unlockCode,
    required int sortOrder,
  }) =>
      _remote.addElement(
        surpriseId: surpriseId,
        creatorToken: creatorToken,
        type: type,
        label: label,
        content: content,
        unlockCode: unlockCode,
        sortOrder: sortOrder,
      );

  @override
  Future<String> uploadImage(File file) => _remote.uploadImage(file);

  @override
  Future<bool> verifyAndSaveCreatorToken({
    required String surpriseId,
    required String token,
  }) async {
    final valid = await _remote.verifyCreatorToken(
      surpriseId: surpriseId,
      token: token,
    );
    // Sauvegarde comme token utilisateur global (pas par surprise).
    if (valid) await _local.saveUserToken(token);
    return valid;
  }

  @override
  Future<List<String>> getSavedCodes() => _local.getSavedCodes();

  @override
  Future<Set<String>> getCreatedCodes() => _local.getCreatedCodes();

  @override
  Future<void> saveCode(String code) => _local.saveCode(code);

  @override
  Future<void> saveCreatedCode(String code) => _local.saveCreatedCode(code);

  @override
  Future<void> removeSavedCode(String code) => _local.removeSavedCode(code);

  @override
  Future<void> removeCreatedCode(String code) => _local.removeCreatedCode(code);

  @override
  Future<String> getUserToken() => _local.getUserToken();

  @override
  Future<String?> getCreatorToken(String surpriseId) =>
      _local.getCreatorToken(surpriseId);
}
