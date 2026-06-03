package com.smsretrieverplus.sms_retriever_plus

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.mockito.Mockito
import org.mockito.kotlin.any
import kotlin.test.Test

internal class SmsRetrieverPlusPluginTest {
    @Test
    fun onMethodCall_getSignature_returnsString() {
        val plugin = SmsRetrieverPlusPlugin()

        val call = MethodCall("getSignature", null)
        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        plugin.onMethodCall(call, mockResult)

        Mockito.verify(mockResult).success(any<String?>())
    }

    @Test
    fun onMethodCall_unknownMethod_returnsNotImplemented() {
        val plugin = SmsRetrieverPlusPlugin()

        val call = MethodCall("unknown", null)
        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        plugin.onMethodCall(call, mockResult)

        Mockito.verify(mockResult).notImplemented()
    }
}
