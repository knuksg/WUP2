import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:fluttermoji/fluttermoji.dart';
import 'package:get/get.dart';
import 'package:mbti_test/components/default_button.dart';
import 'package:mbti_test/components/theme.dart';
import 'package:mbti_test/routes/app_pages.dart';
import 'package:mbti_test/views/slider_view.dart';
import 'package:mbti_test/views/test_screen.dart';
import '../controllers/home_controller.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scheduleTime = DateTime.now().toLocal();
    final GlobalKey<SliderDrawerState> sliderDrawerKey =
        GlobalKey<SliderDrawerState>();
    return Scaffold(
      body: SliderDrawer(
        appBar: const SliderAppBar(
          title: Text(
            'Home',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        key: sliderDrawerKey,
        slider: SliderView(
          onItemClick: (title) {
            sliderDrawerKey.currentState?.closeSlider();
            final route = title.toLowerCase();
            Get.toNamed('/$route');
          },
        ),
        child: Container(
          color: Colors.white,
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FluttermojiCircleAvatar(
                  radius: 100,
                  backgroundColor: Colors.grey[200],
                ),
                Text(
                  controller.userName,
                  style: textTheme().displayLarge,
                ),
                Text(
                  controller.email,
                  style: const TextStyle(fontSize: 20),
                ),
                Text(
                  controller.birthday,
                  style: const TextStyle(fontSize: 20),
                ),
                Text(
                  controller.gender,
                  style: const TextStyle(fontSize: 20),
                ),
                Text(
                  controller.mbti,
                  style: const TextStyle(fontSize: 20),
                ),
                DefaultButton2(
                    press: () {
                      controller.logout();
                    },
                    text: 'Logout'),
                DefaultButton2(
                    press: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return const GuideScreen();
                        },
                      );
                    },
                    text: 'Modal Test'),
                DefaultButton2(
                  press: () {},
                  text: 'Noti test',
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (int index) {
          switch (index) {
            case 0:
              break;
            case 1:
              Get.toNamed(Routes.CALENDAR);
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
        ],
      ),
    );
  }
}
