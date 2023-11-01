import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:paper/common/theme/theme.dart';
import 'package:paper/common/widgets/loader.dart';
import 'package:paper/constants/constants.dart';
import 'package:paper/models/document_model.dart';
import 'package:paper/models/error_model.dart';
import 'package:paper/repository/auth_repository.dart';
import 'package:paper/repository/doc_repository.dart';
import 'package:paper/repository/socket_repository.dart';
import 'package:routemaster/routemaster.dart';

class DocumentView extends ConsumerStatefulWidget {
  final String id;
  const DocumentView({
    super.key,
    required this.id,
  });

  @override
  ConsumerState createState() => _DocumentViewState();
}

class _DocumentViewState extends ConsumerState<DocumentView> {
  final TextEditingController titleController =
      TextEditingController(text: 'Untitled Paper');
  QuillController? _controller;
  ErrorModel? errorModel;
  SocketRepository socketRepository = SocketRepository();

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
    socketRepository.joinRoom(widget.id);
    getDocumentData();
    socketRepository.changeListener((data) => {
          _controller?.compose(
            Delta.fromJson(data['delta']),
            _controller?.selection ?? const TextSelection.collapsed(offset: 0),
            ChangeSource.REMOTE,
          )
        });
    Timer.periodic(const Duration(seconds: 3), (timer) {
      socketRepository.autoSave(<String, dynamic>{
        'delta': _controller!.document.toDelta(),
        'room': widget.id,
      });
    });
  }

  void getDocumentData() async {
    errorModel = await ref.read(docRepositoryProvider).getDocumentById(
          ref.read(userProvider)!.token,
          widget.id,
        );

    if (errorModel!.data != null) {
      titleController.text = (errorModel!.data as DocumentModel).title;
      _controller = QuillController(
        document: errorModel!.data.content.isEmpty
            ? Document()
            : Document.fromDelta(Delta.fromJson(errorModel!.data.content)),
        selection: const TextSelection.collapsed(offset: 0),
      );
      setState(() {});
    }
    _controller!.document.changes.listen((event) {
      //1-> content
      //2-> changes from previous part
      //3-> local? we have typed ; remote
      if (event.source == ChangeSource.LOCAL) {
        Map<String, dynamic> map = {
          'delta': event.source,
          'room': widget.id,
        };
        socketRepository.typing(map);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    _controller?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null) {
      return const Scaffold(
        body: Loader(),
      );
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainGreen,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            InkWell(
              onTap: () {
                Routemaster.of(context).replace('/');
              },
              child: SvgPicture.asset(
                AppIcons().documentLogo,
                height: 40,
                width: 30,
              ),
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
            onPressed: () {
              Clipboard.setData(ClipboardData(
                      text: 'http://localhost:3000/#/document/${widget.id}'))
                  .then((value) => {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Link copied to clipboard'),
                          ),
                        ),
                      });
            },
            icon: const Icon(Icons.share),
          ),
        ],
      ),
      body: QuillProvider(
        configurations: QuillConfigurations(
          controller: _controller!,
          sharedConfigurations: const QuillSharedConfigurations(
            locale: Locale('en'),
          ),
        ),
        child: Column(
          children: [
            const QuillToolbar(
              configurations: QuillToolbarConfigurations(),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 3,
                  child: QuillEditor.basic(
                    configurations: const QuillEditorConfigurations(
                      readOnly: false,
                    ),
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
