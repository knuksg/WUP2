import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/basic_controller.dart';

class BasicScreen extends GetView<BasicController> {
  const BasicScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Basic View'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [Text('basic')],
        ),
      ),
    );
  }
}
