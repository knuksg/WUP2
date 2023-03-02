import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:wup/Service/notification_service.dart';
import 'calendar_screen.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wup/components/constants.dart';
import 'package:wup/components/default_button.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:timezone/timezone.dart' as tz;

class EventInputScreen extends StatefulWidget {
  const EventInputScreen({Key? key}) : super(key: key);

  @override
  _EventInputScreenState createState() => _EventInputScreenState();
}

class _EventInputScreenState extends State<EventInputScreen> {
  final server = dotenv.env['WUP_SERVER']!;
  final email = GetStorage().read('email');

  late TextEditingController _titleController;
  late DateTime _startDate;
  late DateTime _endDate;
  bool _isAllDay = false;
  late Duration? _noti;
  String dropdownValue = '없음';

  List eventList = [];
  bool searchEvent = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _startDate = DateTime.now().toLocal();
    _endDate = DateTime.now().toLocal().add(const Duration(hours: 1));
    _noti = null;
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

  Future<void> _searchEvents(String kw) async {
    await fetchEvents().then((events) {
      for (var event in events) {
        if (event.title.contains(kw)) {
          setState(() {
            eventList.add(event);
          });
        }
      }
      // 날짜 기준 최신 3건만 가져오는 코드.
      try {
        eventList = eventList.sublist(eventList.length - 3);
      } catch (e) {
        eventList;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Event'),
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
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: TextFormField(
                      maxLength: 16,
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: '일정',
                        hintText: '일정을 입력해주세요.',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a title';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        if (value.length > 1) {
                          setState(() {
                            eventList.clear();
                            _searchEvents(value);
                            searchEvent = true;
                          });
                        } else {
                          setState(() {
                            searchEvent = false;
                            eventList.clear();
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Stack(
                    children: [
                      if (searchEvent)
                        Expanded(
                          child: ListView.separated(
                            shrinkWrap: true,
                            separatorBuilder: (context, index) {
                              return const Divider(
                                height: 8,
                              );
                            },
                            itemCount: eventList.length,
                            itemBuilder: (BuildContext context, int index) {
                              // Create a ListTile for each item in the data list
                              return ListTile(
                                title: Text(eventList[index].title),
                                subtitle: Text(
                                    '${eventList[index].start.toString().split(' ')[1].split('.')[0].replaceRange(5, null, '')} - ${eventList[index].end.toString().split(' ')[1].split('.')[0].replaceRange(5, null, '')}'),
                                tileColor: kPrimaryColor,
                                onTap: () {
                                  setState(() {
                                    DateTime oldStartTime = _startDate;
                                    DateTime newStartTime = DateTime(
                                      oldStartTime.year,
                                      oldStartTime.month,
                                      oldStartTime.day,
                                      eventList[index].start.hour,
                                      eventList[index].start.minute,
                                    );
                                    _startDate = newStartTime;

                                    DateTime oldEndTime = _endDate;
                                    DateTime newEndTime = DateTime(
                                      oldEndTime.year,
                                      oldEndTime.month,
                                      oldEndTime.day,
                                      eventList[index].end.hour,
                                      eventList[index].end.minute,
                                    );
                                    _endDate = newEndTime;

                                    _isAllDay = eventList[index].isAllDay;

                                    if (eventList[index].noti != null) {
                                      _noti = Duration(
                                          minutes: eventList[index].noti);
                                      dropdownValue =
                                          eventList[index].noti.toString();
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
                        offset: searchEvent
                            ? Offset(0, eventList.length * 70 + 16)
                            : Offset.zero,
                        child: Column(
                          children: [
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
                                    setState(() {
                                      _isAllDay = value;
                                    });
                                  },
                                ),
                              ],
                            ),
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
                                            backgroundColor:
                                                MaterialStatePropertyAll(
                                                    kPrimaryColor)),
                                        child: Text(
                                          DateFormat('hh:mm a')
                                              .format(_startDate),
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
                                    if (!_endDate.isBefore(_startDate))
                                      FilledButton(
                                        onPressed: _selectEndDate,
                                        style: const ButtonStyle(
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
                                              backgroundColor:
                                                  MaterialStatePropertyAll(
                                                      kPrimaryColor)),
                                          child: Text(
                                            DateFormat('hh:mm a')
                                                .format(_endDate),
                                            style: const TextStyle(
                                                fontSize: 16,
                                                decoration:
                                                    TextDecoration.lineThrough),
                                          ),
                                        ),
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      ),
                    ],
                  ),
                  const Spacer(),
                  DefaultButton2(
                    press: () async {
                      if (_titleController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Please enter a title')));
                        return;
                      }

                      if (_endDate.isBefore(_startDate)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('End date must be after start date')));
                        return;
                      }

                      final event = Event(
                        null,
                        _titleController.text,
                        _startDate.toLocal(),
                        _endDate.toLocal(),
                        _isAllDay,
                        _noti?.inMinutes,
                      );

                      final response = await http.post(
                        Uri.parse('$server/calendars/events/$email/'),
                        headers: {
                          'Content-Type': 'application/json',
                        },
                        body: jsonEncode(event.toJson()),
                      );

                      if (response.statusCode == 201) {
                        Navigator.pop(context, true);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Failed to add event')));
                      }

                      if (_noti != null) {
                        tz.TZDateTime scheduledDate = tz.TZDateTime(
                                tz.local,
                                _startDate.year,
                                _startDate.month,
                                _startDate.day,
                                _startDate.hour,
                                _startDate.minute)
                            .subtract(_noti!);
                        print(scheduledDate);

                        NotificationService().scheduleReminder(
                            GetStorage().read('userName').hashCode ^
                                _startDate.toString().substring(0, 19).hashCode,
                            _titleController.text,
                            '${_noti!.inMinutes}분',
                            scheduledDate);
                      }
                    },
                    text: 'Add Event',
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
