import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/database/app_database.dart';

class MeScreen extends ConsumerWidget {
  const MeScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) => Scaffold(
    appBar: AppBar(title: const Text('Me')),
    body: ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const Text(
          'Local profile',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          'Your profile, plan and diary are stored only on this device.',
        ),
        const SizedBox(height: 32),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.delete_outline),
          title: const Text('Reset local data'),
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
