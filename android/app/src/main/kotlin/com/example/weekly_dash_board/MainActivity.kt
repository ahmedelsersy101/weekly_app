package com.ahmedelsersy.weekly_dash_board

import android.content.Intent
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "deep_link_channel"
    private var methodChannel: MethodChannel? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // إنشاء الـ MethodChannel مرة واحدة وتخزينه
        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)

        methodChannel?.setMethodCallHandler { call, result ->
            when (call.method) {
                "getInitialLink" -> {
                    val initialUri = intent?.dataString
                    result.success(initialUri)
                }
                else -> result.notImplemented()
            }
        }
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)

        // إرسال اللينك الجديد إلى Flutter عبر الـ MethodChannel
        intent.dataString?.let { uri ->
            methodChannel?.invokeMethod("onNewLink", uri)
        }
    }
}
