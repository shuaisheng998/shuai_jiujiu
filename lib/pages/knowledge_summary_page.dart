import 'package:flutter/material.dart';

class KnowledgeSummaryPage extends StatelessWidget {
  const KnowledgeSummaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('单元总结'), backgroundColor: t.colorScheme.primary, foregroundColor: Colors.white),
      body: ListView(padding: const EdgeInsets.all(14), children: [
        _unit('有理数与绝对值', const [
          '📐 公式：|a| = a(a≥0) 或 -a(a<0)',
          '💡 口诀：负数的绝对值去负号，正数不变，0 还是 0',
          '💡 加法：同号相加符号不变绝对值相加；异号取绝对值大的符号，大减小',
          '💡 减法：减去一个数 = 加上它的相反数。减负 = 加正！',
          '💡 乘法：同号得正（负负得正），异号得负',
          '💡 除法：和乘法一样，同号得正，异号得负',
          '💡 运算顺序：括号 → 乘方 → 乘除(从左到右) → 加减',
          '⚠️ 常见错误：(-3)+7≠-10（异号要取绝对值大的符号）',
          '⚠️ 常见错误：(-7)-(-3)≠-10（减负必须变加正！）',
          '⚠️ 常见错误：8÷2×4≠1（乘除必须从左到右！）',
        ]),
        _unit('一元一次方程', const [
          '📐 标准形式：ax + b = 0 (a≠0)',
          '💡 解方程三步：①移项(变号!) ②合并同类项 ③系数化为1(两边除以系数)',
          '💡 移项口诀：过桥变号——从等号一边到另一边，+变-，-变+',
          '💡 有括号的方程：能整除先除、不能整除先展开',
          '💡 两边都有 x：把所有含 x 的项移到同一边',
          '⚠️ 常见错误：移项忘变号！x-5=12→x=12-5? 错！应该是 x=12+5',
          '⚠️ 常见错误：3(x-2)=9 直接写 3x-2=9 忘了分配律！',
        ]),
        _unit('不等式', const [
          '📐 基本性质：加减同一个数，不等号方向不变',
          '📐 乘除正数，不等号方向不变；★乘除负数，不等号必须翻转！',
          '💡 为什么乘除负数要变号？5>3，但 -5<-3（大小关系反转了）',
          '💡 不等式组：画数轴，取公共部分（交叠区域）',
          '⚠️ 最容易错：-2x≤6 → x≥-3（除以-2，≤ 变 ≥！）',
          '⚠️ 方程除以负数不变号，不等式必须变号！别搞混！',
        ]),
        _unit('三角形', const [
          '📐 内角和 = 180°（所有三角形通用）',
          '📐 面积 = ½×底×高（底和高必须垂直）',
          '📐 勾股定理：a²+b²=c²（仅直角三角形，c 是斜边）',
          '💡 等腰三角形：两腰相等，两底角相等。底角=(180°-顶角)÷2',
          '💡 等边三角形：三边相等，三角相等，每角=60°',
          '💡 直角三角形两锐角互余(和为90°)',
          '💡 常见勾股数：3-4-5, 5-12-13, 6-8-10',
          '⚠️ 常见错误：求等腰三角形底角忘了÷2，把两底角之和当成了单个底角',
          '⚠️ 勾股定理只能在直角三角形中用！',
        ]),
        _unit('四边形与圆', const [
          '📐 长方形面积=长×宽，周长=2×(长+宽)',
          '📐 正方形面积=边长²，周长=4×边长',
          '📐 平行四边形：对角线互相平分；矩形对角线相等；菱形对角线垂直',
          '📐 圆周长 C=2πr=πd；圆面积 S=πr²',
          '💡 区分：周长 C=2πr，面积 S=πr². 一个是 r，一个是 r²！',
          '💡 圆的半径扩大 n 倍，面积扩大 n² 倍',
          '💡 n 边形内角和 = (n-2)×180°',
          '⚠️ 半圆周长 ≠ πr！半圆周 = πr + 2r（弧长+直径）',
        ]),
        _unit('函数', const [
          '📐 一次函数：y=kx+b，k=斜率(倾斜度)，b=y轴截距',
          '💡 k>0↗递增，k<0↘递减',
          '📐 二次函数：y=ax²+bx+c，图像是抛物线',
          '💡 对称轴 x=-b/(2a)，a>0开口向上,a<0开口向下',
          '📐 反比例：y=k/x，k>0在一三象限，k<0在二四象限',
          '📐 指数函数 y=aˣ 恒过(0,1)；对数函数 y=logₐx 恒过(1,0)',
          '💡 求定义域：分母≠0，根号内≥0，log 真数>0',
          '💡 奇函数 f(-x)=-f(x)(关于原点对称), 偶函数 f(-x)=f(x)(关于y轴对称)',
        ]),
        _unit('集合', const [
          '📐 A∪B（并集）= 两集合元素合并（去重）',
          '📐 A∩B（交集）= 两集合公共元素',
          '📐 ∁ᵤA（补集）= 全集中去掉 A',
          '💡 判断充要条件：A→B 成立=充分；B→A 成立=必要',
          '💡 空集 ∅ 是任何集合的子集',
        ]),
        _unit('数列', const [
          '📐 等差数列通项：aₙ=a₁+(n-1)d',
          '📐 等差数列求和：Sₙ=n(a₁+aₙ)/2',
          '📐 等比数列通项：aₙ=a₁qⁿ⁻¹',
          '📐 等比数列求和：Sₙ=a₁(1-qⁿ)/(1-q)（q≠1）',
          '💡 公差 d>0 递增，d<0 递减',
          '💡 公比 |q|>1 发散，0<|q|<1 收敛',
          '⚠️ 别把等比通项公式和等差搞混！等差用加，等比用乘！',
        ]),
        _unit('三角函数', const [
          '📐 sin²θ+cos²θ=1（最基础恒等式）',
          '📐 tanθ=sinθ/cosθ',
          '📐 必背特殊值：sin30°=½, sin45°=√2/2, sin60°=√3/2, sin90°=1',
          '📐 cos30°=√3/2, cos45°=√2/2, cos60°=½, cos0°=1',
          '💡 sin(180°-θ)=sinθ, cos(180°-θ)=-cosθ',
          '💡 单位圆法：sinθ=y坐标, cosθ=x坐标',
          '⚠️ sin 和 cos 的值别记反！sin30°=½, cos30°=√3/2',
        ]),
        _unit('向量、导数与解析几何', const [
          '📐 向量加法：(x₁,y₁)+(x₂,y₂)=(x₁+x₂,y₁+y₂)',
          '📐 向量模长：|a|=√(x²+y²)',
          '📐 两点距离：d=√[(x₁-x₂)²+(y₁-y₂)²]',
          '📐 点斜式：y-y₀=k(x-x₀)',
          '📐 圆方程：(x-a)²+(y-b)²=r², 圆心(a,b)',
          '📐 求导：(xⁿ)′=nxⁿ⁻¹, (sinx)′=cosx, (eˣ)′=eˣ',
          '📐 积分：∫xⁿdx=xⁿ⁺¹/(n+1)+C',
          '💡 导数=变化率=切线斜率；积分=导数的逆',
          '💡 常数求导=0！',
          '⚠️ 求导别忘减指数：x³→3x²（指数3变系数，指数变成2）',
        ]),
      ]),
    );
  }

  Widget _unit(String title, List<String> items) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ExpansionTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        initiallyExpanded: false,
        children: items.map((f) {
          final isWarn = f.startsWith('⚠️');
          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isWarn ? Colors.red.shade50 : null,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(f, style: TextStyle(fontSize: 14, height: 1.6, color: isWarn ? Colors.red.shade700 : Colors.black87)),
            ),
          );
        }).toList(),
      ),
    );
  }
}
