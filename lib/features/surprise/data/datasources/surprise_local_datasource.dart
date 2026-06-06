import 'package:shared_preferences/shared_preferences.dart';

class SurpriseLocalDatasource {
  static const _allCodesKey = 'joined_surprise_codes';
  static const _createdCodesKey = 'created_surprise_codes';
  static const _tokenPrefix = 'creator_token_';

  Future<List<String>> getSavedCodes() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_allCodesKey) ?? [];
  }

  Future<Set<String>> getCreatedCodes() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getStringList(_createdCodesKey) ?? []).toSet();
  }

  Future<void> saveCode(String code) async {
    final prefs = await SharedPreferences.getInstance();
    final codes = prefs.getStringList(_allCodesKey) ?? [];
    if (!codes.contains(code)) {
      codes.add(code);
      await prefs.setStringList(_allCodesKey, codes);
    }
  }

  Future<void> saveCreatedCode(String code) async {
    final prefs = await SharedPreferences.getInstance();
    final codes = prefs.getStringList(_createdCodesKey) ?? [];
    if (!codes.contains(code)) {
      codes.add(code);
      await prefs.setStringList(_createdCodesKey, codes);
    }
  }

  Future<void> removeSavedCode(String code) async {
    final prefs = await SharedPreferences.getInstance();
    final codes = prefs.getStringList(_allCodesKey) ?? [];
    codes.remove(code);
    await prefs.setStringList(_allCodesKey, codes);
  }

  Future<void> removeCreatedCode(String code) async {
    final prefs = await SharedPreferences.getInstance();
    final codes = prefs.getStringList(_createdCodesKey) ?? [];
    codes.remove(code);
    await prefs.setStringList(_createdCodesKey, codes);
  }

  Future<void> saveCreatorToken(String surpriseId, String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('$_tokenPrefix$surpriseId', token);
  }

  Future<String?> getCreatorToken(String surpriseId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('$_tokenPrefix$surpriseId');
  }
}
