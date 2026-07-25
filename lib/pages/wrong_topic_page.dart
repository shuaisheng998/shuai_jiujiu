import 'package:flutter/material.dart';
import '../models/wrong_topic.dart';
import '../services/storage_service.dart';

class WrongTopicPage extends StatefulWidget {
  const WrongTopicPage({super.key});
  @override
  State<WrongTopicPage> createState() => _WrongTopicPageState();
}

class _WrongTopicPageState extends State<WrongTopicPage> {
  List<WrongTopic> _topics = [];
  bool _isLoading = true;
  String _filter = 'all';

  // 练习模式
  bool _isPracticeMode = false;
  int _practiceIndex = 0;
  int _practiceCorrect = 0;
  int _practiceDone = 0;

  @override
  void initState() { super.initState(); _loadTopics(); }

  Future<void> _loadTopics() async {
    final topics = await StorageService.getWrongTopics();
    if (!mounted) return;
    setState(() { _topics = topics; _isLoading = false; });
  }

  List<WrongTopic> get _filteredTopics {
    if (_filter == 'all') return _topics;
    return _topics.where((t) => t.type == _filter).toList();
  }

  List<WrongTopic> get _practiceTopics => _filteredTopics;

  Future<void> _removeTopic(String id) async {
    await StorageService.removeWrongTopic(id);
    await _loadTopics();
  }

  void _startPractice() {
    if (_practiceTopics.isEmpty) return;
    setState(() {
      _isPracticeMode = true;
      _practiceIndex = 0;
      _practiceCorrect = 0;
      _practiceDone = 0;
    });
  }

  void _answerPractice(bool understood) {
    if (_practiceIndex >= _practiceTopics.length) return;
    final topic = _practiceTopics[_practiceIndex];
    setState(() {
      _practiceDone++;
      if (understood) _practiceCorrect++;
    });
    if (understood) {
      _removeTopic(topic.id);
    }
    if (_practiceIndex + 1 < _practiceTopics.length) {
      setState(() => _practiceIndex++);
    } else {
      _showPracticeResult();
    }
  }

  void _showPracticeResult() {
    showDialog(context: context, barrierDismissible: false, builder: (_) => AlertDialog(
      title: const Text('练习完成！'),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        const Icon(Icons.emoji_events, size: 56, color: Colors.amber),
        const SizedBox(height: 10),
        Text('$_practiceCorrect / $_practiceDone', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Text(_practiceDone > 0 && _practiceCorrect / _practiceDone >= 0.8 ? '太棒了！继续加油！🌟' : _practiceDone > 0 && _practiceCorrect / _practiceDone >= 0.5 ? '再练练会更好！💪' : '别灰心，再来一次！📚', style: const TextStyle(fontSize: 15, color: Colors.grey)),
      ]),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('返回')),
        TextButton(onPressed: () { Navigator.pop(context); _loadTopics(); setState(() { _isPracticeMode = false; }); }, child: const Text('完成')),
      ],
    ));
  }

  Future<void> _clearAll() async {
    final confirmed = await showDialog<bool>(context: context, builder: (_) => AlertDialog(
      title: const Text('清空错题本'), content: const Text('确定要清空所有错题吗？'), actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('取消')),
        TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('确定', style: TextStyle(color: Colors.red))),
      ],
    ));
    if (confirmed == true) { await StorageService.clearWrongTopics(); await _loadTopics(); }
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    if (_isLoading) return Scaffold(appBar: AppBar(title: const Text('错题本'), backgroundColor: t.colorScheme.primary, foregroundColor: Colors.white), body: const Center(child: CircularProgressIndicator()));

    if (_isPracticeMode) return _buildPracticeMode(t);

    return Scaffold(
      appBar: AppBar(title: const Text('错题本'), backgroundColor: t.colorScheme.primary, foregroundColor: Colors.white, actions: [
        if (_topics.isNotEmpty) IconButton(onPressed: _clearAll, icon: const Icon(Icons.delete_sweep), tooltip: '清空全部'),
      ]),
      body: Column(children: [
        if (_topics.isNotEmpty)
          Padding(padding: const EdgeInsets.fromLTRB(12, 10, 12, 0), child: SizedBox(width: double.infinity, child: ElevatedButton.icon(
            onPressed: _startPractice, icon: const Icon(Icons.replay_circle_filled), label: Text('练习全部错题 (${_filteredTopics.length}道)'),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE6645C), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12)),
          ))),
        Padding(padding: const EdgeInsets.all(10), child: SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: [
          _chip('all', '全部(${_topics.length})'),
          _chip('word', '单词(${_topics.where((t)=>t.type=='word').length})'),
          _chip('grammar', '语法(${_topics.where((t)=>t.type=='grammar').length})'),
          _chip('cloze', '完形(${_topics.where((t)=>t.type=='cloze').length})'),
          _chip('math', '数学(${_topics.where((t)=>t.type=='math').length})'),
        ]))),
        Expanded(child: _filteredTopics.isEmpty ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.check_circle_outline, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          const Text('暂无错题，继续保持！🎉', style: TextStyle(fontSize: 18, color: Colors.grey)),
        ])) : ListView.builder(padding: const EdgeInsets.symmetric(horizontal: 12), itemCount: _filteredTopics.length, itemBuilder: (_, i) => _card(_filteredTopics[i]))),
      ]),
    );
  }

  Widget _buildPracticeMode(ThemeData t) {
    final topic = _practiceTopics[_practiceIndex];
    return Scaffold(
      appBar: AppBar(title: Text('错题练习 ${_practiceIndex + 1}/${_practiceTopics.length}'), backgroundColor: t.colorScheme.primary, foregroundColor: Colors.white),
      body: SingleChildScrollView(padding: const EdgeInsets.all(20), child: Column(children: [
        Row(children: [
          Expanded(child: Text('${_practiceIndex + 1} / ${_practiceTopics.length}', style: const TextStyle(fontSize: 14, color: Colors.grey))),
          Text('✅ $_practiceCorrect', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
        ]),
        const SizedBox(height: 6),
        LinearProgressIndicator(value: (_practiceIndex + 1) / _practiceTopics.length, minHeight: 6, borderRadius: BorderRadius.circular(3)),
        const SizedBox(height: 16),
        Card(child: Container(width: double.infinity, padding: const EdgeInsets.all(16), child: Text(topic.content, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500, height: 1.6)))),
        const SizedBox(height: 12),
        Container(width: double.infinity, padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.red.shade200)), child: Row(children: [
          const Text('❌ 你的答案: ', style: TextStyle(fontSize: 14, color: Colors.red)),
          Expanded(child: Text(topic.userAnswer, style: const TextStyle(fontSize: 14, color: Colors.red, decoration: TextDecoration.lineThrough))),
        ])),
        const SizedBox(height: 8),
        Container(width: double.infinity, padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.green.shade200)), child: Row(children: [
          const Text('✅ 正确答案: ', style: TextStyle(fontSize: 14, color: Colors.green)),
          Expanded(child: Text(topic.correctAnswer, style: const TextStyle(fontSize: 14, color: Colors.green, fontWeight: FontWeight.bold))),
        ])),
        const SizedBox(height: 20),
        const Text('现在你理解了吗？', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
        const SizedBox(height: 14),
        Row(children: [
          Expanded(child: ElevatedButton.icon(onPressed: () => _answerPractice(true), icon: const Icon(Icons.check), label: const Text('我懂了'), style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14)))),
          const SizedBox(width: 12),
          Expanded(child: OutlinedButton.icon(onPressed: () => _answerPractice(false), icon: const Icon(Icons.refresh), label: const Text('再练一次'), style: OutlinedButton.styleFrom(foregroundColor: Colors.orange, padding: const EdgeInsets.symmetric(vertical: 14)))),
        ]),
      ])),
    );
  }

  Widget _chip(String f, String label) {
    final sel = _filter == f;
    return GestureDetector(onTap: () => setState(() => _filter = f), child: Container(
      margin: const EdgeInsets.only(right: 6), padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 6),
      decoration: BoxDecoration(color: sel ? Theme.of(context).colorScheme.primary : Colors.grey[200], borderRadius: BorderRadius.circular(18)),
      child: Text(label, style: TextStyle(color: sel ? Colors.white : Colors.black87, fontWeight: sel ? FontWeight.bold : FontWeight.normal, fontSize: 12))));
  }

  Widget _card(WrongTopic t) {
    final (icon, color, label) = switch (t.type) {
      'word' => (Icons.menu_book, const Color(0xFF5C9CE6), '单词'),
      'grammar' => (Icons.text_snippet, const Color(0xFF7C4DFF), '语法'),
      'cloze' => (Icons.article, const Color(0xFF9C27B0), '完形'),
      _ => (Icons.calculate, const Color(0xFFE6A845), '数学'),
    };
    return Card(margin: const EdgeInsets.only(bottom: 10), child: Padding(padding: const EdgeInsets.all(14), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Icon(icon, color: color, size: 20), const SizedBox(width: 6),
        Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(4)), child: Text(label, style: TextStyle(fontSize: 12, color: color))),
        const Spacer(), Text('${t.wrongDate.month}/${t.wrongDate.day}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(width: 8), GestureDetector(onTap: () => _removeTopic(t.id), child: const Icon(Icons.close, size: 18, color: Colors.grey)),
      ]),
      const SizedBox(height: 8),
      Text(t.content, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
      const SizedBox(height: 6),
      Text('你的答案: ${t.userAnswer}', style: const TextStyle(fontSize: 13, color: Colors.red, decoration: TextDecoration.lineThrough)),
      Text('正确答案: ${t.correctAnswer}', style: const TextStyle(fontSize: 13, color: Colors.green, fontWeight: FontWeight.bold)),
    ])));
  }
}
