import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:fluttermoji/fluttermoji.dart';
import 'package:get/get.dart';
import 'package:wup/Service/notification_service.dart';
import 'package:wup/components/default_button.dart';
import 'package:wup/components/theme.dart';
import 'package:wup/routes/app_pages.dart';
import 'package:wup/views/biorhytme_screen.dart';
import 'package:wup/views/slider_view.dart';
import 'package:wup/views/test_screen.dart';
import 'package:wup/controllers/home_controller.dart';
import 'package:timezone/timezone.dart' as tz;

class HomeScreen extends GetView<HomeController> {
  HomeScreen({Key? key}) : super(key: key);

  tz.TZDateTime _nextInstanceOfTenAM() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, now.hour, 30);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    scheduledDate = now.add(const Duration(seconds: 5));
    return scheduledDate;
  }

  List<double> physicalCycle = [0.99, 0.95, 0.91, 0.87, 0.84, 0.82, 0.81];
  List<double> emotionalCycle = [0.37, 0.52, 0.68, 0.82, 0.91, 0.94, 0.91];
  List<double> intellectualCycle = [0.59, 0.71, 0.81, 0.87, 0.89, 0.87, 0.81];

  @override
  Widget build(BuildContext context) {
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BiorhythmGraph(
                              physical: physicalCycle,
                              emotional: emotionalCycle,
                              intellectual: intellectualCycle),
                        ),
                      );
                    },
                    text: 'Bio'),
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
                  press: () async {
                    await NotificationService().scheduleReminder(
                        3333,
                        'title',
                        'noti',
                        tz.TZDateTime.now(tz.local)
                            .add(const Duration(seconds: 5)));
                  },
                  text: 'add noti',
                ),
                DefaultButton2(
                  press: () async {
                    await NotificationService().deletescheduleReminder(3333);
                  },
                  text: 'cancel noti',
                ),
                DefaultButton2(
                  press: () async {
                    NotificationService().scheduleReminder(
                        0, 'test', '5초', _nextInstanceOfTenAM());
                    print('test');
                  },
                  text: 'Schedule Noti test',
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
