class GrammarQuestion {
  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation;
  final String category; // '时态', 'be动词', '句式', '介词', '冠词'等
  final String level; // 'junior' 初中 / 'senior' 高中
  final int difficulty; // 1-5

  GrammarQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanation,
    required this.category,
    required this.level,
    this.difficulty = 1,
  });
}
