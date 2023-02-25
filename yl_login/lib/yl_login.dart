import 'dart:async';
import 'dart:convert' as convert;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yl_cache_manager/yl_cache_manager.dart';
import 'package:yl_common/navigator/navigator.dart';
import 'package:yl_common/utils/storage_key_tool.dart';
import 'package:yl_module_service/yl_module_service.dart';
import 'package:yl_wowchat/channel/chat_method_channel_utls.dart';

import 'package:yl_login/page/login_page.dart';

// import 'channel/login_eventchannel.dart';

// import 'package:trust_wallet_core/flutter_trust_wallet_core.dart';

class YLLogin extends YLFlutterModule {
  static const MethodChannel channel = const MethodChannel('yl_login');

  static String get loginPageId => "login_page";

  static Future<String> get platformVersion async {
    final String version = await channel.invokeMethod('getPlatformVersion');
    return version;
  }

  @override
  Future<void> setup() async {
    // TODO: implement setup
    super.setup();
    YLModuleService.registerFlutterModule(moduleName, this);
    channel.setMethodCallHandler(_platformCallHandler);
    // ChatBinding.instance.setup();
    // FlutterTrustWalletCore.init();
  }

  @override
  // TODO: implement moduleName
  String get moduleName => 'yl_login';

  @override
  Map<String, Function> get interfaces => {
        'changeLaguage': changeLaguage,
        'changeTheme': changeTheme,
        'wowChatLogout': wowChatLogout,
        'getCurrencyHotChatId': getCurrencyHotChatId,
        'enterChatWithType': enterChatWithType,
        'gotoSetPhoneSystemNotify': gotoSetPhoneSystemNotify,
        'getPhoneSystemNotifyState': getPhoneSystemNotifyState,
        'chatMsgNofifyFlag': chatMsgNofifyFlag,
        'setChatNotifyFlag': setChatNotifyFlag,
        'getRegisterDeviceToken': getRegisterDeviceToken,
        'scanLoginWowChat': scanLoginWowChat,
        'scanQrCodeAddFriendOrGroup': scanQrCodeAddFriendOrGroup,
        'shareImageToChat': shareImageToChat,
        'shareLinkToChat': shareLinkToChat,
        'wowchatShortLink': wowchatShortLink,
        'updateZUserInfo': updateZUserInfo,
        'updateHttpDNSConfig': updateHttpDNSConfig,
        'initFlow': initFlow,
        'authLogin': authLogin
      };

  @override
  navigateToPage(BuildContext context, String pageName, Map<String, dynamic>? params) {
    switch (pageName) {
      case 'LoginPage':
        return YLNavigator.pushPage(
          context,
          (context) => new LoginPage(),
        );
    }
    return null;
  }

  Future<dynamic> _platformCallHandler(MethodCall call) async {
    Map<String, dynamic> callMap = Map<String, dynamic>.from(call.arguments);
    switch (call.method) {
      case 'statisticsPageStart':
        String viewName = callMap['viewName'];
        YLModuleService.invoke("yl_common", "statisticsPageStart", [viewName]);
        break;
      case 'statisticsPageEnd':
        String viewName = callMap['viewName'];
        YLModuleService.invoke("yl_common", "statisticsPageEnd", [viewName]);
        break;
      case 'gotoTradePage':
        String currency = callMap["currency"];
        if (YLNavigator.navigatorKey.currentContext != null) {
          YLModuleService.pushPage(YLNavigator.navigatorKey.currentContext!, 'yl_transaction', 'TradePage', {
            'currency': currency,
          });
        }
        break;
      case 'callPluginJump':
        String jumpUrl = callMap['jumpUrl'];
        if (YLNavigator.navigatorKey.currentContext != null) {
          // String? transferUrl = ModuleJumpUtils.transferUrl(jumpUrl);
          // if (transferUrl != null) {
          //   YLModuleService.invokeByUrl(transferUrl, YLNavigator.navigatorKey.currentContext!);
          // }
        }
        break;
      case 'showYLShare':
        YLModuleService.invoke("yl_share", "showYLShare", [callMap]);
        break;
      case 'gotoRedPacketSend':
        Map paramsMap = callMap;
        String params = convert.jsonEncode(paramsMap);
        YLModuleService.invoke('yl_red_packet', 'moduleCallNewFlutterActivity', ['RedPacketSend', params]);
        break;
      case 'gotoRedPacketDetail':
        Map paramsMap = callMap;
        String params = convert.jsonEncode(paramsMap);
        YLModuleService.invoke('yl_red_packet', 'moduleCallNewFlutterActivity', ['RedPacketDetail', params]);
        break;
      case 'gotoCouponRedPacketSend':
        Map paramsMap = callMap;
        String params = convert.jsonEncode(paramsMap);
        YLModuleService.invoke('yl_red_packet', 'moduleCallNewFlutterActivity', ['CouponRedPacketSend', params]);
        break;
      case 'getZappList':
        print("flutter=========>zappList");
        List zappList = await YLModuleService.invoke('yl_zapp', 'getZappList', []);
        // print("Michael zappList ${zappList}");
        return zappList;
      // case 'checkCouponRedPacketStatus'://orderId
      //   String orderId = callMap['orderId'];
      //   Map<String, dynamic> couponMap = await ChatInterfaceUtils.getCouponStatus(null, orderId);
      //   return couponMap;
      case 'openCouponRedPacket': //orderId
        Map paramsMap = callMap;
        Map<String, dynamic> openResultMap =
            await YLModuleService.invoke('yl_red_packet', 'getCouponByOrder', [paramsMap]);
        return openResultMap;
    }
  }

  void changeLaguage(BuildContext context) {
    ChatMethodChannelUtils.changeLaguage();
  }

  void changeTheme(BuildContext context) {
    ChatMethodChannelUtils.changeTheme();
  }

  void wowChatLogout(String userId) {
    ChatMethodChannelUtils.wowChatLogout(userId);
  }

  Future<String?> getCurrencyHotChatId(String currencyName) async {
    String? chatId = await ChatMethodChannelUtils.getCurrencyHotChatId(currencyName);
    return chatId;
  }

  //use:
  //{
  //       'chatId': chatId, //群聊id
  //       'chatType': '5', // 0 单聊；  1 普通群聊； 2 订单群聊； 3 客服群聊； 4 中币官方热聊； 5 币种热聊
  //       'avatar': '', //  头像
  //       'chatName': '', // 群聊名
  //       'currencyAmount': '', // 该币种持币数量（币种热聊）
  //     }
  void enterChatWithType(Map<String, String> params) {
    ChatMethodChannelUtils.enterChatWithType(params);
  }

  void gotoSetPhoneSystemNotify() {
    ChatMethodChannelUtils.gotoSetPhoneSystemNotify();
  }

  Future<bool> getPhoneSystemNotifyState() async {
    return await ChatMethodChannelUtils.getPhoneSystemNotifyState();
  }

  Future<bool> chatMsgNofifyFlag() async {
    return await ChatMethodChannelUtils.chatNotifyFlag();
  }

  Future<bool> setChatNotifyFlag(bool chatNotifyFlag) async {
    return await ChatMethodChannelUtils.setChatNotifyFlag(chatNotifyFlag);
  }

  Future<String> getRegisterDeviceToken() async {
    return await ChatMethodChannelUtils.getRegisterDeviceToken();
  }

  void scanLoginWowChat(String content) async {
    ChatMethodChannelUtils.scanLoginWowChat(content);
  }

  void shareImageToChat(String? content, Uint8List? imageData) async {
    ChatMethodChannelUtils.shareImageToChat(content, imageData);
  }

  void shareLinkToChat(Map<String, dynamic> params) {
    ChatMethodChannelUtils.shareLinkToChat(params);
  }

  Future<String> wowchatShortLink(String originUrl) async {
    return await ChatMethodChannelUtils.wowchatShortLink(originUrl);
  }

  void scanQrCodeAddFriendOrGroup(String content) async {
    ChatMethodChannelUtils.scanQrCodeAddFriendOrGroup(content);
  }

  void updateZUserInfo(String realName, String vipLevel, String totalInRmb) {
    ChatMethodChannelUtils.updateZUserInfo(realName, vipLevel, totalInRmb);
  }

  void updateHttpDNSConfig() async {
    String domain =
        await YLCacheManager.defaultYLCacheManager.getForeverData(StorageKeyTool.APP_DOMAIN_NAME, defaultValue: "");
    String httpURL = await YLCacheManager.defaultYLCacheManager.getForeverData("csshttps", defaultValue: "");
    String imUdpURL = await YLCacheManager.defaultYLCacheManager.getForeverData("cssudp", defaultValue: "");
    String audioUdpURL = await YLCacheManager.defaultYLCacheManager.getForeverData("cssvoice", defaultValue: "");
    ChatMethodChannelUtils.updateHttpDNSConfig(domain, httpURL, imUdpURL, audioUdpURL);
  }

  void initFlow() {
    channel.invokeMethod(
      'initFlow',
    );
  }

  Future<String?> authLogin() async {
    final String? flowAddress = await channel.invokeMethod(
      'authLogin',
    );
    return flowAddress;
  }
}
