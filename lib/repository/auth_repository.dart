//command-> flutter run -d chrome --web-hostname localhost --web-port 3000
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:paper/constants/constants.dart';
import 'package:paper/models/user_model.dart';
import 'package:http/http.dart';

final authRepositoryProvider = Provider(
  (_) => AuthRepository(
    googleSignIn: GoogleSignIn(),
    client: Client(),
  ),
);

final userProvider = StateProvider<UserModel?>((ref) => null);

class AuthRepository {
  final GoogleSignIn _googleSignIn;
  final Client _client;
  AuthRepository({
    required GoogleSignIn googleSignIn,
    required Client client,
  })  : _googleSignIn = googleSignIn,
        _client = client;

  void signInWithGoogle() async {
    try {
      final user = await _googleSignIn.signIn();
      if (user != null) {
        final accountHolder = UserModel(
          email: user.email,
          name: user.displayName!,
          profilePic: user.photoUrl!,
          uid: '',
          token: '',
        );
        var res = await _client.post(Uri.parse(ApiRoutes().signupRoute),
            body: accountHolder.toJson(),
            headers: {'Content-Type': 'application/json; charset=UTF-8'});

        switch (res.statusCode) {
          case 200:
            accountHolder.copyWith(
              uid: jsonDecode(res.body)['user']['_id'],
            );
            break;
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
