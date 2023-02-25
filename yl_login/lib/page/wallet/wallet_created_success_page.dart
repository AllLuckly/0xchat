import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yl_common/log_util.dart';
import 'package:yl_common/model/yl_user_info.dart';
import 'package:yl_common/navigator/navigator.dart';
import 'package:yl_common/utils/adapt.dart';
import 'package:yl_common/utils/theme_color.dart';
import 'package:yl_common/utils/yl_userinfo_manager.dart';
import 'package:yl_wowchat/channel/chat_method_channel_utls.dart';
import 'dart:convert' as convert;

import '../../yl_login.dart';
import 'backup_wallet_page.dart';

class WalletCreatedSuccessPage extends StatelessWidget {
  final String walletAddress;//钱包地址
  final String mnemonic;//钱包备份助记词
  final String platformUniqueKey;//apple 唯一id
  const WalletCreatedSuccessPage({required this.walletAddress, required this.mnemonic, required this.platformUniqueKey});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ThemeColor.bgColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: Adapt.px(190),
          ),

          Image.asset(
            'assets/images/login_bg_new.png',
            fit: BoxFit.contain,
            width: double.infinity,
            height: Adapt.px(200),
            package: 'yl_login',
          ),
          SizedBox(
            height: Adapt.px(36),
          ),
          Text(
            "创建成功",
            style: TextStyle(fontSize: 24, color: ThemeColor.titleColor),
          ),
          SizedBox(
            height: Adapt.px(10),
          ),
          Container(
            margin: EdgeInsets.only(left: Adapt.px(32), right: Adapt.px(32)),
            child: Text(
              "您的Trust钱包已创建成功。您可以选择进入聊天，或者备份您的钱包",
              style: TextStyle(fontSize: 14, color: ThemeColor.titleColor),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: Adapt.px(32),
          ),
          GestureDetector(
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(left: Adapt.px(32), right: Adapt.px(32)),
              height: Adapt.px(48),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  Color(0xff44FF35),
                  Color(0xff8792FF),
                  Color(0xffA67EFF)
                ]),
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
                border: new Border.all(
                  width: 1, color: Colors.transparent),
              ),
              width: double.infinity,
              child: Text("进入聊天"),
            ),
            onTap: (){//登录逻辑
              LogUtil.e("登录逻辑");
              loginIm(context);
            },
          ),
          SizedBox(
            height: Adapt.px(22),
          ),
          // GestureDetector(
          //   child: Container(
          //     alignment: Alignment.center,
          //     margin: EdgeInsets.only(left: Adapt.px(32), right: Adapt.px(32)),
          //     height: Adapt.px(48),
          //     width: double.infinity,
          //     decoration: BoxDecoration(
          //       color: ThemeColor.gray5,
          //       borderRadius: BorderRadius.all(Radius.circular(4.0)),
          //       border: new Border.all(
          //         width: 1, color: Colors.transparent),
          //     ),
          //     child: Text("备份钱包"),
          //   ),
          //   onTap: (){//登录逻辑
          //     LogUtil.e("备份钱包");
          //     YLNavigator.pushPage(
          //       context,
          //         (context) => BackupWalletPage(walletAddress: walletAddress,mnemonic: mnemonic,),
          //     );
          //   },
          // ),
        ],
      ),
    );
  }

  loginIm(BuildContext context) async {
    print("xxxxxxxxxlogin======3");
    String? loginInfoStr = await ChatMethodChannelUtils.loginWowChat(
      walletAddress,'', '', platformUniqueKey, '', '');
    print("xxxxxxxxxlogin======${loginInfoStr}");
    if (loginInfoStr!.length > 0) {
      print("xxxxxxxxx======" + loginInfoStr);
      //登录成功
      YLUserInfo userInfo = getUser(loginInfoStr);
      YLUserInfoManager.sharedInstance
        .updateUserInfo(userInfo, isUpdate: false);
      //如果没有设置google提示设置google
      YLNavigator.popToPage(context,
        pageId: YLLogin.loginPageId, isPrepage: true);

    } else {
      //登录失败

    }
  }
  YLUserInfo getUser(String loginInfoStr) {
    ///后期根据需要的字段再转化
    Map<String, dynamic> user = convert.jsonDecode(loginInfoStr);
    YLUserInfo userInfo = YLUserInfo.fromMap(Map.from(user));
    userInfo.token = user["token"];
    userInfo.nickName = user["nickname"];
    userInfo.userId = user["user_uid"];
    userInfo.email = user["user_mail"];
    userInfo.headUrl = user["userAvatarFileName"];//userAvatarFileName 在ios或者安卓端获取的时候需获取头像链接手动赋值
    return userInfo;
  }
}
