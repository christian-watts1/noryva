import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
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
          padding: const EdgeInsets.all(16),
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
                Text('${day.day}/${day.month}/${day.year}'),
                IconButton(
                  tooltip: 'Next day',
                  onPressed: () =>
                      setState(() => day = day.add(const Duration(days: 1))),
                  icon: const Icon(Icons.chevron_right),
                ),
              ],
            ),
            Text(
              '${total.round()} / ${target.round()} kcal',
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            Text(
              '${(target - total).clamp(0, double.infinity).round()} remaining',
            ),
            Text(
              'Protein ${entries.fold(0.0, (s, e) => s + e.protein).round()}g  •  Carbs ${entries.fold(0.0, (s, e) => s + e.carbohydrate).round()}g  •  Fat ${entries.fold(0.0, (s, e) => s + e.fat).round()}g',
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
  Widget _group(MealType meal, List<DiaryEntry> entries) => Card(
    margin: const EdgeInsets.only(bottom: 12),
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                meal == MealType.snack
                    ? 'Snacks'
                    : meal.name[0].toUpperCase() + meal.name.substring(1),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text('${entries.fold(0.0, (s, e) => s + e.energy).round()} kcal'),
            ],
          ),
          ...entries.map(
            (e) => ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(e.foodName),
              subtitle: Text(e.servingDescription),
              trailing: PopupMenuButton<String>(
                onSelected: (action) =>
                    action == 'delete' ? _delete(e) : _edit(e),
                itemBuilder: (_) => const [
                  PopupMenuItem(
                    value: 'edit',
                    child: Text('Edit quantity or meal'),
                  ),
                  PopupMenuItem(value: 'delete', child: Text('Delete')),
                ],
              ),
            ),
          ),
        ],
      ),
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
