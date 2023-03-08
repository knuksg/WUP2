import 'package:get/get.dart';
import 'package:wup/app/modules/biorhythm/biorhythm_controller.dart';

class BiorhythmBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BiorhythmController>(
      () => BiorhythmController(),
    );
  }
}
