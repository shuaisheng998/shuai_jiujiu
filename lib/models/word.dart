class Word {
  final String english;
  final String chinese;
  final String? pronunciation; // 音标
  final String? example;
  final String? exampleChinese;
  final String? detailExplanation; // 详细解析/用法
  final String level; // 'junior' 初中 / 'senior' 高中

  Word({
    required this.english,
    required this.chinese,
    this.pronunciation,
    this.example,
    this.exampleChinese,
    this.detailExplanation,
    required this.level,
  });

  factory Word.fromJson(Map<String, dynamic> json) {
    return Word(
      english: json['english'] as String,
      chinese: json['chinese'] as String,
      pronunciation: json['pronunciation'] as String?,
      example: json['example'] as String?,
      exampleChinese: json['exampleChinese'] as String?,
      detailExplanation: json['detailExplanation'] as String?,
      level: json['level'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'english': english,
        'chinese': chinese,
        'pronunciation': pronunciation,
        'example': example,
        'exampleChinese': exampleChinese,
        'detailExplanation': detailExplanation,
        'level': level,
      };
}
