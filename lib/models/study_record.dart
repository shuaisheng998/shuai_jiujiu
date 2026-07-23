class StudyRecord {
  final DateTime date;
  final int wordsLearned;
  final int questionsDone;
  final int correctCount;
  final int wrongCount;
  final bool checkedIn;

  StudyRecord({
    required this.date,
    this.wordsLearned = 0,
    this.questionsDone = 0,
    this.correctCount = 0,
    this.wrongCount = 0,
    this.checkedIn = false,
  });

  double get accuracyRate =>
      questionsDone > 0 ? correctCount / questionsDone * 100 : 0;

  Map<String, dynamic> toJson() => {
        'date': date.toIso8601String().substring(0, 10),
        'wordsLearned': wordsLearned,
        'questionsDone': questionsDone,
        'correctCount': correctCount,
        'wrongCount': wrongCount,
        'checkedIn': checkedIn,
      };

  factory StudyRecord.fromJson(Map<String, dynamic> json) {
    return StudyRecord(
      date: DateTime.parse(json['date'] as String),
      wordsLearned: json['wordsLearned'] as int? ?? 0,
      questionsDone: json['questionsDone'] as int? ?? 0,
      correctCount: json['correctCount'] as int? ?? 0,
      wrongCount: json['wrongCount'] as int? ?? 0,
      checkedIn: json['checkedIn'] as bool? ?? false,
    );
  }
}
