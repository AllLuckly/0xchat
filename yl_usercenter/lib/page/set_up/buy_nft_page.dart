import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:images_picker/images_picker.dart';
import 'package:yl_common/log_util.dart';
import 'package:yl_common/model/yl_user_info.dart';
import 'package:yl_common/navigator/navigator.dart';
import 'package:yl_common/utils/adapt.dart';
import 'package:yl_common/utils/theme_color.dart';
import 'package:yl_common/utils/yl_userinfo_manager.dart';
import 'package:yl_common/widgets/common_appbar.dart';
import 'package:yl_common/widgets/common_hint_dialog.dart';
import 'package:yl_common/widgets/common_toast.dart';
import 'package:yl_common/widgets/yl_loading.dart';
import 'package:yl_localizable/yl_localizable.dart';

import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/billing_client_wrappers.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'package:yl_module_service/yl_module_service.dart';

import 'consumable_store.dart';
import 'package:yl_common/utils/in_app_purchase_verification_ios.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

// const String _kConsumableId = 'com.purchasess.app.vip';

const String _kConsumableId = 'com.0xchat.appnft';


class BuyNftPage extends StatefulWidget {
  const BuyNftPage({Key? key}) : super(key: key);

  @override
  State<BuyNftPage> createState() => _BuyNftPageState();
}

class _BuyNftPageState extends State<BuyNftPage> {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  ProductDetails? buyProductDetails;
  late bool isGuestLogin;

  YLUserInfo? mCurrentUserInfo;
  String mHostName = '';
  String? imgPath;

  @override
  void initState() {
    final Stream<List<PurchaseDetails>> purchaseUpdated =
      _inAppPurchase.purchaseStream;
    _subscription =
      purchaseUpdated.listen((List<PurchaseDetails> purchaseDetailsList) {
        _listenToPurchaseUpdated(purchaseDetailsList);
      }, onDone: () {
        LogUtil.e('error: onDone');
        _subscription.cancel();
      }, onError: (Object error) {
        // handle error here.
        LogUtil.e('error: ${error.toString()}');
      });
    initStoreInfo();
    super.initState();
  }

  Future<void> initStoreInfo() async {
    final prefs = await SharedPreferences.getInstance();
    isGuestLogin = (await prefs.getBool('isGuestLogin'))!;
    final bool isAvailable = await _inAppPurchase.isAvailable();

    if (!isAvailable) {
      CommonToast.instance.show(context, Localized.text("yl_usercenter.in_app_purchases_no_available"));
      LogUtil.e('IAPError ====== !isAvailable');
      setState(() {
      });
      return;
    }

    bool isVerification = await handleLocalValidation();
    if(isVerification){//提醒一下或者别的什么操作
      YLCommonHintDialog.show(context,title: Localized.text('yl_usercenter.unfinished_order_sos'),actionList: [
        YLCommonHintAction.sure(text: Localized.text('yl_usercenter.next_step') , onTap: () {
          YLNavigator.pop(context);
          updateNFT();
        }),
        YLCommonHintAction.cancel(onTap: (){
          YLNavigator.pop(context);
        }),
      ]);
    }

    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
      _inAppPurchase
        .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      await iosPlatformAddition.setDelegate(ExamplePaymentQueueDelegate());
    }
    const Set<String> _kIds = <String>{_kConsumableId};
    final ProductDetailsResponse productDetailResponse =
    // await _inAppPurchase.queryProductDetails(["com.0xchat.appnft"].toSet());

    await _inAppPurchase.queryProductDetails(_kIds);
    if (productDetailResponse.error != null) {

      setState(() {

      });
      return;
    }

    if (productDetailResponse.productDetails.isEmpty) {
      setState(() {

      });
      return;
    }

    buyProductDetails = productDetailResponse.productDetails.first;
    setState(() {

    });

  }


  @override
  void dispose() {
    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
      _inAppPurchase
        .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      iosPlatformAddition.setDelegate(null);
    }
    _subscription.cancel();
    super.dispose();
  }

  Future<void> _listenToPurchaseUpdated(
    List<PurchaseDetails> purchaseDetailsList) async {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {

      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          handleError(purchaseDetails.error!);
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
          purchaseDetails.status == PurchaseStatus.restored) {
            deliverProduct(purchaseDetails);
        }else if(purchaseDetails.status == PurchaseStatus.canceled){//取消购买
          if (purchaseDetails.productID == _kConsumableId) {
            await _inAppPurchase.completePurchase(purchaseDetails);
            CommonToast.instance.show(context, Localized.text("yl_usercenter.Cancel purchase"));
          }
        }
        if (purchaseDetails.pendingCompletePurchase) {
          await _inAppPurchase.completePurchase(purchaseDetails);
        }
      }
    }
  }

  void handleError(IAPError error) {
    setState(() {
      // _purchasePending = false;
    });
  }

  Future<void> deliverProduct(PurchaseDetails purchaseDetails) async {
    // IMPORTANT!! Always verify purchase details before delivering the product.
    if (purchaseDetails.productID == _kConsumableId) {
      updateNFT();
      setState(() {
        // _purchasePending = false;
      });
    } else {
      setState(() {
        // _purchases.add(purchaseDetails);
        // _purchasePending = false;
      });
    }
  }

  void _handleInvalidPurchase(PurchaseDetails purchaseDetails) {

    LogUtil.e('IAPError =_handleInvalidPurchase===== ${purchaseDetails.toString()}');
    // handle invalid purchase here if  _verifyPurchase` failed.
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) async {
    // purchaseDetails.verificationData.serverVerificationData;
    // IMPORTANT!! Always verify a purchase before delivering the product.
    // For the purpose of an example, we directly return true.
    saveVerificationData(purchaseDetails.verificationData.localVerificationData);
    YLLoading.dismiss();
    _inAppPurchase.completePurchase(purchaseDetails);

    //拿到 purchaseDetails.verificationData.serverVerificationData   给服务器验证一波 验证通过就开始上传图片冲冲冲
    LogUtil.e("localVerificationData : ${purchaseDetails.verificationData.localVerificationData}");
    LogUtil.e("serverVerificationData : ${purchaseDetails.verificationData.serverVerificationData}");
    LogUtil.e("source : ${purchaseDetails.verificationData.source}");
    // base64EncodedReceipt   base64Encode(utf8.encode(str))
    LogUtil.e("serverVerificationDataxxxx0");
    // LogUtil.e("serverVerificationDataxxxx1 : ${base64Decode(purchaseDetails.verificationData.serverVerificationData)}");
    LogUtil.e("serverVerificationDataxxxx1 : ${base64Decode(purchaseDetails.verificationData.serverVerificationData)}");
    //
    // Map param = {
    //   "transactionId" : purchaseDetails.purchaseID,
    //   "receipt": purchaseDetails.verificationData.serverVerificationData,
    // };
    return await handleValidation(verificationData: purchaseDetails.verificationData.serverVerificationData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.bgColor,
      appBar: CommonAppBar(
        title: Localized.text('yl_usercenter.NFT Purchase'),
        useLargeTitle: false,
        centerTitle: true,
        canBack: false,
      ),
      body: buildBoby(),
    );
  }

  Widget buildBoby() {
    return Container(
        child: Column(
          children: [
          SizedBox(
            height: Adapt.px(60),
          ),
          Container(
            margin: EdgeInsets.only(left: Adapt.px(16), right: Adapt.px(16)),
            child: Text("Mint a NFT on matic chain as your avator"),
          ),
          SizedBox(
            height: Adapt.px(30),
          ),
          Container(
            margin: EdgeInsets.only(left: Adapt.px(16), right: Adapt.px(16)),
            child: Text("Try to refresh minutes later after purchase"),
          ),
          SizedBox(
            height: Adapt.px(50),
          ),
          GestureDetector(
              child: Container(
                margin: EdgeInsets.only(
                  left: Adapt.px(16), right: Adapt.px(16), top: Adapt.px(16)),
                decoration: BoxDecoration(
                  color: ThemeColor.gray5,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                height: Adapt.px(40),
                child: Center(
                  child: Text(
                    buyProductDetails == null
                      ? Localized.text('yl_usercenter.NFT Purchase')
                      : "${buyProductDetails?.price} ${Localized.text('yl_usercenter.NFT Purchase')}",
                    style: TextStyle(color: ThemeColor.titleColor),
                  ),
                ),
              ),
              onTap: ()  {
                if(isGuestLogin == true){//游客登录
                  YLCommonHintDialog.show(context,title: Localized.text('yl_usercenter.buying_sos_tourist'),actionList: [
                    YLCommonHintAction.sure(text: Localized.text('yl_usercenter.NFT Purchase') , onTap: () {
                        YLNavigator.pop(context);
                        buyConsumable();
                    }),
                    YLCommonHintAction.cancel(onTap: (){
                      YLNavigator.pop(context);
                    }),
                  ]);
                }else{
                  buyConsumable();
                }
              },
            ),
          ],
        ),


    );
  }

  void buyConsumable() async{
    YLLoading.show(
      status:
      Localized.text('yl_usercenter.buy_not_leave'));
    if (buyProductDetails == null) {
      const Set<String> _kIds = <String>{_kConsumableId};
      final ProductDetailsResponse productDetailResponse =
        await _inAppPurchase.queryProductDetails(_kIds);
      if (productDetailResponse.error != null) {
        YLLoading.dismiss();
        LogUtil.e("NFT Purchase : ${productDetailResponse.error}");
        return;
      }
      if (productDetailResponse.notFoundIDs.isNotEmpty) {
        // Handle the error.
        YLLoading.dismiss();
        LogUtil.e(
          "NFT Purchase : isNotEmpty ${productDetailResponse.notFoundIDs}");
        return;
      }
      if (productDetailResponse.productDetails.isEmpty) {
        YLLoading.dismiss();
        LogUtil.e("NFT Purchase : isEmpty");
        return;
      }
      _inAppPurchase.buyConsumable(
        purchaseParam: PurchaseParam(
          productDetails: productDetailResponse.productDetails.first));
    } else {
      _inAppPurchase.buyConsumable(
        purchaseParam: PurchaseParam(productDetails: buyProductDetails!));
    }
  }


  void updateNFT() async{
    final ImagesPicker _picker = ImagesPicker();
    List<Media>? imageFile = await ImagesPicker.pick(
      count: 1, // 最大可选择数量
      pickType: PickType.image, // 选择媒体类型，默认图片
      gif: false,
    );
    if(imageFile == null){
      return;
    }
    print("${imageFile[0].path}");
    imgPath = imageFile[0].path;
    YLLoading.show(
      status:
      Localized.text('yl_usercenter.buy_not_leave'));
    final String headUrl =  await YLModuleService.invoke("yl_wowchat", "processImagePickerComplete", [imgPath]);
    YLLoading.dismiss();
    // mCurrentUserInfo?.headUrl = headUrl;
    // YLUserInfoManager.sharedInstance.updateUserInfo(mCurrentUserInfo!);
    if(headUrl.length > 0){
      final String? verificationData = await getLocalVerificationData();
      removeVerificationData();
      CommonToast.instance.show(context, Localized.text("yl_usercenter.purchase_successful"));
    }
    setState(() {

    });
  }

}



class ExamplePaymentQueueDelegate implements SKPaymentQueueDelegateWrapper {
  @override
  bool shouldContinueTransaction(
    SKPaymentTransactionWrapper transaction, SKStorefrontWrapper storefront) {
    return true;
  }

  @override
  bool shouldShowPriceConsent() {
    return false;
  }
}