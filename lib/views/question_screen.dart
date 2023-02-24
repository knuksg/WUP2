import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mbti_test/components/default_button.dart';
import 'package:mbti_test/controllers/question_controller.dart';
import 'package:mbti_test/models/mbti_question_model.dart';

class QuestionScreen extends GetView<QuestionController> {
  const QuestionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MBTI Test'),
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
              minWidth: constraints.maxWidth,
            ),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  LinearProgressIndicator(
                    value: controller.getStorage.read('progressbar'),
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight - 4,
                      minWidth: constraints.maxWidth,
                    ),
                    child: IntrinsicHeight(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FutureBuilder<List<MbtiQuestion>>(
                          future: controller.fetchQuestions(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (snapshot.hasError) {
                              return const Center(
                                child: Text('Error loading questions.'),
                              );
                            } else if (!snapshot.hasData) {
                              return const Center(
                                child: Text('No questions found.'),
                              );
                            } else {
                              return Obx(
                                () {
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Question ${controller.questionNumber.value}',
                                              style:
                                                  const TextStyle(fontSize: 24),
                                            ),
                                            const SizedBox(height: 16),
                                            Text(
                                              '${controller.currentQuestion.value.title}',
                                              style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          ...List.generate(
                                            controller.currentQuestion.value
                                                        .body!.length *
                                                    2 -
                                                1,
                                            (index) {
                                              if (index.isOdd) {
                                                return const SizedBox(
                                                    height: 16);
                                              }
                                              final int questionIndex =
                                                  index ~/ 2;
                                              return DefaultButton2(
                                                text: controller.currentQuestion
                                                    .value.body![questionIndex],
                                                press: () {
                                                  controller.nextQuestion(
                                                      controller
                                                          .currentQuestion
                                                          .value
                                                          .answer![
                                                              questionIndex]
                                                          .toString());
                                                },
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 16),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
