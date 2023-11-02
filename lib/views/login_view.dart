import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:paper/common/widgets/logo_button.dart';
import 'package:paper/constants/constants.dart';
import 'package:paper/repository/auth_repository.dart';
import 'package:routemaster/routemaster.dart';

class LoginView extends ConsumerWidget {
  const LoginView({super.key});
  void googleLogin(WidgetRef ref, BuildContext context) async {
    final sMessenger = ScaffoldMessenger.of(context);
    final navigator = Routemaster.of(context);
    final errorModel =
        await ref.watch(authRepositoryProvider).signInWithGoogle();
    if (errorModel.error == null) {
      ref.read(userProvider.notifier).update((state) => errorModel.data);
      navigator.push('/');
    } else {
      sMessenger.showSnackBar(
        SnackBar(
          content: Text(errorModel.error.toString()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/animations/intro_animation.json',
              height: 300,
            ),
            const SizedBox(height: 30),
            LogoButton(
              icon: AppIcons().googleIcon,
              text: 'Google SignIn',
              callback: () {
                googleLogin(ref, context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
