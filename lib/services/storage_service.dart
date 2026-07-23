import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/wrong_topic.dart';

class StorageService {
  static const _checkInKey = 'check_in_dates';
  static const _wrongTopicsKey = 'wrong_topics';

  // ===== 打卡功能 =====
  static Future<List<String>> getCheckInDates() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(_checkInKey) ?? [];
    return data;
  }

  static Future<bool> checkInToday() async {
    final prefs = await SharedPreferences.getInstance();
    final dates = prefs.getStringList(_checkInKey) ?? [];
    final today = DateTime.now().toIso8601String().substring(0, 10);

    if (dates.contains(today)) {
      return false; // 今天已打卡
    }

    dates.add(today);
    await prefs.setStringList(_checkInKey, dates);
    return true;
  }

  static Future<bool> hasCheckedInToday() async {
    final dates = await getCheckInDates();
    final today = DateTime.now().toIso8601String().substring(0, 10);
    return dates.contains(today);
  }

  static Future<int> getCheckInStreak() async {
    final dates = await getCheckInDates();
    if (dates.isEmpty) return 0;

    final sorted = dates.map((d) => DateTime.parse(d)).toList()
      ..sort((a, b) => b.compareTo(a));

    int streak = 1;
    final today = DateTime.now();
    final todayStr = today.toIso8601String().substring(0, 10);
    final lastDateStr = sorted[0].toIso8601String().substring(0, 10);

    // 如果最后打卡不是今天或昨天，连续打卡中断
    final yesterday = today.subtract(const Duration(days: 1));
    final yesterdayStr = yesterday.toIso8601String().substring(0, 10);
    if (lastDateStr != todayStr && lastDateStr != yesterdayStr) {
      return 0;
    }

    for (int i = 1; i < sorted.length; i++) {
      final diff = sorted[i - 1].difference(sorted[i]).inDays;
      if (diff == 1) {
        streak++;
      } else {
        break;
      }
    }

    return streak;
  }

  static Future<int> getTotalCheckInDays() async {
    final dates = await getCheckInDates();
    return dates.length;
  }

  // ===== 单词学习进度 =====
  static Future<Set<String>> getLearnedWordIds() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList('learned_words') ?? [];
    return data.toSet();
  }

  static Future<void> markWordLearned(String word) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList('learned_words') ?? [];
    if (!data.contains(word)) {
      data.add(word);
      await prefs.setStringList('learned_words', data);
    }
  }

  // ===== 错题本 =====
  static Future<List<WrongTopic>> getWrongTopics() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(_wrongTopicsKey) ?? [];
    return data.map((e) => WrongTopic.fromJson(jsonDecode(e))).toList();
  }

  static Future<void> addWrongTopic(WrongTopic topic) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(_wrongTopicsKey) ?? [];
    data.add(jsonEncode(topic.toJson()));
    await prefs.setStringList(_wrongTopicsKey, data);
  }

  static Future<void> removeWrongTopic(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(_wrongTopicsKey) ?? [];
    data.removeWhere((e) {
      final topic = WrongTopic.fromJson(jsonDecode(e));
      return topic.id == id;
    });
    await prefs.setStringList(_wrongTopicsKey, data);
  }

  static Future<void> clearWrongTopics() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_wrongTopicsKey);
  }

  // ===== 学习统计 =====
  static Future<int> getTotalWordsLearned() async {
    final words = await getLearnedWordIds();
    return words.length;
  }

  static Future<int> getTotalQuestionsDone() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('total_questions') ?? 0;
  }

  static Future<void> incrementQuestionsDone() async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getInt('total_questions') ?? 0;
    await prefs.setInt('total_questions', current + 1);
  }
}
