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
  String _filter = 'all'; // 'all', 'word', 'grammar', 'cloze', 'math'

  @override
  void initState() {
    super.initState();
    _loadTopics();
  }

  Future<void> _loadTopics() async {
    final topics = await StorageService.getWrongTopics();
    setState(() {
      _topics = topics;
      _isLoading = false;
    });
  }

  List<WrongTopic> get _filteredTopics {
    if (_filter == 'all') return _topics;
    return _topics.where((t) => t.type == _filter).toList();
  }

  Future<void> _removeTopic(String id) async {
    await StorageService.removeWrongTopic(id);
    _loadTopics();
  }

  Future<void> _clearAll() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('清空错题本'),
        content: const Text('确定要清空所有错题吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('确定', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await StorageService.clearWrongTopics();
      _loadTopics();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('错题本'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          if (_topics.isNotEmpty)
            IconButton(
              onPressed: _clearAll,
              icon: const Icon(Icons.delete_sweep),
              tooltip: '清空全部',
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // 分类筛选
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      _buildFilterChip('all', '全部 (${_topics.length})'),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                        'word',
                        '单词 (${_topics.where((t) => t.type == 'word').length})',
                      ),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                        'grammar',
                        '语法 (${_topics.where((t) => t.type == 'grammar').length})',
                      ),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                        'cloze',
                        '完形 (${_topics.where((t) => t.type == 'cloze').length})',
                      ),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                        'math',
                        '数学 (${_topics.where((t) => t.type == 'math').length})',
                      ),
                    ],
                  ),
                ),
                // 错题列表
                Expanded(
                  child: _filteredTopics.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.check_circle_outline,
                                  size: 80, color: Colors.grey[400]),
                              const SizedBox(height: 16),
                              const Text(
                                '暂无错题，继续保持！🎉',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.grey),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          itemCount: _filteredTopics.length,
                          itemBuilder: (_, index) {
                            final topic = _filteredTopics[index];
                            return _buildTopicCard(topic);
                          },
                        ),
                ),
              ],
            ),
    );
  }

  Widget _buildFilterChip(String filter, String label) {
    final isSelected = _filter == filter;
    return GestureDetector(
      onTap: () => setState(() => _filter = filter),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
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

  Widget _buildTopicCard(WrongTopic topic) {
    IconData typeIcon;
    Color typeColor;
    String typeLabel;

    switch (topic.type) {
      case 'word':
        typeIcon = Icons.menu_book;
        typeColor = const Color(0xFF5C9CE6);
        typeLabel = '单词';
        break;
      case 'grammar':
        typeIcon = Icons.text_snippet;
        typeColor = const Color(0xFF7C4DFF);
        typeLabel = '语法';
        break;
      case 'cloze':
        typeIcon = Icons.article;
        typeColor = const Color(0xFF9C27B0);
        typeLabel = '完形';
        break;
      default: // 'math'
        typeIcon = Icons.calculate;
        typeColor = const Color(0xFFE6A845);
        typeLabel = '数学';
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(typeIcon, color: typeColor, size: 20),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: typeColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    typeLabel,
                    style: TextStyle(fontSize: 12, color: typeColor),
                  ),
                ),
                const Spacer(),
                Text(
                  '${topic.wrongDate.month}/${topic.wrongDate.day}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => _removeTopic(topic.id),
                  child: const Icon(Icons.close, size: 18, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              topic.content,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Text('你的答案: ',
                    style: TextStyle(fontSize: 13, color: Colors.red)),
                Text(
                  topic.userAnswer,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.red,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Text('正确答案: ',
                    style: TextStyle(fontSize: 13, color: Colors.green)),
                Text(
                  topic.correctAnswer,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
