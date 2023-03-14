import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:wup/app/routes/app_pages.dart';

class HomeController extends GetxController {
  final getStorage = GetStorage();
  var email = "";
  var name = "";
  var birthday = "";
  var gender = "";
  var mbti = "";

  @override
  void onInit() {
    super.onInit();
    email = getStorage.read("email");
    name = getStorage.read("name");
    birthday = getStorage.read("birthday");
    gender = getStorage.read("gender");
    mbti = getStorage.read("mbti");
  }

  logout() async {
    await FacebookAuth.instance.logOut();
    await GoogleSignIn().signOut();

    getStorage.erase();
    Get.offAllNamed(Routes.LOGIN);
  }

  Future<bool> onBackKey(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('exit_title').tr(),
          content: const Text('exit_content').tr(),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('no').tr(),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('yes').tr(),
            ),
          ],
        );
      },
    );
  }
}
