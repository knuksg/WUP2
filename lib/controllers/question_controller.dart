import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mbti_test/models/api_adapter.dart';
import 'package:mbti_test/models/mbti_question_model.dart';
import 'package:http/http.dart' as http;
import 'package:mbti_test/routes/app_pages.dart';

class QuestionController extends GetxController {
  final getStorage = GetStorage();
  final server = dotenv.env['WUP_SERVER'];
  RxInt questionNumber = 1.obs;
  Rx<MbtiQuestion> currentQuestion = MbtiQuestion().obs;
  List<MbtiQuestion> questions = [];
  List<String> answers = [];

  @override
  void onInit() {
    super.onInit();
    getStorage.write('progressbar', 0.33);
    fetchQuestions();
  }

  Future<List<MbtiQuestion>> fetchQuestions() async {
    final response = await http.get(Uri.parse('$server/mbti/question/'));
    if (response.statusCode == 200) {
      questions = parseMbtiQuestions(utf8.decode(response.bodyBytes));
      currentQuestion.value = questions[0];
      return questions;
    } else {
      throw Exception('failed to load data');
    }
  }

  void nextQuestion(answer) {
    answers.add(answer);
    if (questionNumber.value < questions.length) {
      questionNumber.value++;
      currentQuestion.value = questions[questionNumber.value - 1];
    } else {
      getStorage.write('mbtiList', answers);
      Get.toNamed(Routes.FLUTTERMOJI);
    }
  }
}
