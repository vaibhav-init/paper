import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paper/common/widgets/logo_button.dart';
import 'package:paper/constants/common.dart';
import 'package:paper/repository/auth_repository.dart';

class LoginView extends ConsumerWidget {
  const LoginView({super.key});
  void googleLogin(WidgetRef ref) {
    ref.watch(authRepositoryProvider).signInWithGoogle();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            LogoButton(
              icon: AppIcons().googleIcon,
              text: 'Google SignIn',
              callback: () {
                googleLogin(ref);
              },
            ),
            LogoButton(
              icon: AppIcons().githubIcon,
              text: 'Github SignIn',
              callback: () {},
            ),
            LogoButton(
              icon: AppIcons().guestLogo,
              text: 'LogIn as Guest',
              callback: () {},
            ),
          ],
        ),
      ),
    );
  }
}
