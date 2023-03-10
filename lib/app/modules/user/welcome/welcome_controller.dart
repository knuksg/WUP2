import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class WelcomeController extends GetxController {
  final getStorage = GetStorage();
  var name = "";
  var email = "";

  @override
  void onInit() {
    super.onInit();
    name = getStorage.read("name");
    email = getStorage.read("email");
  }
}
