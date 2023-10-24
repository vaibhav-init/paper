import 'package:flutter/material.dart';
import 'package:paper/common/widgets/logo_button.dart';
import 'package:paper/constants/common.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            LogoButton(
              icon: AppIcons().googleIcon,
              text: 'Google SignIn',
            ),
            LogoButton(
              icon: AppIcons().githubIcon,
              text: 'Github SignIn',
            ),
            LogoButton(
              icon: AppIcons().guestLogo,
              text: 'LogIn as Guest',
            ),
          ],
        ),
      ),
    );
  }
}
