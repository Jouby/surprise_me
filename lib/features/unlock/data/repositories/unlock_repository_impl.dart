import '../../domain/repositories/i_unlock_repository.dart';
import '../datasources/unlock_local_datasource.dart';

class UnlockRepositoryImpl implements IUnlockRepository {
  final UnlockLocalDatasource _local;
  Set<String> _codes = {};

  UnlockRepositoryImpl(this._local);

  @override
  bool isUnlocked(String code) => _codes.contains(code.toUpperCase());

  @override
  Future<void> unlock(String code) async {
    _codes.add(code.toUpperCase());
    await _local.saveCode(code.toUpperCase());
  }

  @override
  Future<void> loadCodes() async {
    _codes = await _local.loadCodes();
  }
}
