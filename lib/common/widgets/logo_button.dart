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
      style: ElevatedButton.styleFrom(
        fixedSize: const Size(230, 30),
      ),
      icon: SvgPicture.asset(
        icon,
        height: 30,
        width: 30,
      ),
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
