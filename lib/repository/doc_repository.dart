import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paper/models/document_model.dart';
import '../constants/constants.dart';
import '../models/error_model.dart';
import 'package:http/http.dart';

final docRepositoryProvider = Provider(
  (ref) => DocRepository(
    client: Client(),
  ),
);

class DocRepository {
  final Client _client;
  DocRepository({required Client client}) : _client = client;

  Future<ErrorModel> createDocument(String token) async {
    ErrorModel error = ErrorModel(
      error: 'Something Unexpected happened :< !',
      data: null,
    );
    try {
      var res = await _client.post(
        Uri.parse(ApiRoutes().createDocumentRoute),
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
          "x-auth-token": token,
        },
        body: jsonEncode({
          'createdAt': DateTime.now().microsecondsSinceEpoch,
        }),
      );
      switch (res.statusCode) {
        case 200:
          error = ErrorModel(
            error: null,
            data: DocumentModel.fromJson(res.body),
          );
          break;
        default:
          error = ErrorModel(error: res.body, data: null);
          break;
      }
    } catch (e) {
      error = ErrorModel(
        error: e.toString(),
        data: null,
      );
    }
    return error;
  }

  Future<ErrorModel> getDocuments(String token) async {
    ErrorModel error = ErrorModel(
      error: 'Something Unexpected happened :< !',
      data: null,
    );
    try {
      var res = await _client.get(
        Uri.parse(ApiRoutes().getDocumentsRoute),
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
          "x-auth-token": token,
        },
      );
      switch (res.statusCode) {
        case 200:
          List<DocumentModel> documents = [];
          for (int i = 0; i < jsonDecode(res.body).length; i++) {
            print(jsonDecode(res.body).length);
            documents.add(
              DocumentModel.fromJson(
                jsonEncode(
                  jsonDecode(res.body)[i],
                ),
              ),
            );
          }

          error = ErrorModel(
            error: null,
            data: documents,
          );
          break;
        default:
          error = ErrorModel(error: res.body, data: null);
          break;
      }
    } catch (e) {
      error = ErrorModel(
        error: e.toString(),
        data: null,
      );
    }
    return error;
  }
}