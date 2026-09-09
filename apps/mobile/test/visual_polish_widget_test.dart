import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:noryva_mobile/app/app.dart';
import 'package:noryva_mobile/core/database/app_database.dart';
import 'package:noryva_mobile/design_system/components/nutrition_components.dart';
import 'package:noryva_mobile/design_system/theme/theme.dart';
import 'package:noryva_mobile/features/diary/domain/diary_entry.dart';

Future<AppDatabase> seed() async {
  final db = await AppDatabase.memory();
  await db.savePlan(
    bmr: 1700,
    maintenance: 2200,
    adjustment: 0,
    calories: 2200,
    protein: 130,
    carbs: 250,
    fat: 70,
    clamped: false,
  );
  await db.completeOnboarding();
  final food = (await db.searchFoods('chicken')).single;
  await db.logFood(
    food: food,
    canonicalQuantity: 100,
    servingDescription: '100 g',
    meal: MealType.lunch,
    loggedAt: DateTime.now(),
  );
  return db;
}

Future<void> reveal(
  WidgetTester tester,
  Finder finder, {
  double delta = 250,
}) async {
  if (finder.evaluate().isEmpty) {
    await tester.scrollUntilVisible(
      finder,
      delta,
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

Future<void> tap(WidgetTester tester, String label) async {
  await tester.ensureVisible(find.text(label).last);
  await tester.tap(find.text(label).last);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('calorie ring has remaining, context and accessible status', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();

    await tester.pumpWidget(
      MaterialApp(
        theme: noryvaTheme(),
        home: const Scaffold(body: CalorieProgress(consumed: 52, target: 2049)),
      ),
    );
    expect(find.text('1997'), findsOneWidget);
    expect(find.text('kcal remaining'), findsOneWidget);
    expect(find.text('52 consumed of 2049'), findsOneWidget);
    expect(
      tester
          .widget<CircularProgressIndicator>(
            find.byType(CircularProgressIndicator),
          )
          .value,
      closeTo(52 / 2049, 1e-9),
    );
    expect(
      find.bySemanticsLabel(
        '1997 kilocalories remaining. 52 consumed of 2049 target.',
      ),
      findsOneWidget,
    );
    semantics.dispose();
  });

  testWidgets('calorie over-target status uses words and bounded progress', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: noryvaTheme(),
        home: const Scaffold(
          body: CalorieProgress(consumed: 2300, target: 2200),
        ),
      ),
    );
    expect(find.text('0'), findsOneWidget);
    expect(find.text('100 kcal over target'), findsOneWidget);
    expect(
      tester
          .widget<CircularProgressIndicator>(
            find.byType(CircularProgressIndicator),
          )
          .value,
      1,
    );
  });

  testWidgets('macro progress exposes current target and semantic labels', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();

    await tester.pumpWidget(
      MaterialApp(
        theme: noryvaTheme(),
        home: const Scaffold(
          body: Column(
            children: [
              MacroProgress(name: 'Protein', current: 31, target: 130),
              MacroProgress(name: 'Carbs', current: 20, target: 250),
              MacroProgress(name: 'Fat', current: 4, target: 70),
            ],
          ),
        ),
      ),
    );
    expect(find.text('31 / 130 g'), findsOneWidget);
    expect(find.text('20 / 250 g'), findsOneWidget);
    expect(find.text('4 / 70 g'), findsOneWidget);
    expect(find.byType(LinearProgressIndicator), findsNWidgets(3));
    expect(find.bySemanticsLabel('Protein: 31 of 130 grams'), findsOneWidget);
    semantics.dispose();
  });

  for (final brightness in Brightness.values) {
    for (final scale in [1.0, 1.6]) {
      testWidgets(
        '$brightness at $scale scale renders Home Diary Search Progress Me and navigation',
        (tester) async {
          tester.view.physicalSize = const Size(390, 844);
          tester.view.devicePixelRatio = 1;
          tester.platformDispatcher.platformBrightnessTestValue = brightness;
          tester.platformDispatcher.textScaleFactorTestValue = scale;
          addTearDown(tester.view.resetPhysicalSize);
          addTearDown(tester.view.resetDevicePixelRatio);
          addTearDown(
            tester.platformDispatcher.clearPlatformBrightnessTestValue,
          );
          addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
          final db = await seed();
          addTearDown(db.close);
          await tester.pumpWidget(
            ProviderScope(
              overrides: [databaseProvider.overrideWithValue(db)],
              child: const NoryvaApp(),
            ),
          );
          await tester.pumpAndSettle();
          expect(
            Theme.of(tester.element(find.byType(CalorieProgress))).brightness,
            brightness,
          );
          expect(find.text('2035'), findsOneWidget);
          expect(find.text('165 consumed of 2200'), findsOneWidget);
          expect(tester.takeException(), isNull);
          await reveal(tester, find.text('Your macros'));
          await tester.pumpAndSettle();
          expect(find.byType(MacroProgress), findsNWidgets(3));
          await reveal(tester, find.text("Today's meals"));
          await tester.pumpAndSettle();
          for (final meal in ['Breakfast', 'Lunch', 'Dinner', 'Snacks']) {
            await reveal(tester, find.text(meal));
            expect(find.text(meal), findsOneWidget);
          }
          await tester.pumpAndSettle();

          expect(tester.takeException(), isNull);
          await tap(tester, 'Diary');
          expect(
            find.text(DateFormat('d MMM yyyy', 'en_US').format(DateTime.now())),
            findsOneWidget,
          );
          expect(find.text('165 / 2200 kcal'), findsOneWidget);
          await tester.tap(find.byTooltip('Previous day'));
          await tester.pumpAndSettle();
          expect(
            find.text(
              DateFormat(
                'd MMM yyyy',
                'en_US',
              ).format(DateTime.now().subtract(const Duration(days: 1))),
            ),
            findsOneWidget,
          );
          await tester.tap(find.byTooltip('Next day'));
          await tester.pumpAndSettle();
          await reveal(tester, find.text('Chicken breast'));
          await tester.pumpAndSettle();
          expect(find.text('100 g'), findsOneWidget);
          expect(tester.takeException(), isNull);
          await tester.ensureVisible(
            find.byTooltip('Options for Chicken breast'),
          );
          await tester.tap(find.byTooltip('Options for Chicken breast'));
          await tester.pumpAndSettle();
          expect(find.text('Edit quantity or meal'), findsOneWidget);
          expect(find.text('Delete'), findsOneWidget);
          await tester.tapAt(const Offset(10, 120));
          await tester.pumpAndSettle();
          await tap(tester, 'Progress');
          expect(
            find.text(
              'Detailed progress features are planned for a later phase.',
            ),
            findsOneWidget,
          );
          expect(tester.takeException(), isNull);
          await tap(tester, 'Me');
          expect(
            find.text(
              'Noryva keeps your profile, plan and diary locally and does not upload them.',
            ),
            findsOneWidget,
          );
          await reveal(tester, find.text('Reset local data'));
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
          await tester.tap(find.byType(FloatingActionButton));
          await tester.pumpAndSettle();
          expect(find.byType(SearchBar), findsOneWidget);
          await tester.enterText(find.byType(SearchBar), 'chicken');
          await tester.pumpAndSettle();
          expect(find.text('Chicken breast'), findsOneWidget);
          expect(find.text('165 kcal'), findsOneWidget);
          expect(find.text('31.0g protein'), findsOneWidget);
          expect(find.text('Noryva demo data · verified'), findsOneWidget);
          expect(tester.takeException(), isNull);
          await tester.pageBack();
          await tester.pumpAndSettle();
          await tap(tester, 'Home');
          await reveal(tester, find.byType(CalorieProgress), delta: -300);
          expect(find.byType(CalorieProgress), findsOneWidget);
          expect(tester.takeException(), isNull);
        },
      );
    }
  }

  test('light and dark text colours meet normal text contrast', () {
    double contrast(Color a, Color b) {
      final x = a.computeLuminance(), y = b.computeLuminance();
      return ((x > y ? x : y) + .05) / ((x > y ? y : x) + .05);
    }

    for (final brightness in Brightness.values) {
      final theme = noryvaTheme(brightness: brightness);
      final c = theme.colorScheme;
      expect(contrast(c.onSurface, c.surface), greaterThanOrEqualTo(4.5));
      expect(
        contrast(c.onSurfaceVariant, c.surface),
        greaterThanOrEqualTo(4.5),
      );
      expect(contrast(c.onPrimary, c.primary), greaterThanOrEqualTo(4.5));
      expect(
        contrast(c.onPrimaryContainer, c.primaryContainer),
        greaterThanOrEqualTo(4.5),
      );
    }
  });
}
