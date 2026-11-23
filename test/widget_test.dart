// test/widget_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:datapack/main.dart';

void main() {
  testWidgets('MyApp builds without errors', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp(isFirstRun: false));
    expect(find.byType(MyApp), findsOneWidget);
  });
}
