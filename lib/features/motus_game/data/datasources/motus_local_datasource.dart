import 'package:shared_preferences/shared_preferences.dart';

/// Persiste localement les IDs des éléments Motus déjà résolus.
class MotusLocalDatasource {
  static const _key = 'solved_motus_element_ids';

  Future<bool> isSolved(String elementId) async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getStringList(_key) ?? []).contains(elementId);
  }

  Future<void> markSolved(String elementId) async {
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
