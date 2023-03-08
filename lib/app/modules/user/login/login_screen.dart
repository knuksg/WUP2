import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wup/app/modules/user/login/login_controller.dart';
import 'package:wup/app/modules/user/login/widgets/login_button.dart';
import 'package:wup/app/theme/app_color.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'WUP',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 64, color: kPrimaryColor),
                    ),
                    Text(
                      'Change Your Life',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: kSecondaryColor),
                    ),
                  ],
                ),
              ),
              LoginButton(
                  platform: "Google",
                  onPressed: () {
                    controller.googleLogin();
                  }),
              const SizedBox(height: 16),
              LoginButton(
                platform: "Facebook",
                onPressed: () {
                  controller.facebookLogin();
                },
              ),
              const SizedBox(height: 16),
              LoginButton(
                platform: "Apple",
                onPressed: () {
                  controller.appleLogin();
                },
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
