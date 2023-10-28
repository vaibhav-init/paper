import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paper/repository/auth_repository.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  void signOut(WidgetRef ref) {
    ref.read(authRepositoryProvider).signOut();
    ref.read(userProvider.notifier).update((state) => null);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.add)),
          IconButton(
            onPressed: () {
              signOut(ref);
            },
            icon: const Icon(
              Icons.logout_outlined,
              color: Colors.red,
            ),
          ),
        ],
      ),
      body: Center(
        child: Text(ref.watch(userProvider)!.name),
      ),
    );
  }
}
