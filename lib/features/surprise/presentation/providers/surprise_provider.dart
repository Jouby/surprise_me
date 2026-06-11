import 'package:flutter/foundation.dart';

import '../../../../core/utils/error_utils.dart';

import '../../../../core/services/local_cleanup_service.dart';
import '../../../unlock/domain/repositories/i_unlock_repository.dart';
import '../../domain/entities/surprise.dart';
import '../../domain/usecases/create_surprise_usecase.dart';
import '../../domain/usecases/delete_surprise_usecase.dart';
import '../../domain/usecases/fetch_surprises_usecase.dart';
import '../../domain/usecases/join_surprise_usecase.dart';
import '../../domain/usecases/update_surprise_usecase.dart';

enum SurpriseLoadState { idle, loading, error }

class SurpriseProvider extends ChangeNotifier {
  final FetchSurprisesUseCase _fetchSurprises;
  final CreateSurpriseUseCase _createSurprise;
  final JoinSurpriseUseCase _joinSurprise;
  final DeleteSurpriseUseCase _deleteSurprise;
  final UpdateSurpriseUseCase _updateSurprise;
  final IUnlockRepository _unlockRepository;

  SurpriseProvider({
    required FetchSurprisesUseCase fetchSurprises,
    required CreateSurpriseUseCase createSurprise,
    required JoinSurpriseUseCase joinSurprise,
    required DeleteSurpriseUseCase deleteSurprise,
    required UpdateSurpriseUseCase updateSurprise,
    required IUnlockRepository unlockRepository,
  }) : _fetchSurprises = fetchSurprises,
       _createSurprise = createSurprise,
       _joinSurprise = joinSurprise,
       _deleteSurprise = deleteSurprise,
       _updateSurprise = updateSurprise,
       _unlockRepository = unlockRepository {
    load();
  }

  List<Surprise> _ownedSurprises = [];
  List<Surprise> _joinedSurprises = [];
  SurpriseLoadState _state = SurpriseLoadState.idle;
  String? _error;

  List<Surprise> get surprises => [..._ownedSurprises, ..._joinedSurprises];
  List<Surprise> get createdSurprises => _ownedSurprises;
  List<Surprise> get joinedSurprises => _joinedSurprises;

  bool isOwner(String surpriseId) =>
      _ownedSurprises.any((s) => s.id == surpriseId);

  SurpriseLoadState get state => _state;
  String? get error => _error;
  bool get isLoading => _state == SurpriseLoadState.loading;

  Future<void> load() async {
    _state = SurpriseLoadState.loading;
    _error = null;
    notifyListeners();
    try {
      final result = await _fetchSurprises();
      _ownedSurprises = result.owned;
      _joinedSurprises = result.joined;
      _state = SurpriseLoadState.idle;
    } catch (e) {
      _state = SurpriseLoadState.error;
      _error = errorMessageRaw(e);
    }
    notifyListeners();
  }

  Future<Surprise?> joinByShareCode(String code) async {
    try {
      final surprise = await _joinSurprise(code);
      if (surprise != null) {
        // Une surprise rejointe n'est jamais owned (token différent).
        if (!_joinedSurprises.any((s) => s.id == surprise.id)) {
          _joinedSurprises = [..._joinedSurprises, surprise];
          notifyListeners();
        }
      }
      return surprise;
    } catch (_) {
      // En cas d'erreur réseau, on retourne null pour que la sheet
      // affiche "code introuvable" plutôt que de rester bloquée.
      return null;
    }
  }

  Future<String> getUserToken() => _fetchSurprises.repository.getUserToken();

  Future<List<String>> getSavedCodes() =>
      _fetchSurprises.repository.getSavedCodes();

  Future<void> update(UpdateSurpriseParams params) async {
    await _updateSurprise(params);
    await load();
  }

  Future<void> deleteSurprise({
    required String surpriseId,
    required String shareCode,
    required bool isOwner,
    required List<String> elementIds,
  }) async {
    await Future.wait([
      _deleteSurprise(
        surpriseId: surpriseId,
        shareCode: shareCode,
        isOwner: isOwner,
      ),
      LocalCleanupService().cleanSurprise(
        surpriseId: surpriseId,
        elementIds: elementIds,
      ),
      _unlockRepository.clearForSurprise(surpriseId),
    ]);
    _ownedSurprises.removeWhere((s) => s.id == surpriseId);
    _joinedSurprises.removeWhere((s) => s.id == surpriseId);
    notifyListeners();
  }

  /// Supprime toutes les données de l'appareil :
  /// - Supprime les surprises créées sur Supabase
  /// - Vide la liste des codes de partage locaux (surprises rejointes)
  /// - Nettoie toute la progression des jeux
  Future<void> clearAllData() async {
    final owned = List<Surprise>.from(_ownedSurprises);

    // Supprime chaque surprise créée sur Supabase en parallèle.
    await Future.wait(
      owned.map(
        (s) => _deleteSurprise(
          surpriseId: s.id,
          shareCode: s.shareCode,
          isOwner: true,
        ).catchError((_) {}), // on continue même si une suppression échoue
      ),
    );

    // Vide les codes locaux, le cache mémoire unlock et toute la progression.
    await Future.wait([
      _fetchSurprises.repository.clearJoinedCodes(),
      _unlockRepository.clearAll(), // vide cache mémoire + SharedPreferences
      LocalCleanupService().clearAll(),
    ]);

    _ownedSurprises = [];
    _joinedSurprises = [];
    notifyListeners();
  }

  Future<String> create({
    required String emoji,
    required String title,
    required String subtitle,
    required String color,
    required List<Map<String, dynamic>> elements,
  }) async {
    final shareCode = await _createSurprise(
      emoji: emoji,
      title: title,
      subtitle: subtitle,
      color: color,
      elements: elements,
    );
    await load();
    return shareCode;
  }
}
