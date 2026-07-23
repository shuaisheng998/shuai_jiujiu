import 'dart:math';
import 'package:flutter/material.dart';
import '../data/word_bank.dart';
import '../models/word.dart';
import '../services/storage_service.dart';
import '../models/wrong_topic.dart';

class WordStudyPage extends StatefulWidget {
  const WordStudyPage({super.key});

  @override
  State<WordStudyPage> createState() => _WordStudyPageState();
}

class _WordStudyPageState extends State<WordStudyPage>
    with SingleTickerProviderStateMixin {
  late List<Word> _words;
  int _currentIndex = 0;
  bool _showChinese = false;
  String _selectedLevel = 'junior';
  late TabController _tabController;

  // 单词测验模式
  bool _isQuizMode = false;
  List<String> _quizOptions = [];
  int? _selectedAnswer;
  bool? _isCorrect;
  int _correctCount = 0;
  int _totalCount = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _words = WordBank.getJuniorWords()..shuffle(Random());
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
      _showChinese = false;
      _isQuizMode = false;
      _words = level == 'junior'
          ? WordBank.getJuniorWords()..shuffle(Random())
          : WordBank.getSeniorWords()..shuffle(Random());
    });
  }

  void _startQuiz() {
    setState(() {
      _isQuizMode = true;
      _currentIndex = 0;
      _selectedAnswer = null;
      _isCorrect = null;
      _correctCount = 0;
      _totalCount = 0;
      _words.shuffle(Random());
      _generateQuizOptions();
    });
  }

  void _generateQuizOptions() {
    if (_currentIndex >= _words.length) return;
    final correctWord = _words[_currentIndex];
    _quizOptions = [correctWord.chinese];

    // 从其他词中随机取3个错误选项
    final otherWords = _words
        .where((w) => w.chinese != correctWord.chinese)
        .toList()
      ..shuffle(Random());

    for (int i = 0;
        i < 3 && i < otherWords.length && _quizOptions.length < 4;
        i++) {
      if (!_quizOptions.contains(otherWords[i].chinese)) {
        _quizOptions.add(otherWords[i].chinese);
      }
    }

    _quizOptions.shuffle(Random());
  }

  void _answerQuestion(int index) {
    if (_selectedAnswer != null) return;

    final correct = _quizOptions[index] == _words[_currentIndex].chinese;
    setState(() {
      _selectedAnswer = index;
      _isCorrect = correct;
      _totalCount++;
      if (correct) _correctCount++;
    });

    // 记录错题
    if (!correct) {
      final topic = WrongTopic(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: 'word',
        content: '单词: ${_words[_currentIndex].english}',
        correctAnswer: _words[_currentIndex].chinese,
        userAnswer: _quizOptions[index],
        wrongDate: DateTime.now(),
      );
      StorageService.addWrongTopic(topic);
    }
  }

  void _nextQuiz() {
    if (_currentIndex + 1 >= _words.length) {
      _showQuizResult();
      return;
    }
    setState(() {
      _currentIndex++;
      _selectedAnswer = null;
      _isCorrect = null;
      _generateQuizOptions();
    });
  }

  void _showQuizResult() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('测验完成！'),
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
              _correctCount / _totalCount >= 0.8
                  ? '太棒了！继续加油！🌟'
                  : _correctCount / _totalCount >= 0.6
                      ? '不错，再练练会更好！💪'
                      : '别灰心，多复习几次就好了！📚',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _isQuizMode = false;
              });
            },
            child: const Text('返回'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _startQuiz();
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
        title: const Text('英语单词'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: '📖 学习模式'),
            Tab(text: '✍️ 测验模式'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildStudyMode(theme),
          _buildQuizMode(theme),
        ],
      ),
    );
  }

  Widget _buildStudyMode(ThemeData theme) {
    if (_words.isEmpty) {
      return const Center(child: Text('暂无单词数据'));
    }

    final word = _words[_currentIndex];

    return Column(
      children: [
        // 等级切换
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              _buildLevelChip('junior', '📗 初中词汇'),
              const SizedBox(width: 8),
              _buildLevelChip('senior', '📘 高中词汇'),
            ],
          ),
        ),

        // 进度条
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Text(
                '${_currentIndex + 1} / ${_words.length}',
                style: const TextStyle(fontSize: 13, color: Colors.grey),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: (_currentIndex + 1) / _words.length,
                    minHeight: 6,
                    backgroundColor: Colors.grey[200],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // 单词卡片
        Expanded(
          child: SingleChildScrollView(
            child: GestureDetector(
              onTap: () {
                setState(() => _showChinese = !_showChinese);
              },
              child: Card(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: _showChinese
                        ? MainAxisAlignment.start
                        : MainAxisAlignment.center,
                    children: [
                      const Text(
                        '点击翻转查看释义',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(height: 20),

                      // 英文/中文
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: Text(
                          _showChinese ? word.chinese : word.english,
                          key: ValueKey(_showChinese),
                          style: TextStyle(
                            fontSize: _showChinese ? 28 : 32,
                            fontWeight: FontWeight.bold,
                            color: _showChinese
                                ? theme.colorScheme.primary
                                : Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // 音标
                      if (word.pronunciation != null && !_showChinese)
                        Text(
                          word.pronunciation!,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                            letterSpacing: 0.5,
                          ),
                        ),

                      const SizedBox(height: 12),
                      Text(
                        _showChinese ? '(点击查看英文)' : '(点击查看中文)',
                        style: const TextStyle(fontSize: 13, color: Colors.grey),
                      ),

                      // 例句
                      if (word.example != null) ...[
                        const SizedBox(height: 20),
                        const Divider(),
                        const SizedBox(height: 12),
                        Text(
                          word.example!,
                          style: const TextStyle(
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                            color: Colors.black54,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        if (word.exampleChinese != null) ...[
                          const SizedBox(height: 6),
                          Text(
                            word.exampleChinese!,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                              height: 1.4,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ],

                      // 详细解析
                      if (word.detailExplanation != null) ...[
                        const SizedBox(height: 16),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: theme.colorScheme.primary.withValues(alpha: 0.2),
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.lightbulb_outline,
                                  color: theme.colorScheme.primary, size: 18),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  word.detailExplanation!,
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
                  ),
                ),
              ),
            ),
          ),
        ),

        // 学习按钮
        Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    if (_currentIndex > 0) {
                      setState(() {
                        _currentIndex--;
                        _showChinese = false;
                      });
                    }
                  },
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('上一个'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await StorageService.markWordLearned(word.english);
                    if (_currentIndex < _words.length - 1) {
                      setState(() {
                        _currentIndex++;
                        _showChinese = false;
                      });
                    } else {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('🎉 所有单词已学完！'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    }
                  },
                  icon: const Icon(Icons.check_circle),
                  label: const Text('学会了 →'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
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

  Widget _buildQuizMode(ThemeData theme) {
    if (!_isQuizMode) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.quiz_outlined, size: 80, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              '准备好测试你的单词量了吗？',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _startQuiz,
              icon: const Icon(Icons.play_arrow),
              label: const Text('开始测验', style: TextStyle(fontSize: 18)),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLevelChip('junior', '📗 初中词汇'),
                const SizedBox(width: 8),
                _buildLevelChip('senior', '📘 高中词汇'),
              ],
            ),
          ],
        ),
      );
    }

    if (_currentIndex >= _words.length) {
      return const Center(child: Text('已完成'));
    }

    final word = _words[_currentIndex];

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // 进度
          Row(
            children: [
              Text(
                '${_currentIndex + 1} / ${_words.length}',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: LinearProgressIndicator(
                  value: (_currentIndex + 1) / _words.length,
                  minHeight: 6,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 12),
              Text('✅ $_correctCount', style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 40),

          Text(
            '请选择"${word.english}"的中文含义：',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),

          Expanded(
            child: ListView.separated(
              itemCount: _quizOptions.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, index) {
                Color? bgColor;
                if (_selectedAnswer != null) {
                  if (index == _selectedAnswer) {
                    bgColor = _isCorrect == true
                        ? Colors.green.withValues(alpha: 0.15)
                        : Colors.red.withValues(alpha: 0.15);
                  }
                  if (_quizOptions[index] == word.chinese &&
                      _selectedAnswer != index) {
                    bgColor = Colors.green.withValues(alpha: 0.15);
                  }
                }

                return GestureDetector(
                  onTap: () => _answerQuestion(index),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                    decoration: BoxDecoration(
                      color: bgColor ?? Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _selectedAnswer == index
                            ? (_isCorrect == true
                                ? Colors.green
                                : Colors.red)
                            : Colors.grey[300]!,
                        width: 2,
                      ),
                    ),
                    child: Text(
                      _quizOptions[index],
                      style: const TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              },
            ),
          ),

          if (_selectedAnswer != null)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _nextQuiz,
                  child: Text(
                    _currentIndex + 1 >= _words.length
                        ? '查看结果'
                        : '下一题',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
