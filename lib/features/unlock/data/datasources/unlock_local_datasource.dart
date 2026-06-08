import 'package:shared_preferences/shared_preferences.dart';

class UnlockLocalDatasource {
  static String _key(String surpriseId) => 'unlocked_codes_$surpriseId';

  Future<Set<String>> loadCodes(String surpriseId) async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getStringList(_key(surpriseId)) ?? []).toSet();
  }

  Future<void> saveCode(String surpriseId, String code) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _key(surpriseId);
    final codes = prefs.getStringList(key) ?? [];
    if (!codes.contains(code)) {
      codes.add(code);
      await prefs.setStringList(key, codes);
    }
  }

  Future<void> clearCodes(String surpriseId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key(surpriseId));
  }
}
