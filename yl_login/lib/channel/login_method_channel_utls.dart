import 'package:yl_login/yl_login.dart';
import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';

///Title: chat_method_channel_utls
///Description: TODO(自己填写)
///Copyright: Copyright (c) 2021
///@author George
///CreateTime: 2021/5/4 4:17 PM
class LoginMethodChannelUtils {
  static Future<String?> connectWallet(String schema) async {
    return await YLLogin.channel
        .invokeMethod('connectWallet', {'schema': schema});
  }

  static Future<String?> connectQrWallet() async {
    return await YLLogin.channel.invokeMethod('connectQrWallet');
  }

  static Future<String?> getWalletAddress() async {
    return await YLLogin.channel.invokeMethod('getWalletAddress');
  }

  static Future<bool> checkAvailability(String uri) async {
    Map<String, dynamic> args = <String, dynamic>{};
    args.putIfAbsent('uri', () => uri);
    //
    // if (Platform.isAndroid) {
    //   Map<dynamic, dynamic> app = await YLLogin.channel.invokeMethod("checkAvailability", args);
    //   return {
    //     "app_name": app["app_name"],
    //     "package_name": app["package_name"],
    //     "versionCode": app["versionCode"],
    //     "version_name": app["version_name"]
    //   };
    // }
    if (Platform.isIOS) {
      print("appAvailable0");
      String appAvailable = await YLLogin.channel.invokeMethod("checkAvailability", args);
      print("appAvailable1");

      // if (!appAvailable) {
      //   throw PlatformException(code: "", message: "App not found $uri");
      // }
      // return {
      //   "app_name": "",
      //   "package_name": uri,
      //   "versionCode": "",
      //   "version_name": ""
      // };
      return (appAvailable == 'YES') ? true : false;
    }
    return true;//安卓直接返回true
  }

  static Future<void> launchApp(String uri) async {
    Map<String, dynamic> args = <String, dynamic>{};
    args.putIfAbsent('uri', () => uri);
    // if (Platform.isAndroid) {
    //   await YLLogin.channel.invokeMethod("launchApp", args);
    // }
    // else
    if (Platform.isIOS) {
      bool appAvailable = await YLLogin.channel.invokeMethod("launchApp", args);
      if (!appAvailable) {
        throw PlatformException(code: "", message: "App not found $uri");
      }
    }
  }
}
