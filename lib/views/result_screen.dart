import 'package:flutter/material.dart';
import 'package:fluttermoji/fluttermoji.dart';
import 'package:get/get.dart';
import 'package:wup/controllers/result_controller.dart';
import 'package:wup/routes/app_pages.dart';

class ResultScreen extends GetView<ResultController> {
  const ResultScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('임시 결과 화면입니다.'),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FluttermojiCircleAvatar(
                radius: 100,
                backgroundColor: Colors.grey[200],
              ),
              Text(controller.mbti),
              IconButton(
                  onPressed: () {
                    Get.offAllNamed(Routes.HOME);
                  },
                  icon: const Icon(Icons.home))
            ],
          ),
        ));
  }
}
