import 'dart:math';
import 'package:flutter/material.dart';
import '../data/grammar_bank.dart';
import '../models/grammar_question.dart';
import '../services/storage_service.dart';
import '../models/wrong_topic.dart';

class GrammarPage extends StatefulWidget {
  const GrammarPage({super.key});

  @override
  State<GrammarPage> createState() => _GrammarPageState();
}

class _GrammarPageState extends State<GrammarPage> {
  late List<GrammarQuestion> _questions;
  int _currentIndex = 0;
  int? _selectedAnswer;
  bool? _isCorrect;
  int _correctCount = 0;
  int _totalCount = 0;
  String _selectedLevel = 'junior';
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _questions = GrammarBank.getJuniorQuestions()..shuffle(Random());
  }

  void _switchLevel(String level) {
    setState(() {
      _selectedLevel = level;
      _currentIndex = 0;
      _selectedAnswer = null;
      _isCorrect = null;
      _correctCount = 0;
      _totalCount = 0;
      _selectedCategory = null;
      final source = level == 'junior'
          ? GrammarBank.getJuniorQuestions()
          : GrammarBank.getSeniorQuestions();
      _questions = source..shuffle(Random());
    });
  }

  void _filterByCategory(String? category) {
    setState(() {
      _selectedCategory = category;
      _currentIndex = 0;
      _selectedAnswer = null;
      _isCorrect = null;
      _correctCount = 0;
      _totalCount = 0;
      final source = _selectedLevel == 'junior'
          ? GrammarBank.getJuniorQuestions()
          : GrammarBank.getSeniorQuestions();
      if (category != null) {
        _questions = source.where((q) => q.category == category).toList()
          ..shuffle(Random());
      } else {
        _questions = source..shuffle(Random());
      }
    });
  }

  void _answerQuestion(int index) {
    if (_selectedAnswer != null) return;

    final correct = index == _questions[_currentIndex].correctIndex;
    setState(() {
      _selectedAnswer = index;
      _isCorrect = correct;
      _totalCount++;
      if (correct) _correctCount++;
    });

    if (!correct) {
      final q = _questions[_currentIndex];
      final topic = WrongTopic(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: 'word',
        content: '语法: ${q.question}',
        correctAnswer: q.options[q.correctIndex],
        userAnswer: q.options[index],
        wrongDate: DateTime.now(),
      );
      StorageService.addWrongTopic(topic);
    }

    StorageService.incrementQuestionsDone();
  }

  void _nextQuestion() {
    if (_currentIndex + 1 >= _questions.length) {
      _showResult();
      return;
    }
    setState(() {
      _currentIndex++;
      _selectedAnswer = null;
      _isCorrect = null;
    });
  }

  void _restart() {
    setState(() {
      _currentIndex = 0;
      _selectedAnswer = null;
      _isCorrect = null;
      _correctCount = 0;
      _totalCount = 0;
      _questions.shuffle(Random());
    });
  }

  void _showResult() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('语法练习完成！'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.emoji_events, size: 64, color: Colors.amber),
            const SizedBox(height: 12),
            Text(
              '$_correctCount / $_totalCount',
              style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '正确率 ${_totalCount > 0 ? (_correctCount / _totalCount * 100).toStringAsFixed(0) : 0}%',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              _correctCount / _totalCount >= 0.8
                  ? '太棒了！🌟'
                  : _correctCount / _totalCount >= 0.6
                      ? '继续加油！💪'
                      : '错题已收录，记得复习！📚',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('返回')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _restart();
            },
            child: const Text('再来一次'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('英语语法'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // 等级和分类筛选
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
            child: Row(
              children: [
                _buildLevelChip('junior', '📗 基础语法'),
                const SizedBox(width: 8),
                _buildLevelChip('senior', '📘 进阶语法'),
                const Spacer(),
                Text(
                  '✅ $_correctCount / $_totalCount',
                  style: const TextStyle(fontSize: 13, color: Colors.green),
                ),
              ],
            ),
          ),

          // 分类标签
          SizedBox(
            height: 38,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                _buildCategoryChip(null, '全部'),
                ...GrammarBank.getCategories().map((c) => _buildCategoryChip(c, c)),
              ],
            ),
          ),

          // 进度
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Text(
                  '${_currentIndex + 1} / ${_questions.length}',
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: LinearProgressIndicator(
                    value: (_currentIndex + 1) / _questions.length,
                    minHeight: 6,
                    borderRadius: BorderRadius.circular(4),
                    backgroundColor: Colors.grey[200],
                  ),
                ),
              ],
            ),
          ),

          if (_questions.isNotEmpty) ...[
            // 题目
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Card(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                _questions[_currentIndex].category,
                                style: TextStyle(fontSize: 12, color: theme.colorScheme.primary),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _questions[_currentIndex].question,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                height: 1.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // 选项
                    ...List.generate(
                      _questions[_currentIndex].options.length,
                      (index) => _buildOption(index, theme),
                    ),

                    // 解析
                    if (_selectedAnswer != null) ...[
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: _isCorrect == true
                              ? Colors.green.withValues(alpha: 0.08)
                              : Colors.blue.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: _isCorrect == true
                                ? Colors.green.withValues(alpha: 0.3)
                                : Colors.blue.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              _isCorrect == true ? Icons.check_circle : Icons.lightbulb_outline,
                              color: _isCorrect == true ? Colors.green : Colors.blue,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _questions[_currentIndex].explanation,
                                style: const TextStyle(fontSize: 14, height: 1.5),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            // 下一题按钮
            if (_selectedAnswer != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _nextQuestion,
                    style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
                    child: Text(
                      _currentIndex + 1 >= _questions.length ? '查看结果' : '下一题 →',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),
          ] else
            const Expanded(child: Center(child: Text('该分类暂无题目'))),
        ],
      ),
    );
  }

  Widget _buildOption(int index, ThemeData theme) {
    final q = _questions[_currentIndex];
    final letter = String.fromCharCode(65 + index);
    Color? bgColor;
    Color? borderColor;

    if (_selectedAnswer != null) {
      if (index == q.correctIndex) {
        bgColor = Colors.green.withValues(alpha: 0.12);
        borderColor = Colors.green;
      } else if (index == _selectedAnswer && _selectedAnswer != q.correctIndex) {
        bgColor = Colors.red.withValues(alpha: 0.12);
        borderColor = Colors.red;
      }
    }

    return GestureDetector(
      onTap: () => _answerQuestion(index),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: bgColor ?? Colors.grey[50],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: borderColor ?? Colors.grey[300]!,
            width: _selectedAnswer != null ? 2 : 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 30, height: 30,
              decoration: BoxDecoration(
                color: _selectedAnswer != null && borderColor != null ? borderColor : Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(letter,
                  style: TextStyle(
                    color: _selectedAnswer != null ? Colors.white : Colors.black54,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(q.options[index], style: const TextStyle(fontSize: 16)),
            ),
            if (_selectedAnswer != null && index == q.correctIndex)
              const Icon(Icons.check, color: Colors.green, size: 20),
          ],
        ),
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
          color: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(label, style: TextStyle(
          color: isSelected ? Colors.white : Colors.black87,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          fontSize: 13,
        )),
      ),
    );
  }

  Widget _buildCategoryChip(String? category, String label) {
    final isSelected = _selectedCategory == category;
    return GestureDetector(
      onTap: () => _filterByCategory(category),
      child: Container(
        margin: const EdgeInsets.only(right: 6),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.grey[100],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? Colors.blue : Colors.grey[300]!, width: 1),
        ),
        child: Text(label, style: TextStyle(
          fontSize: 12,
          color: isSelected ? Colors.white : Colors.black54,
        )),
      ),
    );
  }
}
