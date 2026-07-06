import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_rendering_demo/main.dart';

void main() {
  testWidgets('App should show home page', (WidgetTester tester) async {
    await tester.pumpWidget(const RenderingDemoApp());
    expect(find.text('Flutter 渲染机制演示'), findsOneWidget);
  });
}
