import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import 'word_study_page.dart';
import 'math_practice_page.dart';
import 'wrong_topic_page.dart';
import 'stats_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _checkedInToday = false;
  int _streak = 0;
  int _totalDays = 0;
  int _wordsLearned = 0;
  int _questionsDone = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final checkedIn = await StorageService.hasCheckedInToday();
    final streak = await StorageService.getCheckInStreak();
    final totalDays = await StorageService.getTotalCheckInDays();
    final wordsLearned = await StorageService.getTotalWordsLearned();
    final questionsDone = await StorageService.getTotalQuestionsDone();
    setState(() {
      _checkedInToday = checkedIn;
      _streak = streak;
      _totalDays = totalDays;
      _wordsLearned = wordsLearned;
      _questionsDone = questionsDone;
    });
  }

  Future<void> _doCheckIn() async {
    final success = await StorageService.checkInToday();
    if (success) {
      _loadData();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('✅ 打卡成功！今天也要加油哦！'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '帅舅舅',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ===== 打卡卡片 =====
          _buildCheckInCard(theme),
          const SizedBox(height: 12),

          // ===== 学习统计数据 =====
          _buildStatsRow(theme),
          const SizedBox(height: 16),

          // ===== 功能入口列表 =====
          _buildMenuItem(
            icon: Icons.menu_book_rounded,
            title: '英语单词',
            subtitle: '初中词汇 · 高中词汇',
            color: const Color(0xFF5C9CE6),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const WordStudyPage()),
            ),
          ),
          _buildMenuItem(
            icon: Icons.calculate_rounded,
            title: '数学练习',
            subtitle: '代数 · 几何 · 函数 · 数列',
            color: const Color(0xFFE6A845),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MathPracticePage()),
            ),
          ),
          _buildMenuItem(
            icon: Icons.replay_circle_filled_rounded,
            title: '错题本',
            subtitle: '复习做错的题目',
            color: const Color(0xFFE6645C),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const WrongTopicPage()),
            ),
          ),
          _buildMenuItem(
            icon: Icons.bar_chart_rounded,
            title: '学习统计',
            subtitle: '查看学习进度和成果',
            color: const Color(0xFF50C878),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const StatsPage()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckInCard(ThemeData theme) {
    return Card(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: _checkedInToday
                ? [const Color(0xFF43A047), const Color(0xFF66BB6A)]
                : [const Color(0xFFFF7043), const Color(0xFFEF5350)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _checkedInToday ? '今日已打卡 ✅' : '今日还未打卡',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '连续打卡 $_streak 天 · 累计 $_totalDays 天',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  if (!_checkedInToday)
                    ElevatedButton.icon(
                      onPressed: _doCheckIn,
                      icon: const Icon(Icons.edit_calendar, size: 20),
                      label: const Text('打卡'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFFEF5350),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                ],
              ),
              if (_streak > 0 && _streak % 7 == 0) ...[
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.whatshot, color: Colors.yellow, size: 20),
                      SizedBox(width: 4),
                      Text(
                        '太棒了！坚持到里程碑了！',
                        style: TextStyle(color: Colors.white, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsRow(ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Column(
                children: [
                  Icon(Icons.menu_book_outlined,
                      color: theme.colorScheme.primary, size: 28),
                  const SizedBox(height: 4),
                  Text(
                    '$_wordsLearned',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text('已学单词', style: TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Column(
                children: [
                  Icon(Icons.check_circle_outline,
                      color: Colors.green, size: 28),
                  const SizedBox(height: 4),
                  Text(
                    '$_questionsDone',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text('已做题目', style: TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Column(
                children: [
                  Icon(Icons.local_fire_department,
                      color: Colors.orange, size: 28),
                  const SizedBox(height: 4),
                  Text(
                    '$_streak',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text('连续打卡', style: TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
        ),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 13)),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}
