import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class ResultController extends GetxController {
  final getStorage = GetStorage();
  List mbtiList = [];

  late String email;
  late String gender;
  late String birthday;
  late String height;
  late String weight;
  late String mbti;

  @override
  void onInit() {
    super.onInit();
    mbtiList = getStorage.read('mbtiList');
    mbti = mbtiType(mbtiList);
    getStorage.write('mbti', mbti);
    email = getStorage.read('email');
    gender = getStorage.read('gender');
    birthday = getStorage.read('birthday');
    height = getStorage.read('height');
    weight = getStorage.read('weight');
    updateInfo(
      email: email,
      gender: gender,
      birthday: birthday,
      height: height,
      weight: weight,
      mbti: mbti,
    );
  }
}

String mbtiType(List mbtiList) {
  String type = '';

  Map<String, int> mbtiMap = {
    'E': 0,
    'I': 0,
    'S': 0,
    'N': 0,
    'T': 0,
    'F': 0,
    'J': 0,
    'P': 0
  };

  for (var letter in mbtiList) {
    if (letter.isNotEmpty) {
      mbtiMap[letter] = mbtiMap[letter]! + 1;
    }
  }

  if (mbtiMap['E']! > mbtiMap['I']!) {
    type += 'E';
  } else {
    type += 'I';
  }

  if (mbtiMap['N']! > mbtiMap['S']!) {
    type += 'N';
  } else {
    type += 'S';
  }

  if (mbtiMap['T']! > mbtiMap['F']!) {
    type += 'T';
  } else {
    type += 'F';
  }

  if (mbtiMap['J']! > mbtiMap['P']!) {
    type += 'J';
  } else {
    type += 'P';
  }

  return type;
}

Future<http.Response> updateInfo({
  required String email,
  required String gender,
  required String birthday,
  required String height,
  required String weight,
  required String mbti,
}) async {
  final server = dotenv.env['WUP_SERVER']!;
  final response = await http.put(
    Uri.parse("$server/accounts/$email/"),
    headers: {"Content-Type": "application/json"},
    body:
        '{"mbti": "$mbti", "gender": "$gender","birthday": "$birthday","height": "$height","weight": "$weight"}',
  );
  return response;
}
