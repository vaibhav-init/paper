import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DocumentView extends ConsumerStatefulWidget {
  final String id;
  DocumentView({required this.id});

  @override
  ConsumerState createState() => _DocumentViewState();
}

class _DocumentViewState extends ConsumerState<DocumentView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
