import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:surprise_me/features/surprise/data/datasources/surprise_local_datasource.dart';

void main() {
  late SurpriseLocalDatasource ds;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    ds = SurpriseLocalDatasource();
  });

  group('getUserToken', () {
    test('génère un token UUID valide au premier appel', () async {
      final token = await ds.getUserToken();
      final uuidRegex = RegExp(
        r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
      );
      expect(uuidRegex.hasMatch(token), isTrue);
    });

    test('retourne le même token à chaque appel', () async {
      final first = await ds.getUserToken();
      final second = await ds.getUserToken();
      expect(first, equals(second));
    });

    test('persiste le token entre instances', () async {
      final token = await ds.getUserToken();
      final ds2 = SurpriseLocalDatasource();
      final token2 = await ds2.getUserToken();
      expect(token, equals(token2));
    });
  });

  group('saveUserToken', () {
    test('écrase le token existant', () async {
      await ds.getUserToken(); // génère un premier token
      const custom = '00000000-0000-4000-8000-000000000000';
      await ds.saveUserToken(custom);
      final token = await ds.getUserToken();
      expect(token, equals(custom));
    });
  });

  group('getCreatorToken', () {
    test('retourne le user token quand il existe', () async {
      const token = '11111111-1111-4111-8111-111111111111';
      await ds.saveUserToken(token);
      final result = await ds.getCreatorToken('any-surprise-id');
      expect(result, equals(token));
    });

    test('retourne null si aucun token utilisateur', () async {
      final result = await ds.getCreatorToken('any-surprise-id');
      expect(result, isNull);
    });
  });

  group('saveCode / getSavedCodes / removeCode', () {
    test('sauvegarde et récupère les codes', () async {
      await ds.saveCode('ABC123');
      await ds.saveCode('DEF456');
      final codes = await ds.getSavedCodes();
      expect(codes, containsAll(['ABC123', 'DEF456']));
    });

    test('ignore les doublons', () async {
      await ds.saveCode('ABC123');
      await ds.saveCode('ABC123');
      final codes = await ds.getSavedCodes();
      expect(codes.where((c) => c == 'ABC123').length, equals(1));
    });

    test('supprime un code', () async {
      await ds.saveCode('ABC123');
      await ds.saveCode('DEF456');
      await ds.removeCode('ABC123');
      final codes = await ds.getSavedCodes();
      expect(codes, isNot(contains('ABC123')));
      expect(codes, contains('DEF456'));
    });
  });
}
