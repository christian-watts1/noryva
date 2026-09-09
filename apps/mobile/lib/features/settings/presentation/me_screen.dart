import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/database/app_database.dart';
import '../../../design_system/tokens/tokens.dart';

class MeScreen extends ConsumerWidget {
  const MeScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) => Scaffold(
    appBar: AppBar(title: const Text('Me')),
    body: ListView(
      padding: const EdgeInsets.all(NoryvaSpace.lg),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(NoryvaSpace.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.primaryContainer,
                  child: Icon(
                    Icons.shield_outlined,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Local profile',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Your profile, plan and diary are stored only on this device.',
                ),
                const SizedBox(height: 12),
                Text(
                  'No account needed. Your daily record stays with you.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 4),
          leading: Icon(
            Icons.brightness_auto_outlined,
            color: Theme.of(context).colorScheme.primary,
          ),
          title: const Text('Appearance'),
          subtitle: const Text('Follows your device’s light or dark setting.'),
        ),
        const Divider(),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(
            Icons.delete_outline,
            color: Theme.of(context).colorScheme.error,
          ),
          title: Text(
            'Reset local data',
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
          subtitle: const Text(
            'Delete the local Noryva profile and diary from this device.',
          ),
          onTap: () async {
            final yes = await showDialog<bool>(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('Reset local data?'),
                content: const Text(
                  'This permanently deletes your local Noryva profile and diary. Demo foods remain available.',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Cancel'),
                  ),
                  FilledButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('Reset'),
                  ),
                ],
              ),
            );
            if (yes == true) {
              await ref.read(databaseProvider).resetLocalData();
              if (context.mounted) context.go('/onboarding');
            }
          },
        ),
      ],
    ),
  );
}
