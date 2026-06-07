import 'dart:io';
import '../entities/surprise.dart';

abstract class ISurpriseRepository {
  // ── Remote ────────────────────────────────────────────────────────────────
  Future<({List<Surprise> owned, List<Surprise> joined})> getSurprises(
    List<String> codes,
  );
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
    required String creatorToken,
    required String emoji,
    required String title,
    required String subtitle,
    required String color,
  });
  Future<void> updateElement({
    required String id,
    required String creatorToken,
    required String type,
    required String label,
    required String content,
    required String unlockCode,
    required int sortOrder,
  });
  Future<void> deleteSurprise({
    required String id,
    required String creatorToken,
  });
  Future<void> deleteElement({
    required String id,
    required String creatorToken,
  });
  Future<void> addElement({
    required String surpriseId,
    required String creatorToken,
    required String type,
    required String label,
    required String content,
    required String unlockCode,
    required int sortOrder,
  });
  Future<String> uploadImage(File file);

  // ── Local ─────────────────────────────────────────────────────────────────
  Future<List<String>> getSavedCodes();
  Future<void> saveCode(String code);
  Future<void> removeCode(String code);

  /// Retourne le token utilisateur unique (le génère si absent).
  Future<String> getUserToken();

  /// Retourne le token pour une surprise : legacy par surprise ou token utilisateur.
  Future<String?> getCreatorToken(String surpriseId);
}
