import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wup/controllers/game_controller.dart';
import 'package:wup/routes/app_pages.dart';
import 'package:wup/views/games/ember_quest.dart';
import 'package:wup/views/games/overlays/game_over.dart';
import 'package:wup/views/games/overlays/main_menu.dart';

class GameScreen extends GetView<GameController> {
  const GameScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game View'),
        centerTitle: true,
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
