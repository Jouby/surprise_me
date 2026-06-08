import 'package:shared_preferences/shared_preferences.dart';

/// Persiste localement les IDs des éléments Gratte-moi déjà grattés.
class ScratchLocalDatasource {
  static const _key = 'scratched_element_ids';

  Future<bool> isScratched(String elementId) async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getStringList(_key) ?? []).contains(elementId);
  }

  Future<void> markScratched(String elementId) async {
    final prefs = await SharedPreferences.getInstance();
    final ids = prefs.getStringList(_key) ?? [];
    if (!ids.contains(elementId)) {
      ids.add(elementId);
      await prefs.setStringList(_key, ids);
    }
  }

  Future<void> clearElements(List<String> elementIds) async {
    if (elementIds.isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    final ids = prefs.getStringList(_key) ?? [];
    ids.removeWhere(elementIds.contains);
    await prefs.setStringList(_key, ids);
  }

  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
