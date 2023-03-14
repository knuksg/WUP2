import 'dart:async';

import 'package:chat_gpt_flutter/chat_gpt_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wup/app/data/model/question_answer.dart';

class ChatGPTController extends GetxController {
  final apiKey = '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';
  RxString? answer = ''.obs;
  RxBool loading = false.obs;
  late var chatGpt;
  RxList questionAnswers = [].obs;
  late TextEditingController textEditingController;
  StreamSubscription<CompletionResponse>? streamSubscription;

  @override
  void onInit() {
    chatGpt = ChatGpt(apiKey: apiKey);
    textEditingController = TextEditingController();
    super.onInit();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    streamSubscription?.cancel();
    super.dispose();
  }

  Future<void> sendMessage() async {
    final question = textEditingController.text;
    textEditingController.clear();
    loading.value = true;
    questionAnswers.add(
      QuestionAnswer(
        question: question,
        answer: StringBuffer(),
      ),
    );
    final testRequest = CompletionRequest(
      prompt: [question],
      stream: true,
      maxTokens: 4000,
    );
    await streamResponse(testRequest);
    loading.value = false;
  }

  Future<void> streamResponse(CompletionRequest request) async {
    streamSubscription?.cancel();
    try {
      final stream = await chatGpt.createCompletionStream(request);
      streamSubscription = stream?.listen(
        (event) => () {
          if (event.streamMessageEnd) {
            streamSubscription?.cancel();
          } else {
            print(event.choices?.first.text);
            print('object');
            return questionAnswers.last.answer.write(
              event.choices?.first.text,
            );
          }
        },
      );
    } catch (error) {
      loading.value = false;
      questionAnswers.last.answer.write("Error");
    }
  }
}
