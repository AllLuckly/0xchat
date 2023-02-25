
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:trust_wallet_core/flutter_trust_wallet_core.dart';
import 'package:yl_common/log_util.dart';
import 'package:yl_common/navigator/navigator.dart';
import 'package:yl_common/utils/theme_color.dart';
import 'package:roundcheckbox/roundcheckbox.dart';
import 'package:yl_common/utils/adapt.dart';
import 'package:yl_common/widgets/common_toast.dart';
import 'package:yl_localizable/yl_localizable.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:yl_common/widgets/modal_bottom_sheet/modals/modal_with_navigator.dart';
import 'package:yl_login/page/wallet/wallet_created_success_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:trust_wallet_core/trust_wallet_core_ffi.dart';



import 'package:convert/convert.dart';

import '../../channel/create_wallet_address_tools.dart';
// import 'package:trust_wallet_core/trust_wallet_core.dart';

// import '../../wallet_core/ethereum_example.dart';


class AuthorizationNoticeWidget extends StatefulWidget {
  final String platformUniqueKey;//钱包备份助记词
  AuthorizationNoticeWidget(this.platformUniqueKey);

  @override
  State<AuthorizationNoticeWidget> createState() => _AuthorizationNoticeWidgetState();
}

class _AuthorizationNoticeWidgetState extends State<AuthorizationNoticeWidget> {
  bool isSelected = false;
  // late HDWallet wallet;

  @override
  void initState() {
    // FlutterTrustWalletCore.init();
    super.initState();
    // try{
    //   wallet = HDWallet();
    // }catch(e){
    //   CommonToast.instance.show(context, 'xxxx222 === ${e.toString()}');
    // }
  }

  initCrash() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isGuestLogin', false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: Adapt.px(350),
      ),
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 20,),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 16,
                ),
                GestureDetector(
                  child: Icon(Icons.arrow_back_ios_outlined),
                  onTap:() =>  Navigator.of(context).pop(),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(Localized.text("yl_login.Authorization notice")),
                  ),
                ),
                SizedBox(
                  width: 46,
                ),
              ],
            ),
          ),
          SizedBox(height: Adapt.px(26),),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Spacer(),
              SizedBox(width: Adapt.px(16),),
              RoundCheckBox(
                isChecked:isSelected,
                size: Adapt.px(20),
                onTap: (selected) {
                  setState(() {
                    isSelected = selected!;
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
              Expanded(
                child: Text(
                  Localized.text("yl_login.I_have_read_and_accept_Privacy_Policy"),
                  style: TextStyle(color: ThemeColor.titleColor),
                ),
              ),
              // Spacer(),
              SizedBox(width: Adapt.px(16),),
            ],
          ),
          SizedBox(height: 10,),
          Row(
            children: [
              SizedBox(width: 16,),
              GestureDetector(
                child: Text(
                  // Localized.text('yl_login.create_wallet'),
                  Localized.text("yl_login.<Terms of Service>"),
                  style: TextStyle(
                    color: ThemeColor.purple1,
                    fontSize: 15,
                  ),
                ),
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
            ],
          ),
          SizedBox(height: 10,),

          Row(
            children: [
              SizedBox(width: 16,),
              GestureDetector(
                child: Text(
                  Localized.text('yl_login.<privacy policy>'),
                  // "《隐私权政策》",
                  style: TextStyle(
                    color: ThemeColor.purple1,
                    fontSize: 15,
                  ),
                ),
                onTap: () => showBarModalBottomSheet(
                  expand: true,
                  context: context,
                  backgroundColor: ThemeColor.gray5,
                  builder: (context) => ModalWithNavigator(
                    title: Localized.text("yl_login.terms_of_service"),
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

          SizedBox(height: 28,),

          Container(
            color: ThemeColor.gray5,
            height: 1,
          ),

          GestureDetector(
            child: Container(
              width: double.infinity,
              alignment: Alignment.center,
              height: 55,
              child: Text(
                Localized.text("yl_login.I see"),
                style: TextStyle(color: isSelected ? ThemeColor.purple1 : ThemeColor.gray4, fontSize: 17),
              ),
            ),
            onTap: () async{
              if(isSelected == false){
                return;
              }
              // final publicKey = wallet.getKeyForCoin(TWCoinType.TWCoinTypeEthereum).getPublicKeySecp256k1(false);
              // AnyAddress anyAddress = AnyAddress.createWithPublicKey(publicKey, TWCoinType.TWCoinTypeEthereum);
              // LogUtil.e("address from any address: ${anyAddress.description()}");
              // LogUtil.e("wallet.mnemonic() === : ${wallet.mnemonic()}");//助记词
              // String privateKeyhex = hex.encode(wallet.getKeyForCoin(TWCoinType.TWCoinTypeEthereum).data());
              // LogUtil.e("privateKeyhex: $privateKeyhex");
              // LogUtil.e("seed = ${hex.encode(wallet.seed())}");
              // final keystore = StoredKey.importPrivateKey(wallet.getKeyForCoin(TWCoinType.TWCoinTypeEthereum).data(), "name", "password", TWCoinType.TWCoinTypeEthereum);
              // LogUtil.e("keystore: ${keystore?.exportJson()}");

              WalletInfo walletInfo = await getWalletAddress();
              final prefs = await SharedPreferences.getInstance();
              prefs.setString("mnemonic", walletInfo.mnemonic!);
              Navigator.of(context).pop();
              YLNavigator.pushPage(
                context,
                  (context) => WalletCreatedSuccessPage(walletAddress: walletInfo.address!,mnemonic: walletInfo.mnemonic!, platformUniqueKey: widget.platformUniqueKey,),
              );
              // YLNavigator.pushPage(
              //   context,
              //     (context) => WalletCreatedSuccessPage(walletAddress: anyAddress.description(),mnemonic: wallet.mnemonic(), platformUniqueKey: widget.platformUniqueKey!,),
              // );
            },
          )
        ],
      ),
    );
    // return Column(
    //   mainAxisSize: MainAxisSize.min,
    //   crossAxisAlignment: CrossAxisAlignment.start,
    //   children: <Widget>[
    //     SizedBox(height: 20,),
    //     Container(
    //       child: Row(
    //         mainAxisAlignment: MainAxisAlignment.start,
    //         children: [
    //           SizedBox(
    //             width: 16,
    //           ),
    //           GestureDetector(
    //             child: Icon(Icons.arrow_back_ios_outlined),
    //             onTap:() =>  Navigator.of(context).pop(),
    //           ),
    //           Expanded(
    //             child: Container(
    //               alignment: Alignment.center,
    //               child: Text('授权须知'),
    //             ),
    //           ),
    //           SizedBox(
    //             width: 46,
    //           ),
    //         ],
    //       ),
    //     ),
    //     SizedBox(height: Adapt.px(26),),
    //     Row(
    //       crossAxisAlignment: CrossAxisAlignment.center,
    //       children: [
    //         Spacer(),
    //         RoundCheckBox(
    //           isChecked:isSelected,
    //           size: Adapt.px(20),
    //           onTap: (selected) {
    //             setState(() {
    //               isSelected = selected!;
    //             });
    //           },
    //           border: Border.all(
    //             width: 1,
    //             color: ThemeColor.titleColor,
    //           ),
    //           disabledColor: ThemeColor.titleColor,
    //           uncheckedColor: Colors.transparent,
    //           checkedColor: Colors.transparent,
    //           checkedWidget: Container(
    //             width: Adapt.px(18),
    //             height: Adapt.px(18),
    //             decoration: new BoxDecoration(
    //               color: ThemeColor.purple1,
    //               borderRadius: BorderRadius.all(Radius.circular(18.0)),
    //               border: new Border.all(
    //                 width: 1, color: Colors.transparent),
    //             ),
    //             // child: Icon(Icons.check, color: Colors.white),
    //           ),
    //         ),
    //         SizedBox(
    //           width: Adapt.px(8),
    //         ),
    //         Text(
    //           // Localized.text('yl_login.terms_of_service_privacy_policy'),
    //           "我已阅读并接受 Trust钱包的服务条款和隐私权政策。",
    //           style: TextStyle(color: ThemeColor.titleColor),
    //
    //         ),
    //         Spacer(),
    //       ],
    //     ),
    //     SizedBox(height: 10,),
    //     Row(
    //       children: [
    //         SizedBox(width: 16,),
    //         GestureDetector(
    //           child: Text(
    //             // Localized.text('yl_login.create_wallet'),
    //             "《服务条款》",
    //             style: TextStyle(
    //               color: ThemeColor.purple1,
    //               fontSize: 15,
    //             ),
    //           ),
    //           onTap: () => showBarModalBottomSheet(
    //             expand: true,
    //             context: context,
    //             backgroundColor: ThemeColor.gray5,
    //             builder: (context) => ModalWithNavigator(
    //               title: Localized.text("yl_login.terms_of_service"),
    //               child: Container(
    //                 child: WebView(
    //                   initialUrl: 'https://www.0xchat.com/protocols/0xchat_terms_of_use.html',
    //                   onWebViewCreated: (WebViewController webViewController) {
    //                     // controller = webViewController;
    //                   },
    //                 ),
    //               ),
    //             ),
    //           ),
    //         ),
    //       ],
    //     ),
    //     SizedBox(height: 10,),
    //
    //     Row(
    //       children: [
    //         SizedBox(width: 16,),
    //         GestureDetector(
    //           child: Text(
    //             // Localized.text('yl_login.create_wallet'),
    //             "《隐私权政策》",
    //             style: TextStyle(
    //               color: ThemeColor.purple1,
    //               fontSize: 15,
    //             ),
    //           ),
    //           onTap: () => showBarModalBottomSheet(
    //             expand: true,
    //             context: context,
    //             backgroundColor: ThemeColor.gray5,
    //             builder: (context) => ModalWithNavigator(
    //               title: Localized.text("yl_login.terms_of_service"),
    //               child: Container(
    //                 child: WebView(
    //                   initialUrl: 'https://www.0xchat.com/protocols/0xchat_privacy_policy.html',
    //                   onWebViewCreated: (WebViewController webViewController) {
    //                     // controller = webViewController;
    //                   },
    //                 ),
    //               ),
    //             ),
    //           ),
    //         ),
    //       ],
    //     ),
    //
    //     SizedBox(height: 28,),
    //
    //     Container(
    //       color: ThemeColor.gray5,
    //       height: 1,
    //     ),
    //
    //     GestureDetector(
    //       child: Container(
    //         width: double.infinity,
    //         alignment: Alignment.center,
    //         height: 55,
    //         child: Text(
    //           "我知道了",
    //           style: TextStyle(color: isSelected ? ThemeColor.purple1 : ThemeColor.gray4, fontSize: 17),
    //         ),
    //       ),
    //       onTap: (){
    //         if(isSelected == false){
    //           return;
    //         }
    //         final publicKey = wallet.getKeyForCoin(TWCoinType.TWCoinTypeEthereum).getPublicKeySecp256k1(false);
    //         AnyAddress anyAddress = AnyAddress.createWithPublicKey(publicKey, TWCoinType.TWCoinTypeEthereum);
    //         LogUtil.e("address from any address: ${anyAddress.description()}");
    //         LogUtil.e("wallet.mnemonic() === : ${wallet.mnemonic()}");//助记词
    //         String privateKeyhex = hex.encode(wallet.getKeyForCoin(TWCoinType.TWCoinTypeEthereum).data());
    //         LogUtil.e("privateKeyhex: $privateKeyhex");
    //         LogUtil.e("seed = ${hex.encode(wallet.seed())}");
    //         final keystore = StoredKey.importPrivateKey(wallet.getKeyForCoin(TWCoinType.TWCoinTypeEthereum).data(), "name", "password", TWCoinType.TWCoinTypeEthereum);
    //         LogUtil.e("keystore: ${keystore?.exportJson()}");
    //         Navigator.of(context).pop();
    //         YLNavigator.pushPage(
    //           context,
    //             (context) => WalletCreatedSuccessPage(walletAddress: anyAddress.description(),mnemonic: wallet.mnemonic(), platformUniqueKey: widget.platformUniqueKey,),
    //         );
    //       },
    //     )
    //   ],
    // );
  }
}
