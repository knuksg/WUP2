import 'package:flutter/material.dart';

class GuideScreen extends StatefulWidget {
  const GuideScreen({super.key});

  @override
  _GuideScreenState createState() => _GuideScreenState();
}

class _GuideScreenState extends State<GuideScreen> {
  int _currentModalIndex = 0;

  final List<GuideModal> _modals = [
    GuideModal(
      title: "Welcome to the App",
      description:
          "This app is designed to help you with your daily tasks. In this guide, we'll show you how to get started.",
      hasNextModal: true,
    ),
    GuideModal(
      title: "Step 1: Create a Task",
      description:
          "To create a task, simply click on the 'Create Task' button on the home screen.",
      hasNextModal: true,
    ),
    GuideModal(
      title: "Step 2: Add Details to Your Task",
      description:
          "Once you've created a task, you can add details such as the due date, priority level, and notes.",
      hasNextModal: true,
    ),
    GuideModal(
      title: "Step 3: Complete Your Task",
      description:
          "When you've completed a task, click on the checkbox next to it to mark it as complete.",
      hasNextModal: false,
    ),
  ];

  void _showNextModal() {
    if (_currentModalIndex < _modals.length - 1) {
      setState(() {
        _currentModalIndex++;
      });
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Opacity(
          opacity: 0.1,
          child: ModalBarrier(
            dismissible: false,
            color: Colors.white,
          ),
        ),
        AlertDialog(
          title: Column(
            children: [
              Image.asset(
                'assets/images/guide_character.png',
                height: 200,
              ),
              const SizedBox(height: 8),
              Text(_modals[_currentModalIndex].title),
            ],
          ),
          content: Text(_modals[_currentModalIndex].description),
          actions: <Widget>[
            ElevatedButton(
              onPressed: _showNextModal,
              child: Text(
                  _modals[_currentModalIndex].hasNextModal ? "Next" : "Close"),
            ),
          ],
          alignment: Alignment.bottomRight,
        ),
      ],
    );
  }
}

class GuideModal {
  String title;
  String description;
  bool hasNextModal;

  GuideModal(
      {required this.title,
      required this.description,
      required this.hasNextModal});
}
