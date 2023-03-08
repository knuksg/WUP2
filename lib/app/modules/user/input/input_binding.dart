import 'package:get/get.dart';
import 'package:wup/app/modules/user/input/input_controller.dart';

class InputBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InputController>(
      () => InputController(),
    );
  }
}
