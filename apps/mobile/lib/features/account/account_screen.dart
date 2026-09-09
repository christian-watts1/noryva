import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'account_controller.dart';

class AccountScreen extends ConsumerStatefulWidget {
  const AccountScreen({super.key});
  @override
  ConsumerState<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends ConsumerState<AccountScreen> {
  final email = TextEditingController(), code = TextEditingController();
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(accountControllerProvider.notifier).restore(),
    );
  }

  @override
  void dispose() {
    email.dispose();
    code.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(accountControllerProvider);
    final controller = ref.read(accountControllerProvider.notifier);
    return Scaffold(
      appBar: AppBar(title: const Text('Optional account')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text(
            'Noryva works fully without an account. Signing in attaches this local workspace to your account but does not upload your profile or diary. Backup and sync are not active.',
          ),
          const SizedBox(height: 16),
          if (state.message != null)
            Text(state.message!, key: const Key('account-message')),
          if (state.busy) const LinearProgressIndicator(),
          if (state.signedIn) ...[
            const Text('Signed in'),
            const Text(
              'Signing out keeps your local profile and diary and their account association. A different account cannot take ownership.',
            ),
            FilledButton(
              onPressed: state.busy ? null : controller.signOut,
              child: const Text('Sign out'),
            ),
          ] else if (!controller.configured) ...[
            const Text(
              'Account sign-in is not configured in this build. Keep tracking locally; no account is required.',
            ),
          ] else if (state.challenge) ...[
            TextField(
              controller: code,
              keyboardType: TextInputType.number,
              autofillHints: const [AutofillHints.oneTimeCode],
              decoration: const InputDecoration(labelText: 'Email code'),
            ),
            FilledButton(
              onPressed: state.busy
                  ? null
                  : () async {
                      await controller.confirm(code.text.trim());
                      code.clear();
                      email.clear();
                    },
              child: const Text('Confirm code'),
            ),
          ] else ...[
            TextField(
              controller: email,
              keyboardType: TextInputType.emailAddress,
              autocorrect: false,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            FilledButton(
              onPressed: state.busy
                  ? null
                  : () => controller.begin(email.text.trim(), create: false),
              child: const Text('Sign in with email code'),
            ),
            TextButton(
              onPressed: state.busy
                  ? null
                  : () => controller.begin(email.text.trim(), create: true),
              child: const Text('Create account'),
            ),
            const Text(
              'Mailbox access is your recovery method. Noryva cannot protect an account if its mailbox is compromised.',
            ),
          ],
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Continue without account'),
          ),
        ],
      ),
    );
  }
}
