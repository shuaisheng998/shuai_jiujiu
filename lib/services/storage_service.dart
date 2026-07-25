import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/wrong_topic.dart';

class StorageService {
  static const _checkInKey = 'check_in_dates';
  static const _wrongTopicsKey = 'wrong_topics';
  static const _learnedWordsKey = 'learned_words';
  static const _totalQuestionsKey = 'total_questions';

  // 进度持久化 keys
  static const _wordProgressKey = 'word_study_progress';
  static const _mathProgressKey = 'math_practice_progress';
  static const _grammarProgressKey = 'grammar_progress';
  static const _clozeProgressKey = 'cloze_progress';
  static const _dailyWordGoalKey = 'daily_word_goal';
  static const _dailyQuestionGoalKey = 'daily_question_goal';

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
      return false;
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
    final data = prefs.getStringList(_learnedWordsKey) ?? [];
    return data.toSet();
  }

  static Future<void> markWordLearned(String word) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(_learnedWordsKey) ?? [];
    if (!data.contains(word)) {
      data.add(word);
      await prefs.setStringList(_learnedWordsKey, data);
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
    return prefs.getInt(_totalQuestionsKey) ?? 0;
  }

  static Future<void> incrementQuestionsDone() async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getInt(_totalQuestionsKey) ?? 0;
    await prefs.setInt(_totalQuestionsKey, current + 1);
  }

  // ===== 学习进度持久化 =====

  /// 保存单词学习进度
  static Future<void> saveWordProgress(String level, int index) async {
    final prefs = await SharedPreferences.getInstance();
    final data = jsonEncode({'level': level, 'index': index});
    await prefs.setString(_wordProgressKey, data);
  }

  /// 加载单词学习进度，返回 {level, index} 或 null
  static Future<Map<String, dynamic>?> getWordProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_wordProgressKey);
    if (data == null) return null;
    try {
      return jsonDecode(data) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  /// 保存数学学习进度
  static Future<void> saveMathProgress(String level, String? category, int index) async {
    final prefs = await SharedPreferences.getInstance();
    final data = jsonEncode({
      'level': level,
      'category': category,
      'index': index,
    });
    await prefs.setString(_mathProgressKey, data);
  }

  /// 加载数学学习进度
  static Future<Map<String, dynamic>?> getMathProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_mathProgressKey);
    if (data == null) return null;
    try {
      return jsonDecode(data) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  /// 保存语法学习进度
  static Future<void> saveGrammarProgress(String level, String? category, int index) async {
    final prefs = await SharedPreferences.getInstance();
    final data = jsonEncode({
      'level': level,
      'category': category,
      'index': index,
    });
    await prefs.setString(_grammarProgressKey, data);
  }

  /// 加载语法学习进度
  static Future<Map<String, dynamic>?> getGrammarProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_grammarProgressKey);
    if (data == null) return null;
    try {
      return jsonDecode(data) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  /// 保存完形填空学习进度
  static Future<void> saveClozeProgress(String level, int testIndex, int blankIndex) async {
    final prefs = await SharedPreferences.getInstance();
    final data = jsonEncode({
      'level': level,
      'testIndex': testIndex,
      'blankIndex': blankIndex,
    });
    await prefs.setString(_clozeProgressKey, data);
  }

  /// 加载完形填空学习进度
  static Future<Map<String, dynamic>?> getClozeProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_clozeProgressKey);
    if (data == null) return null;
    try {
      return jsonDecode(data) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  // ===== 每日计划目标 =====
  static Future<int> getDailyWordGoal() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_dailyWordGoalKey) ?? 20;
  }
  static Future<void> setDailyWordGoal(int goal) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_dailyWordGoalKey, goal);
  }
  static Future<int> getDailyQuestionGoal() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_dailyQuestionGoalKey) ?? 10;
  }
  static Future<void> setDailyQuestionGoal(int goal) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_dailyQuestionGoalKey, goal);
  }
}
