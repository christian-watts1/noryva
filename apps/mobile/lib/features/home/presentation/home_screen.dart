import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/database/app_database.dart';
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
            padding: const EdgeInsets.all(24),
            children: [
              Text(
                greeting,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              const Text('TODAY'),
              Text(
                '${calories.round()} / ${target.round()} kcal',
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${(target - calories).clamp(0, double.infinity).round()} remaining',
              ),
              const SizedBox(height: 24),
              _macro('Protein', protein, profile['protein_target']! as double),
              _macro('Carbs', carbs, profile['carbohydrate_target']! as double),
              _macro('Fat', fat, profile['fat_target']! as double),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: () => context.push('/foods'),
                icon: const Icon(Icons.search),
                label: const Text('Search food'),
              ),
              const SizedBox(height: 16),
              const Text(
                "Today's meals",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              ...entries.map(
                (e) => ListTile(
                  title: Text(e.foodName),
                  subtitle: Text(e.meal.name),
                  trailing: Text('${e.energy.round()} kcal'),
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
  Widget _macro(String name, double value, double target) => ListTile(
    contentPadding: EdgeInsets.zero,
    title: Text(name),
    trailing: Text('${value.round()} / ${target.round()}g'),
  );
}
