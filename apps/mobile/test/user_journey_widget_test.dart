import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noryva_mobile/app/app.dart';
import 'package:noryva_mobile/core/database/app_database.dart';
import 'package:noryva_mobile/features/diary/domain/diary_entry.dart';

void main() {
  testWidgets(
    'fresh onboarding, food logging and real database restart journey',
    (tester) async {
      final temp = Directory.systemTemp.createTempSync('noryva_widget_');
      final file = File('${temp.path}/journey.sqlite');
      addTearDown(() async {
        if (temp.existsSync()) {
          temp.deleteSync(recursive: true);
        }
      });

      var database = await AppDatabase.open(file: file);
      addTearDown(() async {
        try {
          await database.close();
        } on Exception {
          // The journey closes both real database instances explicitly.
        }
      });
      await _pumpApplication(tester, database);

      expect(find.text('Track less. Know more.'), findsOneWidget);
      await _tapText(tester, 'Get started');
      await _tapText(tester, 'Lose weight');
      await _tapText(tester, 'Continue');

      await tester.tap(find.text('Sex used for energy calculation'));
      await tester.pumpAndSettle();
      await _tapText(tester, 'male', last: true);
      await _tapText(tester, 'Select date of birth');
      await _tapText(tester, 'OK');
      await tester.enterText(
        find.widgetWithText(TextField, 'Height (cm)'),
        '180',
      );
      await tester.enterText(
        find.widgetWithText(TextField, 'Current weight (kg)'),
        '80',
      );
      await _tapText(tester, 'Continue');

      await _tapText(
        tester,
        'Moderate activity — Regular movement or exercise several times a week.',
      );
      await _tapText(tester, 'Continue');
      await tester.enterText(
        find.widgetWithText(TextField, 'Goal weight (kg)'),
        '75',
      );
      await _tapText(tester, 'Continue');

      expect(find.text('YOUR NORYVA PLAN'), findsOneWidget);
      expect(find.text('How was this calculated?'), findsOneWidget);
      await _tapText(tester, 'Start tracking');
      await _revealText(tester, 'Search food');
      expect(find.text('Search food'), findsOneWidget);

      await _tapText(tester, 'Search food');
      await tester.enterText(find.byType(SearchBar), 'chicken');
      await tester.pumpAndSettle();
      await _tapText(tester, 'Chicken breast');

      await tester.tap(find.text('100 g'));
      await tester.pumpAndSettle();
      await _tapText(tester, 'Custom g', last: true);
      await tester.enterText(
        find.widgetWithText(TextField, 'Quantity (g)'),
        '150',
      );
      await tester.tap(find.byType(DropdownButtonFormField<MealType>));
      await tester.pumpAndSettle();
      await _tapText(tester, 'lunch', last: true);
      expect(find.text('247.5 kcal'), findsOneWidget);
      await _tapText(tester, 'Log food');

      await _tapText(tester, 'Diary');
      expect(find.text('Chicken breast'), findsOneWidget);
      expect(find.textContaining('248 /'), findsOneWidget);
      final beforeRestart = await database.diaryFor(DateTime.now());
      expect(beforeRestart.single.energy, 247.5);

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
      await database.close();
      database = await AppDatabase.open(file: file);
      await _pumpApplication(tester, database);

      expect(find.text('Track less. Know more.'), findsNothing);
      await _revealText(tester, 'Search food');
      expect(find.text('Search food'), findsOneWidget);
      await _tapText(tester, 'Diary');
      expect(find.text('Chicken breast'), findsOneWidget);
      expect(find.textContaining('248 /'), findsOneWidget);
      final afterRestart = await database.diaryFor(DateTime.now());
      expect(afterRestart.single.energy, 247.5);
      await database.close();
    },
  );

  testWidgets('welcome semantics and enlarged text remain usable', (
    tester,
  ) async {
    tester.platformDispatcher.textScaleFactorTestValue = 1.6;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    final database = await AppDatabase.memory();
    addTearDown(database.close);
    final semantics = tester.ensureSemantics();

    await _pumpApplication(tester, database);
    expect(find.text('Track less. Know more.'), findsOneWidget);
    expect(find.text('Get started'), findsOneWidget);
    expect(tester.getSize(find.text('Get started')).height, greaterThan(0));
    semantics.dispose();
  });

  testWidgets('core tracking screens tolerate enlarged text', (tester) async {
    tester.platformDispatcher.textScaleFactorTestValue = 1.6;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    final database = await AppDatabase.memory();
    addTearDown(database.close);
    await database.savePlan(
      bmr: 1700,
      maintenance: 2200,
      adjustment: 0,
      calories: 2200,
      protein: 130,
      carbs: 250,
      fat: 70,
      clamped: false,
    );
    await database.completeOnboarding();
    final chicken = (await database.searchFoods('chicken')).single;
    await database.logFood(
      food: chicken,
      canonicalQuantity: 100,
      servingDescription: '100 g',
      meal: MealType.lunch,
      loggedAt: DateTime.now(),
    );

    await _pumpApplication(tester, database);
    await _revealText(tester, 'Search food');
    expect(find.text('Search food'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await _tapText(tester, 'Search food');
    expect(find.text('COMMON'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pageBack();
    await tester.pumpAndSettle();
    await _tapText(tester, 'Diary');
    expect(find.text('Chicken breast'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

Future<void> _pumpApplication(WidgetTester tester, AppDatabase database) async {
  await tester.pumpWidget(
    ProviderScope(
      key: UniqueKey(),
      overrides: [databaseProvider.overrideWithValue(database)],
      child: const NoryvaApp(),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> _tapText(
  WidgetTester tester,
  String text, {
  bool last = false,
}) async {
  final finder = find.text(text);
  await tester.ensureVisible(last ? finder.last : finder.first);
  await tester.pumpAndSettle();
  await tester.tap(last ? finder.last : finder.first);
  await tester.pumpAndSettle();
}

Future<void> _revealText(WidgetTester tester, String text) async {
  final finder = find.text(text);
  if (finder.evaluate().isEmpty) {
    await tester.scrollUntilVisible(
      finder,
      250,
      scrollable: find
          .descendant(
            of: find.byType(ListView).first,
            matching: find.byType(Scrollable),
          )
          .first,
    );
  }
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
}
