import 'package:flutter/material.dart';
import '../data/cloze_bank.dart';
import '../models/cloze_test.dart';
import '../services/storage_service.dart';
import '../models/wrong_topic.dart';

class ClozePage extends StatefulWidget {
  const ClozePage({super.key});

  @override
  State<ClozePage> createState() => _ClozePageState();
}

class _ClozePageState extends State<ClozePage> {
  late List<ClozeTest> _tests;
  int _currentTestIndex = 0;
  int _currentBlankIndex = 0;
  int? _selectedAnswer;
  bool? _isCorrect;
  int _correctCount = 0;
  int _totalDone = 0;
  bool _showTranslation = false;
  String _selectedLevel = 'junior';

  @override
  void initState() {
    super.initState();
    _tests = ClozeBank.getAllTests()
        .where((t) => t.level == _selectedLevel)
        .toList();
  }

  void _switchLevel(String level) {
    final filtered = ClozeBank.getAllTests()
        .where((t) => t.level == level)
        .toList();
    if (filtered.isEmpty) return; // 无题目时不切换
    setState(() {
      _selectedLevel = level;
      _currentTestIndex = 0;
      _currentBlankIndex = 0;
      _selectedAnswer = null;
      _isCorrect = null;
      _correctCount = 0;
      _totalDone = 0;
      _showTranslation = false;
      _tests = filtered;
    });
  }

  ClozeTest get _currentTest =>
      _tests[_currentTestIndex % _tests.length];

  ClozeBlank get _currentBlank =>
      _currentTest.blanks[_currentBlankIndex];

  int get _totalBlanks => _currentTest.blanks.length;

  Future<void> _answerQuestion(int index) async {
    if (_selectedAnswer != null) return;

    final correct = index == _currentBlank.correctIndex;
    setState(() {
      _selectedAnswer = index;
      _isCorrect = correct;
      _totalDone++;
      if (correct) _correctCount++;
    });

    if (!correct) {
      final topic = WrongTopic(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: 'cloze',
        content:
            '完形填空: ${_currentTest.title} - 第${_currentBlank.index + 1}空',
        correctAnswer: _currentBlank.options[_currentBlank.correctIndex],
        userAnswer: _currentBlank.options[index],
        wrongDate: DateTime.now(),
      );
      await StorageService.addWrongTopic(topic);
    }
  }

  void _nextBlank() {
    if (_currentBlankIndex + 1 >= _totalBlanks) {
      _showResult();
      return;
    }
    setState(() {
      _currentBlankIndex++;
      _selectedAnswer = null;
      _isCorrect = null;
    });
  }

  void _showResult() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('完形填空完成！'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.emoji_events, size: 64, color: Colors.amber),
            const SizedBox(height: 12),
            Text(
              '$_correctCount / $_totalDone',
              style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              _totalDone > 0 && _correctCount / _totalDone >= 0.8
                  ? '太棒了！继续加油！🌟'
                  : _totalDone > 0 && _correctCount / _totalDone >= 0.6
                      ? '不错，再练练会更好！💪'
                      : '错题已收录，记得复习！📚',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('返回'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _restartTest();
            },
            child: const Text('换一篇'),
          ),
        ],
      ),
    );
  }

  void _restartTest() {
    final nextIndex = (_currentTestIndex + 1) % _tests.length;
    setState(() {
      _currentTestIndex = nextIndex;
      _currentBlankIndex = 0;
      _selectedAnswer = null;
      _isCorrect = null;
      _correctCount = 0;
      _totalDone = 0;
      _showTranslation = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_tests.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('完形填空'),
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: Colors.white,
        ),
        body: const Center(child: Text('暂无题目')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('完形填空'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.translate),
            tooltip: '查看全文翻译',
            onPressed: () =>
                setState(() => _showTranslation = !_showTranslation),
          ),
        ],
      ),
      body: Column(
        children: [
          // 等级切换
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
            child: Row(
              children: [
                _buildLevelChip('junior', '📗 初中'),
                const SizedBox(width: 8),
                _buildLevelChip('senior', '📘 高中'),
                const Spacer(),
                Text(
                  '${_currentTestIndex + 1}/${_tests.length}',
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ],
            ),
          ),

          // 进度
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Text(
                  '第${_currentBlankIndex + 1}/$_totalBlanks空',
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: _totalBlanks > 0 ? (_currentBlankIndex + 1) / _totalBlanks : 0,
                      minHeight: 6,
                      backgroundColor: Colors.grey[200],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '✅ $_correctCount / $_totalDone',
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.green),
                ),
              ],
            ),
          ),

          // 翻译
          if (_showTranslation && _currentTest.translation != null)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(12, 8, 12, 0),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.06),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.withOpacity(0.2)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.translate, size: 16, color: Colors.blue),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      _currentTest.translation!,
                      style: const TextStyle(fontSize: 13, color: Colors.black87),
                    ),
                  ),
                ],
              ),
            ),

          // 标题
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 4),
            child: Row(
              children: [
                Icon(Icons.article_outlined,
                    size: 18, color: theme.colorScheme.primary),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    _currentTest.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          // 短文（可滚动）
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
              child: _buildPassageView(theme),
            ),
          ),

          // 选项
          if (_currentBlankIndex < _totalBlanks)
            _buildOptions(theme),

          // 下一题按钮
          if (_selectedAnswer != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _nextBlank,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(
                    _currentBlankIndex + 1 >= _totalBlanks
                        ? '查看结果'
                        : '下一空 →',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPassageView(ThemeData theme) {
    final test = _currentTest;
    // 将文章按 ___ 分割，并高亮当前空格
    final parts = test.passage.split('___');
    final children = <InlineSpan>[];

    for (int i = 0; i < parts.length; i++) {
      children.add(TextSpan(
        text: parts[i],
        style: const TextStyle(
          fontSize: 15,
          color: Colors.black87,
          height: 1.6,
        ),
      ));

      if (i < test.blanks.length) {
        final blank = test.blanks[i];
        final isCurrent = i == _currentBlankIndex;
        final isAnswered = isCurrent && _selectedAnswer != null;

        String? answerText;
        if (isAnswered) {
          answerText = _currentBlank.options[_selectedAnswer!];
        } else if (!isCurrent && i < _currentBlankIndex) {
          // 前面的空已经填了，显示正确答案
          answerText = blank.options[blank.correctIndex];
        } else {
          answerText = '______';
        }

        Color? bgColor;
        if (isAnswered) {
          bgColor = _isCorrect == true
              ? Colors.green.withOpacity(0.2)
              : Colors.red.withOpacity(0.2);
        } else if (!isCurrent && i < _currentBlankIndex) {
          bgColor = Colors.green.withOpacity(0.15);
        }

        children.add(WidgetSpan(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            decoration: BoxDecoration(
              color: bgColor ?? (isCurrent ? Colors.yellow.withOpacity(0.3) : Colors.grey[200]),
              borderRadius: BorderRadius.circular(4),
              border: isCurrent && !isAnswered
                  ? Border.all(color: Colors.orange, width: 1.5)
                  : null,
            ),
            child: Text(
              answerText,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: bgColor != null
                    ? Colors.black87
                    : (isCurrent ? Colors.orange.shade800 : Colors.grey[600]),
              ),
            ),
          ),
        ));
      }
    }

    // 解析
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          margin: EdgeInsets.zero,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            child: RichText(text: TextSpan(children: children)),
          ),
        ),

        // 当前空的解析
        if (_selectedAnswer != null) ...[
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.06),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue.withOpacity(0.2)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.lightbulb_outline,
                    size: 18, color: Colors.blue),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '第${_currentBlank.index + 1}空解析：${_currentBlank.explanation}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildOptions(ThemeData theme) {
    final blank = _currentBlank;
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
      child: Column(
        children: [
          Text(
            '第${blank.index + 1}空 请选择：',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          ...List.generate(blank.options.length, (index) {
            final letter = String.fromCharCode(65 + index);
            Color? bgColor;
            Color? borderColor;

            if (_selectedAnswer != null) {
              if (index == blank.correctIndex) {
                bgColor = Colors.green.withOpacity(0.12);
                borderColor = Colors.green;
              } else if (index == _selectedAnswer &&
                  _selectedAnswer != blank.correctIndex) {
                bgColor = Colors.red.withOpacity(0.12);
                borderColor = Colors.red;
              }
            }

            return GestureDetector(
              onTap: () => _answerQuestion(index),
              child: Container(
                margin: const EdgeInsets.only(bottom: 6),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: bgColor ?? Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: borderColor ?? Colors.grey[300]!,
                    width: _selectedAnswer != null ? 2 : 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: _selectedAnswer != null && borderColor != null
                            ? borderColor
                            : Colors.grey[300],
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Center(
                        child: Text(
                          letter,
                          style: TextStyle(
                            color: _selectedAnswer != null
                                ? Colors.white
                                : Colors.black54,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        blank.options[index],
                        style: const TextStyle(fontSize: 15),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildLevelChip(String level, String label) {
    final isSelected = _selectedLevel == level;
    return GestureDetector(
      onTap: () => _switchLevel(level),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
