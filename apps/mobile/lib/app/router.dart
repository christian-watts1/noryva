import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/database/app_database.dart';
import '../features/diary/presentation/diary_screen.dart';
import '../features/foods/presentation/food_search_screen.dart';
import '../features/home/presentation/home_screen.dart';
import '../features/onboarding/presentation/onboarding_flow.dart';
import '../features/settings/presentation/me_screen.dart';

final routerProvider = Provider<GoRouter>(
  (ref) => GoRouter(
    initialLocation: '/launch',
    routes: [
      GoRoute(path: '/launch', builder: (_, _) => const LaunchScreen()),
      GoRoute(path: '/onboarding', builder: (_, _) => const OnboardingFlow()),
      StatefulShellRoute.indexedStack(
        builder: (_, _, shell) => MainShell(shell: shell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(path: '/home', builder: (_, _) => const HomeScreen()),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(path: '/diary', builder: (_, _) => const DiaryScreen()),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/progress',
                builder: (_, _) => const ProgressScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [GoRoute(path: '/me', builder: (_, _) => const MeScreen())],
          ),
        ],
      ),
      GoRoute(path: '/foods', builder: (_, _) => const FoodSearchScreen()),
    ],
  ),
);

class LaunchScreen extends ConsumerWidget {
  const LaunchScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      FutureBuilder<Map<String, Object?>?>(
        future: ref.read(databaseProvider).profile(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) {
              context.go(
                snapshot.data?['onboarding_completed'] == 1
                    ? '/home'
                    : '/onboarding',
              );
            }
          });
          return const SizedBox.shrink();
        },
      );
}

class MainShell extends StatelessWidget {
  const MainShell({required this.shell, super.key});
  final StatefulNavigationShell shell;
  @override
  Widget build(BuildContext context) => Scaffold(
    body: shell,
    floatingActionButton: Semantics(
      label: 'Add food',
      button: true,
      child: FloatingActionButton(
        onPressed: () => context.push('/foods'),
        child: const Icon(Icons.add),
      ),
    ),
    floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    bottomNavigationBar: NavigationBar(
      selectedIndex: shell.currentIndex > 1
          ? shell.currentIndex + 1
          : shell.currentIndex,
      onDestinationSelected: (i) {
        if (i == 2) {
          context.push('/foods');
          return;
        }
        shell.goBranch(i > 2 ? i - 1 : i);
      },
      destinations: const [
        NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
        NavigationDestination(icon: Icon(Icons.book_outlined), label: 'Diary'),
        NavigationDestination(icon: SizedBox.shrink(), label: ''),
        NavigationDestination(icon: Icon(Icons.show_chart), label: 'Progress'),
        NavigationDestination(icon: Icon(Icons.person_outline), label: 'Me'),
      ],
    ),
  );
}

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Progress')),
    body: const Padding(
      padding: EdgeInsets.all(24),
      child: Text(
        'Detailed progress tools will arrive in a later phase. Your Phase 1 diary remains available locally.',
      ),
    ),
  );
}
