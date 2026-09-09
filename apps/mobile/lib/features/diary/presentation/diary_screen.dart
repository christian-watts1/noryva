import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/database/app_database.dart';
import '../../../design_system/components/nutrition_components.dart';
import '../domain/diary_entry.dart';

class DiaryScreen extends ConsumerStatefulWidget {
  const DiaryScreen({super.key});
  @override
  ConsumerState<DiaryScreen> createState() => _State();
}

class _State extends ConsumerState<DiaryScreen> {
  DateTime day = DateTime.now();
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Diary')),
    body: FutureBuilder<List<Object?>>(
      future: Future.wait([
        ref.read(databaseProvider).profile(),
        ref.read(databaseProvider).diaryFor(day),
      ]),
      builder: (_, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final profile = snapshot.data![0]! as Map<String, Object?>,
            entries = snapshot.data![1]! as List<DiaryEntry>;
        final total = entries.fold(0.0, (s, e) => s + e.energy),
            target = profile['calorie_target']! as double;
        return ListView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 48),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  tooltip: 'Previous day',
                  onPressed: () => setState(
                    () => day = day.subtract(const Duration(days: 1)),
                  ),
                  icon: const Icon(Icons.chevron_left),
                ),
                Expanded(
                  child: Text(
                    DateFormat('d MMM yyyy', 'en_US').format(day),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                IconButton(
                  tooltip: 'Next day',
                  onPressed: () =>
                      setState(() => day = day.add(const Duration(days: 1))),
                  icon: const Icon(Icons.chevron_right),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${total.round()} / ${target.round()} kcal',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${(target - total).clamp(0, double.infinity).round()} remaining',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const Divider(),
                    Wrap(
                      spacing: 16,
                      runSpacing: 8,
                      children: [
                        Text(
                          'Protein ${entries.fold(0.0, (s, e) => s + e.protein).round()}g',
                        ),
                        Text(
                          'Carbs ${entries.fold(0.0, (s, e) => s + e.carbohydrate).round()}g',
                        ),
                        Text(
                          'Fat ${entries.fold(0.0, (s, e) => s + e.fat).round()}g',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            ...MealType.values.expand(
              (meal) => [
                _group(meal, entries.where((e) => e.meal == meal).toList()),
              ],
            ),
          ],
        );
      },
    ),
  );
  Widget _group(MealType meal, List<DiaryEntry> entries) => MealCard(
    meal: meal,
    entries: entries,
    actions: (e) => PopupMenuButton<String>(
      tooltip: 'Options for ${e.foodName}',
      onSelected: (action) => action == 'delete' ? _delete(e) : _edit(e),
      itemBuilder: (_) => const [
        PopupMenuItem(value: 'edit', child: Text('Edit quantity or meal')),
        PopupMenuItem(value: 'delete', child: Text('Delete')),
      ],
    ),
  );
  Future<void> _delete(DiaryEntry e) async {
    final yes = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete entry?'),
        content: Text('Remove ${e.foodName} from the diary?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (yes == true) {
      await ref.read(databaseProvider).deleteEntry(e.id);
      setState(() {});
    }
  }

  Future<void> _edit(DiaryEntry e) async {
    final c = TextEditingController(text: e.quantityGrams.toStringAsFixed(0));
    var meal = e.meal;
    final save = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialog) => AlertDialog(
          title: Text('Edit ${e.foodName}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: c,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Quantity (grams)',
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<MealType>(
                initialValue: meal,
                items: MealType.values
                    .map((m) => DropdownMenuItem(value: m, child: Text(m.name)))
                    .toList(),
                onChanged: (v) => setDialog(() => meal = v!),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
    final grams = double.tryParse(c.text);
    c.dispose();
    if (save == true && grams != null && grams > 0) {
      await ref
          .read(databaseProvider)
          .editEntry(e.id, canonicalQuantity: grams, meal: meal);
      setState(() {});
    }
  }
}
