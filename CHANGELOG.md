# 1.1.1

- Fixed: Add `@Volatile` annotation to `isListening` flag for thread-safe access
- Improved: Enhanced thread safety when stopping the SMS listener

# 1.1.0

- Added `stopSMSAPI()` to stop the listener
- Auto-restart respects stop flag (BroadcastReceiver checks `isListening`)

# 1.0.0

- Initial release
- Get app signature hash
- Start SMS Retriever listener
- Receive SMS messages via callback
