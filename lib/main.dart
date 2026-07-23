import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/word_study_page.dart';
import 'pages/math_practice_page.dart';
import 'pages/wrong_topic_page.dart';
import 'pages/stats_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ShuaiJiujiuApp());
}

class ShuaiJiujiuApp extends StatelessWidget {
  const ShuaiJiujiuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '帅舅舅',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4A90D9),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        fontFamily: null, // 使用系统默认字体
      ),
      home: const HomePage(),
    );
  }
}
