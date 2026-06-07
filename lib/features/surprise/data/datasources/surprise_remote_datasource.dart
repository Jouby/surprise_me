import 'dart:io';
import 'dart:math';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/surprise_model.dart';

class SurpriseRemoteDatasource {
  final SupabaseClient _client;
  SurpriseRemoteDatasource(this._client);

  // Colonnes retournées — creator_token intentionnellement exclu.
  static const _surpriseCols =
      'id, emoji, title, subtitle, share_code, color, created_at, surprise_elements(*)';

  /// Retourne deux listes : [owned] (token correspond) et [joined] (token différent).
  /// Deux requêtes distinctes pour que Supabase ne renvoie jamais le creator_token.
  Future<({List<SurpriseModel> owned, List<SurpriseModel> joined})>
  getSurprises(List<String> codes, String userToken) async {
    if (codes.isEmpty)
      return (owned: <SurpriseModel>[], joined: <SurpriseModel>[]);

    final ownedRes = await _client
        .from('surprises')
        .select(_surpriseCols)
        .inFilter('share_code', codes)
        .eq('creator_token', userToken);

    final joinedRes = await _client
        .from('surprises')
        .select(_surpriseCols)
        .inFilter('share_code', codes)
        .neq('creator_token', userToken);

    return (
      owned: (ownedRes as List)
          .map((e) => SurpriseModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      joined: (joinedRes as List)
          .map((e) => SurpriseModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Future<SurpriseModel?> fetchByShareCode(String code) async {
    final res = await _client
        .from('surprises')
        .select('*, surprise_elements(*)')
        .eq('share_code', code.toUpperCase())
        .maybeSingle();
    if (res == null) return null;
    return SurpriseModel.fromJson(res);
  }

  /// Crée une surprise en injectant le [creatorToken] fourni par l'app (token utilisateur).
  Future<({String shareCode, String surpriseId})> createSurprise({
    required String emoji,
    required String title,
    required String subtitle,
    required String color,
    required List<Map<String, dynamic>> elements,
    required String creatorToken,
  }) async {
    final shareCode = _generateCode();
    final row = await _client
        .from('surprises')
        .insert({
          'emoji': emoji,
          'title': title,
          'subtitle': subtitle,
          'color': color,
          'share_code': shareCode,
          'creator_token': creatorToken,
        })
        .select('id, share_code')
        .single();

    final surpriseId = row['id'] as String;

    final rows = elements
        .asMap()
        .entries
        .map(
          (entry) => {
            'surprise_id': surpriseId,
            'type': entry.value['type'],
            'label': entry.value['label'],
            'content': entry.value['content'],
            'unlock_code': (entry.value['unlock_code'] as String).toUpperCase(),
            'sort_order': entry.key,
          },
        )
        .toList();
    await _client.from('surprise_elements').insert(rows);

    return (shareCode: shareCode, surpriseId: surpriseId);
  }

  Future<void> updateSurprise({
    required String id,
    required String creatorToken,
    required String emoji,
    required String title,
    required String subtitle,
    required String color,
  }) => _client.rpc(
    'update_surprise',
    params: {
      'p_id': id,
      'p_token': creatorToken,
      'p_emoji': emoji,
      'p_title': title,
      'p_subtitle': subtitle,
      'p_color': color,
    },
  );

  Future<void> updateElement({
    required String id,
    required String creatorToken,
    required String type,
    required String label,
    required String content,
    required String unlockCode,
  }) => _client.rpc(
    'update_surprise_element',
    params: {
      'p_id': id,
      'p_token': creatorToken,
      'p_type': type,
      'p_label': label,
      'p_content': content,
      'p_unlock_code': unlockCode.toUpperCase(),
    },
  );

  Future<void> deleteSurprise({
    required String id,
    required String creatorToken,
  }) => _client.rpc(
    'delete_surprise',
    params: {'p_id': id, 'p_token': creatorToken},
  );

  Future<void> deleteElement({
    required String id,
    required String creatorToken,
  }) => _client.rpc(
    'delete_surprise_element',
    params: {'p_id': id, 'p_token': creatorToken},
  );

  Future<void> addElement({
    required String surpriseId,
    required String creatorToken,
    required String type,
    required String label,
    required String content,
    required String unlockCode,
    required int sortOrder,
  }) => _client.rpc(
    'add_surprise_element',
    params: {
      'p_surprise_id': surpriseId,
      'p_token': creatorToken,
      'p_type': type,
      'p_label': label,
      'p_content': content,
      'p_unlock_code': unlockCode.toUpperCase(),
      'p_sort_order': sortOrder,
    },
  );

  Future<bool> verifyCreatorToken({
    required String surpriseId,
    required String token,
  }) async {
    final result = await _client.rpc(
      'verify_creator_token',
      params: {'p_id': surpriseId, 'p_token': token},
    );
    return result as bool? ?? false;
  }

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

    final name = '${DateTime.now().millisecondsSinceEpoch}.$safeExt';
    final path = 'elements/$name';

    await _client.storage
        .from('surprise-images')
        .upload(
          path,
          file,
          fileOptions: FileOptions(contentType: mimeType, upsert: false),
        );
    return _client.storage.from('surprise-images').getPublicUrl(path);
  }

  static String _generateCode() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final rng = Random.secure();
    return List.generate(6, (_) => chars[rng.nextInt(chars.length)]).join();
  }
}
