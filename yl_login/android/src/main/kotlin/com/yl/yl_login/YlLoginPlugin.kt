package com.yl.yl_login

import android.content.Context
import android.util.Log
import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import kotlinx.coroutines.CoroutineScope

/** YlLoginPlugin */
class YlLoginPlugin: FlutterPlugin, MethodCallHandler, ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private lateinit var mContext: Context

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    mContext = flutterPluginBinding.applicationContext
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "yl_login")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    if (call.method == "initFlow"){
//      Log.e("Michael", "初始化Flow");
      FlowManager.getInstance()?.initFlow()
    } else if (call.method == "authLogin"){//Flow注册登录
      FlowManager.getInstance()?.authLogin(object : AuthLoginListener {

        override fun onResult(s: String?) {
//          Log.e("Michael", "address = "+s)
          if(s != null) {
            result.success(s);
          }
        }

      })
    } else if (call.method == "initWalletConnect"){
      WalletConnectManager.get().initWalletConnectAll(mContext)
    } else if (call.method == "connectWallet"){
      var scheme: String? = null
      if (call.hasArgument("scheme") ){
        scheme = call.argument<String>("scheme")
        if(scheme==null){
          scheme = ""
        }
        WalletConnectManager.get().openMetaMask(mContext, scheme, object : WalletConnectManager.ApprovedAccountListener{
          override fun authCalled(result: List<String>?) {
            Log.e("Michael", "authCalled result = "+result?.get(0))
          }
        })
      } else {
        return
      }
    } else if (call.method == "getPlatformVersion") {
      result.success("Android ${android.os.Build.VERSION.RELEASE}")
    } else {
      result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {

  }

  override fun onDetachedFromActivityForConfigChanges() {
//    TODO("Not yet implemented")
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
//    TODO("Not yet implemented")
  }

  override fun onDetachedFromActivity() {
//    TODO("Not yet implemented")
  }
}
