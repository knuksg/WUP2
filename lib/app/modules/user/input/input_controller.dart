import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:wup/app/routes/app_pages.dart';

class InputController extends GetxController {
  final getStorage = GetStorage();
  String name = '';

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    name = getStorage.read('name');
    getStorage.write("progressbar", 0.01);
  }

  void saveUserInfo({
    required String name,
    required DateTime birthday,
    required String gender,
    required String height,
    required String weight,
  }) {
    // TODO: Implement saving user info
    final newBirthday = birthday.toString().split(' ')[0];
    print(newBirthday);
    getStorage.write('name', name);
    getStorage.write('birthday', newBirthday);
    getStorage.write('gender', gender);
    getStorage.write('height', height);
    getStorage.write('weight', weight);
    Get.toNamed(Routes.QUESTION);
  }
}
