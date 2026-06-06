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
  })  : _fetchSurprises = fetchSurprises,
        _createSurprise = createSurprise,
        _joinSurprise = joinSurprise,
        _deleteSurprise = deleteSurprise {
    load();
  }

  List<Surprise> _surprises = [];
  Set<String> _createdCodes = {};
  SurpriseLoadState _state = SurpriseLoadState.idle;
  String? _error;

  List<Surprise> get surprises => _surprises;
  List<Surprise> get createdSurprises =>
      _surprises.where((s) => _createdCodes.contains(s.shareCode)).toList();
  List<Surprise> get joinedSurprises =>
      _surprises.where((s) => !_createdCodes.contains(s.shareCode)).toList();
  bool isOwner(String shareCode) =>
      _createdCodes.contains(shareCode.toUpperCase());

  SurpriseLoadState get state => _state;
  String? get error => _error;
  bool get isLoading => _state == SurpriseLoadState.loading;

  Future<void> load() async {
    _state = SurpriseLoadState.loading;
    _error = null;
    notifyListeners();
    try {
      _surprises = await _fetchSurprises();
      _createdCodes = await _fetchSurprises.repository.getCreatedCodes();
      _state = SurpriseLoadState.idle;
    } catch (e) {
      _state = SurpriseLoadState.error;
      _error = e.toString();
    }
    notifyListeners();
  }

  Future<Surprise?> joinByShareCode(String code) async {
    final surprise = await _joinSurprise(code);
    if (surprise != null) {
      if (!_surprises.any((s) => s.id == surprise.id)) {
        _surprises = [..._surprises, surprise];
        notifyListeners();
      }
    }
    return surprise;
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
    _surprises.removeWhere((s) => s.id == surpriseId);
    _createdCodes.remove(shareCode);
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
