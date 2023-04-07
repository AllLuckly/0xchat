import 'dart:convert' as convert;
import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:trust_wallet_core/flutter_trust_wallet_core.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yl_common/log_util.dart';
import 'package:yl_common/model/yl_user_info.dart';
import 'package:yl_common/navigator/navigator.dart';
import 'package:yl_common/utils/adapt.dart';
import 'package:yl_common/utils/yl_userinfo_manager.dart';
import 'package:yl_common/widgets/common_appbar.dart';
import 'package:yl_common/widgets/common_toast.dart';
import 'package:yl_common/widgets/modal_bottom_sheet/modals/modal_fit.dart';
import 'package:yl_common/widgets/modal_bottom_sheet/modals/modal_with_navigator.dart';
import 'package:yl_localizable/yl_localizable.dart';
import 'package:yl_login/channel/login_method_channel_utls.dart';
import 'package:yl_login/page/wallet/authorization_notice_widget.dart';
import 'package:yl_login/page/wallet/wallet_created_success_page.dart';
import 'package:yl_login/walletconnect/ethereum_transaction_tester.dart';
import 'package:yl_login/walletconnect/transaction_tester.dart';
import 'package:yl_module_service/yl_module_service.dart';
import 'package:yl_wowchat/channel/chat_method_channel_utls.dart';
import 'package:yl_common/utils/theme_color.dart';
import '../yl_login.dart';
import 'package:rich_text_widget/rich_text_widget.dart';
import 'package:roundcheckbox/roundcheckbox.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'package:webview_flutter/platform_interface.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:yl_login/channel/create_wallet_address_tools.dart';

// import 'package:trust_wallet_core/trust_wallet_core_ffi.dart';

// import 'package:trust_wallet_core_lib/trust_wallet_core_lib.dart';
import 'package:convert/convert.dart';

// import 'package:appcheck/appcheck.dart';

import 'package:shared_preferences/shared_preferences.dart';


enum TransactionState {
  disconnected,
  connecting,
  connected,
  connectionFailed,
  transferring,
  success,
  failed,
}

class LoginPage extends StatefulWidget {
  final bool? isLoginShow;
  LoginPage({this.isLoginShow});

  @override
  _LoginPageState createState() => _LoginPageState();

}

class _LoginPageState extends State<LoginPage> {
  late List loginList;
  String _displayUri = '';
  String address = '';
  int groupValue = 1;
  TransactionState _state = TransactionState.disconnected;
  TransactionTester? _transactionTester = EthereumTransactionTester();
  bool checkboxSelected = false;
  String loginSchema = 'wc';
  String? platformUniqueKey;
  // late HDWallet wallet;

  initState() {
    // FlutterTrustWalletCore.init();
    super.initState();

    // getWalletAddress('xxxxx');
    // loginList = [
    //   {"title": 'MetaMask','iconName' : 'meta_icon.png', 'schema' :'wc'},
    //   {"title": 'Trust Wallet','iconName' : 'trust_icon.png', 'schema' :'trust'},
    //   {"title": 'imToken','iconName' : 'imToken_icon.png', 'schema' :'imtokenv2'},
    // ];


    // metamask://
    // trust://
    // "imtokenv2://navigate/AssetsTab"




    // try{
    //   wallet = HDWallet();
    // }catch(e){
    //   CommonToast.instance.show(context, 'xxxx222 === ${e.toString()}');
    // }


    loginList = [
      // {"title": 'MetaMask','iconName' : 'meta_icon.png', 'schema' :'wc'},
      // {"title": 'Trust Wallet','iconName' : 'trust_icon.png', 'schema' :'trust'},
      // {"title": 'imToken','iconName' : 'imToken_icon.png', 'schema' :'imtokenv2'},
    ];

    getApps();//安装了才展示这些钱包登录

  }

  getApps() async{
    bool isMetamask = await LoginMethodChannelUtils.checkAvailability('metamask://');
    if(isMetamask){
      // Map metamask =  {"title": 'MetaMask','iconName' : 'meta_icon.png', 'schema' :'wc'};
      Map metamask =  {"title": 'MetaMask','iconName' : 'meta_icon.png', 'schema' :'metamask'};//fix 会跳转到其他支持wc协议的app
      loginList.add(metamask);
    }
    bool isTrust = await LoginMethodChannelUtils.checkAvailability('trust://');
    if(isTrust){
      Map trust =  {"title": 'Trust Wallet','iconName' : 'trust_icon.png', 'schema' :'trust'};
      loginList.add(trust);
    }
    bool isImToken = await LoginMethodChannelUtils.checkAvailability('imtokenv2://');
    if(isImToken){
      Map imtokenv2 =  {"title": 'imToken','iconName' : 'imToken_icon.png', 'schema' :'imtokenv2'};
      loginList.add(imtokenv2);
    }
    if (mounted) setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: '',
        useLargeTitle: false,
        centerTitle: true,
      ),
      body: buildScrollView(),
      backgroundColor: ThemeColor.bgColor,
    );
  }

  Widget buildScrollView() {
    return SingleChildScrollView(
      //滑动的方向 Axis.vertical为垂直方向滑动，Axis.horizontal 为水平方向
      scrollDirection: Axis.vertical,
      //true 滑动到底部
      reverse: false,
      padding: EdgeInsets.all(0.0),
      //滑动到底部回弹效果
      physics: BouncingScrollPhysics(),
      child: Center(
        child: Column(
          children: <Widget>[
            Container(
                // height: 250,
                color: ThemeColor.bgColor,
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/logo_icon.png',
                      fit: BoxFit.contain,
                      width: Adapt.px(110),
                      height: Adapt.px(110),
                      package: 'yl_login',
                    ),
                    SizedBox(
                      height: Adapt.px(5),
                    ),
                    // Text(
                    //   '0xChat',
                    //   style: TextStyle(
                    //       color: ThemeColor.titleColor,
                    //       fontSize: 24,
                    //       fontWeight: FontWeight.bold),
                    // ),
                    SizedBox(
                      height: Adapt.px(14),
                    ),
                    Container(
                      child: Text(
                        'Connect to one of our wallet provider or create a new one.',
                        style: TextStyle(
                            color: ThemeColor.titleColor, fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                      margin: const EdgeInsets.fromLTRB(50, 0, 50, 0),
                    ),
                    SizedBox(
                      height: Adapt.px(43),
                    ),
                  ],
                )),
            Container(
              margin: EdgeInsets.only(left: 32, right: 32),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                child: Container(
                  height: 68 * loginList.length + 1,
                  padding: EdgeInsets.only(left: 16, right: 16),
                  child: buildListItems(),
                  color: ThemeColor.gray8,
                ),
              ),
              color: ThemeColor.bgColor,
            ),
            Container(
              margin: EdgeInsets.only(top: Adapt.px(24)),
              color: ThemeColor.bgColor,
              child: Column(
                children: [
                  Platform.isAndroid ? Container() : Row(
                    children: [
                      SizedBox(
                        width: Adapt.px(32),
                      ),
                      Expanded(
                          child: Container(
                        height: 1,
                        color: ThemeColor.gray4,
                      )),
                      SizedBox(
                        width: Adapt.px(10),
                      ),
                      Text(
                        Localized.text("yl_login.or"),
                        style: TextStyle(
                          color: ThemeColor.gray9,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(
                        width: Adapt.px(10),
                      ),
                      Expanded(
                          child: Container(
                        height: 1,
                        color: ThemeColor.gray4,
                      )),
                      SizedBox(
                        width: Adapt.px(32),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: Adapt.px(9),
                  ),
                  Platform.isAndroid ? Container() : Row(
                    children: [
                      SizedBox(
                        width: Adapt.px(32),
                      ),
                      Expanded(
                          child: Container(
                        height: Adapt.px(68),
                        // color: ThemeColor.gray8,
                        decoration: new BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                          border: new Border.all(
                              width: 0.3, color: Colors.transparent),
                        ),
                        child: Center(
                          child:SignInWithAppleButton(
                            onPressed: () async {
                              if(!checkboxSelected){
                                CommonToast.instance.show(context, Localized.text("yl_login.Agree to the agreement to log in"));
                                return;
                              }
                              final credential = await SignInWithApple.getAppleIDCredential(
                                scopes: [
                                  AppleIDAuthorizationScopes.email,
                                  AppleIDAuthorizationScopes.fullName,
                                ],
                              );

                              print('identityToken : ${credential.identityToken}   userIdentifier : ${credential.userIdentifier} ');

                              String? addressStr = await ChatMethodChannelUtils.getAppleLoginWalletAddress(
                                credential.userIdentifier ?? '');

                              final prefs = await SharedPreferences.getInstance();
                              prefs.setBool('isGuestLogin', false);

                              if (addressStr!.length > 0) {//走登录IM
                                address = addressStr;
                                loginIm('');
                              }else{//创建钱包流程
                                platformUniqueKey = credential.userIdentifier;

                                WalletInfo walletInfo = await getWalletAddress();
                                final prefs = await SharedPreferences.getInstance();
                                prefs.setString("mnemonic", walletInfo.mnemonic!);
                                  Navigator.of(context).pop();
                                YLNavigator.pushPage(
                                  context,
                                    (context) => WalletCreatedSuccessPage(walletAddress: walletInfo.address!,mnemonic: walletInfo.mnemonic!, platformUniqueKey: platformUniqueKey!,),
                                );
                              }
                              // Now send the credential (especially `credential.authorizationCode`) to your server to create a session
                              // after they have been validated with Apple (see `Integration` section for more information on how to do this)
                            },
                            style: SignInWithAppleButtonStyle.white,
                          )

                        ),
                      )),

                      SizedBox(
                        width: Adapt.px(32),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: Adapt.px(20),
                  ),

                  Row(
                   children: [
                     Spacer(),
                     GestureDetector(
                       child: Text(
                         Localized.text('yl_login.create_wallet'),
                         style: TextStyle(
                           color: ThemeColor.purple1,
                           fontSize: 15,
                           decoration: TextDecoration.underline,
                         ),
                       ),
                       // onTap: (){
                       //   YLNavigator.pushPage(context, (context) => AuthorizationNoticeWidget(''));
                       // }

                       onTap: () => showMaterialModalBottomSheet(
                         // expand: true,
                         context: context,
                         builder: (context) => ModalFit(
                           child: AuthorizationNoticeWidget(''),
                         ),
                       ),
                     ),
                     SizedBox(width: Adapt.px(10),),
                     GestureDetector(
                       child: Text(
                         Localized.text('yl_login.Guest login'),
                         style: TextStyle(
                           color: ThemeColor.purple1,
                           fontSize: 15,
                           decoration: TextDecoration.underline,
                         ),
                       ),
                       onTap: () async {//游客登录 写死一个钱包地址
                       //
                        //  address = "0xd8bd35a994d14929323b8a837af5ca4c0f744914";
                         //我自己的
                         address = '0x96d7cf71f6391a6092487c0390c4977052e78ddb';
                        //未知，数据蛮多
                        //  address = '0xC8b960D09C0078c18Dcbe7eB9AB9d816BcCa8944';
                         //老板
                         // address = '0x4f714880A5847D335606bb37848CcAcbcD6d5836';


                         loginIm("");
                         final prefs = await SharedPreferences.getInstance();
                         await prefs.setBool('isGuestLogin', true);
                       },
                     ),
                     Spacer(),
                   ],
                  ),
                  Container(
                    height: 20,
                  ),

                  Container(
                    height: 20,
                  ),
                ],
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Spacer(),
                RoundCheckBox(
                  isChecked:checkboxSelected,
                  size: Adapt.px(20),
                  onTap: (selected) {
                    setState(() {
                      checkboxSelected = selected!;
                    });
                  },
                  border: Border.all(
                    width: 1,
                    color: ThemeColor.titleColor,
                  ),
                  disabledColor: ThemeColor.titleColor,
                  uncheckedColor: Colors.transparent,
                  checkedColor: Colors.transparent,
                  checkedWidget: Container(
                    width: Adapt.px(18),
                    height: Adapt.px(18),
                    decoration: new BoxDecoration(
                      color: ThemeColor.purple1,
                      borderRadius: BorderRadius.all(Radius.circular(18.0)),
                      border: new Border.all(
                        width: 1, color: Colors.transparent),
                    ),
                    // child: Icon(Icons.check, color: Colors.white),
                  ),
                ),
                SizedBox(
                  width: Adapt.px(8),
                ),
                RichTextWidget(
                  // default Text
                  Text(
                    Localized.text('yl_login.terms_of_service_privacy_policy'),
                    style: TextStyle(color: ThemeColor.titleColor),
                  ),
                  // rich text list
                  richTexts: [
                    BaseRichText(
                      Localized.text("yl_login.terms_of_service"),
                      style: TextStyle(color:ThemeColor.purple1),
                      onTap: () => showBarModalBottomSheet(
                        expand: true,
                        context: context,
                        backgroundColor: ThemeColor.gray5,
                        builder: (context) => ModalWithNavigator(
                          title: Localized.text("yl_login.terms_of_service"),
                          child: Container(
                            child: WebView(
                              initialUrl: 'https://www.0xchat.com/protocols/0xchat_terms_of_use.html',
                              onWebViewCreated: (WebViewController webViewController) {
                                // controller = webViewController;
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    BaseRichText(
                      Localized.text("yl_login.privacy_policy"),
                      style: TextStyle(color: ThemeColor.purple1),
                      onTap: () => showBarModalBottomSheet(
                        expand: true,
                        context: context,
                        backgroundColor: ThemeColor.gray5,
                        builder: (context) => ModalWithNavigator(
                          title: Localized.text("yl_login.privacy_policy"),
                          child: Container(
                            child: WebView(
                              initialUrl: 'https://www.0xchat.com/protocols/0xchat_privacy_policy.html',
                              onWebViewCreated: (WebViewController webViewController) {
                                // controller = webViewController;
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Spacer(),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget buildListItems() {
    List<Widget> tiles = [];
    Widget content; //单独一个widget组件，用于返回需要生成的内容widget
    for (var i = 0; i < loginList.length; i++) {
      var item = loginList[i];
      if (i == loginList.length - 1) {
        tiles.add(new Container(
          color: ThemeColor.gray8,
          // height: 50,
          child: Column(
            children: [
              Container(
                height: 68,
                child: buildListRow(item),
                // padding: EdgeInsets.only(left: 16, right: 16),
              ),
            ],
          ),
        ));
      } else {
        tiles.add(new Container(
          height: 68,
          child: Column(
            children: [
              Container(
                height: 67.5,
                child: buildListRow(item),
                // padding: EdgeInsets.only(left: 16, right: 16),
              ),
              Container(
                height: 0.5,
                color: Color(0x1A000000),
              ),
            ],
          ),
        ));
      }
    }
    content = new Column(
        children: tiles //重点在这里，因为用编辑器写Column生成的children后面会跟一个<Widget>[]，
        //此时如果我们直接把生成的tiles放在<Widget>[]中是会报一个类型不匹配的错误，把<Widget>[]删了就可以了
        );
    return content;
  }

  Widget buildListRow(item) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(36)),
            child: Image.asset(
              'assets/images/${item['iconName']}',
              fit: BoxFit.cover,
              width: Adapt.px(36),
              height: Adapt.px(36),
              package: 'yl_login',
            ),
          ),
          SizedBox(
            width: Adapt.px(12),
          ),
          Text(
            item['title'],
            style: TextStyle(color: ThemeColor.gray1, fontSize: 17),
          ),
        ],
      ),
      onTap: ()  async{
        // print("欧尼tap");
        if(!checkboxSelected){
          CommonToast.instance.show(context, Localized.text("yl_login.Agree to the agreement to log in"));
          return;
        }
        loginSchema = item['schema'];
        _login(captchaStr : loginSchema);
        final prefs = await SharedPreferences.getInstance();
        prefs.setBool('isGuestLogin', false);
        // address = "0x96d7cf71f6391a6092487c0390c4977052e78ddb";
        // loginIm("0x117a2c4041d172a3447797fa3fceea72d2ffd4a2afcbfd954fe90e0a77828f686722ecb633070d8898d82ff2a67c365f398df2c4f6d9c8e2449ca169eb0b3e211b");
      },
    );
  }

  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    super.setState(fn);
    if (_displayUri.length > 0) {
      final uri = loginSchema + "://wc?uri=" + _displayUri;
      print("_displayUri ==== ${_displayUri}");
      _launchUniversalLinkIos(uri);
      // _displayUri = '';
    }
  }

  void _login({String? captchaStr}) async {
    final session = await _transactionTester?.connect(
      onDisplayUri: (uri) => setState(() => _displayUri = uri),
    );
    address = session?.accounts[0] ?? '';

    if (session == null) {
      print('Unable to connect');
      setState(() => _state = TransactionState.failed);
      return;
    }
    setState(() => _state = TransactionState.connected);
    print('success ===' + _displayUri);
    Future.delayed(const Duration(seconds: 1), () async {
      try {
        final walletLoginInfoStr = await _transactionTester?.personalSign(
            message: "Welcome to 0xchat!\n\nClick to sign in and accept the 0xchat Terms of Service\n\nThis request will not trigger a blockchain transaction or cost any gas fees.", address: session.accounts[0], password: '');
        print('my  ------- to sign ----${walletLoginInfoStr}');
        loginIm(walletLoginInfoStr ?? '');
        // setState(() => _state = TransactionState.success);
        LogUtil.e('address: ${session.accounts[0]}');
        YLUserInfo userInfo = YLUserInfo();
        userInfo.token = session.accounts[0];
        YLUserInfoManager.sharedInstance
          .updateUserInfo(userInfo, isUpdate: false);

        Future.delayed(Duration.zero, () {
          YLNavigator.popToPage(context,
            pageId: YLLogin.loginPageId, isPrepage: true);
        });

        LogUtil.e("pop YLLogin");

      } catch (e) {
        print('Transaction error: $e');
      }
    });

  }

  static void walletAuthorization(){

  }

  _transactionStateToString({required TransactionState state}) {
    print(state);
    switch (state) {
      case TransactionState.disconnected:
        return;
      case TransactionState.connecting:
        final uri = "wc" + "://wc?uri=" + _displayUri;
        print(uri);
        // _launchUniversalLinkIos(uri);
        return;

      case TransactionState.connected: //连接成功授权
        print("Session connected, preparing transaction...");
        return;
      case TransactionState.connectionFailed:
        return;
      case TransactionState.transferring:
        return;
      case TransactionState.success:
        return;
      case TransactionState.failed:
        return;
    }
  }

  loginIm(String walletLoginInfoStr) async {
    String? loginInfoStr = await ChatMethodChannelUtils.loginWowChat(
      address, walletLoginInfoStr, '', '', '','');
    if (loginInfoStr!.length > 0) {
      LogUtil.e("xxxxxxxxx====== : ${loginInfoStr}");
      //登录成功
      YLUserInfo userInfo = getUser(loginInfoStr);
      YLUserInfoManager.sharedInstance
          .updateUserInfo(userInfo, isUpdate: false);
      //如果没有设置google提示设置google
      YLNavigator.popToPage(context,
          pageId: YLLogin.loginPageId, isPrepage: true);
      // YLModuleService.pushPage(context, "yl_usercenter", "UserCenterPage", {});
    } else {
      //登录失败

    }
  }

  YLUserInfo getUser(String loginInfoStr) {
    ///后期根据需要的字段再转化
    Map<String, dynamic> user = convert.jsonDecode(loginInfoStr);
    YLUserInfo userInfo = YLUserInfo();
    userInfo.token = user["token"];
    userInfo.nickName = user["nickname"];
    userInfo.userId = user["user_uid"];
    userInfo.email = user["user_mail"];
    userInfo.headUrl = user["userAvatarFileName"];//userAvatarFileName 在ios或者安卓端获取的时候需获取头像链接手动赋值
    userInfo.whatsUp = user["whatsUp"];
    return userInfo;
  }

  Future<void> _launchUniversalLinkIos(String url) async {
    final bool nativeAppLaunchSucceeded = await launch(url);
  }

  void _unfocusAllNode(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }
}
