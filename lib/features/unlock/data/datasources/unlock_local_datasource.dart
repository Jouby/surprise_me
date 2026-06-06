import 'package:shared_preferences/shared_preferences.dart';

class UnlockLocalDatasource {
  static const _key = 'unlocked_codes';

  Future<Set<String>> loadCodes() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getStringList(_key) ?? []).toSet();
  }

  Future<void> saveCode(String code) async {
    final prefs = await SharedPreferences.getInstance();
    final codes = prefs.getStringList(_key) ?? [];
    if (!codes.contains(code)) {
      codes.add(code);
      await prefs.setStringList(_key, codes);
    }
  }
}
