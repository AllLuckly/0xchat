import 'package:url_launcher/url_launcher.dart';
import 'package:yl_common/log_util.dart';
import 'package:yl_common/navigator/navigator.dart';
import 'package:yl_common/widgets/modal_bottom_sheet/modals/modal_fit.dart';
import 'package:yl_login/page/login_page.dart';
import 'package:yl_login/yl_login.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert' as convert;

import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../page/wallet/wallet_authorization_page.dart';
import '../walletconnect/ethereum_transaction_tester.dart';
import '../walletconnect/transaction_tester.dart';

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

  static Future<Map<String, dynamic>> walletAuthorization(Map paramsMap) async{
    String schema = '';
    String jumpUrl = '';
    if(paramsMap['walletType'] == 100){
      schema = 'metamask';
    }else if(paramsMap['walletType'] == 101){
      schema = 'trust';
    }else if(paramsMap['walletType'] == 102){
      schema = 'imtokenv2';
    }
    LogUtil.e("walletAuthorization paramsMap: ${paramsMap}");
    TransactionTester? _transactionTester = EthereumTransactionTester();
    LogUtil.e("walletAuthorization _transactionTester: ${_transactionTester}");
    final session = await _transactionTester.connect(
        onDisplayUri: (uri) async{
        LogUtil.e("walletAuthorization uri: ${uri}");
        String myuri = schema + "://wc?uri=" + uri;
        //metamask://wc?uri=wc:8854cff9-697b-4658-a00f-868b54bace3c@1?bridge=https%3A%2F%2Fn.bridge.walletconnect.org&key=e4d6b3c30ba27af5074e2a28868e5ccbea9dfdcae4eaf4fc4409abd8d7c664a9
        print("_displayUri ==== ${myuri}");
        jumpUrl = myuri;
        await launch(jumpUrl);
       },
    );
    // address = session?.accounts[0] ?? '';
    if (session == null) {
      LogUtil.e(' walletAuthorization Unable to connect');
      return {'sign': ''};
    }
    final result = await Future.delayed(const Duration(seconds: 2), () async {
      LogUtil.e("walletAuthorization walletLoginInfoStr");
      try {
        await launch(schema + "://" );//不加这个不重新跳转到app进行签名
        final walletLoginInfoStr = await _transactionTester.personalSign(message: "Transaction", address: session.accounts[0], password: '');
        LogUtil.e("walletAuthorization to sign ${walletLoginInfoStr}");
        return walletLoginInfoStr;
      } catch (e) {
        LogUtil.e('Transaction error: $e');
        return '';
      }
    });
    return {'sign': result};
  }



}
