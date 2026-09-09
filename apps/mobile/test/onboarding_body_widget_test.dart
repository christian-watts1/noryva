import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noryva_mobile/core/database/app_database.dart';
import 'package:noryva_mobile/features/onboarding/domain/body_details.dart';
import 'package:noryva_mobile/features/onboarding/presentation/onboarding_flow.dart';

Future<void> pump(WidgetTester tester, AppDatabase db) async {
  await tester.pumpWidget(
    ProviderScope(
      key: UniqueKey(),
      overrides: [databaseProvider.overrideWithValue(db)],
      child: const MaterialApp(home: OnboardingFlow()),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> tap(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

Future<void> enter(WidgetTester tester, String label, String value) async {
  final field = find.widgetWithText(TextField, label);
  await tester.ensureVisible(field);
  await tester.enterText(field, value);
  await tester.pumpAndSettle();
}

bool enabled(WidgetTester tester) =>
    tester
        .widget<FilledButton>(find.widgetWithText(FilledButton, 'Continue'))
        .onPressed !=
    null;

void main() {
  for (final mode in WeightUnit.values) {
    testWidgets(
      '$mode with feet/inches persists draft and calculates metric plan',
      (tester) async {
        final dir = Directory.systemTemp.createTempSync('noryva_body_');
        final file = File('${dir.path}/app.sqlite');
        var db = await AppDatabase.open(file: file);
        addTearDown(() async {
          await db.close();
          dir.deleteSync(recursive: true);
        });
        await db.saveOnboarding(
          step: 2,
          goal: 'maintainWeight',
          sex: 'male',
          dateOfBirth: '1990-01-02',
        );
        await pump(tester, db);
        expect(find.text('02/01/1990'), findsOneWidget);
        expect(enabled(tester), isFalse);
        await tap(tester, find.byType(DropdownButtonFormField<HeightUnit>));
        await tap(tester, find.text('Feet + inches').last);
        await enter(tester, 'Feet', '5');
        await enter(tester, 'Inches', '12');
        expect(enabled(tester), isFalse);
        await enter(tester, 'Inches', '11');
        await enter(tester, 'Feet', '5arbitrary');
        expect(
          tester
              .widget<TextField>(find.widgetWithText(TextField, 'Feet'))
              .controller!
              .text,
          '5',
        );

        if (mode != WeightUnit.kilograms) {
          await tap(tester, find.byType(DropdownButtonFormField<WeightUnit>));
          await tap(
            tester,
            find
                .text(mode == WeightUnit.pounds ? 'Pounds' : 'Stones + pounds')
                .last,
          );
        }
        switch (mode) {
          case WeightUnit.kilograms:
            await enter(tester, 'Current weight (kg)', '301');
            expect(enabled(tester), isFalse);
            await enter(tester, 'Current weight (kg)', '80');
          case WeightUnit.pounds:
            await enter(tester, 'Current weight (lb)', '176');
          case WeightUnit.stonesPounds:
            await enter(tester, 'Stones', '12');
            expect(enabled(tester), isFalse);
            await enter(tester, 'Pounds', '14');
            expect(enabled(tester), isFalse);
            await enter(tester, 'Pounds', '8');
        }
        expect(enabled(tester), isTrue);
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pumpAndSettle();
        await db.close();
        db = await AppDatabase.open(file: file);
        await pump(tester, db);
        expect(enabled(tester), isTrue);
        expect(find.text('02/01/1990'), findsOneWidget);
        expect(
          tester
              .widget<TextField>(find.widgetWithText(TextField, 'Feet'))
              .controller!
              .text,
          '5',
        );
        expect(
          tester
              .widget<TextField>(find.widgetWithText(TextField, 'Inches'))
              .controller!
              .text,
          '11',
        );
        final profile = (await db.profile())!;
        final kg = mode == WeightUnit.kilograms ? 80.0 : 79.83225712;
        expect(profile['height_cm'], closeTo(180.34, 1e-9));
        expect(profile['weight_kg'], closeTo(kg, 1e-9));
        await tap(tester, find.text('Continue'));
        await tap(
          tester,
          find.text(
            'Low activity — Mostly seated with limited regular exercise.',
          ),
        );
        await tap(tester, find.text('Continue'));
        await tap(tester, find.text('Continue'));
        expect(find.text('YOUR NORYVA PLAN'), findsOneWidget);
        final plan = (await db.profile())!;
        expect(
          plan['bmr'],
          closeTo(
            10 * kg +
                6.25 * 180.34 -
                5 * BodyDetails.age(DateTime(1990, 1, 2), DateTime.now()) +
                5,
            1e-8,
          ),
        );
      },
    );
  }

  testWidgets(
    'metric validity, calendar only DOB and incomplete draft restart',
    (tester) async {
      final dir = Directory.systemTemp.createTempSync('noryva_dob_');
      final file = File('${dir.path}/app.sqlite');
      var db = await AppDatabase.open(file: file);
      addTearDown(() async {
        await db.close();
        dir.deleteSync(recursive: true);
      });
      await db.saveOnboarding(step: 2, sex: 'female');
      await pump(tester, db);
      await enter(tester, 'Height (cm)', '119');
      await enter(tester, 'Current weight (kg)', '80');
      expect(enabled(tester), isFalse);
      await enter(tester, 'Height (cm)', '180');
      expect(enabled(tester), isFalse);
      await tap(tester, find.text('Select date of birth'));
      expect(
        tester
            .widget<DatePickerDialog>(find.byType(DatePickerDialog))
            .initialEntryMode,
        DatePickerEntryMode.calendarOnly,
      );
      await tap(tester, find.text('OK'));
      expect(enabled(tester), isTrue);
      await enter(tester, 'Height (cm)', '');
      expect(enabled(tester), isFalse);
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
      await db.close();
      db = await AppDatabase.open(file: file);
      await pump(tester, db);
      expect(enabled(tester), isFalse);
      expect(find.text('01/01/1990'), findsOneWidget);
      expect(
        tester
            .widget<TextField>(find.widgetWithText(TextField, 'Height (cm)'))
            .controller!
            .text,
        '',
      );
      expect((await db.profile())!['height_cm'], isNull);
    },
  );
}
