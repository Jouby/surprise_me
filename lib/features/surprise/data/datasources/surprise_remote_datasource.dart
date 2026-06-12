import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:pocketbase/pocketbase.dart';

import '../../../../core/config/app_config.dart';
import '../models/surprise_model.dart';

class SurpriseRemoteDatasource {
  final PocketBase _pb;

  SurpriseRemoteDatasource(this._pb);

  static const _expand = 'surprise_elements_via_surprise';

  /// Retourne deux listes : [owned] et [joined].
  Future<({List<SurpriseModel> owned, List<SurpriseModel> joined})>
  getSurprises(List<String> codes, String userToken) async {
    if (codes.isEmpty) {
      return (owned: <SurpriseModel>[], joined: <SurpriseModel>[]);
    }

    final codeFilter = codes.map((c) => 'share_code="$c"').join('||');

    final ownedRes = await _pb
        .collection('surprises')
        .getFullList(
          filter: '($codeFilter) && creator_token="$userToken"',
          expand: _expand,
          sort: '-created',
        );

    final joinedRes = await _pb
        .collection('surprises')
        .getFullList(
          filter: '($codeFilter) && creator_token!="$userToken"',
          expand: _expand,
          sort: '-created',
        );

    return (
      owned: ownedRes.map(SurpriseModel.fromRecord).toList(),
      joined: joinedRes.map(SurpriseModel.fromRecord).toList(),
    );
  }

  Future<SurpriseModel?> fetchByShareCode(String code) async {
    final res = await _pb
        .collection('surprises')
        .getFullList(
          filter: 'share_code="${code.toUpperCase()}"',
          expand: _expand,
        );
    if (res.isEmpty) return null;
    return SurpriseModel.fromRecord(res.first);
  }

  Future<({String shareCode, String surpriseId})> createSurprise({
    required String emoji,
    required String title,
    required String subtitle,
    required String color,
    required List<Map<String, dynamic>> elements,
    required String creatorToken,
    required String shareCode,
  }) async {
    final record = await _pb
        .collection('surprises')
        .create(
          body: {
            'emoji': emoji,
            'title': title,
            'subtitle': subtitle,
            'color': color,
            'share_code': shareCode,
            'creator_token': creatorToken,
          },
        );

    for (var i = 0; i < elements.length; i++) {
      final el = elements[i];
      await _pb
          .collection('surprise_elements')
          .create(
            body: {
              'surprise': record.id,
              'type': el['type'],
              'label': el['label'],
              'content': el['content'],
              'unlock_code': (el['unlock_code'] as String).toUpperCase(),
              'solve_code': (el['solve_code'] as String? ?? '').toUpperCase(),
              'sort_order': i + 1,
            },
          );
    }

    return (
      shareCode: record.getStringValue('share_code'),
      surpriseId: record.id,
    );
  }

  Future<void> updateSurprise({
    required String id,
    required String creatorToken,
    required String emoji,
    required String title,
    required String subtitle,
    required String color,
  }) => _pb
      .collection('surprises')
      .update(
        id,
        body: {
          'emoji': emoji,
          'title': title,
          'subtitle': subtitle,
          'color': color,
          'creator_token': creatorToken,
        },
      );

  Future<void> updateElement({
    required String id,
    required String creatorToken,
    required String type,
    required String label,
    required String content,
    required String unlockCode,
    required String solveCode,
    required int sortOrder,
  }) => _pb
      .collection('surprise_elements')
      .update(
        id,
        body: {
          'type': type,
          'label': label,
          'content': content,
          'unlock_code': unlockCode.toUpperCase(),
          'solve_code': solveCode.toUpperCase(),
          'sort_order': sortOrder,
          'creator_token': creatorToken,
        },
      );

  Future<void> deleteSurprise({
    required String id,
    required String creatorToken,
  }) => _pb
      .collection('surprises')
      .delete(id, body: {'creator_token': creatorToken});

  Future<void> deleteElement({
    required String id,
    required String creatorToken,
  }) => _pb
      .collection('surprise_elements')
      .delete(id, body: {'creator_token': creatorToken});

  Future<void> addElement({
    required String surpriseId,
    required String creatorToken,
    required String type,
    required String label,
    required String content,
    required String unlockCode,
    required String solveCode,
    required int sortOrder,
  }) => _pb
      .collection('surprise_elements')
      .create(
        body: {
          'surprise': surpriseId,
          'type': type,
          'label': label,
          'content': content,
          'unlock_code': unlockCode.toUpperCase(),
          'solve_code': solveCode.toUpperCase(),
          'sort_order': sortOrder,
          'creator_token': creatorToken,
        },
      );

  /// Upload une image dans la collection `images` et retourne son URL publique.
  Future<String> uploadImage(File file) async {
    final baseName = file.path.split('/').last.split('?').first;
    final dotIndex = baseName.lastIndexOf('.');
    final ext = dotIndex != -1
        ? baseName.substring(dotIndex + 1).toLowerCase()
        : 'jpg';
    final safeExt = (ext == 'jpeg' || ext == 'heic' || ext == 'heif')
        ? 'jpg'
        : ext;
    final mimeType = safeExt == 'png'
        ? 'image/png'
        : safeExt == 'webp'
        ? 'image/webp'
        : 'image/jpeg';

    final fileName = '${DateTime.now().millisecondsSinceEpoch}.$safeExt';
    final bytes = await file.readAsBytes();

    final record = await _pb
        .collection('images')
        .create(
          files: [
            http.MultipartFile.fromBytes(
              'file',
              bytes,
              filename: fileName,
              contentType: http.MediaType.parse(mimeType),
            ),
          ],
        );

    final storedName = record.getStringValue('file');
    return '${AppConfig.pocketbaseUrl}/api/files/images/${record.id}/$storedName';
  }
}
