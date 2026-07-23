class ClozeTest {
  final String id;
  final String title;
  final String passage; // 原文（用 ___ 表示空格）
  final List<ClozeBlank> blanks;
  final String level; // 'junior' 初中 / 'senior' 高中
  final String? translation; // 全文翻译

  ClozeTest({
    required this.id,
    required this.title,
    required this.passage,
    required this.blanks,
    required this.level,
    this.translation,
  });
}

class ClozeBlank {
  final int index; // 第几个空
  final List<String> options; // 4个选项
  final int correctIndex; // 正确答案索引 (0-3)
  final String explanation; // 为什么选这个

  ClozeBlank({
    required this.index,
    required this.options,
    required this.correctIndex,
    required this.explanation,
  });
}
