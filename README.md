# sms_retriever_plus

<p align="center">
  <img src="https://img.shields.io/badge/platform-Android-brightgreen?logo=android" alt="Platform: Android"/>
  <img src="https://img.shields.io/badge/minSdk-30-orange" alt="minSdk 30"/>
  <img src="https://img.shields.io/badge/Kotlin-2.2.20-blueviolet?logo=kotlin" alt="Kotlin 2.2.20"/>
  <img src="https://img.shields.io/badge/license-MIT-blue" alt="License: MIT"/>
</p>

A **Flutter plugin** for the **Android SMS Retriever API** — automatically intercept OTP and verification SMS messages **without** requiring the `RECEIVE_SMS` permission.

---

## Features

- ✅ No SMS permissions needed
- ✅ Get your 11-character app signature hash in one call
- ✅ Start / auto-restart the SMS listener
- ✅ Receive messages via a simple callback
- ✅ Manifest-declared `BroadcastReceiver` — auto-merged into your app
- ✅ Minimal setup — just add the dependency

---

## How it works

The Android SMS Retriever API can read a single SMS message that **ends with your app's 11-character hash**. The message is delivered directly to your app without persisting in the SMS content provider.

```
┌──────────────┐     ┌──────────────────┐     ┌──────────────┐
│   SMS arrives │────▶│ BroadcastReceiver │────▶│  Your App    │
│  "...1234 HASH"│     │ (auto-registered) │     │  (callback)  │
└──────────────┘     └──────────────────┘     └──────────────┘
```

> **Note:** The sender must **not** be in your contacts. RCS / Chat messages are **not** intercepted.

---

## Quick start

### 1. Add dependency

```yaml
dependencies:
  sms_retriever_plus: ^1.0.0
```

### 2. Use it

```dart
import 'package:sms_retriever_plus/sms_retriever_plus.dart';

void setupSmsListener() async {
  // 1. Initialize the handler (call once)
  SmsRetrieverPlus.initialize();

  // 2. Set callback for incoming SMS
  SmsRetrieverPlus.onSmsReceivedCallback = (String message) {
    print('SMS received: $message');
  };

  // 3. Get the app signature hash
  final hash = await SmsRetrieverPlus.getSignature();
  print('App hash: $hash');

  // 4. Start listening
  await SmsRetrieverPlus.initSMSAPI();
}
```

### 3. Send a test SMS

From a phone that is **not in your contacts** (RCS disabled), send:
```
Your verification code is 123456 <11-char-hash>
```

Your app will receive `"Your verification code is 123456 <11-char-hash>"` via the callback.

---

## API

| Method | Returns | Description |
|---|---|---|
| `initialize()` | `void` | Register the platform channel handler (call once) |
| `getSignature()` | `Future<String?>` | Get the 11-char app signature hash |
| `initSMSAPI()` | `Future<bool?>` | Start the SMS Retriever listener |
| `stopSMSAPI()` | `Future<bool?>` | Stop the listener (prevents auto-restart) |
| `onSmsReceivedCallback` | setter | Callback `void Function(String)` for received SMS |

---

## Requirements

| Requirement | Version |
|---|---|
| Flutter | `>=3.3.0` |
| Dart | `>=3.10.8` |
| Android | `API 30+` (Android 11) |
| Kotlin | `2.2.20` |
| compileSdk | `36` |

---

## How to get your hash

Run the app and call `SmsRetrieverPlus.getSignature()` — the hash is logged and returned.

For debug builds on a device, the hash is **stable per signing key**. A release build with a different keystore produces a different hash.

---

## Troubleshooting

- **SMS not received?** Make sure the sender is **not in your contacts**.
- **RCS enabled?** Disable Chat features in Google Messages (or use a non-RCS sender).
- **Listener times out?** The SMS Retriever API has a 5-minute timeout. The receiver automatically restarts it.
- **Wrong hash?** The hash depends on your signing key. Debug and release builds have different hashes.

---

## License

MIT
