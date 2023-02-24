import 'package:get/get.dart';
import 'package:mbti_test/controllers/question_controller.dart';

class QuestionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QuestionController>(
      () => QuestionController(),
    );
  }
}
