import 'package:flutter_test/flutter_test.dart';
import 'package:shuai_jiujiu/main.dart';

void main() {
  testWidgets('App should display home page', (WidgetTester tester) async {
    await tester.pumpWidget(const ShuaiJiujiuApp());
    expect(find.text('帅舅舅'), findsOneWidget);
  });
}
