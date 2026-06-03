package com.smsretrieverplus.sms_retriever_plus

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log
import com.google.android.gms.auth.api.phone.SmsRetriever
import com.google.android.gms.common.api.CommonStatusCodes
import com.google.android.gms.common.api.Status

class SmsRetrieverBroadcastReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        if (SmsRetriever.SMS_RETRIEVED_ACTION == intent.action) {
            val extras = intent.extras
            val status = extras?.get(SmsRetriever.EXTRA_STATUS) as Status?

            when (status?.statusCode) {
                CommonStatusCodes.SUCCESS -> {
                    val message = extras?.getString(SmsRetriever.EXTRA_SMS_MESSAGE)
                    if (message != null) {
                        Log.i("SmsRetriever", "SMS received: $message")
                        SmsRetrieverPlusPlugin.sendSmsToFlutter(message)

                        val client = SmsRetriever.getClient(context)
                        client.startSmsRetriever()
                            .addOnSuccessListener {
                                Log.i("SmsRetriever", "Listening for next SMS.")
                            }
                            .addOnFailureListener { e ->
                                Log.e("SmsRetriever", "Failed to restart listener", e)
                            }
                    }
                }
                CommonStatusCodes.TIMEOUT -> {
                    Log.e("SmsRetriever", "SMS retrieval timed out. Restarting listener...")
                    val client = SmsRetriever.getClient(context)
                    client.startSmsRetriever()
                        .addOnSuccessListener {
                            Log.i("SmsRetriever", "Listener restarted successfully.")
                        }
                        .addOnFailureListener { e ->
                            Log.e("SmsRetriever", "Failed to restart listener after timeout", e)
                        }
                }
            }
        }
    }
}
