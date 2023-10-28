//command-> flutter run -d chrome  --web-port 3000
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:paper/constants/constants.dart';
import 'package:paper/models/error_model.dart';
import 'package:paper/models/user_model.dart';
import 'package:http/http.dart';
import 'local_storage_repository.dart';

final authRepositoryProvider = Provider(
  (_) => AuthRepository(
    googleSignIn: GoogleSignIn(),
    client: Client(),
    localStorage: LocalStorage(),
  ),
);

final userProvider = StateProvider<UserModel?>((ref) => null);

class AuthRepository {
  final GoogleSignIn _googleSignIn;
  final Client _client;
  final LocalStorage _localStorage;
  AuthRepository(
      {required GoogleSignIn googleSignIn,
      required Client client,
      required LocalStorage localStorage})
      : _googleSignIn = googleSignIn,
        _client = client,
        _localStorage = localStorage;

  Future<ErrorModel> signInWithGoogle() async {
    ErrorModel error = ErrorModel(
      error: 'Something unexpected happened!',
      data: null,
    );
    try {
      final user = await _googleSignIn.signIn();

      if (user != null) {
        final accountHolder = UserModel(
          email: user.email,
          name: user.displayName!,
          profile: user.photoUrl!,
          uid: '',
          token: '',
        );
        var res = await _client.post(Uri.parse(ApiRoutes().signupRoute),
            body: accountHolder.toJson(),
            headers: {'Content-Type': 'application/json; charset=UTF-8'});
        switch (res.statusCode) {
          case 200:
            final newUser = accountHolder.copyWith(
              uid: jsonDecode(res.body)['user']['_id'],
              token: jsonDecode(res.body)['token'],
            );
            error = ErrorModel(error: null, data: newUser);

            _localStorage.setToken(newUser.token);

            break;
        }
      }
    } catch (e) {
      error = ErrorModel(
        error: e.toString(),
        data: null,
      );
    }
    return error;
  }

  Future<ErrorModel> getUserData() async {
    ErrorModel error = ErrorModel(
      error: 'ErrorModel Initialized never used !',
      data: null,
    );
    try {
      String? token = await _localStorage.getToken();
      if (token != null) {
        var res =
            await _client.get(Uri.parse(ApiRoutes().getUserRoute), headers: {
          "Content-Type": "application/json; charset=UTF-8",
          "x-auth-token": token,
        });
        switch (res.statusCode) {
          case 200:
            final newUser = UserModel.fromJson(
              jsonEncode(
                jsonDecode(res.body)['user'],
              ),
            ).copyWith(
              token: token,
            );
            error = ErrorModel(error: null, data: newUser);
            _localStorage.setToken(newUser.token);
            break;
        }
      }
    } catch (e) {
      error = ErrorModel(
        error: e.toString(),
        data: null,
      );
    }
    return error;
  }

  void signOut() async {
    await _googleSignIn.signOut();
    _localStorage.setToken('');
  }
}
