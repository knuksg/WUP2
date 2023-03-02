import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class ResultController extends GetxController {
  final getStorage = GetStorage();
  List mbtiList = [];
  String mbti = '';

  @override
  void onInit() {
    super.onInit();
    mbtiList = getStorage.read('mbtiList');
    mbti = mbtiType(mbtiList);
    getStorage.write('mbti', mbti);
    updateMbti(getStorage.read('email'), mbti);
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

Future<http.Response> updateMbti(String email, String mbti) async {
  final server = dotenv.env['WUP_SERVER']!;
  final response = await http.put(Uri.parse("$server/accounts/$email/"),
      headers: {"Content-Type": "application/json"}, body: '{"mbti": "$mbti"}');
  return response;
}
