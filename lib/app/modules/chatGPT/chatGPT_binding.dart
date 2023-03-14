import 'package:get/get.dart';
import 'package:wup/app/modules/chatGPT/chatGPT_controller.dart';

class ChatGPTBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChatGPTController>(
      () => ChatGPTController(),
    );
  }
}
