import 'package:flutter/material.dart';

class WritingGuidePage extends StatefulWidget {
  const WritingGuidePage({super.key});
  @override
  State<WritingGuidePage> createState() => _WritingGuidePageState();
}

class _WritingGuidePageState extends State<WritingGuidePage> with SingleTickerProviderStateMixin {
  late TabController _tab;

  @override
  void initState() { super.initState(); _tab = TabController(length: 4, vsync: this); }
  @override
  void dispose() { _tab.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('作文引导'), backgroundColor: t.colorScheme.primary, foregroundColor: Colors.white,
        bottom: TabBar(controller: _tab, labelColor: Colors.white, unselectedLabelColor: Colors.white60, indicatorColor: Colors.white,
          tabs: const [Tab(text: '🔍 审题'), Tab(text: '📝 结构'), Tab(text: '🔗 衔接'), Tab(text: '📋 题型')])),
      body: TabBarView(controller: _tab, children: [_build1(t), _build2(t), _build3(t), _build4(t)]),
    );
  }

  Widget _s(String title, List<String> items) => Card(margin: const EdgeInsets.fromLTRB(12,8,12,0),
    child: ExpansionTile(title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      children: items.map((f) => Padding(padding: const EdgeInsets.fromLTRB(16,0,16,14), child: Text(f, style: const TextStyle(fontSize: 14, height: 1.6)))).toList()));

  Widget _build1(ThemeData t) => ListView(padding: const EdgeInsets.all(12), children: [
    Text('拿到作文题不要马上动笔，先用 3 分钟审题', style: TextStyle(fontSize: 15, color: t.colorScheme.primary, fontWeight: FontWeight.bold)),
    const SizedBox(height: 8),
    _s('第一步：圈关键词', [
      '读了题目后，拿笔画下最重要的 2-3 个词',
      '例：题目 "My Favorite Teacher"',
      '  关键词：My（不是别人的）、Favorite（最爱的，不是随便的）、Teacher（老师，不是朋友）',
      '  你写的内容必须同时满足这三个词！',
    ]),
    _s('第二步：确定文体', [
      '题目里通常藏着文体提示：',
      '• 有 "should" → 议论文（要论证观点）',
      '• 有 "tell a story" / "an experience" → 记叙文（讲故事）',
      '• 有 "a letter to" → 书信格式',
      '• 有 "introduce" / "describe" → 说明文',
      '• 最简单的判断：题目要你"表达看法"还是"讲故事"？',
    ]),
    _s('第三步：列提纲（只需要 30 秒）', [
      '拿笔快速写 3 行：',
      '① 开头怎么引入？',
      '② 中间写哪 2-3 个点？',
      '③ 结尾怎么收？',
      '例："My Favorite Teacher" 提纲：',
      '  开头：我最喜欢的老师是李老师，教英语',
      '  中间1：她上课很有趣（举例）',
      '  中间2：她关心学生（举例）',
      '  结尾：她改变了我对英语的看法',
      '有了提纲再写正文，就不会跑题了！',
    ]),
  ]);

  Widget _build2(ThemeData t) => ListView(padding: const EdgeInsets.all(12), children: [
    Text('英语作文标准三段式', style: TextStyle(fontSize: 15, color: t.colorScheme.primary, fontWeight: FontWeight.bold)),
    const SizedBox(height: 8),
    _s('第一段：开头（2-3 句）', [
      '目的：让读者知道你要写什么',
      '方法（选一种，不要全用）：',
      '① 直接引入：直接说出主题',
      '  例：My favorite teacher is Mr. Li, who teaches us English.',
      '② 提问引入：用一个问题开头',
      '  例：Have you ever met someone who changed your life?',
      '③ 背景引入：先给一点背景',
      '  例：During my school years, I have met many great teachers.',
      '⚠️ 不要写太长，2-3 句就够。读者想看的是中间的内容。',
    ]),
    _s('第二段：中间段落（5-8 句）', [
      '目的：这是作文的核心！展开你的观点或故事',
      '结构：每段 = 一个观点 + 一个例子',
      '方法：',
      '① 先给观点句（topic sentence）',
      '  例：First, Mr. Li makes his classes very interesting.',
      '② 再给具体例子（supporting detail）',
      '  例：For example, he often uses games and songs to teach us new words.',
      '③ 可以加自己的感受',
      '  例：As a result, I always look forward to his class.',
      '⚠️ 不要只写空洞的话！每个观点必须配例子！',
      '如果写两个观点：用 First, ... Second, ... 或 On one hand, ... On the other hand, ...',
    ]),
    _s('第三段：结尾（2-3 句）', [
      '目的：总结全文，给读者留下印象',
      '方法（选一种）：',
      '① 总结观点：In conclusion, Mr. Li is not just a teacher but also a friend.',
      '② 展望未来：I believe I will never forget him in the future.',
      '③ 呼应开头：This is why Mr. Li is my favorite teacher.',
      '⚠️ 不要在结尾引入新观点！结尾只做总结。',
    ]),
    const SizedBox(height: 12),
    Card(margin: EdgeInsets.zero, color: Colors.amber.shade50, child: const Padding(padding: EdgeInsets.all(14), child: Text('💡 记住这个黄金结构：\n开头（引入）→ 中间1（观点+例子）→ 中间2（观点+例子）→ 结尾（总结）\n只要按这个框架，作文就不会乱！', style: TextStyle(fontSize: 14, height: 1.6)))),
  ]);

  Widget _build3(ThemeData t) => ListView(padding: const EdgeInsets.all(12), children: [
    Text('衔接词让作文更流畅，但不要滥用', style: TextStyle(fontSize: 15, color: t.colorScheme.primary, fontWeight: FontWeight.bold)),
    const SizedBox(height: 8),
    _s('表顺序（列举观点用）', [
      'First / Firstly — 首先（最常用）',
      'Second / Secondly — 其次',
      'Finally / Lastly — 最后',
      'First of all — 首先（稍正式）',
      'Last but not least — 最后但同样重要的',
      '⚠️ 不要写 "At first"！它的意思是"起初"，不是"首先"！',
    ]),
    _s('表转折（换观点用）', [
      'However — 然而（最常用，放句首加逗号）',
      'But — 但是（不能放句首，要连句子）',
      'On the other hand — 另一方面',
      'Nevertheless — 尽管如此（较高级）',
      'Although / Though — 虽然（不能和 but 连用！）',
      '例：Although he is strict, I like him.（不能写 Although...but...）',
    ]),
    _s('表因果（解释原因/结果用）', [
      'Because / Since / As — 因为',
      'Therefore / Thus — 因此（放句首）',
      'As a result — 结果（最常用）',
      'So — 所以（不能放句首）',
      'Due to / Because of + 名词 — 由于...',
      '例：Due to his help, I improved a lot.',
    ]),
    _s('表补充/递进（加论点用）', [
      'Moreover / Furthermore — 此外（更正式）',
      'Besides — 此外（口语化）',
      'In addition — 另外',
      'What\'s more — 更重要的是',
      'Not only...but also... — 不仅...而且...',
    ]),
    _s('表举例（给例子用）', [
      'For example / For instance — 例如',
      'Such as + 名词 — 比如...',
      'Like — 像...（口语化）',
      'Take ... as an example — 以...为例',
    ]),
    _s('表总结（结尾用）', [
      'In conclusion — 总之（最正式）',
      'To sum up — 总结一下',
      'In short / In a word — 简而言之',
      'All in all — 总的来说',
    ]),
  ]);

  Widget _build4(ThemeData t) => ListView(padding: const EdgeInsets.all(12), children: [
    Text('不同题型的写法重点', style: TextStyle(fontSize: 15, color: t.colorScheme.primary, fontWeight: FontWeight.bold)),
    const SizedBox(height: 8),
    _s('📣 议论文（表达观点）', [
      '常见题目：Should students use phones? / Is homework necessary?',
      '结构要点：',
      '① 开头：明确你的观点（赞成还是反对）',
      '② 中间1：你的第一个理由 + 例子',
      '③ 中间2：你的第二个理由 + 例子',
      '④ 可以写一小段"对方观点"然后反驳（加分项）',
      '⑤ 结尾：重申观点，提出建议',
      '⚠️ 议论文最怕"两边都说"——你要选一边站！',
    ]),
    _s('✉️ 书信/邮件', [
      '常见题目：Write a letter to your friend / Write an email to...',
      '格式要点：',
      '① 开头称呼：Dear [名字],（注意逗号！）',
      '② 第一句：问候 +说明写信目的',
      '  例：How are you? I\'m writing to tell you about...',
      '③ 正文：按正常段落写',
      '④ 结尾：I\'m looking forward to your reply.',
      '⑤ 签名：Yours, / Best wishes, + 你的名字',
      '⚠️ 书信格式扣分很严重，一定要记住称呼和签名！',
    ]),
    _s('📖 记叙文（讲故事）', [
      '常见题目：An unforgettable experience / A special day',
      '结构要点：',
      '① 开头：时间+地点+人物（一句话交代背景）',
      '  例：Last summer, I went to Beijing with my parents.',
      '② 中间：按时间顺序讲发生了什么',
      '  用 First, Then, After that, Finally 串联',
      '③ 高潮：最精彩/最重要的部分多写两句',
      '④ 结尾：你的感受或学到了什么',
      '  例：From this experience, I learned that...',
      '⚠️ 记叙文必须用过去时！从头到尾！',
    ]),
    _s('📝 说明文/介绍', [
      '常见题目：Introduce your school / How to learn English well',
      '结构要点：',
      '① 开头：简单介绍你要说明的东西',
      '② 中间：分点介绍（用 First, Second, Finally）',
      '③ 如果是"how to"类：按步骤写',  
      '④ 结尾：总结或鼓励',
      '⚠️ 说明文不要加太多个人感受，重在讲清楚',
    ]),
    const SizedBox(height: 12),
    Card(margin: EdgeInsets.zero, color: Colors.blue.shade50, child: const Padding(padding: EdgeInsets.all(14), child: Text('📌 参考范文（这是一篇例文，请用自己的经历和话语来写）\n\n题目：My Favorite Teacher (80-100 words)\n\nMy favorite teacher is Ms. Wang, our English teacher. She is kind and patient.\n\nFirst, she makes her classes interesting. For example, she often uses games to teach us new words. As a result, I always listen carefully.\n\nSecond, she cares about every student. Once I failed an exam and felt very sad. She talked to me and said, "Don\'t give up." Her words gave me confidence.\n\nIn conclusion, Ms. Wang is not just a teacher. She is also a friend who changed my attitude toward English.', style: TextStyle(fontSize: 14, height: 1.7, fontStyle: FontStyle.italic)))),
  ]);
}
