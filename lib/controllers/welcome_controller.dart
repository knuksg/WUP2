import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class WelcomeController extends GetxController {
  final getStorage = GetStorage();
  var userName = "";
  var email = "";

  @override
  void onInit() {
    super.onInit();
    userName = getStorage.read("userName");
    email = getStorage.read("email");
  }
}
