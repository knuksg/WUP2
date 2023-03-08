import 'package:flutter/material.dart';
import 'package:wup/app/theme/app_color.dart';

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
