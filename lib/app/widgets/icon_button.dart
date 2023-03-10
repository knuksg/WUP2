import 'package:flutter/material.dart';
import 'package:wup/app/theme/app_color.dart';

class IconDefaultButton extends StatelessWidget {
  final Icon icon;
  final GestureTapCallback? press;
  final Color color;

  const IconDefaultButton({
    Key? key,
    required this.icon,
    this.press,
    this.color = kPrimaryColor,
  }) : super(key: key);

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
            minWidth: 50,
            minHeight: 50,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.values[0],
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
            ],
          ),
        ),
      ),
    );
  }
}
