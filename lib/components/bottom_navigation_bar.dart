import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wup/components/constants.dart';
import 'package:wup/routes/app_pages.dart';

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
            Get.toNamed(Routes.HOME);
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
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_month),
          label: 'Calendar',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.gamepad),
          label: 'Game',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.timeline),
          label: 'Biorhythm',
        ),
      ],
    );
  }
}
