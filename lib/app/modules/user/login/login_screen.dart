import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wup/app/modules/user/login/login_controller.dart';
import 'package:wup/app/modules/user/login/widgets/login_button.dart';
import 'package:wup/app/theme/app_color.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 640),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return Scaffold(
            body: Container(
              width: 360.w,
              height: 640.h,
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'WUP',
                          textAlign: TextAlign.center,
                          style:
                              TextStyle(fontSize: 96.sp, color: kPrimaryColor),
                        ),
                        Text(
                          'Change Your Life',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 24.sp, color: kSecondaryColor),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      SizedBox(
                        width: min(320, 320.w),
                        height: 35.h,
                        child: LoginButton(
                            platform: "Google",
                            onPressed: () {
                              controller.googleLogin();
                            }),
                      ),
                      const SizedBox(height: 8.0),
                      SizedBox(
                        width: min(320, 320.w),
                        height: 35.h,
                        child: LoginButton(
                          platform: "Facebook",
                          onPressed: () {
                            controller.facebookLogin();
                          },
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      SizedBox(
                        width: min(320, 320.w),
                        height: 35.h,
                        child: LoginButton(
                          platform: "Apple",
                          onPressed: () {
                            controller.appleLogin();
                          },
                        ),
                      ),
                      const SizedBox(height: 8.0),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }
}
