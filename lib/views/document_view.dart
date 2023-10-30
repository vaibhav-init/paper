import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:paper/constants/constants.dart';

class DocumentView extends ConsumerStatefulWidget {
  final String id;
  DocumentView({required this.id});

  @override
  ConsumerState createState() => _DocumentViewState();
}

class _DocumentViewState extends ConsumerState<DocumentView> {
  TextEditingController titleController =
      TextEditingController(text: 'Untitled Document');

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
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
                decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red))),
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
    );
  }
}
