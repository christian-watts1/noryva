enum HeightUnit { centimetres, feetInches }

enum WeightUnit { kilograms, stonesPounds, pounds }

abstract final class BodyDetails {
  static const cmPerInch = 2.54;
  static const kgPerPound = 0.45359237;

  static double? number(String text) =>
      RegExp(r'^\d+(\.\d+)?$').hasMatch(text) ? double.tryParse(text) : null;

  static double? height(HeightUnit unit, String main, String component) {
    final value = number(main);
    if (value == null) return null;
    if (unit == HeightUnit.centimetres) return value;
    final inches = int.tryParse(component);
    if (int.tryParse(main) == null ||
        inches == null ||
        inches < 0 ||
        inches > 11) {
      return null;
    }
    return (value * 12 + inches) * cmPerInch;
  }

  static double? weight(WeightUnit unit, String main, String component) {
    final value = number(main);
    if (value == null) return null;
    if (unit == WeightUnit.kilograms) return value;
    if (unit == WeightUnit.pounds) return value * kgPerPound;
    final pounds = int.tryParse(component);
    if (int.tryParse(main) == null ||
        pounds == null ||
        pounds < 0 ||
        pounds > 13) {
      return null;
    }
    return (value * 14 + pounds) * kgPerPound;
  }

  static bool validHeight(double? value) =>
      value != null && value.isFinite && value >= 120 && value <= 230;
  static bool validWeight(double? value) =>
      value != null && value.isFinite && value >= 35 && value <= 300;

  static int age(DateTime dob, DateTime today) =>
      today.year -
      dob.year -
      (today.month < dob.month ||
              (today.month == dob.month && today.day < dob.day)
          ? 1
          : 0);
  static bool validDob(DateTime? dob, DateTime today) =>
      dob != null &&
      !dob.isAfter(today) &&
      age(dob, today) >= 18 &&
      age(dob, today) <= 100;
  static String formatDob(DateTime dob) =>
      '${dob.day.toString().padLeft(2, '0')}/${dob.month.toString().padLeft(2, '0')}/${dob.year.toString().padLeft(4, '0')}';
}
