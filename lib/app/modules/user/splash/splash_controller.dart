import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:wup/app/routes/app_pages.dart';
import 'package:wup/app/theme/app_color.dart';

class SplashController extends GetxController {
  final getStorage = GetStorage();
  RxList textWidget = [].obs;
  RxString WUP = ''.obs;

  List<Color> colorizeColors = [
    kPrimaryColor,
    kSecondaryColor,
    Colors.cyan,
    Colors.lightBlue,
  ];

  TextStyle colorizeTextStyle = const TextStyle(
    fontSize: 72.0,
    fontWeight: FontWeight.bold,
    color: kPrimaryColor,
  );

  void animationFinished() {
    textWidget[0] = Container();
    textWidget[1] = Container();
    textWidget[2] = Container();
    WUP.value = 'W-UP';
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    textWidget.addAll(textWidgetList);
  }

  @override
  void onReady() async {
    super.onReady();
    // 화면 수정 쉽게 하기 위해서 아래줄에서 바로 링크 연결합니다.
    //수정 끝나면 하단 주석처리된 부분 다시 살려주세요.
    // Get.offNamed(Routes.LOGIN);

    if (getStorage.read('email') != null) {
      Future.delayed(const Duration(milliseconds: 3000), () {
        if (getStorage.read('mbti') != null) {
          Get.offAllNamed(Routes.HOME);
        } else {
          Get.offAllNamed(Routes.WELCOME);
        }
      });
    } else {
      Get.offAllNamed(Routes.LOGIN);
    }
  }

  List<Widget> textWidgetList = [
    const Text(
      'W',
      style: TextStyle(
        fontSize: 72,
        fontWeight: FontWeight.bold,
        color: kPrimaryColor,
      ),
    ),
    const SizedBox(
      width: double.minPositive,
      child: Text(
        '-',
        style: TextStyle(
          fontSize: 72,
          fontWeight: FontWeight.bold,
          color: kPrimaryColor,
        ),
      ),
    ),
    const Text(
      'UP',
      style: TextStyle(
        fontSize: 72,
        fontWeight: FontWeight.bold,
        color: kPrimaryColor,
      ),
    ),
  ];
}
