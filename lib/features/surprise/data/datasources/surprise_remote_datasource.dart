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

  Future<String> createSurprise({
    required String emoji,
    required String title,
    required String subtitle,
    required String color,
    required List<Map<String, dynamic>> elements,
  }) async {
    final shareCode = _generateCode();
    final surprise = await _client.from('surprises').insert({
      'emoji': emoji,
      'title': title,
      'subtitle': subtitle,
      'color': color,
      'share_code': shareCode,
    }).select().single();

    final surpriseId = surprise['id'] as String;
    final rows = elements.asMap().entries.map((entry) => {
          'surprise_id': surpriseId,
          'type': entry.value['type'],
          'label': entry.value['label'],
          'content': entry.value['content'],
          'unlock_code':
              (entry.value['unlock_code'] as String).toUpperCase(),
          'sort_order': entry.key,
        }).toList();
    await _client.from('surprise_elements').insert(rows);
    return shareCode;
  }

  Future<void> updateSurprise({
    required String id,
    required String emoji,
    required String title,
    required String subtitle,
    required String color,
  }) async {
    final rows = await _client.from('surprises').update({
      'emoji': emoji,
      'title': title,
      'subtitle': subtitle,
      'color': color,
    }).eq('id', id).select();
    if ((rows as List).isEmpty) {
      throw Exception('Mise à jour refusée (RLS). Vérifiez les policies Supabase.');
    }
  }

  Future<void> updateElement({
    required String id,
    required String type,
    required String label,
    required String content,
    required String unlockCode,
  }) async {
    final rows = await _client.from('surprise_elements').update({
      'type': type,
      'label': label,
      'content': content,
      'unlock_code': unlockCode.toUpperCase(),
    }).eq('id', id).select();
    if ((rows as List).isEmpty) {
      throw Exception('Mise à jour élément refusée (RLS).');
    }
  }

  Future<void> deleteSurprise(String id) async {
    final rows = await _client
        .from('surprises')
        .delete()
        .eq('id', id)
        .select();
    if ((rows as List).isEmpty) {
      throw Exception('Suppression refusée (RLS). Vérifiez les policies Supabase.');
    }
  }

  Future<void> deleteElement(String id) async {
    final rows = await _client
        .from('surprise_elements')
        .delete()
        .eq('id', id)
        .select();
    if ((rows as List).isEmpty) {
      throw Exception('Suppression refusée (RLS).');
    }
  }

  Future<void> addElement({
    required String surpriseId,
    required String type,
    required String label,
    required String content,
    required String unlockCode,
    required int sortOrder,
  }) async {
    await _client.from('surprise_elements').insert({
      'surprise_id': surpriseId,
      'type': type,
      'label': label,
      'content': content,
      'unlock_code': unlockCode.toUpperCase(),
      'sort_order': sortOrder,
    });
  }

  Future<String> uploadImage(File file) async {
    // Extraire l'extension proprement (le chemin peut contenir des query strings)
    final baseName = file.path.split('/').last.split('?').first;
    final dotIndex = baseName.lastIndexOf('.');
    final ext = dotIndex != -1
        ? baseName.substring(dotIndex + 1).toLowerCase()
        : 'jpg';

    // Normaliser : jpeg → jpg, png, webp, heic → jpg
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
