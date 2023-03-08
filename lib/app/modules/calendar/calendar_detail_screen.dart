import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:wup/app/data/model/calendar_event_model.dart';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:wup/app/data/services/notification_service.dart';
import 'package:wup/app/routes/app_pages.dart';
import 'package:wup/app/theme/app_color.dart';

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
  late DateTime _startDate;
  late DateTime _endDate;
  late bool _isAllDay;
  late Duration? _noti;
  late String dropdownValue;

  List eventList = [];
  List searchList = [];
  bool searchEvent = false;

  late int hashcode;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.event.title);
    _startDate = widget.event.start;
    _endDate = widget.event.end;
    _isAllDay = widget.event.isAllDay;
    if (widget.event.noti != null) {
      _noti = Duration(minutes: widget.event.noti!);
      dropdownValue = widget.event.noti.toString();
    } else {
      _noti = null;
      dropdownValue = "없음";
    }
    hashcode = GetStorage().read('userName').hashCode ^
        _startDate.toString().substring(0, 19).hashCode;
    _fetchEvents();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _selectStartDate() async {
    final initialDate = _startDate;
    final newStartDate = await DatePicker.showDatePicker(
      context,
      showTitleActions: true,
      minTime: DateTime(1900),
      maxTime: DateTime(2999),
      onChanged: (date) {
        print('change $date');

        if (_endDate.isBefore(date)) {
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
      if (_endDate.isBefore(newStartDate)) {
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
    final initialDate = _endDate;
    final newEndDate = await DatePicker.showDatePicker(
      context,
      showTitleActions: true,
      minTime: DateTime(1900),
      maxTime: DateTime(2999),
      onChanged: (date) {
        print('change $date');

        if (_startDate.isAfter(date)) {
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
      if (_startDate.isAfter(newEndDate)) {
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
    final initialDate = _startDate;
    final newStartDate = await DatePicker.showTimePicker(
      context,
      showSecondsColumn: false,
      showTitleActions: true,
      onChanged: (date) {
        print('change $date');

        if (_endDate.isBefore(date)) {
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
      if (_endDate.isBefore(newStartDate)) {
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
    final initialDate = _endDate;
    final newEndDate = await DatePicker.showTimePicker(
      context,
      showTitleActions: true,
      showSecondsColumn: false,
      onChanged: (date) {
        print('change $date');

        if (_startDate.isAfter(date)) {
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
      if (_startDate.isAfter(newEndDate)) {
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
                  NotificationService().deletescheduleReminder(hashcode);
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

  Future<void> _fetchEvents() async {
    List<Event> events = await fetchEvents();
    setState(() {
      eventList.addAll(events);
    });
  }

  // 유저 이벤트 받아오기 위해 새로 작성한 부분입니다.
  Future<List<Event>> fetchEvents() async {
    final response =
        await http.get(Uri.parse("$server/calendars/events/$email/"));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
      return data.map((event) => Event.fromJson(event)).toList();
    } else {
      throw Exception('Failed to load events');
    }
  }

  void _searchEvents(String kw) {
    for (var event in eventList) {
      if (event.title.contains(kw)) {
        setState(() {
          searchList.add(event);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close)),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              _showDeleteConfirmationDialog();
            },
          ),
          IconButton(
              onPressed: () async {
                if (_titleController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter a title')));
                  return;
                }

                if (_endDate.isBefore(_startDate)) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('End date must be after start date')));
                  return;
                }

                final updatedEvent = Event(
                    widget.event.id,
                    _titleController.text,
                    _startDate.toLocal(),
                    _endDate.toLocal(),
                    _isAllDay,
                    _noti?.inMinutes);

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
                      const SnackBar(content: Text('Failed to save changes')));
                }

                NotificationService().deletescheduleReminder(hashcode);
                if (_noti != null) {
                  tz.TZDateTime scheduledDate = tz.TZDateTime(
                          tz.local,
                          _startDate.year,
                          _startDate.month,
                          _startDate.day,
                          _startDate.hour,
                          _startDate.minute)
                      .subtract(_noti!);

                  NotificationService().scheduleReminder(
                      GetStorage().read('userName').hashCode ^
                          _startDate.hashCode,
                      _titleController.text,
                      '${_noti!.inMinutes}분',
                      scheduledDate);
                }
              },
              icon: const Icon(Icons.edit_calendar))
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
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(
                      height: 16,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'ADD EVENT',
                        ),
                        TextFormField(
                          maxLength: 16,
                          controller: _titleController,
                          decoration: const InputDecoration(
                            hintText: '일정을 입력해주세요.',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a title';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setState(() {
                              searchList.clear();
                            });
                            if (value.length > 1) {
                              _searchEvents(value);
                            }
                          },
                          onEditingComplete: () {
                            FocusScope.of(context).unfocus();
                            searchList.clear();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    Stack(
                      children: [
                        if (searchList.isNotEmpty)
                          Expanded(
                            child: ListView.separated(
                              shrinkWrap: true,
                              separatorBuilder: (context, index) {
                                return const Divider(
                                  height: 8,
                                );
                              },
                              itemCount:
                                  searchList.length > 3 ? 3 : searchList.length,
                              itemBuilder: (BuildContext context, int index) {
                                // Create a ListTile for each item in the data list
                                return ListTile(
                                  title: Text(
                                    searchList[index].title,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                      '${searchList[index].start.toString().split(' ')[1].split('.')[0].replaceRange(5, null, '')} - ${searchList[index].end.toString().split(' ')[1].split('.')[0].replaceRange(5, null, '')}'),
                                  tileColor: kPrimaryColor,
                                  textColor: Colors.white,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  onTap: () {
                                    setState(() {
                                      DateTime oldStartTime = _startDate;
                                      DateTime newStartTime = DateTime(
                                        oldStartTime.year,
                                        oldStartTime.month,
                                        oldStartTime.day,
                                        searchList[index].start.hour,
                                        searchList[index].start.minute,
                                      );
                                      _startDate = newStartTime;

                                      DateTime oldEndTime = _endDate;
                                      DateTime newEndTime = DateTime(
                                        oldEndTime.year,
                                        oldEndTime.month,
                                        oldEndTime.day,
                                        searchList[index].end.hour,
                                        searchList[index].end.minute,
                                      );
                                      _endDate = newEndTime;

                                      _isAllDay = searchList[index].isAllDay;

                                      if (searchList[index].noti != null) {
                                        _noti = Duration(
                                            minutes: searchList[index].noti);
                                        dropdownValue =
                                            searchList[index].noti.toString();
                                      } else {
                                        _noti = null;
                                        dropdownValue = "없음";
                                      }
                                    });
                                  },
                                );
                              },
                            ),
                          ),
                        Transform.translate(
                          offset: searchList.isNotEmpty
                              ? Offset(
                                  0,
                                  searchList.length > 3
                                      ? 3 * 80 + 16
                                      : searchList.length * 80 + 16)
                              : Offset.zero,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Text(
                                'EVENT DATE',
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    '하루 종일',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Switch(
                                    value: _isAllDay,
                                    onChanged: (value) {
                                      setState(() {
                                        _isAllDay = value;
                                      });
                                      if (value) {}
                                    },
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                            minimumSize:
                                                MaterialStatePropertyAll(
                                                    Size.square(32)),
                                            padding: MaterialStatePropertyAll(
                                                EdgeInsets.symmetric(
                                                    vertical: 0,
                                                    horizontal: 16.0)),
                                            backgroundColor:
                                                MaterialStatePropertyAll(
                                                    kPrimaryColor)),
                                        child: Text(
                                          DateFormat('yyyy. MM. dd.')
                                              .format(_startDate),
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      if (!_isAllDay)
                                        FilledButton(
                                          onPressed: _selectStartTime,
                                          style: const ButtonStyle(
                                              minimumSize:
                                                  MaterialStatePropertyAll(
                                                      Size.square(32)),
                                              padding: MaterialStatePropertyAll(
                                                  EdgeInsets.symmetric(
                                                      vertical: 0,
                                                      horizontal: 16.0)),
                                              backgroundColor:
                                                  MaterialStatePropertyAll(
                                                      kPrimaryColor)),
                                          child: Text(
                                            DateFormat('hh:mm a')
                                                .format(_startDate),
                                            style:
                                                const TextStyle(fontSize: 16),
                                          ),
                                        )
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    '종료',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Row(
                                    children: [
                                      if (!_endDate.isBefore(_startDate))
                                        FilledButton(
                                          onPressed: _selectEndDate,
                                          style: const ButtonStyle(
                                              minimumSize:
                                                  MaterialStatePropertyAll(
                                                      Size.square(32)),
                                              padding: MaterialStatePropertyAll(
                                                  EdgeInsets.symmetric(
                                                      vertical: 0,
                                                      horizontal: 16.0)),
                                              backgroundColor:
                                                  MaterialStatePropertyAll(
                                                      kPrimaryColor)),
                                          child: Text(
                                            DateFormat('yyyy. MM. dd.')
                                                .format(_endDate),
                                            style: const TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      if (_endDate.isBefore(_startDate))
                                        FilledButton(
                                          onPressed: _selectEndDate,
                                          style: const ButtonStyle(
                                              minimumSize:
                                                  MaterialStatePropertyAll(
                                                      Size.square(32)),
                                              padding: MaterialStatePropertyAll(
                                                  EdgeInsets.symmetric(
                                                      vertical: 0,
                                                      horizontal: 16.0)),
                                              backgroundColor:
                                                  MaterialStatePropertyAll(
                                                      kPrimaryColor)),
                                          child: Text(
                                            DateFormat('yyyy. MM. dd.')
                                                .format(_endDate),
                                            style: const TextStyle(
                                                fontSize: 16,
                                                decoration:
                                                    TextDecoration.lineThrough),
                                          ),
                                        ),
                                      const SizedBox(width: 8),
                                      if (!_isAllDay)
                                        if (!_endDate.isBefore(_startDate))
                                          FilledButton(
                                            onPressed: _selectEndTime,
                                            style: const ButtonStyle(
                                                minimumSize:
                                                    MaterialStatePropertyAll(
                                                        Size.square(32)),
                                                padding:
                                                    MaterialStatePropertyAll(
                                                        EdgeInsets.symmetric(
                                                            vertical: 0,
                                                            horizontal: 16.0)),
                                                backgroundColor:
                                                    MaterialStatePropertyAll(
                                                        kPrimaryColor)),
                                            child: Text(
                                              DateFormat('hh:mm a')
                                                  .format(_endDate),
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            ),
                                          ),
                                      if (!_isAllDay)
                                        if (_endDate.isBefore(_startDate))
                                          FilledButton(
                                            onPressed: _selectEndTime,
                                            style: const ButtonStyle(
                                                minimumSize:
                                                    MaterialStatePropertyAll(
                                                        Size.square(32)),
                                                padding:
                                                    MaterialStatePropertyAll(
                                                        EdgeInsets.symmetric(
                                                            vertical: 0,
                                                            horizontal: 16.0)),
                                                backgroundColor:
                                                    MaterialStatePropertyAll(
                                                        kPrimaryColor)),
                                            child: Text(
                                              DateFormat('hh:mm a')
                                                  .format(_endDate),
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  decoration: TextDecoration
                                                      .lineThrough),
                                            ),
                                          ),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    '알람',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  DropdownButton<String>(
                                    value: dropdownValue,
                                    items: const [
                                      DropdownMenuItem(
                                        value: "없음",
                                        child: Text("없음"),
                                      ),
                                      DropdownMenuItem(
                                        value: "15",
                                        child: Text("15분 전 알람"),
                                      ),
                                      DropdownMenuItem(
                                        value: "30",
                                        child: Text("30분 전 알람"),
                                      ),
                                      DropdownMenuItem(
                                        value: "60",
                                        child: Text("한 시간 전 알람"),
                                      ),
                                    ],
                                    onChanged: (value) {
                                      setState(() {
                                        dropdownValue = value!;
                                        if (value == "없음") {
                                          _noti = null;
                                        }
                                        if (value == "15") {
                                          _noti = const Duration(minutes: 15);
                                        }
                                        if (value == "30") {
                                          _noti = const Duration(minutes: 30);
                                        }
                                        if (value == "60") {
                                          _noti = const Duration(minutes: 60);
                                        }
                                      });
                                    },
                                  )
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
