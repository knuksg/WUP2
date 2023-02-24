class Event {
  final int id;
  final String title;
  final String description;
  final DateTime start;
  final DateTime end;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.start,
    required this.end,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      start: DateTime.parse(json['start']),
      end: DateTime.parse(json['end']),
    );
  }

  @override
  String toString() => title;
}
