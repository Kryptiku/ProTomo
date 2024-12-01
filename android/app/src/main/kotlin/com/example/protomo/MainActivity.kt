package com.example.protomo // Replace with your app's package name

import android.app.ActivityManager
import android.content.Context
import android.os.Build
import android.os.Bundle
import android.widget.Toast
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.your_app/screen_pin"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "startScreenPinning" -> {
                    val success = startScreenPinning()
                    if (success) {
                        result.success(null)
                    } else {
                        result.error("UNAVAILABLE", "Screen pinning could not start", null)
                    }
                }
                "stopScreenPinning" -> {
                    stopScreenPinning()
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun startScreenPinning(): Boolean {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            val activityManager = getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
            if (!isTaskRoot) {
                // Prevent pinning if the activity is not the root
                return false
            }
            startLockTask()
            Toast.makeText(this, "Screen pinning enabled", Toast.LENGTH_SHORT).show()
            return true
        }
        return false
    }

    private fun stopScreenPinning() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            stopLockTask()
            Toast.makeText(this, "Screen pinning disabled", Toast.LENGTH_SHORT).show()
        }
    }
}
