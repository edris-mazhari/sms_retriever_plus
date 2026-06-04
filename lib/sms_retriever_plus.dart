import 'package:flutter/services.dart';

/// A Flutter plugin for Android SMS Retriever API.
///
/// Listens for SMS messages that end with your app's 11-character hash
/// without requiring `RECEIVE_SMS` permission.
///
/// To test, send an SMS ending with the hash from an unknown number:
///   `Your code is 123456 <11char-hash>`
///
/// Usage:
/// ```dart
/// // 1. Initialize the handler (call once)
/// SmsRetrieverPlus.initialize();
///
/// // 2. Set callback for incoming SMS
/// SmsRetrieverPlus.onSmsReceivedCallback = (String message) {
///   print('SMS received: $message');
/// };
///
/// // 3. Get the app signature hash (append this to test SMS)
/// String? hash = await SmsRetrieverPlus.getSignature();
///
/// // 4. Start listening for SMS
/// bool? started = await SmsRetrieverPlus.initSMSAPI();
/// ```
class SmsRetrieverPlus {
  static const MethodChannel _channel = MethodChannel('sms_retriever_plus');

  /// Callback invoked when an SMS is received via the SMS Retriever API.
  ///
  /// Set this before calling [initSMSAPI]. The [String] parameter is the
  /// full SMS message text.
  static void Function(String)? onSmsReceivedCallback;

  /// Initialize the method channel handler.
  ///
  /// Call this once before [getSignature] and [initSMSAPI]. It registers
  /// the platform channel that receives SMS from the native BroadcastReceiver.
  static void initialize() {
    _channel.setMethodCallHandler((MethodCall call) async {
      if (call.method == 'onSmsReceived') {
        onSmsReceivedCallback?.call(call.arguments as String);
      }
    });
  }

  /// Returns the 11-character app signature hash.
  ///
  /// This hash must be appended to SMS messages for the SMS Retriever API
  /// to intercept them (e.g., `Your code is 123456 <hash>`).
  /// Returns `null` if the hash could not be computed.
  static Future<String?> getSignature() async {
    return await _channel.invokeMethod<String?>('getSignature');
  }

  /// Start the SMS Retriever listener.
  ///
  /// Returns `true` when the listener is active. The listener times out
  /// after 5 minutes; the BroadcastReceiver automatically restarts it
  /// until [stopSMSAPI] is called.
  ///
  /// Requirements:
  /// - Sender must NOT be in contacts
  /// - RCS/Chat messages are NOT intercepted (use a non-RCS sender)
  /// - Message must end with the 11-char app hash
  static Future<bool?> initSMSAPI() async {
    return await _channel.invokeMethod<bool?>('initSMSAPI');
  }

  /// Stop the SMS Retriever listener.
  ///
  /// The current listener will stop on its next timeout or SMS receipt.
  /// Call [initSMSAPI] to start listening again.
  static Future<bool?> stopSMSAPI() async {
    return await _channel.invokeMethod<bool?>('stopSMSAPI');
  }
}
