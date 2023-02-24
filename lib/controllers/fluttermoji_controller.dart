import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class MojiController extends GetxController {
  final getStorage = GetStorage();
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    // loadFluttermojiFromStorage();
    getStorage.write('progressbar', 0.66);
  }

  // void saveFluttermojiToStorage() async {
  //   final encodedData = await FluttermojiFunctions().encodeMySVGtoString();
  //   // Save the encoded data to local storage
  //   getStorage.write('fluttermoji', encodedData);
  //   print(encodedData);
  //   print('save');
  //   Get.toNamed(Routes.RESULT);
  // }

  // void loadFluttermojiFromStorage() {
  //   final encodedData = getStorage.read('fluttermoji');
  //   if (encodedData != null) {
  //     // Decode the encoded data and apply it to the fluttermoji widget
  //     FluttermojiFunctions().decodeFluttermojifromString(encodedData);
  //     print(encodedData);
  //     print('load');
  //   }
  // }
}
