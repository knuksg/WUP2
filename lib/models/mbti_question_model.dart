class MbtiQuestion {
  String? title;
  List<String>? body;
  List<String>? answer;

  MbtiQuestion({this.title, this.body, this.answer});

  MbtiQuestion.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    body = json['body'].toString().split('/');
    answer = json['answer'].toString().split('/');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['body'] = body;
    data['answer'] = answer;
    return data;
  }
}
