import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wup/app/modules/biorhythm/biorhythm_screen.dart';
import 'package:wup/app/modules/game/game_controller.dart';
import 'package:wup/app/routes/app_pages.dart';

class GameScreen extends GetView<GameController> {
  const GameScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Get.offAllNamed(Routes.HOME);
          },
        ),
      ),
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        return ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: constraints.maxHeight,
            minWidth: constraints.maxWidth,
          ),
          child: IntrinsicHeight(
            child: Stack(
              children: const [
                GameWidget.controlled(
                  gameFactory: MoveEffectExample.new,
                  overlayBuilderMap: {
                    'NextButton': _nextButtonBuilder,
                    'PreviousButton': _previousButtonBuilder,
                    'TodayButton': _todayButtonBuilder,
                  },
                  initialActiveOverlays: ['TodayButton'],
                ),
              ],
            ),
            // child: GameWidget<EmberQuestGame>.controlled(
            //   gameFactory: EmberQuestGame.new,
            //   overlayBuilderMap: {
            //     'MainMenu': (_, game) => MainMenu(game: game),
            //     'GameOver': (_, game) => GameOver(game: game),
            //   },
            //   initialActiveOverlays: const ['MainMenu'],
            // ),
          ),
        );
      }),
    );
  }
}

Widget _nextButtonBuilder(BuildContext buildContext, MoveEffectExample game) {
  return Positioned(
    bottom: 10,
    right: 10,
    child: ElevatedButton(
      child: const Icon(Icons.navigate_next),
      onPressed: () {
        if (game.tapPositon < game.data.length - 1) {
          game.tapPositon++;

          game.physicalComponent.position = Vector2(30.0 * game.tapPositon,
              game.centerHeight - game.data[game.tapPositon].bioPhy);
          game.emotionalComponent.position = Vector2(30.0 * game.tapPositon,
              game.centerHeight - game.data[game.tapPositon].bioEmo);
          game.intellectualComponent.position = Vector2(30.0 * game.tapPositon,
              game.centerHeight - game.data[game.tapPositon].bioInt);

          game.centerPhysical = game.data[game.tapPositon].bioPhy;
          game.centerEmotional = game.data[game.tapPositon].bioEmo;
          game.centerIntellectual = game.data[game.tapPositon].bioInt;

          if (game.tapPositon <= 24 && game.tapPositon >= 7) {
            game.cameraPosition.x = game.physicalComponent.x;
          }
        }
      },
    ),
  );
}

Widget _previousButtonBuilder(
    BuildContext buildContext, MoveEffectExample game) {
  return Positioned(
    bottom: 10,
    left: 10,
    child: ElevatedButton(
      child: const Icon(Icons.navigate_before),
      onPressed: () {
        if (game.tapPositon > 1) {
          game.tapPositon--;

          game.physicalComponent.position = Vector2(30.0 * game.tapPositon,
              game.centerHeight - game.data[game.tapPositon].bioPhy);
          game.emotionalComponent.position = Vector2(30.0 * game.tapPositon,
              game.centerHeight - game.data[game.tapPositon].bioEmo);
          game.intellectualComponent.position = Vector2(30.0 * game.tapPositon,
              game.centerHeight - game.data[game.tapPositon].bioInt);

          game.centerPhysical = game.data[game.tapPositon].bioPhy;
          game.centerEmotional = game.data[game.tapPositon].bioEmo;
          game.centerIntellectual = game.data[game.tapPositon].bioInt;

          if (game.tapPositon >= 7 && game.tapPositon <= 24) {
            game.cameraPosition.x = game.physicalComponent.x;
          }
        }
      },
    ),
  );
}

Widget _todayButtonBuilder(BuildContext buildContext, MoveEffectExample game) {
  return Positioned.fill(
    bottom: 10,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        ElevatedButton(
          child: const Icon(Icons.today),
          onPressed: () {
            game.tapPositon = 16;

            game.physicalComponent.position = Vector2(30.0 * game.tapPositon,
                game.centerHeight - game.data[game.tapPositon].bioPhy);
            game.emotionalComponent.position = Vector2(30.0 * game.tapPositon,
                game.centerHeight - game.data[game.tapPositon].bioEmo);
            game.intellectualComponent.position = Vector2(
                30.0 * game.tapPositon,
                game.centerHeight - game.data[game.tapPositon].bioInt);

            game.centerPhysical = game.data[game.tapPositon].bioPhy;

            game.cameraPosition = Vector2(30.0 * 16, game.centerHeight + 100);
          },
        ),
      ],
    ),
  );
}
