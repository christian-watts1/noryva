import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/database/app_database.dart';
import '../../../design_system/components/nutrition_components.dart';
import '../../../design_system/tokens/tokens.dart';
import '../../diary/domain/diary_entry.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) => Scaffold(
    appBar: AppBar(title: const Text('Noryva')),
    body: FutureBuilder<List<Object?>>(
      future: Future.wait([
        ref.read(databaseProvider).profile(),
        ref.read(databaseProvider).diaryFor(DateTime.now()),
      ]),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final profile = snapshot.data![0]! as Map<String, Object?>;
        final entries = snapshot.data![1]! as List<DiaryEntry>;
        final calories = entries.fold(0.0, (s, e) => s + e.energy),
            protein = entries.fold(0.0, (s, e) => s + e.protein),
            carbs = entries.fold(0.0, (s, e) => s + e.carbohydrate),
            fat = entries.fold(0.0, (s, e) => s + e.fat);
        final target = profile['calorie_target']! as double;
        final hour = DateTime.now().hour;
        final greeting = hour < 12
            ? 'Good morning'
            : hour < 18
            ? 'Good afternoon'
            : 'Good evening';
        return RefreshIndicator(
          onRefresh: () async => context.go('/home'),
          child: ListView(
            padding: const EdgeInsets.all(NoryvaSpace.lg),
            children: [
              Text(greeting, style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 8),
              Text(
                'A little awareness, every day.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 24),
              CalorieProgress(consumed: calories, target: target),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () => context.push('/foods'),
                icon: const Icon(Icons.search),
                label: const Text('Search food'),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SectionTitle('Your macros'),
                      const SizedBox(height: 8),
                      MacroProgress(
                        name: 'Protein',
                        current: protein,
                        target: profile['protein_target']! as double,
                      ),
                      MacroProgress(
                        name: 'Carbs',
                        current: carbs,
                        target: profile['carbohydrate_target']! as double,
                      ),
                      MacroProgress(
                        name: 'Fat',
                        current: fat,
                        target: profile['fat_target']! as double,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const SectionTitle("Today's meals"),
              const SizedBox(height: 16),
              ...MealType.values.map(
                (meal) => MealCard(
                  meal: meal,
                  entries: entries
                      .where((entry) => entry.meal == meal)
                      .toList(),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        );
      },
    ),
  );
}
