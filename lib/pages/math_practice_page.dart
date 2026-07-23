import 'dart:math';
import 'package:flutter/material.dart';
import '../data/math_bank.dart';
import '../models/math_question.dart';
import '../services/storage_service.dart';
import '../models/wrong_topic.dart';

class MathPracticePage extends StatefulWidget {
  const MathPracticePage({super.key});

  @override
  State<MathPracticePage> createState() => _MathPracticePageState();
}

class _MathPracticePageState extends State<MathPracticePage>
    with SingleTickerProviderStateMixin {
  late List<MathQuestion> _questions;
  int _currentIndex = 0;
  int? _selectedAnswer;
  bool? _isCorrect;
  int _correctCount = 0;
  int _totalCount = 0;
  String _selectedLevel = 'junior';
  bool _showExplanation = false;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _questions = MathBank.getJuniorQuestions()..shuffle(Random());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _switchLevel(String level) {
    setState(() {
      _selectedLevel = level;
      _currentIndex = 0;
      _selectedAnswer = null;
      _isCorrect = null;
      _showExplanation = false;
      _correctCount = 0;
      _totalCount = 0;
      final source = level == 'junior'
          ? MathBank.getJuniorQuestions()
          : MathBank.getSeniorQuestions();
      _questions = source..shuffle(Random());
    });
  }

  void _restart() {
    setState(() {
      _currentIndex = 0;
      _selectedAnswer = null;
      _isCorrect = null;
      _showExplanation = false;
      _correctCount = 0;
      _totalCount = 0;
      _questions.shuffle(Random());
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
      _showExplanation = !correct; // 做错了自动显示解析
    });

    // 记录错题
    if (!correct) {
      final q = _questions[_currentIndex];
      final topic = WrongTopic(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: 'math',
        content: q.question,
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
      _showExplanation = false;
    });
  }

  void _showResult() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('练习完成！'),
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
              _totalCount > 0 && _correctCount / _totalCount >= 0.8
                  ? '太棒了！🌟'
                  : _totalCount > 0 && _correctCount / _totalCount >= 0.6
                      ? '继续加油！💪'
                      : '错题已自动收录，记得复习哦！📚',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
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
        title: const Text('数学练习'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: '📝 开始练习'),
            Tab(text: '📚 选择章节'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPracticeMode(theme),
          _buildChapterSelect(theme),
        ],
      ),
    );
  }

  Widget _buildChapterSelect(ThemeData theme) {
    final categories = _selectedLevel == 'junior'
        ? MathBank.getJuniorCategories()
        : MathBank.getSeniorCategories();

    final levelQuestions = _selectedLevel == 'junior'
        ? MathBank.getJuniorQuestions()
        : MathBank.getSeniorQuestions();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            children: [
              _buildLevelChip('junior', '📗 初中数学'),
              const SizedBox(width: 8),
              _buildLevelChip('senior', '📘 高中数学'),
            ],
          ),
        ),
        Text(
          '知识点分类',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 12),
        ...categories.map((category) {
          final count = levelQuestions
              .where((q) => q.category == category)
              .length;
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: Icon(
                Icons.folder_outlined,
                color: theme.colorScheme.primary,
              ),
              title: Text(category),
              subtitle: Text('$count 道题目'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                final filtered = levelQuestions
                    .where((q) => q.category == category)
                    .toList()
                  ..shuffle(Random());
                setState(() {
                  _questions = filtered;
                  _currentIndex = 0;
                  _selectedAnswer = null;
                  _isCorrect = null;
                  _correctCount = 0;
                  _totalCount = 0;
                  _showExplanation = false;
                });
                _tabController.animateTo(0); // 切换到练习模式
              },
            ),
          );
        }),
      ],
    );
  }

  Widget _buildLevelChip(String level, String label) {
    final isSelected = _selectedLevel == level;
    return GestureDetector(
      onTap: () => _switchLevel(level),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildPracticeMode(ThemeData theme) {
    if (_questions.isEmpty) {
      return const Center(child: Text('暂无题目'));
    }

    final question = _questions[_currentIndex];

    return Column(
      children: [
        // 进度和统计
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '${_currentIndex + 1} / ${_questions.length}',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ),
              Text(
                '✅ $_correctCount / $_totalCount',
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.green),
              ),
            ],
          ),
        ),
        // 进度条
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: LinearProgressIndicator(
            value: (_currentIndex + 1) / _questions.length,
            minHeight: 6,
            borderRadius: BorderRadius.circular(4),
            backgroundColor: Colors.grey[200],
          ),
        ),
        const SizedBox(height: 8),
        // 难度和分类标签
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  question.category,
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '难度 ${"⭐" * question.difficulty}',
                  style: const TextStyle(fontSize: 12, color: Colors.orange),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // 题目
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            child: Text(
              question.question,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                height: 1.5,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // 选项
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: question.options.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (_, index) {
              Color? bgColor;
              Color? borderColor;

              if (_selectedAnswer != null) {
                if (index == question.correctIndex) {
                  bgColor = Colors.green.withOpacity(0.12);
                  borderColor = Colors.green;
                } else if (index == _selectedAnswer &&
                    _selectedAnswer != question.correctIndex) {
                  bgColor = Colors.red.withOpacity(0.12);
                  borderColor = Colors.red;
                }
              }

              final letter = String.fromCharCode(65 + index); // A, B, C, D

              return GestureDetector(
                onTap: () => _answerQuestion(index),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: bgColor ?? Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: borderColor ?? Colors.grey[300]!,
                      width: _selectedAnswer != null ? 2 : 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: _selectedAnswer != null &&
                                  borderColor != null
                              ? borderColor
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            letter,
                            style: TextStyle(
                              color: _selectedAnswer != null
                                  ? Colors.white
                                  : Colors.black54,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          question.options[index],
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        // 解析
        if (_selectedAnswer != null)
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 答题结果
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _isCorrect == true
                        ? Colors.green.withOpacity(0.1)
                        : Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: _isCorrect == true
                          ? Colors.green
                          : Colors.red,
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _isCorrect == true
                            ? Icons.check_circle
                            : Icons.cancel,
                        color:
                            _isCorrect == true ? Colors.green : Colors.red,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _isCorrect == true ? '回答正确！🎉' : '回答错误',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: _isCorrect == true
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                      if (_isCorrect == false) ...[
                        const Spacer(),
                        Text(
                          '正确答案: ${question.options[question.correctIndex]}',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.green,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // 知识点标签
                if (question.knowledgePoint != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.purple.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                          color: Colors.purple.withOpacity(0.2)),
                    ),
                    child: Text(
                      '🧠 ${question.knowledgePoint!}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.purple,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],

                // 解题步骤
                if (question.steps.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: Colors.blue.withOpacity(0.2)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.lightbulb_outline,
                                color: Colors.blue, size: 18),
                            SizedBox(width: 6),
                            Text(
                              '详细解题步骤',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ...question.steps.map((step) => Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('  •  ',
                                      style: TextStyle(color: Colors.blue)),
                                  Expanded(
                                    child: Text(
                                      step,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black87,
                                        height: 1.5,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                      ],
                    ),
                  ),
                ],

                // 简短解释
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.summarize_outlined,
                          color: Colors.grey, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          question.explanation,
                          style: TextStyle(
                              fontSize: 13, color: Colors.grey[700]),
                        ),
                      ),
                    ],
                  ),
                ),

                // 下一题按钮
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _nextQuestion,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text(
                      _currentIndex + 1 >= _questions.length
                          ? '查看结果'
                          : '下一题 →',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
