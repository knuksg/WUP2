class Event {
  final int id;
  final String title;
  final String description;
  final DateTime start;
  final DateTime end;
  final bool isAllDay;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.start,
    required this.end,
    required this.isAllDay,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      start: DateTime.parse(json['start']),
      end: DateTime.parse(json['end']),
      isAllDay: json['isAllDay'],
    );
  }

  @override
  String toString() => title;
}
