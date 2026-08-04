import 'package:flutter_test/flutter_test.dart';

import 'package:carry_you_user/main.dart';

void main() {
  testWidgets('App builds smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump(const Duration(seconds: 3));
    await tester.pump();

    expect(find.byType(MyApp), findsOneWidget);
  });
}
