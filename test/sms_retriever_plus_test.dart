import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sms_retriever_plus/sms_retriever_plus.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('sms_retriever_plus');
  String? capturedMessage;

  setUp(() {
    SmsRetrieverPlus.initialize();
    SmsRetrieverPlus.onSmsReceivedCallback = (msg) {
      capturedMessage = msg;
    };
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      if (methodCall.method == 'getSignature') {
        return 'AbCdEfGhIjK';
      }
      if (methodCall.method == 'initSMSAPI') {
        return true;
      }
      if (methodCall.method == 'stopSMSAPI') {
        return true;
      }
      return null;
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
    capturedMessage = null;
  });

  test('getSignature returns 11-char hash', () async {
    final hash = await SmsRetrieverPlus.getSignature();
    expect(hash, 'AbCdEfGhIjK');
  });

  test('initSMSAPI returns true', () async {
    final result = await SmsRetrieverPlus.initSMSAPI();
    expect(result, true);
  });

  test('initSMSAPI returns true after stop', () async {
    await SmsRetrieverPlus.stopSMSAPI();
    final result = await SmsRetrieverPlus.initSMSAPI();
    expect(result, true);
  });

  test('onSmsReceivedCallback is called when SMS received', () async {
    final message = 'Your code is 1234 AbCdEfGhIjK';
    await channel.binaryMessenger
        .handlePlatformMessage(
          channel.name,
          channel.codec.encodeMethodCall(
            MethodCall('onSmsReceived', message),
          ),
          (data) {},
        );
    expect(capturedMessage, message);
  });
}
