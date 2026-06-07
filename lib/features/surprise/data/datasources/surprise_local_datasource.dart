import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

class SurpriseLocalDatasource {
  static const _allCodesKey = 'joined_surprise_codes';
  static const _userTokenKey = 'user_creator_token';

  // Conservé uniquement pour la rétrocompatibilité (surprises créées avant la migration).
  static const _legacyTokenPrefix = 'creator_token_';

  // ── Token utilisateur ──────────────────────────────────────────────────────

  /// Retourne le token utilisateur unique. Le génère et le persiste s'il n'existe pas encore.
  Future<String> getUserToken() async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString(_userTokenKey);
    if (token == null) {
      token = _generateUuid();
      await prefs.setString(_userTokenKey, token);
    }
    return token;
  }

  /// Sauvegarde un token utilisateur (utilisé lors de la récupération sur un nouvel appareil).
  Future<void> saveUserToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userTokenKey, token);
  }

  /// Retourne le token à utiliser pour une surprise donnée :
  /// - D'abord l'éventuel token legacy par surprise (créé avant la migration).
  /// - Sinon le token utilisateur global.
  Future<String?> getCreatorToken(String surpriseId) async {
    final prefs = await SharedPreferences.getInstance();
    final legacy = prefs.getString('$_legacyTokenPrefix$surpriseId');
    if (legacy != null) return legacy;
    return prefs.getString(_userTokenKey);
  }

  // ── Codes de partage ────────────────────────────────────────────────────────

  Future<List<String>> getSavedCodes() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_allCodesKey) ?? [];
  }

  Future<void> saveCode(String code) async {
    final prefs = await SharedPreferences.getInstance();
    final codes = prefs.getStringList(_allCodesKey) ?? [];
    if (!codes.contains(code)) {
      codes.add(code);
      await prefs.setStringList(_allCodesKey, codes);
    }
  }

  Future<void> removeCode(String code) async {
    final prefs = await SharedPreferences.getInstance();
    final codes = prefs.getStringList(_allCodesKey) ?? [];
    codes.remove(code);
    await prefs.setStringList(_allCodesKey, codes);
  }

  // ── UUID v4 ────────────────────────────────────────────────────────────────

  /// Génère un UUID v4 aléatoire (format xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx).
  String _generateUuid() {
    final rng = Random.secure();
    final bytes = List<int>.generate(16, (_) => rng.nextInt(256));
    bytes[6] = (bytes[6] & 0x0f) | 0x40; // version 4
    bytes[8] = (bytes[8] & 0x3f) | 0x80; // variant 10xx
    final hex = bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
    return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-'
        '${hex.substring(12, 16)}-${hex.substring(16, 20)}-${hex.substring(20)}';
  }
}
