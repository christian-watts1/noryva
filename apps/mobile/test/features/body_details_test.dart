import 'package:flutter_test/flutter_test.dart';
import 'package:noryva_mobile/features/onboarding/domain/body_details.dart';

void main() {
  test('metric and imperial conversions', () {
    expect(BodyDetails.height(HeightUnit.centimetres, '180.5', ''), 180.5);
    expect(
      BodyDetails.height(HeightUnit.feetInches, '5', '11'),
      closeTo(180.34, 1e-9),
    );
    expect(BodyDetails.weight(WeightUnit.kilograms, '80.5', ''), 80.5);
    expect(
      BodyDetails.weight(WeightUnit.stonesPounds, '12', '8'),
      closeTo(79.83225712, 1e-9),
    );
    expect(
      BodyDetails.weight(WeightUnit.pounds, '176', ''),
      closeTo(79.83225712, 1e-9),
    );
  });
  test('ranges and malformed or incomplete values are rejected', () {
    for (final value in [null, 119.99, 230.01, double.nan, double.infinity]) {
      expect(BodyDetails.validHeight(value), isFalse);
    }
    for (final value in [null, 34.99, 300.01, double.nan, double.infinity]) {
      expect(BodyDetails.validWeight(value), isFalse);
    }
    for (final value in [120.0, 230.0]) {
      expect(BodyDetails.validHeight(value), isTrue);
    }
    for (final value in [35.0, 300.0]) {
      expect(BodyDetails.validWeight(value), isTrue);
    }
    for (final value in ['', 'abc', '-1', 'NaN', '1e2', '1.2.3']) {
      expect(BodyDetails.number(value), isNull);
    }
    expect(BodyDetails.height(HeightUnit.feetInches, '5', '12'), isNull);
    expect(BodyDetails.height(HeightUnit.feetInches, '5', ''), isNull);
    expect(BodyDetails.height(HeightUnit.feetInches, '5.5', '1'), isNull);
    expect(BodyDetails.weight(WeightUnit.stonesPounds, '12', '14'), isNull);
    expect(BodyDetails.weight(WeightUnit.stonesPounds, '12', ''), isNull);
    expect(
      BodyDetails.validHeight(
        BodyDetails.height(HeightUnit.feetInches, '3', '0'),
      ),
      isFalse,
    );
    expect(
      BodyDetails.validHeight(
        BodyDetails.height(HeightUnit.feetInches, '8', '0'),
      ),
      isFalse,
    );
    expect(
      BodyDetails.validWeight(
        BodyDetails.weight(WeightUnit.stonesPounds, '50', '0'),
      ),
      isFalse,
    );
    expect(
      BodyDetails.validWeight(BodyDetails.weight(WeightUnit.pounds, '700', '')),
      isFalse,
    );
  });
  test('UK DOB formatting and exact birthday age validation', () {
    final now = DateTime(2026, 9, 6);
    expect(BodyDetails.formatDob(DateTime(1990, 1, 2)), '02/01/1990');
    expect(BodyDetails.validDob(DateTime(2008, 9, 6), now), isTrue);
    expect(BodyDetails.validDob(DateTime(2008, 9, 7), now), isFalse);
    expect(BodyDetails.validDob(DateTime(1925, 9, 7), now), isTrue);
    expect(BodyDetails.validDob(DateTime(1925, 9, 6), now), isFalse);
    expect(BodyDetails.validDob(DateTime(2027), now), isFalse);
    expect(BodyDetails.validDob(null, now), isFalse);
    expect(BodyDetails.age(DateTime(2004, 2, 29), DateTime(2022, 2, 28)), 17);
    expect(BodyDetails.age(DateTime(2004, 2, 29), DateTime(2022, 3, 1)), 18);
  });
}
