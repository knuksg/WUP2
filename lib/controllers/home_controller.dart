import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:wup/routes/app_pages.dart';

class HomeController extends GetxController {
  final getStorage = GetStorage();
  var email = "";
  var userName = "";
  var birthday = "";
  var gender = "";
  var mbti = "";

  @override
  void onInit() {
    super.onInit();
    email = getStorage.read("email");
    userName = getStorage.read("userName");
    birthday = getStorage.read("birthday");
    gender = getStorage.read("gender");
    mbti = getStorage.read("mbti");
    // MojiController().loadFluttermojiFromStorage();
    print(getStorage.getValues());
  }

  logout() async {
    await FacebookAuth.instance.logOut();
    await GoogleSignIn().signOut();

    getStorage.erase();
    Get.offAllNamed(Routes.LOGIN);
  }
}
