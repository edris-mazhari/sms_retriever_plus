import 'package:flutter/material.dart';
import 'package:sms_retriever_plus/sms_retriever_plus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _appHash = 'Loading...';
  String _status = 'Initializing...';
  final _messages = <String>[];
  bool _listening = false;

  @override
  void initState() {
    super.initState();
    _initSmsRetriever();
  }

  Future<void> _initSmsRetriever() async {
    SmsRetrieverPlus.initialize();
    SmsRetrieverPlus.onSmsReceivedCallback = (message) {
      setState(() {
        _messages.insert(0, message);
        _status = 'SMS received!';
      });
    };

    final hash = await SmsRetrieverPlus.getSignature();
    setState(() => _appHash = hash ?? 'No hash');
    await _start();
  }

  Future<void> _start() async {
    final ok = await SmsRetrieverPlus.initSMSAPI();
    setState(() {
      _listening = ok ?? false;
      _status = ok == true
          ? 'Listening - send SMS ending with $_appHash'
          : 'Failed to start';
    });
  }

  Future<void> _stop() async {
    await SmsRetrieverPlus.stopSMSAPI();
    setState(() {
      _listening = false;
      _status = 'Stopped';
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('SMS Retriever Example'),
          actions: [
            IconButton(
              icon: Icon(_listening ? Icons.stop : Icons.play_arrow),
              onPressed: _listening ? _stop : _start,
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('App Hash: $_appHash'),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text('Status: $_status'),
                  const SizedBox(width: 8),
                  if (_listening)
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              const Text('Received Messages:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Expanded(
                child: ListView.builder(
                  itemCount: _messages.length,
                  itemBuilder: (context, index) =>
                      ListTile(title: Text(_messages[index])),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
