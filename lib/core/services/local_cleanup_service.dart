import '../../features/unlock/data/datasources/unlock_local_datasource.dart';
import '../../features/scratch_game/data/datasources/scratch_local_datasource.dart';
import '../../features/motus_game/data/datasources/motus_local_datasource.dart';
import '../../features/code_game/data/datasources/code_local_datasource.dart';

/// Nettoie toutes les données locales associées à une surprise supprimée.
///
/// À appeler juste avant ou après la suppression distante d'une surprise.
/// Reçoit les IDs des éléments pour purger les états de jeu persistés.
class LocalCleanupService {
  final _unlock = UnlockLocalDatasource();
  final _scratch = ScratchLocalDatasource();
  final _motus = MotusLocalDatasource();
  final _code = CodeLocalDatasource();

  Future<void> cleanSurprise({
    required String surpriseId,
    required List<String> elementIds,
  }) async {
    await Future.wait([
      // Codes de déverrouillage (clé par surpriseId)
      _unlock.clearCodes(surpriseId),
      // États des jeux (clé par elementId)
      _scratch.clearElements(elementIds),
      _motus.clearElements(elementIds),
      _code.clearElements(elementIds),
    ]);
  }
}
