package com.smsretrieverplus.sms_retriever_plus

import android.content.Context
import android.util.Log
import com.google.android.gms.auth.api.phone.SmsRetriever
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class SmsRetrieverPlusPlugin :
    FlutterPlugin,
    MethodCallHandler {

    companion object {
        private var channel: MethodChannel? = null
        private var applicationContext: Context? = null
        @Volatile @JvmField var isListening = false

        fun sendSmsToFlutter(smsMessage: String) {
            channel?.invokeMethod("onSmsReceived", smsMessage)
        }
    }

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        applicationContext = flutterPluginBinding.applicationContext
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "sms_retriever_plus")
        channel?.setMethodCallHandler(this)
    }

    override fun onMethodCall(
        call: MethodCall,
        result: Result
    ) {
        when (call.method) {
            "getSignature" -> {
                val context = applicationContext
                if (context != null) {
                    val helper = AppSignatureHashHelper(context)
                    val signature = helper.appSignatures.firstOrNull()
                    Log.i("Signature", signature ?: "Signature not found")
                    result.success(signature)
                } else {
                    result.success(null)
                }
            }
            "initSMSAPI" -> {
                isListening = true
                val context = applicationContext
                if (context != null) {
                    val client = SmsRetriever.getClient(context)
                    client.startSmsRetriever()
                        .addOnSuccessListener {
                            Log.i("SmsRetriever", "Listener started successfully")
                            result.success(true)
                        }
                        .addOnFailureListener { e ->
                            Log.e("SmsRetriever", "Failed to start SMS retriever", e)
                            result.success(false)
                        }
                } else {
                    result.success(false)
                }
            }
            "stopSMSAPI" -> {
                isListening = false
                Log.i("SmsRetriever", "Listener stopped")
                result.success(true)
            }
            else -> result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel?.setMethodCallHandler(null)
        channel = null
        applicationContext = null
    }
}
