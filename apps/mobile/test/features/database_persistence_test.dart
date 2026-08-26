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
    await db.close();

    db = await AppDatabase.open(file: file);
    final incomplete = await db.profile();
    expect(incomplete!['anonymous_user_id'], id);
    expect(incomplete['onboarding_step'], 2);
    expect(incomplete['goal'], 'loseWeight');
    expect(incomplete['onboarding_completed'], 0);
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
    expect(p['protein_target'], 120);
    expect(p['carbohydrate_target'], 180);
    expect(p['fat_target'], 55);
    await db.close();
  });
  test('diary create, edit, snapshots, delete and reset persist', () async {
    var db = await AppDatabase.open(file: file);
    final chicken = (await db.searchFoods('chicken')).single;
    await db.logFood(
      food: chicken,
      canonicalQuantity: 150,
      servingDescription: '150 g',
      meal: MealType.lunch,
      loggedAt: DateTime.now(),
    );
    await db.close();
    db = await AppDatabase.open(file: file);
    var entries = await db.diaryFor(DateTime.now());
    expect(entries.single.energy, 247.5);
    final entryId = entries.single.id;
    await db.editEntry(entryId, canonicalQuantity: 200, meal: MealType.dinner);
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
        canonicalQuantity: 150,
        servingDescription: '150 g',
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

  test('serving definitions persist for mass, units and volume', () async {
    var db = await AppDatabase.open(file: file);
    expect(
      (await db.servingsForFood('chicken-breast')).map((item) => item.label),
      contains('100 g'),
    );
    expect(
      (await db.servingsForFood('egg')).map((item) => item.label),
      containsAll(<String>['100 g', '1 large egg']),
    );
    await db.close();

    db = await AppDatabase.open(file: file);
    final milk = await db.servingsForFood('milk');
    expect(
      milk.map((item) => item.label),
      containsAll(<String>['100 ml', '250 ml glass']),
    );
    expect(
      milk.singleWhere((item) => item.id == 'milk-glass').canonicalQuantity,
      250,
    );
    await db.close();
  });

  test('search is case insensitive and retains prefix ranking', () async {
    final db = await AppDatabase.open(file: file);
    for (final query in const ['chicken', 'Chicken', 'CHICKEN']) {
      final results = await db.searchFoods(query);
      expect(results.first.name, 'Chicken breast');
    }
    await db.close();
  });

  test('actual recent diary history is ranked after database reopen', () async {
    var db = await AppDatabase.open(file: file);
    final banana = (await db.searchFoods('banana')).single;
    final chicken = (await db.searchFoods('chicken')).single;
    await db.logFood(
      food: banana,
      canonicalQuantity: 118,
      servingDescription: '1 medium banana',
      meal: MealType.breakfast,
      loggedAt: DateTime.now().subtract(const Duration(minutes: 2)),
    );
    await db.logFood(
      food: chicken,
      canonicalQuantity: 100,
      servingDescription: '100 g',
      meal: MealType.lunch,
      loggedAt: DateTime.now(),
    );
    await db.close();

    db = await AppDatabase.open(file: file);
    final sections = await db.foodSearchSections();
    expect(sections.recent.map((item) => item.name), <String>[
      'Chicken breast',
      'Banana',
    ]);
    expect((await db.searchFoods('')).first.name, 'Chicken breast');
    await db.close();
  });
}
