import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ProfileController extends GetxController {
  final getStorage = GetStorage();

  late String name;
  late String email;
  late String gender;
  late String birthday;
  late String height;
  late String weight;
  late String mbti;

  @override
  void onInit() {
    // TODO: implement onInit
    name = getStorage.read('name');
    email = getStorage.read('email');
    gender = getStorage.read('gender');
    birthday = getStorage.read('birthday');
    height = getStorage.read('height');
    weight = getStorage.read('weight');
    mbti = getStorage.read('mbti');
    super.onInit();
  }
}
