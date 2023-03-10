import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:wup/app/routes/app_pages.dart';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class LoginController extends GetxController {
  final getStorage = GetStorage();
  final server = dotenv.env['WUP_SERVER']!;

  Future<void> googleLogin() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser != null) {
      await signUp(googleUser.email, googleUser.displayName);
      getStorage.write("email", googleUser.email);
      getStorage.write("name", googleUser.displayName);
      if (getStorage.read('mbti') != null) {
        Get.offAllNamed(Routes.HOME);
      } else {
        Get.offAllNamed(Routes.WELCOME);
      }
    }
  }

  Future<void> facebookLogin() async {
    final LoginResult result = await FacebookAuth.instance.login();
    if (result.status == LoginStatus.success) {
      final url = Uri.https('graph.facebook.com', '/v2.12/me', {
        'fields': 'id, email, name',
        'access_token': result.accessToken!.token
      });
      final response = await http.get(url);
      final profileInfo = json.decode(response.body);

      await signUp(profileInfo['email'], profileInfo['name']);
      getStorage.write("email", profileInfo['email']);
      getStorage.write("name", profileInfo['name']);
      if (getStorage.read('mbti') != null) {
        Get.offAllNamed(Routes.HOME);
      } else {
        Get.offAllNamed(Routes.WELCOME);
      }
    }
  }

  Future<void> appleLogin() async {
    // Request credential for the currently signed in Apple account.
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    if (appleCredential.state != null) {
      await signUp(appleCredential.email!, appleCredential.givenName);
      getStorage.write("email", appleCredential.email);
      getStorage.write("name", appleCredential.givenName);
      if (getStorage.read('mbti') != null) {
        Get.offAllNamed(Routes.HOME);
      } else {
        Get.offAllNamed(Routes.WELCOME);
      }
    }
  }

  Future<http.Response> signUp(String email, String? name) async {
    name ??= 'None';
    final response = await http.post(Uri.parse("$server/accounts/"),
        headers: {"Content-Type": "application/json"},
        body: '{"email": "$email", "name": "$name"}');
    return response;
  }
}
