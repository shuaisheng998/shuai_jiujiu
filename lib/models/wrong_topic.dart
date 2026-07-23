class WrongTopic {
  final String id;
  final String type; // 'word' 或 'math'
  final String content;
  final String correctAnswer;
  final String userAnswer;
  final DateTime wrongDate;
  bool reviewed;

  WrongTopic({
    required this.id,
    required this.type,
    required this.content,
    required this.correctAnswer,
    required this.userAnswer,
    required this.wrongDate,
    this.reviewed = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'content': content,
        'correctAnswer': correctAnswer,
        'userAnswer': userAnswer,
        'wrongDate': wrongDate.toIso8601String(),
        'reviewed': reviewed,
      };

  factory WrongTopic.fromJson(Map<String, dynamic> json) {
    return WrongTopic(
      id: json['id'] as String,
      type: json['type'] as String,
      content: json['content'] as String,
      correctAnswer: json['correctAnswer'] as String,
      userAnswer: json['userAnswer'] as String,
      wrongDate: DateTime.parse(json['wrongDate'] as String),
      reviewed: json['reviewed'] as bool? ?? false,
    );
  }
}
