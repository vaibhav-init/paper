import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LogoButton extends StatelessWidget {
  final String icon;
  final String text;
  LogoButton({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: SvgPicture.asset(icon),
      label: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 18,
          fontFamily: 'Ubuntu',
        ),
      ),
    );
  }
}
