import 'package:flutter_test/flutter_test.dart';
import 'package:sms_retriever_plus_example/main.dart';

void main() {
  testWidgets('Example app renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('SMS Retriever Example'), findsOneWidget);
    expect(find.textContaining('App Hash:'), findsOneWidget);
    expect(find.textContaining('Status:'), findsOneWidget);
  });
}
