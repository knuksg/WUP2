import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wup/app/modules/user/welcome/welcome_controller.dart';
import 'package:wup/app/routes/app_pages.dart';
import 'package:wup/app/theme/app_color.dart';
import 'package:wup/app/widgets/default_button.dart';
import 'package:easy_localization/easy_localization.dart';

class WelcomeScreen extends GetView<WelcomeController> {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 640),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return Scaffold(
            appBar: AppBar(
              toolbarHeight: 0,
              backgroundColor: kPrimaryColor,
            ),
            body: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
              return ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                    minWidth: constraints.maxWidth,
                  ),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 16),
                          if (context.locale.languageCode == 'en')
                            Text.rich(TextSpan(
                                text: '${tr('welcome')}, ',
                                style: TextStyle(
                                    fontSize: 24.sp,
                                    fontWeight: FontWeight.bold,
                                    color: kPrimaryColor),
                                children: [
                                  TextSpan(
                                      text: '${tr("name", args: [
                                            controller.name
                                          ])}!',
                                      style:
                                          const TextStyle(color: Colors.black))
                                ])),
                          if (context.locale.languageCode != 'en')
                            Text.rich(TextSpan(
                                text:
                                    "${tr('name', args: [controller.name])}, ",
                                style: TextStyle(
                                    fontSize: 24.sp,
                                    fontWeight: FontWeight.bold),
                                children: [
                                  TextSpan(
                                      text: '${tr('welcome')}!',
                                      style:
                                          const TextStyle(color: kPrimaryColor))
                                ])),
                          const SizedBox(
                            height: 32,
                          ),
                          const Text('환'),
                          const Text('영'),
                          const Text('멘'),
                          const Text('트'),
                          const SizedBox(
                            height: 32,
                          ),
                          const Spacer(),
                          SizedBox(
                            width: min(320, 320.w),
                            height: 30.h,
                            child: DefaultButton(
                              text: tr('next'),
                              press: () {
                                Get.offNamed(Routes.INPUT);
                              },
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ));
            }),
          );
        });
  }
}
