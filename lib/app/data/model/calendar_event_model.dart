import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
    final start =
        DateFormat("yyyy-MM-dd'T'HH:mm:ssZ").parse(json['start']).toLocal();
    final end =
        DateFormat("yyyy-MM-dd'T'HH:mm:ssZ").parse(json['end']).toLocal();
    int? intNoti;

    try {
      final jsonNoti = json['noti'].toString().split(':')[2];
      intNoti = int.parse(jsonNoti);
    } catch (e) {
      // 알람이 없을 경우 콘솔에 에러 찍힐 수 있음.
      debugPrint('Event.fromJson Error');
      debugPrint(e.toString());
    }

    return Event(
      json['id'],
      json['title'],
      start,
      end,
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
