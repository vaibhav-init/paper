import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paper/common/widgets/loader.dart';
import 'package:paper/models/document_model.dart';
import 'package:paper/repository/auth_repository.dart';
import 'package:paper/repository/doc_repository.dart';
import 'package:routemaster/routemaster.dart';

import '../common/theme/theme_provider.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  void signOut(WidgetRef ref) {
    ref.read(authRepositoryProvider).signOut();
    ref.read(userProvider.notifier).update((state) => null);
  }

  void createDocument(WidgetRef ref, BuildContext context) async {
    String token = ref.read(userProvider)!.token;
    final navigator = Routemaster.of(context);
    final snackbar = ScaffoldMessenger.of(context);
    final errorModel =
        await ref.read(docRepositoryProvider).createDocument(token);

    if (errorModel.data != null) {
      navigator.push('/document/${errorModel.data.id}');
    } else {
      snackbar.showSnackBar(
        SnackBar(
          content: Text(errorModel.error!),
        ),
      );
    }
  }

  void navigateToDocument(BuildContext context, String documentId) {
    Routemaster.of(context).push('/document/$documentId');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var darkMode = ref.watch(darkModeProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          Switch(
              value: darkMode,
              onChanged: (val) {
                ref.read(darkModeProvider.notifier).toggle();
              }),
          IconButton(
            onPressed: () => createDocument(ref, context),
            icon: const Icon(Icons.add),
          ),
          IconButton(
            onPressed: () => signOut(ref),
            icon: const Icon(
              Icons.logout_outlined,
              color: Colors.red,
            ),
          ),
        ],
      ),
      body: FutureBuilder(
          future: ref.watch(docRepositoryProvider).getDocuments(
                ref.watch(userProvider)!.token,
              ),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Loader();
            }
            return ListView.builder(
                itemCount: snapshot.data!.data.length,
                itemBuilder: (context, index) {
                  DocumentModel document = snapshot.data!.data[index];
                  return InkWell(
                    onTap: () => navigateToDocument(
                      context,
                      document.id,
                    ),
                    child: Card(
                      child: Center(
                        child: Text(
                          document.title,
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  );
                });
          }),
    );
  }
}
