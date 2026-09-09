import 'package:flutter/material.dart';

import '../../features/diary/domain/diary_entry.dart';
import '../tokens/tokens.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle(this.title, {super.key});
  final String title;
  @override
  Widget build(BuildContext context) => Semantics(
    header: true,
    child: Text(title, style: Theme.of(context).textTheme.titleLarge),
  );
}

class CalorieProgress extends StatelessWidget {
  const CalorieProgress({
    required this.consumed,
    required this.target,
    super.key,
  });
  final double consumed;
  final double target;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final remaining = (target - consumed).clamp(0, double.infinity).round();
    final over = consumed > target;
    return Semantics(
      label:
          '$remaining kilocalories remaining. ${consumed.round()} consumed of ${target.round()} target.${over ? ' ${(consumed - target).round()} kilocalories over target.' : ''}',
      child: ExcludeSemantics(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(NoryvaSpace.lg),
            child: Column(
              children: [
                Text(
                  'TODAY’S ENERGY',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: NoryvaSpace.lg),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final size = constraints.maxWidth.clamp(0.0, 264.0);
                    // Give scaled text its natural height outside the ring.
                    final largeText =
                        MediaQuery.textScalerOf(context).scale(16) > 20;
                    final number = Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('$remaining', style: theme.textTheme.displaySmall),
                        Text(
                          'kcal remaining',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    );
                    if (largeText) {
                      return Column(
                        children: [
                          number,
                          const SizedBox(height: 16),
                          LinearProgressIndicator(
                            value: target > 0
                                ? (consumed / target).clamp(0, 1)
                                : 0,
                            minHeight: 8,
                            borderRadius: BorderRadius.circular(8),
                            backgroundColor: theme.colorScheme.primaryContainer,
                          ),
                        ],
                      );
                    }
                    return SizedBox(
                      width: size,
                      height: size,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Positioned.fill(
                            child: CircularProgressIndicator(
                              value: target > 0
                                  ? (consumed / target).clamp(0, 1)
                                  : 0,
                              strokeWidth: 10,
                              strokeCap: StrokeCap.round,
                              backgroundColor:
                                  theme.colorScheme.primaryContainer,
                            ),
                          ),
                          number,
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: NoryvaSpace.lg),
                Text(
                  '${consumed.round()} consumed of ${target.round()}',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium,
                ),
                if (over)
                  Text(
                    '${(consumed - target).round()} kcal over target',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MacroProgress extends StatelessWidget {
  const MacroProgress({
    required this.name,
    required this.current,
    required this.target,
    super.key,
  });
  final String name;
  final double current;
  final double target;
  @override
  Widget build(BuildContext context) => Semantics(
    label: '$name: ${current.round()} of ${target.round()} grams',
    child: ExcludeSemantics(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: NoryvaSpace.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              spacing: 12,
              runSpacing: 4,
              children: [
                Text(name, style: Theme.of(context).textTheme.titleMedium),
                Text(
                  '${current.round()} / ${target.round()} g',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            const SizedBox(height: NoryvaSpace.sm),
            LinearProgressIndicator(
              value: target > 0 ? (current / target).clamp(0, 1) : 0,
              minHeight: 5,
              borderRadius: BorderRadius.circular(5),
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            ),
          ],
        ),
      ),
    ),
  );
}

class MealCard extends StatelessWidget {
  const MealCard({
    required this.meal,
    required this.entries,
    this.actions,
    super.key,
  });
  final MealType meal;
  final List<DiaryEntry> entries;
  final Widget Function(DiaryEntry)? actions;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = meal == MealType.snack
        ? 'Snacks'
        : meal.name[0].toUpperCase() + meal.name.substring(1);
    return Padding(
      padding: const EdgeInsets.only(bottom: NoryvaSpace.md),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(NoryvaSpace.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                spacing: 12,
                runSpacing: 4,
                children: [
                  Semantics(
                    header: true,
                    child: Text(title, style: theme.textTheme.titleMedium),
                  ),
                  Text(
                    '${entries.fold(0.0, (sum, e) => sum + e.energy).round()} kcal',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
              if (entries.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    'Nothing logged yet',
                    style: theme.textTheme.bodySmall,
                  ),
                ),
              for (final entry in entries) ...[
                const Divider(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            entry.foodName,
                            style: theme.textTheme.bodyLarge,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            entry.servingDescription,
                            style: theme.textTheme.bodySmall,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${entry.energy.round()} kcal',
                            style: theme.textTheme.labelLarge,
                          ),
                        ],
                      ),
                    ),
                    if (actions != null) actions!(entry),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
