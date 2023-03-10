import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:wup/app/modules/game/ember_quest.dart';
import 'package:wup/app/modules/game/game_controller.dart';
import 'package:wup/app/modules/game/overlays/game_over.dart';
import 'package:wup/app/modules/game/overlays/main_menu.dart';
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
            child: GameWidget<EmberQuestGame>.controlled(
              gameFactory: EmberQuestGame.new,
              overlayBuilderMap: {
                'MainMenu': (_, game) => MainMenu(game: game),
                'GameOver': (_, game) => GameOver(game: game),
              },
              initialActiveOverlays: const ['MainMenu'],
            ),
          ),
        );
      }),
    );
  }
}
