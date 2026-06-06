import 'dart:io';
import '../repositories/i_surprise_repository.dart';

class UploadImageUseCase {
  final ISurpriseRepository _repository;
  const UploadImageUseCase(this._repository);

  Future<String> call(File file) => _repository.uploadImage(file);
}
