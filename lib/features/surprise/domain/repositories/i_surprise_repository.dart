import 'dart:io';
import '../entities/surprise.dart';

abstract class ISurpriseRepository {
  // ── Remote ────────────────────────────────────────────────────────────────
  Future<List<Surprise>> getSurprises(List<String> codes);
  Future<Surprise?> fetchByShareCode(String code);
  Future<String> createSurprise({
    required String emoji,
    required String title,
    required String subtitle,
    required String color,
    required List<Map<String, dynamic>> elements,
  });
  Future<void> updateSurprise({
    required String id,
    required String emoji,
    required String title,
    required String subtitle,
    required String color,
  });
  Future<void> updateElement({
    required String id,
    required String type,
    required String label,
    required String content,
    required String unlockCode,
  });
  Future<void> deleteSurprise(String id);
  Future<void> deleteElement(String id);
  Future<void> addElement({
    required String surpriseId,
    required String type,
    required String label,
    required String content,
    required String unlockCode,
    required int sortOrder,
  });
  Future<String> uploadImage(File file);

  // ── Local ─────────────────────────────────────────────────────────────────
  Future<List<String>> getSavedCodes();
  Future<Set<String>> getCreatedCodes();
  Future<void> saveCode(String code);
  Future<void> saveCreatedCode(String code);
  Future<void> removeSavedCode(String code);
  Future<void> removeCreatedCode(String code);
}
