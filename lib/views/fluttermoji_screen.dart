import 'package:flutter/material.dart';
import 'package:fluttermoji/fluttermoji.dart';

import 'dart:math';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mbti_test/components/default_button.dart';
import 'package:mbti_test/components/theme.dart';
import 'package:mbti_test/controllers/fluttermoji_controller.dart';
import 'package:mbti_test/routes/app_pages.dart';

class FluttermojiScreen extends GetView<FluttermojiController> {
  FluttermojiScreen({Key? key}) : super(key: key);
  final MojiController mojiController = Get.put(MojiController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
              minWidth: constraints.maxWidth,
            ),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  LinearProgressIndicator(
                    value: GetStorage().read('progressbar'),
                  ),
                  ConstrainedBox(
                    constraints:
                        BoxConstraints(minHeight: constraints.maxHeight),
                    child: IntrinsicHeight(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(children: [
                          const SizedBox(height: 16),
                          Text(
                            '자유롭게 아바타를 만들어보세요!',
                            style: textTheme().displayLarge,
                          ),
                          const SizedBox(height: 16),
                          FluttermojiCircleAvatar(
                            radius: 100,
                            backgroundColor: Colors.grey[200],
                          ),
                          const SizedBox(height: 16),
                          FluttermojiCustomizer(
                            // 모든 구성 요소를 직접 커스터마이즈할 수 있음!
                            scaffoldWidth:
                                min(600, constraints.maxWidth * 0.85),
                            autosave: false,
                            theme: FluttermojiThemeData(
                              boxDecoration:
                                  const BoxDecoration(boxShadow: [BoxShadow()]),
                              labelTextStyle:
                                  const TextStyle(color: Colors.red),
                              selectedIconColor: Colors.blueAccent,
                              selectedTileDecoration:
                                  const BoxDecoration(color: Colors.amber),
                            ),
                          ),
                          const Spacer(),
                          FluttermojiSaveWidget(
                            child: const DefaultButton2(
                              text: 'Submit',
                            ),
                            onTap: () {
                              Get.toNamed(Routes.RESULT);
                            },
                          ),
                          const SizedBox(height: 32),
                        ]),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
