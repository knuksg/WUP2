import 'package:flutter/material.dart';
import 'package:wup/app/theme/app_color.dart';

class DefaultTextBox extends StatelessWidget {
  final String? text;
  final GestureTapCallback? press;
  final Color color;
  const DefaultTextBox({
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
        padding: const EdgeInsets.all(8.0),
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
        child: Text(text ?? ''),
      ),
    );
  }
}
