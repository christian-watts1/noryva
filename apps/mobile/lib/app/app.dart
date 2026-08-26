import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../design_system/theme/theme.dart';
import 'router.dart';

class NoryvaApp extends ConsumerWidget {
  const NoryvaApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) => MaterialApp.router(
    title: 'Noryva',
    debugShowCheckedModeBanner: false,
    theme: noryvaTheme(),
    routerConfig: ref.watch(routerProvider),
  );
}
