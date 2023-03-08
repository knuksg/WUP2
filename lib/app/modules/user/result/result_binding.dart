import 'package:get/get.dart';
import 'package:wup/app/modules/user/result/result_controller.dart';

class ResultBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ResultController>(
      () => ResultController(),
    );
  }
}
