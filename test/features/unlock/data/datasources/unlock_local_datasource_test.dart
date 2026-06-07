import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:surprise_me/features/unlock/data/datasources/unlock_local_datasource.dart';

void main() {
  late UnlockLocalDatasource ds;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    ds = UnlockLocalDatasource();
  });

  group('saveCode / loadCodes', () {
    test('sauvegarde et recharge un code pour une surprise', () async {
      await ds.saveCode('surprise-1', 'SECRET');
      final codes = await ds.loadCodes('surprise-1');
      expect(codes, contains('SECRET'));
    });

    test('les codes de deux surprises sont isolés', () async {
      await ds.saveCode('surprise-1', 'CODE_A');
      await ds.saveCode('surprise-2', 'CODE_B');

      final codes1 = await ds.loadCodes('surprise-1');
      final codes2 = await ds.loadCodes('surprise-2');

      expect(codes1, contains('CODE_A'));
      expect(codes1, isNot(contains('CODE_B')));
      expect(codes2, contains('CODE_B'));
      expect(codes2, isNot(contains('CODE_A')));
    });

    test('deux surprises avec le même code ne s\'interfèrent pas', () async {
      await ds.saveCode('surprise-1', 'SAME_CODE');
      final codes2 = await ds.loadCodes('surprise-2');
      expect(codes2, isEmpty);
    });

    test('ignore les doublons', () async {
      await ds.saveCode('surprise-1', 'SECRET');
      await ds.saveCode('surprise-1', 'SECRET');
      final codes = await ds.loadCodes('surprise-1');
      expect(codes.where((c) => c == 'SECRET').length, equals(1));
    });

    test('retourne un set vide si aucun code sauvegardé', () async {
      final codes = await ds.loadCodes('surprise-inconnue');
      expect(codes, isEmpty);
    });
  });
}
