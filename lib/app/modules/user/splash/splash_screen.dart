import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wup/app/modules/user/splash/splash_controller.dart';

class SplashScreen extends GetView<SplashController> {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 15, end: -5),
              duration: const Duration(milliseconds: 700),
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(value, 0),
                  child: child,
                );
              },
              child: Obx(() => controller.textWidget[0]),
            ),
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: const Duration(milliseconds: 1000),
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: child,
                );
              },
              child: Obx(() => controller.textWidget[1]),
              onEnd: () {
                controller.animationFinished();
              },
            ),
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 15, end: 35),
              duration: const Duration(milliseconds: 700),
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(value, 0),
                  child: child,
                );
              },
              child: Obx(() => controller.textWidget[2]),
            ),
            Obx(() => AnimatedTextKit(animatedTexts: [
                  ColorizeAnimatedText(
                    controller.WUP.value,
                    textStyle: controller.colorizeTextStyle,
                    colors: controller.colorizeColors,
                  ),
                ]))
          ],
        ),
      ),
    );
  }
}
