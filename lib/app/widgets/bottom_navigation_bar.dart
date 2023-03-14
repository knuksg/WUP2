import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wup/app/routes/app_pages.dart';
import 'package:wup/app/theme/app_color.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;

  const CustomBottomNavigationBar({Key? key, required this.selectedIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      selectedItemColor: Colors.red,
      unselectedItemColor: kPrimaryColor,
      showUnselectedLabels: true,
      currentIndex: selectedIndex,
      onTap: (int index) {
        switch (index) {
          case 0:
            Get.offNamed(Routes.HOME);
            break;
          case 1:
            Get.toNamed(Routes.CALENDAR);
            break;
          case 2:
            Get.toNamed(Routes.GAME);
            break;
          case 3:
            Get.toNamed(Routes.PROFILE);
            break;
          case 4:
            Get.toNamed(Routes.BIORHYTHM);
            break;
        }
      },
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.home),
          label: tr('navigation_bar.home'),
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.calendar_month),
          label: tr('navigation_bar.calendar'),
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.gamepad),
          label: tr('navigation_bar.game'),
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.person),
          label: tr('navigation_bar.profile'),
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.timeline),
          label: tr('navigation_bar.biorhythm'),
        ),
      ],
    );
  }
}
