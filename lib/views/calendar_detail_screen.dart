import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mbti_test/components/default_button.dart';
import 'package:mbti_test/routes/app_pages.dart';
import 'calendar_screen.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class EventDetailScreen extends StatefulWidget {
  final Event event;

  const EventDetailScreen({required this.event, Key? key}) : super(key: key);

  @override
  _EventDetailScreenState createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  final server = dotenv.env['WUP_SERVER']!;
  final email = GetStorage().read('email');

  late TextEditingController _titleController;
  late DateTime _startDateTime;
  late DateTime? _endDateTime;
  late bool _isEndDateEnabled = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.event.title);
    _startDateTime = widget.event.start;
    _endDateTime = widget.event.end;
    _isEndDateEnabled = _startDateTime != _endDateTime;
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _selectStartDate() async {
    final initialDate = _startDateTime;
    final newStartDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (newStartDate != null) {
      setState(() {
        _startDateTime = newStartDate;
        if (!_isEndDateEnabled) {
          _endDateTime = newStartDate;
        }
      });
    }
  }

  Future<void> _selectEndDate() async {
    final initialDate = _endDateTime ?? _startDateTime;
    final newEndDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (newEndDate != null) {
      setState(() {
        _endDateTime = newEndDate;
      });
    }
  }

  Future<void> _showDeleteConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete event?'),
          content: const Text('This action cannot be undone.'),
          actions: <Widget>[
            TextButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              onPressed: () async {
                final response = await http.delete(Uri.parse(
                    "$server/calendars/events/$email/${widget.event.id}/"));
                if (response.statusCode == 204) {
                  // The event was deleted successfully, go back to the calendar screen
                  // Navigator.pop(_scaffoldContext, true);
                  Get.offNamed(Routes.CALENDAR);
                } else {
                  // There was an error while deleting the event, show a snackbar
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Failed to delete event')));
                }
              },
              child: const Text('DELETE'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Details'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              _showDeleteConfirmationDialog();
            },
          ),
        ],
      ),
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        return ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: constraints.maxHeight,
            minWidth: constraints.maxWidth,
          ),
          child: IntrinsicHeight(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(labelText: 'Title'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          style: const ButtonStyle(),
                          onPressed: _selectStartDate,
                          child: Row(
                            children: [
                              const Text('Start'),
                              const SizedBox(width: 16),
                              Text(
                                DateFormat('yyyy-MM-dd').format(_startDateTime),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (_isEndDateEnabled) ...[
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: _selectEndDate,
                            child: Row(
                              children: [
                                const Text('End'),
                                const SizedBox(width: 16),
                                Text(
                                  DateFormat('yyyy-MM-dd')
                                      .format(_endDateTime!),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 16.0),
                  Row(
                    children: [
                      Checkbox(
                        value: _isEndDateEnabled,
                        onChanged: (value) {
                          setState(() {
                            _isEndDateEnabled = value!;
                          });
                        },
                      ),
                      const Text('End Date'),
                    ],
                  ),
                  const Spacer(),
                  DefaultButton2(
                    text: "Save Changes",
                    press: () async {
                      if (_titleController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Please enter a title')));
                        return;
                      }
                      if (_isEndDateEnabled && _endDateTime == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Please select an end date')));
                        return;
                      }
                      if (_isEndDateEnabled &&
                          _endDateTime!.isBefore(_startDateTime)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('End date must be after start date')));
                        return;
                      }

                      final updatedEvent = Event(
                        widget.event.id,
                        _titleController.text,
                        _startDateTime.toLocal(),
                        _isEndDateEnabled
                            ? _endDateTime!.toLocal()
                            : _startDateTime.toLocal(),
                      );

                      final response = await http.put(
                        Uri.parse(
                            '$server/calendars/events/$email/${widget.event.id}/'),
                        headers: {
                          'Content-Type': 'application/json',
                        },
                        body: jsonEncode(updatedEvent.toJson()),
                      );

                      if (response.statusCode == 200) {
                        Get.toNamed(Routes.CALENDAR);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Failed to save changes')));
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
