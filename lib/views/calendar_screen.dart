import 'dart:collection';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:wup/components/constants.dart';
import 'package:wup/views/calendar_input_screen.dart';
import 'package:wup/views/calendar_detail_screen.dart';
import 'package:wup/views/slider_view.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';

class Event {
  final int? id;
  final String title;
  final DateTime start;
  final DateTime end;
  final bool isAllDay;
  final int? noti;

  const Event(
      this.id, this.title, this.start, this.end, this.isAllDay, this.noti);

  @override
  String toString() => title;

  factory Event.fromJson(Map<String, dynamic> json) {
    final start = DateFormat("yyyy-MM-dd'T'HH:mm:ssZ").parse(json['start']);
    final end = DateFormat("yyyy-MM-dd'T'HH:mm:ssZ").parse(json['end']);
    int? intNoti;
    try {
      debugPrint(json['noti'].toString().split(':')[2]);
      final jsonNoti = json['noti'].toString().split(':')[2];
      intNoti = int.parse(jsonNoti);
    } catch (e) {}
    return Event(
      json['id'],
      json['title'],
      start.toLocal(),
      end.toLocal(),
      json['isAllDay'],
      intNoti,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'start': start.toLocal().toIso8601String(),
        'end': end.toLocal().toIso8601String(),
        'isAllDay': isAllDay,
        'noti': noti,
      };
}

final kEvents = LinkedHashMap<DateTime, List<Event>>(
  equals: isSameDay,
  hashCode: getHashCode,
)..addAll(_kEventSource);

LinkedHashMap<DateTime, List<Event>> _kEventSource =
    LinkedHashMap<DateTime, List<Event>>();

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

/// Returns a list of [DateTime] objects from [first] to [last], inclusive.
List<DateTime> daysInRange(DateTime first, DateTime last) {
  final localFirst = first.toLocal();
  final localLast = last.toLocal();
  final dayCount = localLast.difference(localFirst).inDays + 1;
  return List.generate(
    dayCount,
    (index) =>
        DateTime.utc(localFirst.year, localFirst.month, localFirst.day + index)
            .toLocal(),
  );
}

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final server = dotenv.env['WUP_SERVER']!;
  final email = GetStorage().read('email');

  late final ValueNotifier<List<Event>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier([]);

    setState(() {
      kEvents.clear();
      _kEventSource.clear();
    });

    fetchEvents().then((events) {
      setState(() {
        for (final event in events) {
          final days = daysInRange(event.start, event.end);
          final addedDays = <DateTime>{};

          for (final day in days) {
            if (_kEventSource[day] == null) {
              _kEventSource[day] = [event];
            } else {
              _kEventSource[day]!.add(event);
            }

            if (!addedDays.contains(day)) {
              kEvents[day] = _kEventSource[day]!;
              addedDays.add(day);
            }
          }
        }

        _selectedEvents.value = _getEventsForDay(_selectedDay!);
      });
    });
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<Event> _getEventsForDay(DateTime day) {
    // Implementation example
    return kEvents[day] ?? [];
  }

  List<Event> _getEventsForRange(DateTime start, DateTime end) {
    // Implementation example
    final days = daysInRange(start, end);

    return [
      for (final d in days) ..._getEventsForDay(d),
    ];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    // `start` or `end` could be null
    if (start != null && end != null) {
      _selectedEvents.value = _getEventsForRange(start, end);
    } else if (start != null) {
      _selectedEvents.value = _getEventsForDay(start);
    } else if (end != null) {
      _selectedEvents.value = _getEventsForDay(end);
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

  @override
  Widget build(BuildContext context) {
    final GlobalKey<SliderDrawerState> sliderDrawerKey =
        GlobalKey<SliderDrawerState>();
    return Scaffold(
      body: SliderDrawer(
        appBar: const SliderAppBar(
          title: Text(
            'Calendar',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        key: sliderDrawerKey,
        slider: SliderView(
          onItemClick: (title) {
            sliderDrawerKey.currentState!.closeSlider();
            final route = title.toLowerCase();
            Get.toNamed('/$route');
          },
        ),
        child: Column(
          children: [
            TableCalendar<Event>(
              locale: 'ko_KR',
              daysOfWeekHeight: 30,
              firstDay: kFirstDay,
              lastDay: kLastDay,
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              rangeStartDay: _rangeStart,
              rangeEndDay: _rangeEnd,
              calendarFormat: _calendarFormat,
              rangeSelectionMode: _rangeSelectionMode,
              eventLoader: _getEventsForDay,
              startingDayOfWeek: StartingDayOfWeek.sunday,
              calendarStyle: const CalendarStyle(
                  // Use `CalendarStyle` to customize the UI
                  outsideDaysVisible: false,
                  selectedDecoration: BoxDecoration(
                      color: kPrimaryColor, shape: BoxShape.circle)),
              onDaySelected: _onDaySelected,
              onRangeSelected: _onRangeSelected,
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
            ),
            const SizedBox(height: 8.0),
            Expanded(
              child: ValueListenableBuilder<List<Event>>(
                valueListenable: _selectedEvents,
                builder: (context, value, _) {
                  return ListView.builder(
                    itemCount: value.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12.0,
                          vertical: 4.0,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: ListTile(
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EventDetailScreen(event: value[index]),
                              ),
                            ).then((value) {
                              if (value != null && value) {
                                // Refresh the calendar events if a new event was added
                                setState(() {
                                  kEvents.clear();
                                  _kEventSource.clear();
                                });
                                fetchEvents().then((events) {
                                  setState(() {
                                    for (final event in events) {
                                      if (event.start
                                              .difference(event.end)
                                              .inDays ==
                                          0) {
                                        if (_kEventSource[event.start] ==
                                            null) {
                                          _kEventSource[event.start] = [event];
                                        } else {
                                          _kEventSource[event.start]!
                                              .add(event);
                                        }
                                      } else {
                                        final days =
                                            daysInRange(event.start, event.end);
                                        for (final day in days) {
                                          if (_kEventSource[day] == null) {
                                            _kEventSource[day] = [event];
                                          } else {
                                            _kEventSource[day]!.add(event);
                                          }
                                        }
                                      }
                                    }
                                    kEvents.addAll(_kEventSource);
                                    _selectedEvents.value =
                                        _getEventsForDay(_selectedDay!);
                                  });
                                });
                              }
                            });
                          },
                          title: Text('${value[index]}'),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const EventInputScreen()),
          ).then((value) {
            if (value != null && value) {
              // Refresh the calendar events if a new event was added
              setState(() {
                kEvents.clear();
                _kEventSource.clear();
              });
              fetchEvents().then((events) {
                setState(() {
                  for (final event in events) {
                    final days = daysInRange(event.start, event.end);
                    final addedDays = <DateTime>{};

                    for (final day in days) {
                      if (_kEventSource[day] == null) {
                        _kEventSource[day] = [event];
                      } else {
                        _kEventSource[day]!.add(event);
                      }

                      if (!addedDays.contains(day)) {
                        kEvents[day] = _kEventSource[day]!;
                        addedDays.add(day);
                      }
                    }
                  }

                  _selectedEvents.value = _getEventsForDay(_selectedDay!);
                });
              });
            }
          });
        },
        backgroundColor: kSecondaryColor,
        foregroundColor: kPrimaryColor,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
