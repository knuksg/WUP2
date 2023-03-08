import 'package:get/get.dart';
import 'package:wup/app/modules/user/question/question_controller.dart';

class QuestionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QuestionController>(
      () => QuestionController(),
    );
  }
}
