import 'package:get/get.dart';
import 'package:mbti_test/controllers/input_controller.dart';

class InputBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InputController>(
      () => InputController(),
    );
  }
}
