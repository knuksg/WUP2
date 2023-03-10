import 'dart:math';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:chat_gpt_flutter/chat_gpt_flutter.dart';
import 'package:wup/app/data/model/biorhythm_model.dart';

class BiorhythmController extends GetxController {
  final getStorage = GetStorage();
  var advice = "".obs;
  var centerPhysical = 0.0;
  var centerEmotional = 0.0;
  var centerIntellectual = 0.0;
  var isLoading = true.obs;
  List<BioData> data = [];
  double Physical = 0;
  double Emotional = 0;
  double Intellectual = 0;
  late var locale;

  @override
  void onInit() {
    // TODO: implement onInit
    locale = Get.locale?.languageCode;
    getBiorhythm();
    getAdvice();
    super.onInit();
  }

  getBiorhythm() {
    final birthday = DateTime.parse(GetStorage().read('birthday'));
    final today = DateTime.now();
    final delta = today.difference(birthday).inDays;

    final bioList = List.generate(
      31,
      (index) {
        final date = today.add(Duration(days: index - 15));
        final countDays = delta + index - 15;
        final bioPhy = sin(2 * pi * countDays / 23) * 100;
        final bioEmo = sin(2 * pi * countDays / 28) * 100;
        final bioInt = sin(2 * pi * countDays / 33) * 100;
        return BioData(date, bioPhy, bioEmo, bioInt);
      },
    );

    data.addAll(bioList);

    Physical = data[16].bioPhy;
    Emotional = data[16].bioEmo;
    Intellectual = data[16].bioInt;
  }

  Future<CompletionResponse?> getChatGPT(
      double Physical, double Emotional, double Intellectual) async {
    const apiKey = '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';
    final chatGpt = ChatGpt(apiKey: apiKey);

    var pragraphPrompt = '''
                      Biorhythm have physical, emotional, and intellectual value.
                      100 is highest value. -100 is lowest value.
                      My physical value is ${Physical.floor()}, emotional value is ${Emotional.floor()}, intellectual value is ${Intellectual.floor()}. 
                      Give me paragraphs that are helpfull.
                      Each paragraph starts with number.
                      Each paragraph explain each value, and recommend what to do.
                      Please answer in $locale.
                     ''';

    final testRequest = CompletionRequest(
      prompt: [pragraphPrompt],
      maxTokens: 4000,
    );

    final result = await chatGpt.createCompletion(testRequest);
    return result;
  }

  Future<void> getAdvice() async {
    final result = await getChatGPT(
      Physical,
      Emotional,
      Intellectual,
    );

    advice.value = result?.choices?.first.text ?? 'error';

    isLoading.value = false;
  }
}
