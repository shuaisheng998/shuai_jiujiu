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
  String _selectedLevel = 'grade7';
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
    _words = WordBank.getGrade7Words()..shuffle(Random());
    _restoreProgress();
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
      _words = _getWordsForLevel(level)..shuffle(Random());
    });
  }

  List<Word> _getWordsForLevel(String level) {
    switch (level) {
      case 'grade7': return WordBank.getGrade7Words();
      case 'grade8': return WordBank.getGrade8Words();
      case 'grade9': return WordBank.getGrade9Words();
      case 'grade10': return WordBank.getGrade10Words();
      case 'grade11': return WordBank.getGrade11Words();
      case 'grade12': return WordBank.getGrade12Words();
      default: return WordBank.getGrade7Words();
    }
  }

  Future<void> _restoreProgress() async {
    final p = await StorageService.getWordProgress();
    if (p != null && mounted) {
      final level = p['level'] as String?;
      final index = p['index'] as int?;
      if (level != null && index != null && index > 0) {
        setState(() {
          _selectedLevel = level;
          _words = _getWordsForLevel(level)..shuffle(Random());
          _currentIndex = index.clamp(0, _words.length - 1);
        });
      }
    }
  }

  Future<void> _saveProgress() async {
    await StorageService.saveWordProgress(_selectedLevel, _currentIndex);
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

  Future<void> _answerQuestion(int index) async {
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
      await StorageService.addWrongTopic(topic);
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
              _totalCount > 0 && _correctCount / _totalCount >= 0.8
                  ? '太棒了！继续加油！🌟'
                  : _totalCount > 0 && _correctCount / _totalCount >= 0.6
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
        // 年级切换
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
          child: SizedBox(
            height: 36,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: _buildGradeChips(),
            ),
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
                            color: theme.colorScheme.primary.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: theme.colorScheme.primary.withOpacity(0.2),
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
                    if (!mounted) return;
                    if (_currentIndex < _words.length - 1) {
                      setState(() {
                        _currentIndex++;
                        _showChinese = false;
                      });
                      _saveProgress();
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

  List<Widget> _buildGradeChips() {
    const grades = {
      'grade7': '初一', 'grade8': '初二', 'grade9': '初三',
      'grade10': '高一', 'grade11': '高二', 'grade12': '高三',
    };
    return grades.entries.map((e) {
      final isSelected = _selectedLevel == e.key;
      return Padding(
        padding: const EdgeInsets.only(right: 6),
        child: GestureDetector(
          onTap: () => _switchLevel(e.key),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey[200],
              borderRadius: BorderRadius.circular(18),
            ),
            child: Text(e.value, style: TextStyle(
              color: isSelected ? Colors.white : Colors.black87,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 13,
            )),
          ),
        ),
      );
    }).toList();
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
              children: _buildGradeChips(),
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
                        ? Colors.green.withOpacity(0.15)
                        : Colors.red.withOpacity(0.15);
                  }
                  if (_quizOptions[index] == word.chinese &&
                      _selectedAnswer != index) {
                    bgColor = Colors.green.withOpacity(0.15);
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
