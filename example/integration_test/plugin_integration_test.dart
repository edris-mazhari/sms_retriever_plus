import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:sms_retriever_plus/sms_retriever_plus.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('getSignature returns non-empty string', (WidgetTester tester) async {
    SmsRetrieverPlus.initialize();
    final hash = await SmsRetrieverPlus.getSignature();
    expect(hash?.isNotEmpty, true);
  });
}
