import 'dart:async';

import 'package:flame/effects.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flame/components.dart';
import 'package:flame/input.dart';

import 'dart:math';

import 'package:wup/app/data/model/biorhythm_model.dart';

class MoveEffectExample extends FlameGame with HasDraggables, HasTappables {
  bool isCameraMoved = false;
  late Vector2 cameraPosition;
  late Vector2 cameraVelocity;
  double baseHeight = 0;
  double centerHeight = 0;
  double baseWidth = 0;
  double centerWidth = 0;
  late TextComponent todayComponent;
  late SpriteComponent physicalComponent;
  late SpriteComponent emotionalComponent;
  late SpriteComponent intellectualComponent;
  double centerPhysical = 0;
  double centerEmotional = 0;
  double centerIntellectual = 0;
  List<BioData> data = [];
  int tapPositon = 16;
  late Path path1;

  @override
  Color backgroundColor() => Colors.white;

  @override
  FutureOr<void> onLoad() {
    // TODO: implement onLoad
    return super.onLoad();
  }

  @override
  void onMount() async {
    camera.viewport = FixedResolutionViewport(Vector2(400, 600));
    baseHeight = camera.viewport.canvasSize!.y;
    centerHeight = (baseHeight / 2) - 100;

    print(centerHeight);

    baseWidth = camera.viewport.canvasSize!.x;
    centerWidth = baseWidth / 2;

    final birthday = DateTime.parse(GetStorage().read('birthday'));
    final today = DateTime.now();
    final delta = today.difference(birthday).inDays;

    final bioList = List.generate(
      31,
      (index) {
        final date = today.add(Duration(days: index - 15));
        final countDays = delta + index - 15;
        final bioPhy = sin(2 * pi * countDays / 23) * 100;
        final bioEmo = sin(2 * pi * countDays / 28) * 100;
        final bioInt = sin(2 * pi * countDays / 33) * 100;
        return BioData(date, bioPhy, bioEmo, bioInt);
      },
    );

    data.addAll(bioList);

    final firstPhy = data.first.bioPhy;
    final firstEmo = data.first.bioEmo;
    final firstInt = data.first.bioInt;

    centerPhysical = firstPhy;
    centerEmotional = firstEmo;
    centerIntellectual = firstInt;

    final paint1 = Paint()..color = Colors.red;
    final paint2 = Paint()..color = Colors.blue;
    final paint3 = Paint()..color = Colors.green;

    final path0 = Path()..moveTo(198, centerHeight + 100);
    path1 = Path()..moveTo(0, centerHeight - firstPhy);
    final path2 = Path()..moveTo(0, centerHeight - firstEmo);
    final path3 = Path()..moveTo(0, centerHeight - firstInt);
    final path4 = Path()..moveTo(0, centerHeight - firstPhy);
    final path5 = Path()..moveTo(0, centerHeight - firstEmo);
    final path6 = Path()..moveTo(0, centerHeight - firstInt);

    for (var i = 1; i <= 31; i++) {
      final countDays = delta + i - 15;
      final bioPhy = sin(2 * pi * countDays / 23) * 100;
      final bioEmo = sin(2 * pi * countDays / 28) * 100;
      final bioInt = sin(2 * pi * countDays / 33) * 100;

      final x = i * 30.0;
      final firstX = i * 30.0 + 198;
      final phyY = centerHeight - bioPhy;
      final emoY = centerHeight - bioEmo;
      final intY = centerHeight - bioInt;
      path1.lineTo(x, phyY);
      path2.lineTo(x, emoY);
      path3.lineTo(x, intY);

      if (i <= 9) {
        path0.lineTo(firstX, centerHeight + 100);
      }
      if (i <= 16) {
        path4.lineTo(x, phyY);
        path5.lineTo(x, emoY);
        path6.lineTo(x, intY);
      }
    }

    for (var i = 0; i < 300; i++) {
      print(centerHeight);
      print(centerHeight - firstPhy);

      add(
        CircleComponent(radius: 5)
          ..paint = paint1
          ..position = Vector2(0, centerHeight - firstPhy)
          ..anchor = Anchor.center
          ..add(
            MoveAlongPathEffect(
              path1,
              EffectController(
                duration: 5,
                startDelay: i * 0.03,
                infinite: true,
              ),
              absolute: true,
            ),
          ),
      );
      add(
        CircleComponent(radius: 5)
          ..paint = paint2
          ..position = Vector2(0, centerHeight - firstEmo)
          ..anchor = Anchor.center
          ..add(
            MoveAlongPathEffect(
              path2,
              EffectController(
                duration: 5,
                startDelay: i * 0.03,
                infinite: true,
              ),
              absolute: true,
            ),
          ),
      );
      add(
        CircleComponent(radius: 5)
          ..paint = paint3
          ..position = Vector2(0, centerHeight - firstInt)
          ..anchor = Anchor.center
          ..add(
            MoveAlongPathEffect(
              path3,
              EffectController(
                duration: 5,
                startDelay: i * 0.03,
                infinite: true,
              ),
              absolute: true,
            ),
          ),
      );
    }

    add(todayComponent = TextComponent()
      ..add(MoveAlongPathEffect(path0, EffectController(duration: 5))));

    camera.followComponent(todayComponent);

    final physicalImage = await images.load('Physical.png');
    add(physicalComponent = SpriteComponent.fromImage(physicalImage)
      ..size = Vector2.all(30)
      ..anchor = Anchor.center
      ..priority = Priority.kMaxOffset
      ..add(MoveAlongPathEffect(path4, EffectController(duration: 5))));

    final emotionalImage = await images.load('Emotional.png');
    add(emotionalComponent = SpriteComponent.fromImage(emotionalImage)
      ..size = Vector2.all(30)
      ..anchor = Anchor.center
      ..priority = Priority.kMaxOffset
      ..add(MoveAlongPathEffect(path5, EffectController(duration: 5))));

    final intellectualImage = await images.load('Intellectual.png');
    add(intellectualComponent = SpriteComponent.fromImage(intellectualImage)
      ..size = Vector2.all(30)
      ..anchor = Anchor.center
      ..priority = Priority.kMaxOffset
      ..add(MoveAlongPathEffect(path6, EffectController(duration: 5))));

    add(TextComponent(
      text: 'Today',
      textRenderer: TextPaint(
          style: const TextStyle(
        color: Colors.black,
      )),
      position: Vector2(30.0 * 16, centerHeight + 115),
      anchor: Anchor.center,
    ));

    add(TimerComponent(
      period: 5,
      onTick: () => isCameraMoved = true,
    ));

    overlays.add('NextButton');
    overlays.add('PreviousButton');

    cameraPosition = Vector2(30.0 * 16, centerHeight + 100);
    cameraVelocity = Vector2(0, centerHeight + 100);
  }

  @override
  void render(Canvas canvas) async {
    // TODO: implement render
    super.render(canvas);

    const textStyle = TextStyle(
      color: Colors.black,
      fontSize: 16,
    );

    const textSpan0 = TextSpan(
      text: '0',
      style: textStyle,
    );

    const textSpan1 = TextSpan(
      text: '100',
      style: textStyle,
    );

    const textSpan2 = TextSpan(
      text: '-100',
      style: textStyle,
    );

    TextSpan textSpan3 = TextSpan(
      text: 'Physical $centerPhysical',
      style: textStyle,
    );

    TextSpan textSpan4 = TextSpan(
      text: 'Emotional $centerEmotional',
      style: textStyle,
    );

    TextSpan textSpan5 = TextSpan(
      text: 'Intellectual $centerIntellectual',
      style: textStyle,
    );

    final textPainter0 = TextPainter(
      text: textSpan0,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    final textPainter1 = TextPainter(
      text: textSpan1,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    final textPainter2 = TextPainter(
      text: textSpan2,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    final textPainter3 = TextPainter(
      text: textSpan3,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    final textPainter4 = TextPainter(
      text: textSpan4,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    final textPainter5 = TextPainter(
      text: textSpan5,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    textPainter0.layout();
    textPainter1.layout();
    textPainter2.layout();
    textPainter3.layout();
    textPainter4.layout();
    textPainter5.layout();

    const x = 16.0;
    double y = centerHeight - 125;

    textPainter0.paint(canvas, Offset(x, centerHeight - 20));
    textPainter1.paint(canvas, Offset(x, y));
    textPainter2.paint(canvas, Offset(x, centerHeight + 105));
    textPainter3.paint(canvas, const Offset(x, 30));
    textPainter4.paint(canvas, const Offset(x, 50));
    textPainter5.paint(canvas, const Offset(x, 70));

    final paint1 = Paint()
      ..color = const Color.fromARGB(99, 0, 0, 0)
      ..strokeWidth = 2;
    canvas.drawLine(
        Offset(0, centerHeight), Offset(baseWidth, centerHeight), paint1);
    canvas.drawLine(Offset(0, centerHeight + 102),
        Offset(baseWidth, centerHeight + 102), paint1);
    canvas.drawLine(Offset(0, centerHeight - 102),
        Offset(baseWidth, centerHeight - 102), paint1);

    canvas.drawLine(Offset(centerWidth, centerHeight - 102),
        Offset(centerWidth, centerHeight + 102), paint1);
    canvas.drawLine(Offset(baseWidth / 4 + 10, centerHeight - 102),
        Offset(baseWidth / 4 + 10, centerHeight + 102), paint1);
    canvas.drawLine(Offset(baseWidth / 4 * 3 - 10, centerHeight - 102),
        Offset(baseWidth / 4 * 3 - 10, centerHeight + 102), paint1);
    canvas.drawLine(Offset(baseWidth - 20, centerHeight - 102),
        Offset(baseWidth - 20, centerHeight + 102), paint1);
    canvas.drawLine(
        Offset(20, centerHeight - 102), Offset(20, centerHeight + 102), paint1);
  }

  @override
  void onDragUpdate(int pointerId, DragUpdateInfo info) {
    // TODO: implement onDragUpdate
    super.onDragUpdate(pointerId, info);
    final dragDelta = Vector2(info.delta.game.x, 0);
    final dragPos = cameraPosition - dragDelta;
    final maxPos = Vector2(30.0 * 24, centerHeight + 100);
    final minPos = camera.viewport.effectiveSize / 2;
    cameraPosition.x = dragPos.x.clamp(minPos.x + 10, maxPos.x);
    cameraPosition.y = dragPos.y.clamp(minPos.y, maxPos.y);
  }

  @override
  void onDragEnd(int pointerId, DragEndInfo info) {
    // TODO: implement onDragEnd
    super.onDragEnd(pointerId, info);
    cameraVelocity = Vector2(0, centerHeight);
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (isCameraMoved) {
      camera.followVector2(cameraPosition);
    }
  }
}
