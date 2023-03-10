import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wup/app/modules/biorhythm/biorhythm_animation_screen.dart';
import 'package:wup/app/modules/biorhythm/biorhythm_controller.dart';
import 'package:wup/app/routes/app_pages.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wup/app/widgets/default_text_box.dart';
import 'package:wup/app/widgets/icon_button.dart';

class NewBiorhythmScreen extends GetView<BiorhythmController> {
  const NewBiorhythmScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 640),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Get.offAllNamed(Routes.HOME);
                },
              ),
            ),
            body: Stack(
              children: [
                GameWidget.controlled(
                  gameFactory: BiorhythmAnimation.new,
                  overlayBuilderMap: {
                    'NextButton': _nextButtonBuilder,
                    'PreviousButton': _previousButtonBuilder,
                    'TodayButton': _todayButtonBuilder,
                  },
                  initialActiveOverlays: const ['TodayButton'],
                ),
                Positioned.fill(
                  top: 350,
                  bottom: 50,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      child: Column(
                        children: [
                          const Text("Today's Advice"),
                          const SizedBox(height: 8.0),
                          SizedBox(
                            height: 200.h,
                            child: SingleChildScrollView(
                              child: Obx(() {
                                if (controller.isLoading.value) {
                                  return const Visibility(
                                    visible: true,
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (controller.advice.value.isEmpty) {
                                  return const Visibility(
                                    visible: true,
                                    child: Text('No advice available.'),
                                  );
                                } else {
                                  return DefaultTextBox(
                                    text: controller.advice.value.trim(),
                                  );
                                }
                              }),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  Widget _nextButtonBuilder(
      BuildContext buildContext, BiorhythmAnimation game) {
    return Positioned(
      bottom: 10,
      right: 10,
      child: IconDefaultButton(
        icon: const Icon(Icons.navigate_next),
        press: () {
          if (game.tapPositon < game.data.length - 1) {
            game.tapPositon++;

            game.physicalComponent.position = Vector2(30.0 * game.tapPositon,
                game.baseHeight + 100 - game.data[game.tapPositon].bioPhy);
            game.emotionalComponent.position = Vector2(30.0 * game.tapPositon,
                game.baseHeight + 100 - game.data[game.tapPositon].bioEmo);
            game.intellectualComponent.position = Vector2(
                30.0 * game.tapPositon,
                game.baseHeight + 100 - game.data[game.tapPositon].bioInt);

            game.centerPhysical = game.data[game.tapPositon].bioPhy;
            game.centerEmotional = game.data[game.tapPositon].bioEmo;
            game.centerIntellectual = game.data[game.tapPositon].bioInt;

            if (game.cameraPosition.x <
                    30 * 31 - game.camera.viewport.effectiveSize.x / 2 - 30 &&
                game.cameraPosition.x >
                    game.camera.viewport.effectiveSize.x / 2 + 30) {
              game.cameraPosition.x = game.physicalComponent.x;
            } else if (game.physicalComponent.x <
                    30 * 31 - game.camera.viewport.effectiveSize.x / 2 - 30 &&
                game.physicalComponent.x >
                    game.camera.viewport.effectiveSize.x / 2 + 30) {
              game.cameraPosition.x = game.physicalComponent.x;
            }
          }
        },
      ),
    );
  }

  Widget _previousButtonBuilder(
      BuildContext buildContext, BiorhythmAnimation game) {
    return Positioned(
      bottom: 10,
      left: 10,
      child: IconDefaultButton(
        icon: const Icon(Icons.navigate_before),
        press: () async {
          if (game.tapPositon > 1) {
            game.tapPositon--;

            game.physicalComponent.position = Vector2(30.0 * game.tapPositon,
                game.baseHeight + 100 - game.data[game.tapPositon].bioPhy);
            game.emotionalComponent.position = Vector2(30.0 * game.tapPositon,
                game.baseHeight + 100 - game.data[game.tapPositon].bioEmo);
            game.intellectualComponent.position = Vector2(
                30.0 * game.tapPositon,
                game.baseHeight + 100 - game.data[game.tapPositon].bioInt);

            game.centerPhysical = game.data[game.tapPositon].bioPhy;
            game.centerEmotional = game.data[game.tapPositon].bioEmo;
            game.centerIntellectual = game.data[game.tapPositon].bioInt;

            if (game.cameraPosition.x <
                    30 * 31 - game.camera.viewport.effectiveSize.x / 2 - 30 &&
                game.cameraPosition.x >
                    game.camera.viewport.effectiveSize.x / 2 + 30) {
              game.cameraPosition.x = game.physicalComponent.x;
            } else if (game.physicalComponent.x <
                    30 * 31 - game.camera.viewport.effectiveSize.x / 2 - 30 &&
                game.physicalComponent.x >
                    game.camera.viewport.effectiveSize.x / 2 + 30) {
              game.cameraPosition.x = game.physicalComponent.x;
            }
          }
        },
      ),
    );
  }

  Widget _todayButtonBuilder(
      BuildContext buildContext, BiorhythmAnimation game) {
    return Positioned.fill(
      bottom: 10,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          IconDefaultButton(
            icon: const Icon(Icons.today),
            press: () async {
              game.tapPositon = 16;

              game.physicalComponent.position = Vector2(30.0 * game.tapPositon,
                  game.baseHeight + 100 - game.data[game.tapPositon].bioPhy);
              game.emotionalComponent.position = Vector2(30.0 * game.tapPositon,
                  game.baseHeight + 100 - game.data[game.tapPositon].bioEmo);
              game.intellectualComponent.position = Vector2(
                  30.0 * game.tapPositon,
                  game.baseHeight + 100 - game.data[game.tapPositon].bioInt);

              game.centerPhysical = game.data[game.tapPositon].bioPhy;
              game.centerEmotional = game.data[game.tapPositon].bioEmo;
              game.centerIntellectual = game.data[game.tapPositon].bioInt;

              game.cameraPosition.x = game.physicalComponent.x;
            },
          )
        ],
      ),
    );
  }
}
