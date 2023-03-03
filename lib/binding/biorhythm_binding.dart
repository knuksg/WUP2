import 'package:get/get.dart';
import 'package:wup/controllers/basic_controller.dart';

class BiorhythmBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BasicController>(
      () => BasicController(),
    );
  }
}
