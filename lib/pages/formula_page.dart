import 'package:flutter/material.dart';

class FormulaPage extends StatefulWidget {
  const FormulaPage({super.key});
  @override
  State<FormulaPage> createState() => _FormulaPageState();
}

class _FormulaPageState extends State<FormulaPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('公式速查'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: '📐 数学公式'),
            Tab(text: '📖 语法规则'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildMathFormulas(theme),
          _buildGrammarRules(theme),
        ],
      ),
    );
  }

  Widget _buildMathFormulas(ThemeData theme) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _section('代数基础', [
          '|a| = a(a≥0) 或 -a(a<0) — 绝对值',
          '(a+b)² = a²+2ab+b² — 完全平方',
          '(a-b)² = a²-2ab+b² — 完全平方',
          'a²-b² = (a+b)(a-b) — 平方差',
          'x= [-b ± √(b²-4ac)] / 2a — 一元二次求根',
          'a⁰ = 1 (a≠0) — 零指数',
          'a⁻ⁿ = 1/aⁿ — 负指数',
        ]),
        _section('几何公式', [
          'S△ = ½ × 底 × 高 — 三角形面积',
          'S▭ = 长 × 宽 — 长方形面积',
          'S□ = 边长² — 正方形面积',
          'C□ = 4 × 边长 — 正方形周长',
          'C 圆 = 2πr = πd — 圆周长',
          'S 圆 = πr² — 圆面积',
          'V 长方体 = 长×宽×高',
          '直角三角形：a²+b²=c² — 勾股定理',
          'n 边形内角和 = (n-2)×180°',
          '三角形内角和 = 180°',
          '等腰三角形：两底角相等，顶角=180°-2×底角',
          '平行四边形：对边平行且相等，对角线互相平分',
          '菱形：四边相等，对角线互相垂直平分',
          '矩形：四角为90°，对角线相等',
        ]),
        _section('函数', [
          '一次函数：y = kx + b (k≠0)',
          '  k>0↗递增, k<0↘递减, b=y轴截距',
          '二次函数：y = ax²+bx+c (a≠0)',
          '  对称轴 x=-b/(2a), 顶点(-b/(2a), f(-b/(2a)))',
          '  a>0开口向上有最小值, a<0开口向下有最大值',
          '反比例函数：y = k/x (k≠0)',
          '  k>0在一三象限, k<0在二四象限',
          '指数函数：y = aˣ (a>0,a≠1) 恒过(0,1)',
          '对数函数：y = logₐx (a>0,a≠1) 恒过(1,0)',
          '  logₐN = x ↔ aˣ = N',
          '  lga = log₁₀a（常用对数）',
        ]),
        _section('三角函数', [
          'sin²θ + cos²θ = 1 — 基本恒等式',
          'tanθ = sinθ / cosθ',
          'sin(90°-θ)=cosθ, cos(90°-θ)=sinθ — 互余',
          'sin(180°-θ)=sinθ, cos(180°-θ)=-cosθ — 互补',
          'sin30°=½, sin45°=√2/2, sin60°=√3/2',
          'cos30°=√3/2, cos45°=√2/2, cos60°=½',
          'tan30°=√3/3, tan45°=1, tan60°=√3',
        ]),
        _section('数列', [
          '等差：aₙ = a₁ + (n-1)d — 通项',
          '等差求和：Sₙ = n(a₁+aₙ)/2 = na₁ + n(n-1)d/2',
          '等比：aₙ = a₁·qⁿ⁻¹ — 通项 (q≠0)',
          '等比求和：Sₙ = a₁(1-qⁿ)/(1-q) (q≠1)',
        ]),
        _section('向量与解析几何', [
          '向量模：|a| = √(x²+y²)',
          '向量加法：(x₁,y₁)+(x₂,y₂)=(x₁+x₂, y₁+y₂)',
          '两点距离：d = √[(x₁-x₂)²+(y₁-y₂)²]',
          '直线点斜式：y-y₀ = k(x-x₀)',
          '圆标准方程：(x-a)²+(y-b)² = r², 圆心(a,b)',
          '椭圆：x²/a²+y²/b²=1, 长轴=2a',
        ]),
        _section('导数与积分', [
          '(xⁿ)′ = nxⁿ⁻¹ — 幂函数求导',
          '(sinx)′ = cosx, (cosx)′ = -sinx',
          '(eˣ)′ = eˣ, (lnx)′ = 1/x',
          '常数求导 = 0',
          '∫xⁿdx = xⁿ⁺¹/(n+1) + C (n≠-1)',
          '∫sinxdx = -cosx + C, ∫cosxdx = sinx + C',
        ]),
      ],
    );
  }

  Widget _section(String title, List<String> items) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ExpansionTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        children: items.map((f) => ListTile(
          dense: true,
          title: Text(f, style: const TextStyle(fontSize: 14, height: 1.5)),
        )).toList(),
      ),
    );
  }

  Widget _buildGrammarRules(ThemeData theme) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _section('be 动词', [
          'I → am, He/She/It → is, We/You/They → are',
          '过去式：I/He/She/It → was, We/You/They → were',
          '例句：I am a student. / She is my friend. / They are happy.',
        ]),
        _section('时态速查', [
          '一般现在时：动词原形/第三人称单数+s',
          '  标志：always, usually, every day',
          '  He goes to school. / They play football.',
          '',
          '现在进行时：am/is/are + doing',
          '  标志：now, Look!, Listen!',
          '  She is reading a book.',
          '',
          '一般过去时：动词过去式',
          '  标志：yesterday, last week, ago',
          '  I went to the park yesterday.',
          '',
          '一般将来时：will + 动词原形',
          '  标志：tomorrow, next week, in the future',
          '  I will visit Beijing next year.',
          '',
          '现在完成时：have/has + done',
          '  标志：already, yet, since, for',
          '  I have finished my homework.',
        ]),
        _section('被动语态', [
          '结构：be + 过去分词 (done)',
          '一般现在被动：am/is/are + done → The book is read.',
          '一般过去被动：was/were + done → The book was read.',
          '一般将来被动：will be + done → The book will be read.',
          '现在完成被动：have/has been + done',
        ]),
        _section('情态动词', [
          'can/could — 能/可以（could 更委婉）',
          'may/might — 可能/可以（might 更不确定）',
          'must — 必须（mustn\'t=禁止）',
          'should — 应该（should have done=本应做而没做）',
          'would — 会/愿意（would like=想要）',
          'need — 需要（needn\'t=不必）',
          '用法：情态动词 + 动词原形',
        ]),
        _section('非谓语动词', [
          'doing（动名词/现在分词）',
          '  ① 作主语：Reading is important.',
          '  ② 作宾语：I enjoy reading.',
          '  ③ keep/practice/finish + doing',
          '',
          'to do（不定式）',
          '  ① 表目的：I came to see you.',
          '  ② want/hope/decide + to do',
          '',
          'done（过去分词）',
          '  ① 被动/完成含义',
          '  ② have/get sth. done 让别人做某事',
        ]),
        _section('从句', [
          '定语从句：',
          '  who/that 指人：The girl who is singing is my sister.',
          '  which/that 指物：The book which I read is good.',
          '  whose 表所属：The boy whose bag is red.',
          '',
          '宾语从句：',
          '  陈述句：I think (that) he is right.',
          '  疑问句：I don\'t know what he wants.',
          '',
          '状语从句：',
          '  时间：when/while/as soon as',
          '  原因：because/since/as',
          '  条件：if/unless（主将从现！）',
          '  让步：although/though（不与 but 连用！）',
          '  结果：so...that... / such...that...',
        ]),
        _section('常用句型', [
          'It is + adj. + for sb. to do — 对某人来说做某事是...的',
          '  It is important for us to study hard.',
          'There be + 名词 + 地点 — 某地有某物',
          '  There is a book on the desk.',
          'the + 比较级, the + 比较级 — 越...越...',
          '  The more you read, the wiser you become.',
          'not only...but also... — 不仅...而且...',
          '  He not only sings but also dances.',
          'neither...nor... — 既不...也不...',
          '  Neither he nor I am right.（就近原则）',
        ]),
      ],
    );
  }
}
