import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class StudyPlanPage extends StatefulWidget {
  const StudyPlanPage({super.key});
  @override
  State<StudyPlanPage> createState() => _StudyPlanPageState();
}

class _StudyPlanPageState extends State<StudyPlanPage> {
  int _wordGoal = 20;
  int _questionGoal = 10;
  int _wordsDone = 0;
  int _questionsDone = 0;
  bool _isLoading = true;

  @override
  void initState() { super.initState(); _loadData(); }

  Future<void> _loadData() async {
    final wordGoal = await StorageService.getDailyWordGoal();
    final questionGoal = await StorageService.getDailyQuestionGoal();
    final wordsDone = await StorageService.getTotalWordsLearned();
    final questionsDone = await StorageService.getTotalQuestionsDone();
    if (!mounted) return;
    setState(() {
      _wordGoal = wordGoal; _questionGoal = questionGoal;
      _wordsDone = wordsDone; _questionsDone = questionsDone;
      _isLoading = false;
    });
  }

  Future<void> _saveWordGoal(int goal) async {
    await StorageService.setDailyWordGoal(goal);
    setState(() => _wordGoal = goal);
  }
  Future<void> _saveQuestionGoal(int goal) async {
    await StorageService.setDailyQuestionGoal(goal);
    setState(() => _questionGoal = goal);
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    if (_isLoading) return Scaffold(appBar: AppBar(title: const Text('每日计划'), backgroundColor: t.colorScheme.primary, foregroundColor: Colors.white), body: const Center(child: CircularProgressIndicator()));

    final wP = _wordGoal > 0 ? (_wordsDone / _wordGoal).clamp(0.0, 1.0) : 0.0;
    final qP = _questionGoal > 0 ? (_questionsDone / _questionGoal).clamp(0.0, 1.0) : 0.0;
    final tP = (_wordGoal + _questionGoal > 0) ? (_wordsDone + _questionsDone) / (_wordGoal + _questionGoal) : 0.0;
    String msg; IconData icon; Color color;
    if (tP >= 1.0) { msg = '🎉 今日目标全部完成！太棒了！'; icon = Icons.emoji_events; color = Colors.amber; }
    else if (tP >= 0.6) { msg = '💪 快完成了，再加把劲！'; icon = Icons.trending_up; color = Colors.green; }
    else if (tP > 0) { msg = '🚀 好的开始，继续加油！'; icon = Icons.play_circle; color = Colors.blue; }
    else { msg = '📋 设定今日目标，开始学习吧！'; icon = Icons.edit_calendar; color = Colors.grey; }

    return Scaffold(
      appBar: AppBar(title: const Text('每日计划'), backgroundColor: t.colorScheme.primary, foregroundColor: Colors.white),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(children: [
          _goalRow('📖 每日背单词目标', _wordGoal, (v) => _saveWordGoal(v)),
          const SizedBox(height: 12),
          _goalRow('✍️ 每日做题目标', _questionGoal, (v) => _saveQuestionGoal(v)),
        ]))),
        const SizedBox(height: 14),
        Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(children: [
          const Text('今日进度', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 14),
          _progressRow('背单词', _wordsDone, _wordGoal, wP, t.colorScheme.primary),
          const SizedBox(height: 10),
          _progressRow('做题目', _questionsDone, _questionGoal, qP, Colors.green),
          const SizedBox(height: 14),
          ClipRRect(borderRadius: BorderRadius.circular(6), child: LinearProgressIndicator(value: tP, minHeight: 12, backgroundColor: Colors.grey[200], color: tP >= 1 ? Colors.amber : t.colorScheme.primary)),
          const SizedBox(height: 8),
          Text('${(_wordsDone + _questionsDone)} / ${_wordGoal + _questionGoal} 总进度', style: const TextStyle(color: Colors.grey, fontSize: 13)),
        ]))),
        const SizedBox(height: 14),
        Card(child: Padding(padding: const EdgeInsets.all(20), child: Row(children: [
          Icon(icon, color: color, size: 36), const SizedBox(width: 16),
          Expanded(child: Text(msg, style: const TextStyle(fontSize: 15, height: 1.4))),
        ]))),
      ]),
    );
  }

  Widget _goalRow(String label, int current, Function(int) onSave) {
    final ctrl = TextEditingController(text: current.toString());
    return Row(children: [
      Expanded(child: Text(label, style: const TextStyle(fontSize: 15))),
      SizedBox(width: 60, child: TextField(controller: ctrl, keyboardType: TextInputType.number, textAlign: TextAlign.center, decoration: const InputDecoration(border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 10), isDense: true), onSubmitted: (v) {
        final n = int.tryParse(v); if (n != null && n > 0) onSave(n);
      })),
      const Text(' 个/天', style: TextStyle(color: Colors.grey, fontSize: 13)),
    ]);
  }

  Widget _progressRow(String label, int done, int goal, double pct, Color color) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label, style: const TextStyle(fontSize: 14)),
        Text('$done / $goal', style: TextStyle(fontSize: 13, color: pct >= 1 ? Colors.green : Colors.grey)),
      ]),
      const SizedBox(height: 4),
      ClipRRect(borderRadius: BorderRadius.circular(4), child: LinearProgressIndicator(value: pct, minHeight: 8, backgroundColor: Colors.grey[200], color: color)),
    ]);
  }
}
