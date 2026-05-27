// Basic unit tests for shared utilities. End-to-end flows live in
// `integration_test/` and run on a real device or emulator.

import 'package:flutter_test/flutter_test.dart';

import 'package:driver/core/utils/ethiopia_phone.dart';

void main() {
  group('normalizeEthiopiaPhone', () {
    test('accepts 09… local format and returns +251 E.164', () {
      expect(normalizeEthiopiaPhone('0912345678'), '+251912345678');
    });

    test('accepts 251… and 9-digit raw mobile numbers', () {
      expect(normalizeEthiopiaPhone('251912345678'), '+251912345678');
      expect(normalizeEthiopiaPhone('912345678'), '+251912345678');
    });

    test('accepts +251 E.164 unchanged', () {
      expect(normalizeEthiopiaPhone('+251912345678'), '+251912345678');
    });

    test('rejects empty or clearly invalid input', () {
      expect(normalizeEthiopiaPhone(''), isNull);
      expect(normalizeEthiopiaPhone('abc'), isNull);
      expect(normalizeEthiopiaPhone('123'), isNull);
    });
  });
}
