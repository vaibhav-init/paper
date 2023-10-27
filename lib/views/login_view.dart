import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paper/common/widgets/logo_button.dart';
import 'package:paper/constants/constants.dart';
import 'package:paper/repository/auth_repository.dart';
import 'package:paper/views/home_view.dart';

class LoginView extends ConsumerWidget {
  const LoginView({super.key});
  void googleLogin(WidgetRef ref, BuildContext context) async {
    final sMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final errorModel =
        await ref.watch(authRepositoryProvider).signInWithGoogle();
    if (errorModel.error == null) {
      ref.read(userProvider.notifier).update((state) => errorModel.data);
      navigator.push(
        MaterialPageRoute(
          builder: (context) => const HomeView(),
        ),
      );
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            LogoButton(
              icon: AppIcons().googleIcon,
              text: 'Google SignIn',
              callback: () {
                googleLogin(ref, context);
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
