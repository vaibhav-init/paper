import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:paper/constants/constants.dart';
import 'package:paper/models/document_model.dart';
import 'package:paper/models/error_model.dart';
import 'package:paper/repository/auth_repository.dart';
import 'package:paper/repository/doc_repository.dart';

class DocumentView extends ConsumerStatefulWidget {
  final String id;
  DocumentView({
    required this.id,
  });

  @override
  ConsumerState createState() => _DocumentViewState();
}

class _DocumentViewState extends ConsumerState<DocumentView> {
  final TextEditingController titleController =
      TextEditingController(text: 'Untitled Paper');
  final QuillController _controller = QuillController.basic();
  ErrorModel? errorModel;

  void updateTitle(WidgetRef ref, String title) {
    ref.read(docRepositoryProvider).updateTitle(
          title: title,
          token: ref.read(userProvider)!.token,
          id: widget.id,
        );
  }

  @override
  void initState() {
    super.initState();
    getDocumentData();
  }

  void getDocumentData() async {
    errorModel = await ref.read(docRepositoryProvider).getDocumentById(
          ref.read(userProvider)!.token,
          widget.id,
        );

    if (errorModel!.data != null) {
      titleController.text = (errorModel!.data as DocumentModel).title;
      setState(() {});
    } else {
      print('errorModel is null ');
    }
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            SvgPicture.asset(
              AppIcons().documentLogo,
              height: 40,
              width: 30,
            ),
            SizedBox(
              width: 200,
              child: TextField(
                onSubmitted: (t) => updateTitle(ref, t),
                controller: titleController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.share),
          ),
        ],
      ),
      body: QuillProvider(
        configurations: QuillConfigurations(
          controller: _controller,
          sharedConfigurations: const QuillSharedConfigurations(
            locale: Locale('de'),
          ),
        ),
        child: Column(
          children: [
            const QuillToolbar(),
            Expanded(
              child: Card(
                elevation: 3,
                child: QuillEditor.basic(
                  configurations: const QuillEditorConfigurations(
                    readOnly: false,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
