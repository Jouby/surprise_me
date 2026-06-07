import '../repositories/i_surprise_repository.dart';

class CreateSurpriseUseCase {
  final ISurpriseRepository _repository;
  const CreateSurpriseUseCase(this._repository);

  Future<String> call({
    required String emoji,
    required String title,
    required String subtitle,
    required String color,
    required List<Map<String, dynamic>> elements,
  }) async {
    final shareCode = await _repository.createSurprise(
      emoji: emoji,
      title: title,
      subtitle: subtitle,
      color: color,
      elements: elements,
    );
    // Sauvegarde le code dans la liste locale unifiée.
    await _repository.saveCode(shareCode);
    return shareCode;
  }
}
