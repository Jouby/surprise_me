import 'package:flutter/foundation.dart';

import '../../domain/entities/surprise.dart';
import '../../domain/usecases/create_surprise_usecase.dart';
import '../../domain/usecases/delete_surprise_usecase.dart';
import '../../domain/usecases/fetch_surprises_usecase.dart';
import '../../domain/usecases/join_surprise_usecase.dart';

enum SurpriseLoadState { idle, loading, error }

class SurpriseProvider extends ChangeNotifier {
  final FetchSurprisesUseCase _fetchSurprises;
  final CreateSurpriseUseCase _createSurprise;
  final JoinSurpriseUseCase _joinSurprise;
  final DeleteSurpriseUseCase _deleteSurprise;

  SurpriseProvider({
    required FetchSurprisesUseCase fetchSurprises,
    required CreateSurpriseUseCase createSurprise,
    required JoinSurpriseUseCase joinSurprise,
    required DeleteSurpriseUseCase deleteSurprise,
  }) : _fetchSurprises = fetchSurprises,
       _createSurprise = createSurprise,
       _joinSurprise = joinSurprise,
       _deleteSurprise = deleteSurprise {
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
      _error = e.toString();
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

  Future<void> deleteSurprise({
    required String surpriseId,
    required String shareCode,
    required bool isOwner,
  }) async {
    await _deleteSurprise(
      surpriseId: surpriseId,
      shareCode: shareCode,
      isOwner: isOwner,
    );
    _ownedSurprises.removeWhere((s) => s.id == surpriseId);
    _joinedSurprises.removeWhere((s) => s.id == surpriseId);
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
