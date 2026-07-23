class MathQuestion {
  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation;
  final List<String> steps; // 详细解题步骤
  final String? knowledgePoint; // 考察知识点
  final String category; // '代数', '几何', '函数', '集合' 等
  final String level; // 'junior' 初中 / 'senior' 高中
  final int difficulty; // 1-5

  MathQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanation,
    this.steps = const [],
    this.knowledgePoint,
    required this.category,
    required this.level,
    this.difficulty = 1,
  });

  factory MathQuestion.fromJson(Map<String, dynamic> json) {
    return MathQuestion(
      question: json['question'] as String,
      options: List<String>.from(json['options'] as List),
      correctIndex: json['correctIndex'] as int,
      explanation: json['explanation'] as String,
      steps: json['steps'] != null
          ? List<String>.from(json['steps'] as List)
          : [],
      knowledgePoint: json['knowledgePoint'] as String?,
      category: json['category'] as String,
      level: json['level'] as String,
      difficulty: json['difficulty'] as int? ?? 1,
    );
  }
}
