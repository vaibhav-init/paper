import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paper/common/theme/theme.dart';
import 'package:paper/common/theme/theme_provider.dart';
import 'package:paper/constants/routes.dart';
import 'package:paper/models/error_model.dart';
import 'package:paper/repository/auth_repository.dart';
import 'package:routemaster/routemaster.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  ErrorModel? errorModel;
  @override
  void initState() {
    super.initState();
    getUserData();
  }

  void getUserData() async {
    errorModel = await ref.read(authRepositoryProvider).getUserData();
    if (errorModel != null && errorModel!.data != null) {
      ref.read(userProvider.notifier).update((state) => errorModel!.data);
    }
  }

  @override
  Widget build(BuildContext context) {
    var darkMode = ref.watch(darkModeProvider);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: mainGreen),
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark().copyWith(useMaterial3: true),
      themeMode: darkMode ? ThemeMode.dark : ThemeMode.light,
      title: 'Paper App',
      routeInformationParser: const RoutemasterParser(),
      routerDelegate: RoutemasterDelegate(routesBuilder: (context) {
        final user = ref.watch(userProvider);
        if (user != null && user.token.isNotEmpty) {
          return loggedInRoutes;
        }
        return loggedOutRoutes;
      }),
    );
  }
}
