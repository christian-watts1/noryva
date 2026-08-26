import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:noryva_mobile/core/database/app_database.dart';
import 'package:noryva_mobile/features/diary/domain/diary_entry.dart';
import 'package:noryva_mobile/features/goals/domain/energy_calculator.dart';

void main() {
  late Directory temp;
  late File file;
  setUp(() {
    temp = Directory.systemTemp.createTempSync('noryva_test_');
    file = File('${temp.path}/test.sqlite');
  });
  tearDown(() => temp.deleteSync(recursive: true));
  test('identity, onboarding and calculated targets survive reopen', () async {
    var db = await AppDatabase.open(file: file);
    final id = await db.ensureIdentity();
    await db.saveOnboarding(step: 2, goal: 'loseWeight');
    await db.savePlan(
      bmr: 1700,
      maintenance: 2200,
      adjustment: -500,
      calories: 1700,
      protein: 120,
      carbs: 180,
      fat: 55,
      clamped: false,
    );
    await db.completeOnboarding();
    await db.close();
    db = await AppDatabase.open(file: file);
    final p = await db.profile();
    expect(p!['anonymous_user_id'], id);
    expect(p['goal'], 'loseWeight');
    expect(p['onboarding_completed'], 1);
    expect(p['calorie_target'], 1700);
    await db.close();
  });
  test('diary create, edit, snapshots, delete and reset persist', () async {
    var db = await AppDatabase.open(file: file);
    final chicken = (await db.searchFoods('chicken')).single;
    await db.logFood(
      food: chicken,
      grams: 150,
      meal: MealType.lunch,
      loggedAt: DateTime.now(),
    );
    await db.close();
    db = await AppDatabase.open(file: file);
    var entries = await db.diaryFor(DateTime.now());
    expect(entries.single.energy, 247.5);
    final entryId = entries.single.id;
    await db.editEntry(entryId, grams: 200, meal: MealType.dinner);
    await db.close();
    db = await AppDatabase.open(file: file);
    entries = await db.diaryFor(DateTime.now());
    expect(entries.single.meal, MealType.dinner);
    expect(entries.single.energy, 330);
    await db.updateFoodEnergyForTest('chicken-breast', 999);
    entries = await db.diaryFor(DateTime.now());
    expect(entries.single.energy, 330, reason: 'history uses snapshots');
    await db.deleteEntry(entryId);
    await db.close();
    db = await AppDatabase.open(file: file);
    expect(await db.diaryFor(DateTime.now()), isEmpty);
    final oldId = await db.ensureIdentity();
    await db.resetLocalData();
    expect((await db.profile())!['anonymous_user_id'], isNot(oldId));
    expect(
      await db.searchFoods('chicken'),
      isNotEmpty,
      reason: 'seed data remains after reset',
    );
    await db.close();
  });

  test(
    'required journey data remains correct after application reopen',
    () async {
      var db = await AppDatabase.open(file: file);
      await db.saveOnboarding(
        step: 4,
        goal: GoalKind.loseWeight.name,
        dateOfBirth: DateTime(1996, 1, 1).toIso8601String(),
        sex: CalculationSex.male.name,
        heightCm: 180,
        weightKg: 80,
        activity: ActivityLevel.moderate.name,
        goalWeightKg: 75,
        rateKgWeek: .5,
      );
      final plan = EnergyCalculator.calculate(
        const EnergyInput(
          sex: CalculationSex.male,
          age: 30,
          heightCm: 180,
          weightKg: 80,
          activity: ActivityLevel.moderate,
          goal: GoalKind.loseWeight,
          rateKgPerWeek: .5,
        ),
      );
      await db.savePlan(
        bmr: plan.bmr,
        maintenance: plan.maintenanceCalories,
        adjustment: plan.goalAdjustment,
        calories: plan.dailyCalories,
        protein: plan.proteinG,
        carbs: plan.carbohydrateG,
        fat: plan.fatG,
        clamped: plan.wasClamped,
      );
      await db.completeOnboarding();
      final chicken = (await db.searchFoods('chicken')).single;
      await db.logFood(
        food: chicken,
        grams: 150,
        meal: MealType.lunch,
        loggedAt: DateTime.now(),
      );
      await db.close();

      db = await AppDatabase.open(file: file);
      expect((await db.profile())!['onboarding_completed'], 1);
      final diary = await db.diaryFor(DateTime.now());
      expect(diary.single.foodName, 'Chicken breast');
      expect(diary.single.meal, MealType.lunch);
      expect(diary.single.energy, 247.5);
      expect(diary.fold(0.0, (sum, entry) => sum + entry.energy), 247.5);
      await db.close();
    },
  );
}
