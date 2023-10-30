import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:paper/constants/constants.dart';

class DocumentView extends ConsumerStatefulWidget {
  final String id;
  DocumentView({required this.id, z});

  @override
  ConsumerState createState() => _DocumentViewState();
}

class _DocumentViewState extends ConsumerState<DocumentView> {
  TextEditingController titleController =
      TextEditingController(text: 'Untitled Document');
  QuillController _controller = QuillController.basic();

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
