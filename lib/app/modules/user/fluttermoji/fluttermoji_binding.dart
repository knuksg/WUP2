import 'package:fluttermoji/fluttermoji.dart';
import 'package:get/get.dart';

class FluttermojiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FluttermojiController>(
      () => FluttermojiController(),
    );
  }
}
