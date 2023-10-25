import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LogoButton extends StatelessWidget {
  final String icon;
  final String text;
  final VoidCallback callback;
  const LogoButton({
    super.key,
    required this.icon,
    required this.text,
    required this.callback,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: callback,
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
