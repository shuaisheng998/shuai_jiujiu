import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../models/wrong_topic.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  int _totalDays = 0;
  int _streak = 0;
  int _wordsLearned = 0;
  int _questionsDone = 0;
  int _wrongCount = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final totalDays = await StorageService.getTotalCheckInDays();
    final streak = await StorageService.getCheckInStreak();
    final wordsLearned = await StorageService.getTotalWordsLearned();
    final questionsDone = await StorageService.getTotalQuestionsDone();
    final wrongTopics = await StorageService.getWrongTopics();

    setState(() {
      _totalDays = totalDays;
      _streak = streak;
      _wordsLearned = wordsLearned;
      _questionsDone = questionsDone;
      _wrongCount = wrongTopics.length;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('学习统计'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadStats,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // 总览卡片
                  _buildOverviewCard(theme),
                  const SizedBox(height: 16),

                  // 统计数据网格
                  _buildStatsGrid(theme),
                  const SizedBox(height: 16),

                  // 打卡日历
                  _buildCheckInCalendar(theme),

                  const SizedBox(height: 16),

                  // 鼓励语
                  _buildEncouragement(theme),
                ],
              ),
            ),
    );
  }

  Widget _buildOverviewCard(ThemeData theme) {
    return Card(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.primary,
              theme.colorScheme.primary.withOpacity(0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            const Icon(Icons.emoji_events, size: 48, color: Colors.amber),
            const SizedBox(height: 12),
            Text(
              '累计学习 $_totalDays 天',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '连续打卡 $_streak 天',
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsGrid(ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  Icon(Icons.menu_book_rounded,
                      color: theme.colorScheme.primary, size: 32),
                  const SizedBox(height: 8),
                  Text(
                    '$_wordsLearned',
                    style: const TextStyle(
                        fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const Text('已学单词',
                      style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  Icon(Icons.check_circle_outline,
                      color: Colors.green, size: 32),
                  const SizedBox(height: 8),
                  Text(
                    '$_questionsDone',
                    style: const TextStyle(
                        fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const Text('已做题目',
                      style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  Icon(Icons.error_outline,
                      color: _wrongCount > 0 ? Colors.red : Colors.green,
                      size: 32),
                  const SizedBox(height: 8),
                  Text(
                    '$_wrongCount',
                    style: const TextStyle(
                        fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const Text('错题数', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCheckInCalendar(ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '打卡记录',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              '点亮每一天 🔥',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            // 显示最近30天的打卡情况
            _buildCalendarGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarGrid() {
    return FutureBuilder<List<String>>(
      future: StorageService.getCheckInDates(),
      builder: (_, snapshot) {
        if (!snapshot.hasData) return const SizedBox();
        final checkInDates = snapshot.data!;

        final now = DateTime.now();
        final days = <Widget>[];

        // 显示最近30天
        for (int i = 29; i >= 0; i--) {
          final date = now.subtract(Duration(days: i));
          final dateStr = date.toIso8601String().substring(0, 10);
          final checked = checkInDates.contains(dateStr);
          final isToday = i == 0;

          days.add(
            Container(
              width: 30,
              height: 30,
              margin: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: checked
                    ? const Color(0xFF4CAF50)
                    : (isToday
                        ? Colors.orange.withOpacity(0.3)
                        : Colors.grey[200]),
                borderRadius: BorderRadius.circular(6),
                border: isToday && !checked
                    ? Border.all(color: Colors.orange, width: 2)
                    : null,
              ),
              child: Center(
                child: Text(
                  '${date.day}',
                  style: TextStyle(
                    fontSize: 11,
                    color: checked
                        ? Colors.white
                        : (isToday ? Colors.orange : Colors.grey[600]),
                    fontWeight:
                        checked || isToday ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        }

        return Wrap(children: days);
      },
    );
  }

  Widget _buildEncouragement(ThemeData theme) {
    String message;
    IconData icon;
    Color color;

    if (_streak >= 30) {
      message = '🌟 天哪！连续打卡 $_streak 天，你简直就是学习超人！';
      icon = Icons.auto_awesome;
      color = Colors.amber;
    } else if (_streak >= 14) {
      message = '🔥 连续打卡 $_streak 天，毅力惊人！坚持下去！';
      icon = Icons.whatshot;
      color = Colors.orange;
    } else if (_streak >= 7) {
      message = '💪 坚持一周了！你已经养成了学习的好习惯！';
      icon = Icons.trending_up;
      color = Colors.green;
    } else if (_streak >= 3) {
      message = '👏 连续 $_streak 天，好的开始！继续加油！';
      icon = Icons.thumb_up;
      color = Colors.blue;
    } else if (_totalDays > 0) {
      message = '🚀 学习是日积月累的过程，每天进步一点点！';
      icon = Icons.menu_book;
      color = theme.colorScheme.primary;
    } else {
      message = '📚 开始学习吧！每一小步都是进步！';
      icon = Icons.lightbulb_outline;
      color = Colors.grey;
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Icon(icon, color: color, size: 36),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(fontSize: 15, height: 1.4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
