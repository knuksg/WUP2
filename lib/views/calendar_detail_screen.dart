import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:wup/components/constants.dart';
import 'package:wup/components/default_button.dart';
import 'package:wup/routes/app_pages.dart';
import 'calendar_screen.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

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
  late DateTime? _startDate;
  late DateTime? _endDate;
  late bool _isAllDay;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.event.title);
    _startDate = widget.event.start;
    _endDate = widget.event.end;
    _isAllDay = widget.event.isAllDay;
    print(_startDate);
    print(_endDate);
    print(_isAllDay);
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _selectStartDate() async {
    final initialDate = _startDate ?? DateTime.now();
    final newStartDate = await DatePicker.showDatePicker(
      context,
      showTitleActions: true,
      minTime: DateTime(1900),
      maxTime: DateTime(2999),
      onChanged: (date) {
        print('change $date');

        if (_endDate!.isBefore(date)) {
          Get.snackbar(
            'End date must be after start date',
            'End date must be after start date',
            snackPosition: SnackPosition.TOP,
          );
        }
      },
      onConfirm: (date) {
        print('confirm $date');
      },
      currentTime: initialDate,
      locale: LocaleType.ko,
    );

    if (newStartDate != null) {
      if (_endDate!.isBefore(newStartDate)) {
        Get.snackbar(
          'End date must be after start date',
          'End date must be after start date',
          snackPosition: SnackPosition.TOP,
        );

        setState(() {
          _startDate = initialDate;
        });
      } else {
        setState(() {
          _startDate = newStartDate;
        });
      }
    }
  }

  Future<void> _selectEndDate() async {
    final initialDate = _endDate ?? _startDate ?? DateTime.now();
    final newEndDate = await DatePicker.showDatePicker(
      context,
      showTitleActions: true,
      minTime: DateTime(1900),
      maxTime: DateTime(2999),
      onChanged: (date) {
        print('change $date');

        if (_startDate!.isAfter(date)) {
          Get.snackbar(
            'End date must be after start date',
            'End date must be after start date',
            snackPosition: SnackPosition.TOP,
          );
        }
      },
      onConfirm: (date) {
        print('confirm $date');
      },
      currentTime: initialDate,
      locale: LocaleType.ko,
    );

    if (newEndDate != null) {
      if (_startDate!.isAfter(newEndDate)) {
        Get.snackbar(
          'End date must be after start date',
          'End date must be after start date',
          snackPosition: SnackPosition.TOP,
        );

        setState(() {
          _endDate = initialDate;
        });
      } else {
        setState(() {
          _endDate = newEndDate;
        });
      }
    }
  }

  Future<void> _selectStartTime() async {
    final initialDate = _startDate ?? DateTime.now();
    final newStartDate = await DatePicker.showTimePicker(
      context,
      showSecondsColumn: false,
      showTitleActions: true,
      onChanged: (date) {
        print('change $date');

        if (_endDate!.isBefore(date)) {
          Get.snackbar(
            'End date must be after start date',
            'End date must be after start date',
            snackPosition: SnackPosition.TOP,
          );
        }
      },
      onConfirm: (date) {
        print('confirm $date');
      },
      currentTime: initialDate,
      locale: LocaleType.ko,
    );

    if (newStartDate != null) {
      if (_endDate!.isBefore(newStartDate)) {
        Get.snackbar(
          'End date must be after start date',
          'End date must be after start date',
          snackPosition: SnackPosition.TOP,
        );

        setState(() {
          _startDate = initialDate;
        });
      } else {
        setState(() {
          _startDate = newStartDate;
        });
      }
    }
  }

  Future<void> _selectEndTime() async {
    final initialDate = _endDate ?? _startDate ?? DateTime.now();
    final newEndDate = await DatePicker.showTimePicker(
      context,
      showTitleActions: true,
      showSecondsColumn: false,
      onChanged: (date) {
        print('change $date');

        if (_startDate!.isAfter(date)) {
          Get.snackbar(
            'End date must be after start date',
            'End date must be after start date',
            snackPosition: SnackPosition.TOP,
          );
        }
      },
      onConfirm: (date) {
        print('confirm $date');
      },
      currentTime: initialDate,
      locale: LocaleType.ko,
    );

    if (newEndDate != null) {
      if (_startDate!.isAfter(newEndDate)) {
        Get.snackbar(
          'End date must be after start date',
          'End date must be after start date',
          snackPosition: SnackPosition.TOP,
        );

        setState(() {
          _endDate = initialDate;
        });
      } else {
        setState(() {
          _endDate = newEndDate;
        });
      }
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
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  TextFormField(
                    maxLength: 16,
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      hintText: '일정을 입력해주세요.',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '하루 종일',
                        style: TextStyle(fontSize: 16),
                      ),
                      Switch(
                        value: _isAllDay,
                        onChanged: (value) {
                          print(value);
                          setState(() {
                            _isAllDay = value;
                          });
                          if (value) {}
                        },
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            '시작',
                            style: TextStyle(fontSize: 16),
                          ),
                          Row(
                            children: [
                              FilledButton(
                                onPressed: _selectStartDate,
                                style: const ButtonStyle(
                                    backgroundColor: MaterialStatePropertyAll(
                                        kPrimaryColor)),
                                child: Text(
                                  DateFormat('yyyy. MM. dd.')
                                      .format(_startDate!),
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                              const SizedBox(width: 8),
                              if (!_isAllDay)
                                FilledButton(
                                  onPressed: _selectStartTime,
                                  style: const ButtonStyle(
                                      backgroundColor: MaterialStatePropertyAll(
                                          kPrimaryColor)),
                                  child: Text(
                                    DateFormat('hh:mm a').format(_startDate!),
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                )
                            ],
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            '종료',
                            style: TextStyle(fontSize: 16),
                          ),
                          Row(
                            children: [
                              FilledButton(
                                onPressed: _selectEndDate,
                                style: const ButtonStyle(
                                    backgroundColor: MaterialStatePropertyAll(
                                        kPrimaryColor)),
                                child: Text(
                                  DateFormat('yyyy. MM. dd.').format(_endDate!),
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                              const SizedBox(width: 8),
                              if (!_isAllDay)
                                FilledButton(
                                  onPressed: _selectEndTime,
                                  style: const ButtonStyle(
                                      backgroundColor: MaterialStatePropertyAll(
                                          kPrimaryColor)),
                                  child: Text(
                                    DateFormat('hh:mm a').format(_endDate!),
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
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
                      if (_startDate == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Please select a start date')));
                        return;
                      }
                      if (_endDate == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Please select an end date')));
                        return;
                      }
                      if (_endDate!.isBefore(_startDate!)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('End date must be after start date')));
                        return;
                      }

                      final updatedEvent = Event(
                        widget.event.id,
                        _titleController.text,
                        _startDate!.toLocal(),
                        _endDate!.toLocal(),
                        _isAllDay,
                      );

                      print(_isAllDay);

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
