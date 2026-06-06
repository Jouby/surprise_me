import 'dart:io';
import 'dart:math';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/surprise_model.dart';

class SurpriseRemoteDatasource {
  final SupabaseClient _client;
  SurpriseRemoteDatasource(this._client);

  Future<List<SurpriseModel>> getSurprises(List<String> codes) async {
    if (codes.isEmpty) return [];
    final res = await _client
        .from('surprises')
        .select('*, surprise_elements(*)')
        .inFilter('share_code', codes);
    return (res as List)
        .map((e) => SurpriseModel.fromJson(e as Map<String, dynamic>))
        .toList();
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

  /// Returns shareCode, surpriseId and creatorToken for local storage.
  Future<({String shareCode, String surpriseId, String creatorToken})> createSurprise({
    required String emoji,
    required String title,
    required String subtitle,
    required String color,
    required List<Map<String, dynamic>> elements,
  }) async {
    final shareCode = _generateCode();
    final row = await _client.from('surprises').insert({
      'emoji': emoji,
      'title': title,
      'subtitle': subtitle,
      'color': color,
      'share_code': shareCode,
    }).select('id, share_code, creator_token').single();

    final surpriseId = row['id'] as String;
    final creatorToken = row['creator_token'] as String;

    final rows = elements.asMap().entries.map((entry) => {
          'surprise_id': surpriseId,
          'type': entry.value['type'],
          'label': entry.value['label'],
          'content': entry.value['content'],
          'unlock_code': (entry.value['unlock_code'] as String).toUpperCase(),
          'sort_order': entry.key,
        }).toList();
    await _client.from('surprise_elements').insert(rows);

    return (shareCode: shareCode, surpriseId: surpriseId, creatorToken: creatorToken);
  }

  Future<void> updateSurprise({
    required String id,
    required String creatorToken,
    required String emoji,
    required String title,
    required String subtitle,
    required String color,
  }) =>
      _client.rpc('update_surprise', params: {
        'p_id': id,
        'p_token': creatorToken,
        'p_emoji': emoji,
        'p_title': title,
        'p_subtitle': subtitle,
        'p_color': color,
      });

  Future<void> updateElement({
    required String id,
    required String creatorToken,
    required String type,
    required String label,
    required String content,
    required String unlockCode,
  }) =>
      _client.rpc('update_surprise_element', params: {
        'p_id': id,
        'p_token': creatorToken,
        'p_type': type,
        'p_label': label,
        'p_content': content,
        'p_unlock_code': unlockCode.toUpperCase(),
      });

  Future<void> deleteSurprise({
    required String id,
    required String creatorToken,
  }) =>
      _client.rpc('delete_surprise', params: {
        'p_id': id,
        'p_token': creatorToken,
      });

  Future<void> deleteElement({
    required String id,
    required String creatorToken,
  }) =>
      _client.rpc('delete_surprise_element', params: {
        'p_id': id,
        'p_token': creatorToken,
      });

  Future<void> addElement({
    required String surpriseId,
    required String creatorToken,
    required String type,
    required String label,
    required String content,
    required String unlockCode,
    required int sortOrder,
  }) =>
      _client.rpc('add_surprise_element', params: {
        'p_surprise_id': surpriseId,
        'p_token': creatorToken,
        'p_type': type,
        'p_label': label,
        'p_content': content,
        'p_unlock_code': unlockCode.toUpperCase(),
        'p_sort_order': sortOrder,
      });

  Future<String> uploadImage(File file) async {
    final baseName = file.path.split('/').last.split('?').first;
    final dotIndex = baseName.lastIndexOf('.');
    final ext = dotIndex != -1
        ? baseName.substring(dotIndex + 1).toLowerCase()
        : 'jpg';

    final safeExt = (ext == 'jpeg' || ext == 'heic' || ext == 'heif') ? 'jpg' : ext;
    final mimeType = safeExt == 'png' ? 'image/png'
        : safeExt == 'webp' ? 'image/webp'
        : 'image/jpeg';

    final name = '${DateTime.now().millisecondsSinceEpoch}.$safeExt';
    final path = 'elements/$name';

    await _client.storage.from('surprise-images').upload(
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
