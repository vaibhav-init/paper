import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paper/common/theme/theme.dart';
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
      navigator.replace('/document/${errorModel.data.id}');
    } else {
      snackbar.showSnackBar(
        SnackBar(
          content: Text(errorModel.error!),
        ),
      );
    }
  }

  Future<void> deleteDocument(
      WidgetRef ref, String documentId, BuildContext context) async {
    String token = ref.read(userProvider)!.token;
    final sMessenger = ScaffoldMessenger.of(context);
    final errorModel =
        await ref.read(docRepositoryProvider).deleteDocument(token, documentId);

    if (errorModel.data != null) {
      //implement list refresh feature
      sMessenger.showSnackBar(
        SnackBar(
          content: Text('Document with id $documentId deleted :)'),
        ),
      );

      //feature end
    } else {
      sMessenger.showSnackBar(
        SnackBar(
          content: Text(errorModel.error!),
        ),
      );
    }
  }

  void navigateToDocument(BuildContext context, String documentId) {
    Routemaster.of(context).replace('/document/$documentId');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var darkMode = ref.watch(darkModeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Your Papers : ',
          style: TextStyle(
            fontFamily: 'Ubuntu',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
          ),
        ),
        backgroundColor: mainGreen,
        actions: [
          Switch(
              activeColor: Colors.black,
              inactiveThumbColor: Colors.white,
              inactiveTrackColor: Colors.white.withOpacity(0.5),
              value: darkMode,
              onChanged: (val) {
                ref.read(darkModeProvider.notifier).toggle();
              }),
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
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200.0,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 20.0,
                childAspectRatio: 0.8,
              ),
              itemCount: snapshot.data!.data.length,
              itemBuilder: (context, index) {
                DocumentModel document = snapshot.data!.data[index];
                return InkWell(
                  onTap: () => navigateToDocument(
                    context,
                    document.id,
                  ),
                  onLongPress: () {
                    deleteDocument(ref, document.id, context);
                  },
                  child: Card(
                    child: Text(
                      document.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontFamily: 'Ubuntu',
                      ),
                    ),
                  ),
                );
              },
            );
          }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: mainGreen,
        onPressed: () => createDocument(ref, context),
        child: const Center(
          child: Icon(
            Icons.add,
            size: 33,
          ),
        ),
      ),
    );
  }
}
