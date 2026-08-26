import 'package:flutter_test/flutter_test.dart';
import 'package:noryva_mobile/features/goals/domain/energy_calculator.dart';

void main() {
  EnergyInput input({
    CalculationSex sex = CalculationSex.male,
    ActivityLevel activity = ActivityLevel.low,
    GoalKind goal = GoalKind.maintainWeight,
    double? rate,
    double weight = 80,
  }) => EnergyInput(
    sex: sex,
    age: 30,
    heightCm: 180,
    weightKg: weight,
    activity: activity,
    goal: goal,
    rateKgPerWeek: rate,
  );
  test('male Mifflin-St Jeor example', () {
    expect(EnergyCalculator.calculate(input()).bmr, 1780);
  });
  test('female Mifflin-St Jeor example', () {
    expect(
      EnergyCalculator.calculate(input(sex: CalculationSex.female)).bmr,
      1614,
    );
  });
  test('maintenance has no adjustment', () {
    final p = EnergyCalculator.calculate(input());
    expect(p.goalAdjustment, 0);
    expect(p.dailyCalories, 2136);
  });
  test('weight loss applies 0.5 kg weekly deficit', () {
    final p = EnergyCalculator.calculate(
      input(goal: GoalKind.loseWeight, rate: .5),
    );
    expect(p.goalAdjustment, closeTo(-550, 1e-9));
    expect(p.dailyCalories, 1586);
  });
  test('weight gain applies 0.25 kg weekly surplus', () {
    final p = EnergyCalculator.calculate(
      input(goal: GoalKind.gainWeight, rate: .25),
    );
    expect(p.goalAdjustment, 275);
    expect(p.dailyCalories, 2411);
  });
  test('each activity multiplier is exact', () {
    expect(
      EnergyCalculator.calculate(input(activity: ActivityLevel.low))
          .maintenanceCalories,
      2136,
    );
    expect(
      EnergyCalculator.calculate(input(activity: ActivityLevel.light))
          .maintenanceCalories,
      2447.5,
    );
    expect(
      EnergyCalculator.calculate(input(activity: ActivityLevel.moderate))
          .maintenanceCalories,
      2759,
    );
    expect(
      EnergyCalculator.calculate(input(activity: ActivityLevel.high))
          .maintenanceCalories,
      3070.5,
    );
  });
  test('each supported rate maps to deterministic adjustment', () {
    for (final pair in const [(0.25, 275.0), (0.5, 550.0), (0.75, 825.0)]) {
      expect(
        EnergyCalculator.calculate(
          input(goal: GoalKind.gainWeight, rate: pair.$1),
        ).goalAdjustment,
        pair.$2,
      );
    }
  });
  test('female safety floor clamps and explains', () {
    final p = EnergyCalculator.calculate(
      EnergyInput(
        sex: CalculationSex.female,
        age: 80,
        heightCm: 140,
        weightKg: 40,
        activity: ActivityLevel.low,
        goal: GoalKind.loseWeight,
        rateKgPerWeek: .75,
      ),
    );
    expect(p.dailyCalories, 1200);
    expect(p.wasClamped, isTrue);
    expect(p.clampReason, isNotEmpty);
  });
  test('macros are deterministic expected values', () {
    final p = EnergyCalculator.calculate(input());
    expect(p.proteinG, 128);
    expect(p.fatG, 64);
    expect(p.carbohydrateG, 262);
  });
  test('invalid body and goal rate inputs are rejected', () {
    expect(
      () => EnergyCalculator.calculate(input(weight: 20)),
      throwsArgumentError,
    );
    expect(
      () =>
          EnergyCalculator.calculate(input(goal: GoalKind.loseWeight, rate: 1)),
      throwsArgumentError,
    );
  });
}
