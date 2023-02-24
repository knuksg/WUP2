import 'package:flutter/material.dart';
import 'package:mbti_test/components/constants.dart';
import 'package:mbti_test/components/theme.dart';

class DefaultButton extends StatelessWidget {
  final String? text;
  final GestureTapCallback? press;
  final Color color;
  const DefaultButton({
    super.key,
    this.text,
    this.press,
    this.color = kPrimaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: kPrimaryColor,
          fixedSize: const Size(300, 50),
          padding: const EdgeInsets.all(16),
          visualDensity: VisualDensity.compact),
      onPressed: press,
      child: Center(
        child: Text(
          text ?? "",
          style: textTheme().titleMedium,
        ),
      ),
    );
  }
}

class DefaultButton2 extends StatelessWidget {
  final String? text;
  final GestureTapCallback? press;
  final Color color;
  const DefaultButton2({
    super.key,
    this.text,
    this.press,
    this.color = kPrimaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: press,
      child: Container(
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
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: 300,
            minHeight: 50,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.values[0],
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                text ?? '',
                style: const TextStyle(
                  fontSize: 16.0,
                  color: kSecondaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
