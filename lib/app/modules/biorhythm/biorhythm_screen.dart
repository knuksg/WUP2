import 'package:easy_localization/easy_localization.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
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
              actions: [
                const SizedBox(height: 8.0),
                IconButton(
                  icon: const Icon(Icons.share),
                  onPressed: () async {
                    await Share.share(controller.advice.value);
                  },
                )
              ],
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
                ),
                Positioned.fill(
                    top: 210.h,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 110.w,
                              height: 100.h,
                              child: Obx(
                                () => SfRadialGauge(
                                  axes: <RadialAxis>[
                                    RadialAxis(
                                      startAngle: 0,
                                      endAngle: 360,
                                      showLabels: false,
                                      showTicks: false,
                                      radiusFactor: 0.8,
                                      axisLineStyle: const AxisLineStyle(
                                        thicknessUnit: GaugeSizeUnit.factor,
                                        thickness: 0.07,
                                      ),
                                    ),
                                    RadialAxis(
                                      startAngle: 0,
                                      endAngle: 360,
                                      showLabels: false,
                                      showTicks: false,
                                      showAxisLine: false,
                                      radiusFactor: 0.8,
                                      maximum: 100,
                                      interval: 1,
                                      annotations: <GaugeAnnotation>[
                                        GaugeAnnotation(
                                          widget: Center(
                                            child: Text(
                                              controller.centerPhysical.value
                                                          .toString()
                                                          .split('.')[1] !=
                                                      '0'
                                                  ? "${controller.centerPhysical.value}%"
                                                  : controller.centerPhysical
                                                              .value !=
                                                          0
                                                      ? "${controller.centerPhysical.value.toInt()}%"
                                                      : "0%",
                                              style: TextStyle(
                                                fontSize: 16.sp,
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                      pointers: <GaugePointer>[
                                        RangePointer(
                                          value: convertValue(
                                            controller.centerPhysical.value,
                                          ),
                                          width: 0.1,
                                          color: const Color(0xFFF67280),
                                          enableAnimation: true,
                                          sizeUnit: GaugeSizeUnit.factor,
                                          gradient: const SweepGradient(
                                            colors: <Color>[
                                              Color(0xFFFFB397),
                                              Color(0xFFF46AA0)
                                            ],
                                            stops: <double>[0.25, 0.75],
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 110.w,
                              height: 100.h,
                              child: Obx(
                                () => SfRadialGauge(
                                  axes: <RadialAxis>[
                                    RadialAxis(
                                      startAngle: 0,
                                      endAngle: 360,
                                      showLabels: false,
                                      showTicks: false,
                                      radiusFactor: 0.8,
                                      axisLineStyle: const AxisLineStyle(
                                        thicknessUnit: GaugeSizeUnit.factor,
                                        thickness: 0.07,
                                      ),
                                    ),
                                    RadialAxis(
                                        startAngle: 0,
                                        endAngle: 360,
                                        showLabels: false,
                                        showTicks: false,
                                        showAxisLine: false,
                                        radiusFactor: 0.8,
                                        maximum: 100,
                                        interval: 1,
                                        annotations: <GaugeAnnotation>[
                                          GaugeAnnotation(
                                            widget: Center(
                                              child: Text(
                                                  controller.centerEmotional
                                                              .value
                                                              .toString()
                                                              .split('.')[1] !=
                                                          '0'
                                                      ? "${controller.centerEmotional.value}%"
                                                      : controller.centerEmotional
                                                                  .value !=
                                                              0
                                                          ? "${controller.centerEmotional.value.toInt()}%"
                                                          : "0%",
                                                  style: TextStyle(
                                                      fontSize: 16.sp),
                                                  textAlign: TextAlign.center),
                                            ),
                                          )
                                        ],
                                        pointers: <GaugePointer>[
                                          RangePointer(
                                            value: convertValue(
                                              controller.centerEmotional.value,
                                            ),
                                            width: 0.1,
                                            color: const Color(0xFFC9E4F9),
                                            enableAnimation: true,
                                            sizeUnit: GaugeSizeUnit.factor,
                                            gradient: const SweepGradient(
                                                colors: <Color>[
                                                  Color(0xFF86CFF4),
                                                  Color(0xFF3BA7F5)
                                                ],
                                                stops: <double>[
                                                  0.25,
                                                  0.75
                                                ]),
                                          ),
                                        ])
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 110.w,
                              height: 100.h,
                              child: Obx(
                                () => SfRadialGauge(
                                  axes: <RadialAxis>[
                                    RadialAxis(
                                      startAngle: 0,
                                      endAngle: 360,
                                      showLabels: false,
                                      showTicks: false,
                                      radiusFactor: 0.8,
                                      axisLineStyle: const AxisLineStyle(
                                        thicknessUnit: GaugeSizeUnit.factor,
                                        thickness: 0.07,
                                      ),
                                    ),
                                    RadialAxis(
                                        startAngle: 0,
                                        endAngle: 360,
                                        showLabels: false,
                                        showTicks: false,
                                        showAxisLine: false,
                                        radiusFactor: 0.8,
                                        maximum: 100,
                                        interval: 1,
                                        annotations: <GaugeAnnotation>[
                                          GaugeAnnotation(
                                            widget: Text(
                                                controller.centerIntellectual
                                                            .value
                                                            .toString()
                                                            .split('.')[1] !=
                                                        '0'
                                                    ? "${controller.centerIntellectual.value}%"
                                                    : controller.centerIntellectual
                                                                .value !=
                                                            0
                                                        ? "${controller.centerIntellectual.value.toInt()}%"
                                                        : "0%",
                                                style:
                                                    TextStyle(fontSize: 16.sp),
                                                textAlign: TextAlign.center),
                                          )
                                        ],
                                        pointers: <GaugePointer>[
                                          RangePointer(
                                            value: convertValue(
                                              controller
                                                  .centerIntellectual.value,
                                            ),
                                            width: 0.1,
                                            color: const Color(0xFF98FB98),
                                            enableAnimation: true,
                                            sizeUnit: GaugeSizeUnit.factor,
                                            gradient: const SweepGradient(
                                                colors: <Color>[
                                                  Color(0xFF8BC34A),
                                                  Color(0xFF008B45)
                                                ],
                                                stops: <double>[
                                                  0.25,
                                                  0.75
                                                ]),
                                          ),
                                        ])
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    )),
                Positioned.fill(
                  top: 310.h,
                  bottom: 50.h,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      child: Column(
                        children: [
                          DefaultTextBox(text: tr('biorhythm.advice_title')),
                          const SizedBox(height: 8.0),
                          Obx(() {
                            if (controller.isLoading.value) {
                              return Visibility(
                                visible: true,
                                child: Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      CircularProgressIndicator(),
                                    ],
                                  ),
                                ),
                              );
                            } else if (controller.advice.value.isEmpty) {
                              return const Visibility(
                                visible: true,
                                child: Text('No advice available.'),
                              );
                            } else {
                              return Column(
                                children: [
                                  SizedBox(
                                    height: 150.h,
                                    child: DefaultTextBox(
                                      text: controller.advice.value.trim(),
                                    ),
                                  ),
                                ],
                              );
                            }
                          }),
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
      BuildContext buildContext, BiorhythmAnimation animation) {
    return Positioned(
      bottom: 10,
      right: 10,
      child: IconDefaultButton(
        icon: const Icon(Icons.navigate_next),
        press: () {
          print(animation.tapPositon);
          if (animation.tapPositon < animation.data.length - 1) {
            animation.tapPositon++;

            animation.physicalComponent.position = Vector2(
                30.0 * animation.tapPositon,
                animation.baseHeight +
                    100 -
                    animation.data[animation.tapPositon].bioPhy);
            animation.emotionalComponent.position = Vector2(
                30.0 * animation.tapPositon,
                animation.baseHeight +
                    100 -
                    animation.data[animation.tapPositon].bioEmo);
            animation.intellectualComponent.position = Vector2(
                30.0 * animation.tapPositon,
                animation.baseHeight +
                    100 -
                    animation.data[animation.tapPositon].bioInt);

            animation.centerPhysical =
                animation.data[animation.tapPositon].bioPhy;
            animation.centerEmotional =
                animation.data[animation.tapPositon].bioEmo;
            animation.centerIntellectual =
                animation.data[animation.tapPositon].bioInt;

            if (animation.cameraPosition.x <
                    30 * 31 -
                        animation.camera.viewport.effectiveSize.x / 2 -
                        30 &&
                animation.cameraPosition.x >
                    animation.camera.viewport.effectiveSize.x / 2 + 30) {
              animation.cameraPosition.x = animation.physicalComponent.x;
            } else if (animation.physicalComponent.x <
                    30 * 31 -
                        animation.camera.viewport.effectiveSize.x / 2 -
                        30 &&
                animation.physicalComponent.x >
                    animation.camera.viewport.effectiveSize.x / 2 + 30) {
              animation.cameraPosition.x = animation.physicalComponent.x;
            }
          }

          controller.centerPhysical.value =
              animation.data[animation.tapPositon].bioPhy;
          controller.centerEmotional.value =
              animation.data[animation.tapPositon].bioEmo;
          controller.centerIntellectual.value =
              animation.data[animation.tapPositon].bioInt;
        },
      ),
    );
  }

  Widget _previousButtonBuilder(
      BuildContext buildContext, BiorhythmAnimation animation) {
    return Positioned(
      bottom: 10,
      left: 10,
      child: IconDefaultButton(
        icon: const Icon(Icons.navigate_before),
        press: () {
          if (animation.tapPositon > 1) {
            animation.tapPositon--;

            animation.physicalComponent.position = Vector2(
                30.0 * animation.tapPositon,
                animation.baseHeight +
                    100 -
                    animation.data[animation.tapPositon].bioPhy);
            animation.emotionalComponent.position = Vector2(
                30.0 * animation.tapPositon,
                animation.baseHeight +
                    100 -
                    animation.data[animation.tapPositon].bioEmo);
            animation.intellectualComponent.position = Vector2(
                30.0 * animation.tapPositon,
                animation.baseHeight +
                    100 -
                    animation.data[animation.tapPositon].bioInt);

            animation.centerPhysical =
                animation.data[animation.tapPositon].bioPhy;
            animation.centerEmotional =
                animation.data[animation.tapPositon].bioEmo;
            animation.centerIntellectual =
                animation.data[animation.tapPositon].bioInt;

            if (animation.cameraPosition.x <
                    30 * 31 -
                        animation.camera.viewport.effectiveSize.x / 2 -
                        30 &&
                animation.cameraPosition.x >
                    animation.camera.viewport.effectiveSize.x / 2 + 30) {
              animation.cameraPosition.x = animation.physicalComponent.x;
            } else if (animation.physicalComponent.x <
                    30 * 31 -
                        animation.camera.viewport.effectiveSize.x / 2 -
                        30 &&
                animation.physicalComponent.x >
                    animation.camera.viewport.effectiveSize.x / 2 + 30) {
              animation.cameraPosition.x = animation.physicalComponent.x;
            }
          }

          controller.centerPhysical.value =
              animation.data[animation.tapPositon].bioPhy;
          controller.centerEmotional.value =
              animation.data[animation.tapPositon].bioEmo;
          controller.centerIntellectual.value =
              animation.data[animation.tapPositon].bioInt;
        },
      ),
    );
  }

  Widget _todayButtonBuilder(
      BuildContext buildContext, BiorhythmAnimation animation) {
    return Positioned.fill(
      bottom: 10,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          IconDefaultButton(
            icon: const Icon(Icons.today),
            press: () async {
              animation.tapPositon = 16;

              animation.physicalComponent.position = Vector2(
                  30.0 * animation.tapPositon,
                  animation.baseHeight +
                      100 -
                      animation.data[animation.tapPositon].bioPhy);
              animation.emotionalComponent.position = Vector2(
                  30.0 * animation.tapPositon,
                  animation.baseHeight +
                      100 -
                      animation.data[animation.tapPositon].bioEmo);
              animation.intellectualComponent.position = Vector2(
                  30.0 * animation.tapPositon,
                  animation.baseHeight +
                      100 -
                      animation.data[animation.tapPositon].bioInt);

              animation.centerPhysical =
                  animation.data[animation.tapPositon].bioPhy;
              animation.centerEmotional =
                  animation.data[animation.tapPositon].bioEmo;
              animation.centerIntellectual =
                  animation.data[animation.tapPositon].bioInt;

              animation.cameraPosition.x = animation.physicalComponent.x;

              controller.centerPhysical.value =
                  animation.data[animation.tapPositon].bioPhy;
              controller.centerEmotional.value =
                  animation.data[animation.tapPositon].bioEmo;
              controller.centerIntellectual.value =
                  animation.data[animation.tapPositon].bioInt;
            },
          )
        ],
      ),
    );
  }
}

convertValue(double value) {
  return (value + 100) / 2;
}
