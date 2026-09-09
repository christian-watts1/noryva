package com.noryva.noryva_mobile

import android.os.Build
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "noryva/identity_metadata")
            .setMethodCallHandler { call, result ->
                if (call.method != "get") {
                    result.notImplemented()
                } else {
                    @Suppress("DEPRECATION")
                    val version = packageManager.getPackageInfo(packageName, 0).versionName
                    result.success(mapOf("osMajor" to (Build.VERSION.RELEASE.substringBefore('.').toIntOrNull() ?: 1), "appVersion" to version))
                }
            }
    }
}
