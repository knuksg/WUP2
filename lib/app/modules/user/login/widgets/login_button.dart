import 'package:flutter/material.dart';
import 'package:wup/app/theme/app_color.dart';

class LoginButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String platform;

  const LoginButton({Key? key, required this.onPressed, required this.platform})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: 300,
        height: 50.0,
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: kSecondaryColor.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.values[0],
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 32,
              height: 32,
              child: Image.asset(
                'assets/images/${platform}_logo.png',
              ),
            ),
            const SizedBox(width: 10.0),
            Text(
              'Sign in with $platform',
              style: const TextStyle(
                fontSize: 16.0,
                color: kSecondaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
