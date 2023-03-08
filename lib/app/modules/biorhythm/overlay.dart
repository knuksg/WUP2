import 'dart:async';

import 'package:flame/components.dart';

class today extends PositionComponent {
  @override
  FutureOr<void> onLoad() {
    // TODO: implement onLoad
    add(TextComponent(
      text: 'today',
      position: Vector2(30.0 * 16, 420),
      anchor: Anchor.center,
    ));

    return super.onLoad();
  }
}
