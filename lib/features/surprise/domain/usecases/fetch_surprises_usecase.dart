import '../entities/surprise.dart';
import '../repositories/i_surprise_repository.dart';

class FetchSurprisesUseCase {
  final ISurpriseRepository _repository;
  ISurpriseRepository get repository => _repository;
  const FetchSurprisesUseCase(this._repository);

  Future<List<Surprise>> call() async {
    final codes = await _repository.getSavedCodes();
    return _repository.getSurprises(codes);
  }
}
