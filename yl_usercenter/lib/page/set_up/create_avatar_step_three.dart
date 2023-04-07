import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:yl_common/log_util.dart';
import 'package:yl_common/navigator/navigator.dart';
import 'package:yl_common/utils/adapt.dart';
import 'package:yl_common/utils/theme_color.dart';
import 'package:yl_common/utils/yl_userinfo_manager.dart';
import 'package:yl_common/widgets/common_appbar.dart';
import 'package:yl_common/widgets/common_gradient_border_widget.dart';
import 'package:yl_common/widgets/common_hint_dialog.dart';
import 'package:yl_common/widgets/common_image.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:yl_common/widgets/common_toast.dart';
import 'package:yl_common/widgets/common_webview.dart';
import 'package:yl_common/widgets/yl_loading.dart';
import 'package:yl_localizable/yl_localizable.dart';
import 'package:yl_module_service/yl_module_service.dart';

import 'package:yl_usercenter/model/my_product_list_entity.dart';
import 'package:yl_usercenter/uitls/choose_image_upload.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'package:yl_common/utils/in_app_purchase_verification_ios.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../nft_avatar/nft_avatar_upload_page.dart';
import 'avatar_shop_details_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateAvatarStepThree extends StatefulWidget {
  List<File?> fileList;
  int gender;

  CreateAvatarStepThree(
      {Key? key, required this.fileList, required this.gender})
      : super(key: key);

  @override
  State<CreateAvatarStepThree> createState() => _CreateAvatarStepThreeState();
}

class _CreateAvatarStepThreeState extends State<CreateAvatarStepThree> {
  int seletIndex = 0;
  List<String> titleList = ['Female', 'Male', 'Other'];
  MyProductListEntity? assetsEntity;
  // final String InsidePurchaseSubscribeID = 'com.subscribe.app.vip';

  final String InsidePurchaseSubscribeID = 'com.0xchat.nft.avatar.month';

  late bool isGuestLogin;
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  ProductDetails? buyProductDetails;
  ProductDetails? buySubscribeProductDetails;

  //
  @override
  void initState() {
    super.initState();
    getData();
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
  }

  Future<void> initStoreInfo() async {
    final prefs = await SharedPreferences.getInstance();
    isGuestLogin = (await prefs.getBool('isGuestLogin'))!;
    final bool isAvailable = await _inAppPurchase.isAvailable();

    if (!isAvailable) {
      CommonToast.instance.show(context, Localized.text("yl_usercenter.in_app_purchases_no_available"));
      LogUtil.e('IAPError ====== !isAvailable');
      if(mounted){
        setState(() {
          // _purchasePending = false;
        });
      }
      return;
    }

    // bool isVerification = await handleLocalValidation();
    // if(isVerification){//提醒一下或者别的什么操作
    //   YLCommonHintDialog.show(context,title: Localized.text('yl_usercenter.unfinished_order_sos'),actionList: [
    //     YLCommonHintAction.sure(text: Localized.text('yl_usercenter.next_step') , onTap: () async {
    //       YLNavigator.pop(context);
    //       final verificationData = await getLocalVerificationData();
    //       // updateNFT(verificationData!);
    //       verifyInsiderPurchase(verificationData!);
    //     }),
    //     YLCommonHintAction.cancel(onTap: (){
    //       YLNavigator.pop(context);
    //     }),
    //   ]);
    // }

    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
      _inAppPurchase
        .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      await iosPlatformAddition.setDelegate(ExamplePaymentQueueDelegate());

      var paymentWrapper = SKPaymentQueueWrapper();
      var transactions = await paymentWrapper.transactions();
      transactions.forEach((transaction) async {
        await paymentWrapper.finishTransaction(transaction);
      });


    }

    if(mounted){
      setState(() {
        // _purchasePending = false;
      });
    }

  }

  getData() async {
    ChooseImageUploadNetManage.getPriceListAndWhetherToSubscribe(
            ownerAddress:
                YLUserInfoManager.sharedInstance.currentUserInfo?.token ?? '')
        .then((value) {
      assetsEntity = value;
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: ThemeColor.bgColor,
        appBar: CommonAppBar(
          title: 'Step 3/3',
          useLargeTitle: false,
          centerTitle: true,
          canBack: false,
        ),
        bottomNavigationBar: bottomNavigationView(),
        body: SafeArea(
            child: CustomScrollView(slivers: [
          SliverList(
            delegate: SliverChildListDelegate(List.generate(
                assetsEntity?.productList?.length ?? 0, (int index) {
              return itemBuilder(context, index);
            })),
          ),
          SliverToBoxAdapter(
            child: Container(
              alignment: Alignment.center,
              child: Text(
                "Check Out",
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 32,
                    color: ThemeColor.color0),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.only(
                  left: Adapt.px(24), right: Adapt.px(24), top: Adapt.px(12)),
              alignment: Alignment.center,
              child: Text(
                  "0xavatar will create an NFT avatar for you on the blockchain, the only and permanent blockchain, which will consume a certain amount of gas fees, and we are working hard to make it cheaper.",
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: ThemeColor.color60),
                  textAlign: TextAlign.center),
            ),
          ),
        ])));
  }

  Widget bottomNavigationView() {
    return Container(
      height: Platform.isIOS ? Adapt.px(170) : Adapt.px(60),
      child: Column(
        children: [
          GestureDetector(
            child: Container(
              alignment: Alignment.center,
              height: Adapt.px(48),
              margin: EdgeInsets.only(
                  left: Adapt.px(24),
                  right: Adapt.px(24),
                  bottom: Adapt.px(20)),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                  Radius.circular(12),
                ),
                border: Border.all(color: ThemeColor.color180, width: 2),
                gradient: LinearGradient(
                    colors: [ThemeColor.gradientMainStart, ThemeColor.gradientMainEnd]),
              ),
              child: Text(
                'Creat NFT Avatar',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: ThemeColor.color0),
                textAlign: TextAlign.center,
              ),
            ),
            onTap: () async {
              String purchasingId = Platform.isIOS ?
              assetsEntity?.productList![seletIndex].inPurchasingId ?? '' :
              assetsEntity?.productList![seletIndex].inPurchasingIdAndroid ?? '';
              if(Platform.isIOS){
                if(purchasingId == 'nft.avatar.sale.5'){//苹果后台被删了,无法创建一样的id,后台暂未修改本地写死
                  purchasingId = 'nft.avatar.sale.five';
                }
              }
              // Set<String> _kIds = <String>{purchasingId};
              // final ProductDetailsResponse productDetailResponse = await _inAppPurchase.queryProductDetails(_kIds);
              // if (productDetailResponse.error != null) {
              //   setState(() {
              //   });
              //   return;
              // }
              // if (productDetailResponse.productDetails.isEmpty) {
              //   setState(() {
              //   });
              //   return;
              // }
              // buyProductDetails = productDetailResponse.productDetails.first;
              // buyConsumable(purchasingId);
              // com.purchasess.app.vip

              if(isGuestLogin == true){//游客登录
                YLCommonHintDialog.show(context,title: Localized.text('yl_usercenter.buying_sos_tourist'),actionList: [
                  YLCommonHintAction.sure(text: Localized.text('yl_usercenter.buy_now') , onTap: () {
                    YLNavigator.pop(context);
                    if (Platform.isIOS) {//ios 暂时测试
                      // buyConsumable('com.purchasess.app.vip');
                      buyConsumable(purchasingId);
                    }else{
                      buyConsumable(purchasingId);
                    }
                  }),
                  YLCommonHintAction.cancel(onTap: (){
                    YLNavigator.pop(context);
                  }),
                ]);
              }else{
                if (Platform.isIOS) {//ios 暂时测试
                  // buyConsumable('com.purchasess.app.vip');
                  buyConsumable(purchasingId);
                }else{
                  buyConsumable(purchasingId);
                }
              }
            },
          ),
          Platform.isIOS
              ? GestureDetector(
                  child: Container(
                    alignment: Alignment.center,
                    height: Adapt.px(48),
                    margin: EdgeInsets.only(
                        left: Adapt.px(24),
                        right: Adapt.px(24),
                        bottom: Adapt.px(12)),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(12),
                      ),
                      border: Border.all(color: ThemeColor.color180, width: 2),
                      gradient: LinearGradient(
                          colors: [ThemeColor.color180, ThemeColor.color180]),
                    ),
                    child: Text(
                      'Subscribe: Get 50% Off',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: ThemeColor.color0),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  onTap: () {//订阅购买
                    if(isGuestLogin == true){//游客登录
                      YLCommonHintDialog.show(context,title: Localized.text('yl_usercenter.buying_sos_tourist'),actionList: [
                        YLCommonHintAction.sure(text: Localized.text('yl_usercenter.buy_now') , onTap: () {
                          YLNavigator.pop(context);
                            buySubscribeConsumable();
                        }),
                        YLCommonHintAction.cancel(onTap: (){
                          YLNavigator.pop(context);
                        }),
                      ]);
                    }else{
                      buySubscribeConsumable();
                    }
                  },
                )
              : Container(),
          Platform.isIOS
              ? Container(
                  margin: EdgeInsets.only(
                      left: Adapt.px(24),
                      right: Adapt.px(24),
    ),
                  child: Row(
                    children: [
                      GestureDetector(
                        child: GradientText('Term of use',
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                                color: ThemeColor.color110),
                            colors: [ThemeColor.color110, ThemeColor.color110]),
                        onTap: () {
                          YLNavigator.pushPage(
                            context,
                              (context) => CommonWebView('https://www.0xchat.com/protocols/0xchat_nftavatar_terms_of_use.html',
                              title: 'Term of use',
                            ),
                          );
                        },
                      ),
                      Spacer(),
                      GestureDetector(
                        child: GradientText('Restore purchase',
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                                color: ThemeColor.titleColor),
                            colors: [
                              ThemeColor.gradientMainStart,
                              ThemeColor.gradientMainEnd
                            ]),
                        onTap: () async {// 恢复购买
                          await InAppPurchase.instance.restorePurchases();
                        },
                      ),
                      Spacer(),
                      GestureDetector(
                        child: GradientText('Privacy policy',
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                                color: ThemeColor.color110),
                            colors: [ThemeColor.color110, ThemeColor.color110]),
                        onTap: () {
                          YLNavigator.pushPage(
                            context,
                              (context) => CommonWebView('https://www.0xchat.com/protocols/0xchat_nftavatar_privacy_policy.html',
                              title: 'Privacy policy',
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                )
              : Container()
        ],
      ),
    );
  }

  void buyConsumable(String consumableId) async{
    YLLoading.show(
      status:
      Localized.text('yl_usercenter.buy_not_leave'));
    if (buyProductDetails == null) {
      Set<String> _kIds = <String>{consumableId};
      final ProductDetailsResponse productDetailResponse =
      await _inAppPurchase.queryProductDetails(_kIds);
      if (productDetailResponse.error != null) {
        YLLoading.dismiss();
        LogUtil.e("NFT Purchase : productDetailResponse.error =${productDetailResponse.error}");
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

  void buySubscribeConsumable() async{
    YLLoading.show(
      status:
      Localized.text('yl_usercenter.buy_not_leave'));
    if (buySubscribeProductDetails == null) {
      Set<String> _kIds = <String>{InsidePurchaseSubscribeID};
      final ProductDetailsResponse productDetailResponse =
      await _inAppPurchase.queryProductDetails(_kIds);
      if (productDetailResponse.error != null) {
        YLLoading.dismiss();
        LogUtil.e("NFT Purchase : productDetailResponse.error =${productDetailResponse.error}");
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

      _inAppPurchase.buyNonConsumable(purchaseParam: PurchaseParam(
        productDetails: productDetailResponse.productDetails.first));
    } else {

      _inAppPurchase.buyNonConsumable(purchaseParam: PurchaseParam(productDetails: buySubscribeProductDetails!));
    }
  }

  ///去后台重新验证购买
  void verifyInsiderPurchase(String receiptData) async{
    Map<String, dynamic> dataMap = {
      "nftId" : "",
      "receiptData":receiptData,
      "ownerAddress":YLUserInfoManager.sharedInstance.currentUserInfo?.token ?? '',
      "validationType" : 1, //验证类型：0：购买nft商品   1：购买nft头像
    };
    final dataJson = await YLModuleService.invoke("yl_wowchat", "buyNftData", [dataMap]);
    YLLoading.dismiss();
    if(dataJson){//购买成功 跳转逻辑
      removeVerificationData();
      // YLNavigator.pop(context);
      // CommonToast.instance.show(context, Localized.text("yl_usercenter.purchase_success"));

      YLNavigator.pushPage(context, (context) => NFTAvatarUploadPage(fileList: widget.fileList,gender: widget.gender,nftAvatarCount : assetsEntity?.productList?[seletIndex].nftAvatarCount ?? 0, productId: assetsEntity?.productList?[seletIndex].productId ?? '',));
    }else{
      CommonToast.instance.show(context, Localized.text("yl_usercenter.Cancel purchase"));
    }
    LogUtil.e("updateNFT dataJson: ${dataJson}");
  }


  Future<void> _listenToPurchaseUpdated(
    List<PurchaseDetails> purchaseDetailsList) async {
    LogUtil.e("_listenToPurchaseUpdated : 0xxxxxx");
    LogUtil.e("_listenToPurchaseUpdated : 0${assetsEntity?.productList![seletIndex].inPurchasingId}");
    String purchasingId = Platform.isIOS ?
    assetsEntity?.productList![seletIndex].inPurchasingId ?? '' :
    assetsEntity?.productList![seletIndex].inPurchasingIdAndroid ?? '';
    if(Platform.isIOS){
      if(purchasingId == 'nft.avatar.sale.5'){//苹果后台被删了,无法创建一样的id,后台暂未修改本地写死
        purchasingId = 'nft.avatar.sale.five';
      }
    }
    LogUtil.e("_listenToPurchaseUpdated : 1${assetsEntity?.productList![seletIndex].inPurchasingId}");
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {

      if (purchaseDetails.status == PurchaseStatus.pending) {

      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          await _inAppPurchase.completePurchase(purchaseDetails);
          handleError(purchaseDetails.error!);
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
          purchaseDetails.status == PurchaseStatus.restored) {
          LogUtil.e("xxxxxxx 恢复购买");
          if(purchaseDetails.productID == InsidePurchaseSubscribeID){//订阅验证
            bool? isTrue =
            await ChooseImageUploadNetManage.postRecordsAfterSubscription(
              ownerAddress:
              YLUserInfoManager.sharedInstance.currentUserInfo?.token ?? '',
              receiptData:
              purchaseDetails.verificationData.localVerificationData);
            if(isTrue == true){
              CommonToast.instance.show(context, Localized.text("yl_usercenter.purchase_successful"));
              getData();
            }else{
              CommonToast.instance.show(context, Localized.text("yl_usercenter.Cancel purchase"));
            }
            // if(mounted){ //your code
            //   setState(() {
            //     // _purchasePending = false;
            //   });
            // }
          }else{
            LogUtil.e("message");
            deliverProduct(purchaseDetails);
          }

        }else if(purchaseDetails.status == PurchaseStatus.canceled){//取消购买
          if (purchaseDetails.productID == purchasingId) {
            await _inAppPurchase.completePurchase(purchaseDetails);
            CommonToast.instance.show(context, Localized.text("yl_usercenter.Cancel purchase"));
          }else if(purchaseDetails.productID == InsidePurchaseSubscribeID){//订阅
            await _inAppPurchase.completePurchase(purchaseDetails);
            CommonToast.instance.show(context, Localized.text("yl_usercenter.Cancel purchase"));
          }
        }
        if (Platform.isAndroid) {
          if (purchaseDetails.productID == purchasingId) {
            final InAppPurchaseAndroidPlatformAddition androidAddition =
            _inAppPurchase.getPlatformAddition<
              InAppPurchaseAndroidPlatformAddition>();
            await androidAddition.consumePurchase(purchaseDetails);
          }
        }
        if (purchaseDetails.pendingCompletePurchase) {
          await _inAppPurchase.completePurchase(purchaseDetails);
        }
      }
    }
  }

  void handleError(IAPError error) {
    LogUtil.e('IAPError : ${error}');
    if(mounted){
      setState(() {
        // _purchasePending = false;
      });
    }
  }

  Future<void> deliverProduct(PurchaseDetails purchaseDetails) async {
    // IMPORTANT!! Always verify purchase details before delivering the product.
    LogUtil.e("verifyInsiderPurchase : 0");
    String purchasingId = Platform.isIOS ?
    assetsEntity?.productList![seletIndex].inPurchasingId ?? '' :
    assetsEntity?.productList![seletIndex].inPurchasingIdAndroid ?? '';
    if(Platform.isIOS){
      if(purchasingId == 'nft.avatar.sale.5'){//苹果后台被删了,无法创建一样的id,后台暂未修改本地写死
        purchasingId = 'nft.avatar.sale.five';
      }
    }
    LogUtil.e("verifyInsiderPurchase : 2");
    if (purchaseDetails.productID == purchasingId) {
      // updateNFT(purchaseDetails.verificationData.localVerificationData);
      LogUtil.e("verifyInsiderPurchase : ${purchaseDetails.verificationData.localVerificationData}");
      verifyInsiderPurchase(purchaseDetails.verificationData.localVerificationData);
      LogUtil.e("verifyInsiderPurchase : 1");
      if(mounted){
        setState(() {
          // _purchasePending = false;
        });
      }

    }else if(purchaseDetails.productID == InsidePurchaseSubscribeID){//订阅
      LogUtil.e("订阅 成功");
      bool? isTrue =
          await ChooseImageUploadNetManage.postRecordsAfterSubscription(
              ownerAddress:
                  YLUserInfoManager.sharedInstance.currentUserInfo?.token ?? '',
              receiptData:
                  purchaseDetails.verificationData.localVerificationData);
      if(isTrue == true){
        CommonToast.instance.show(context, Localized.text("yl_usercenter.purchase_successful"));
        getData();
      }else{
        CommonToast.instance.show(context, Localized.text("yl_usercenter.Cancel purchase"));
      }
      if(mounted){
        setState(() {
          // _purchasePending = false;
        });
      }
    }
    else {//测试
      verifyInsiderPurchase(purchaseDetails.verificationData.localVerificationData);
      LogUtil.e("verifyInsiderPurchase : 1");
      if(mounted){
        setState(() {

        });
      }
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
    LogUtil.e("localVerificationData : ${purchaseDetails.verificationData.localVerificationData}");
    saveVerificationData(purchaseDetails.verificationData.localVerificationData);
    YLLoading.dismiss();
    _inAppPurchase.completePurchase(purchaseDetails);

    if(Platform.isIOS) {//统一用后台验证
      // return await handleValidation(verificationData: purchaseDetails.verificationData.serverVerificationData);
      return true;
    } else{
      return true;
    }
  }

  Widget itemBuilder(BuildContext context, int index) {
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.only(
            left: Adapt.px(24),
            right: Adapt.px(24),
            top: Adapt.px(8),
            bottom: Adapt.px(8)),
        child: CommonGradientBorderWidget(
          strokeWidth: 2,
          radius: Adapt.px(16),
          gradient: SweepGradient(
              colors: index == seletIndex
                  ? [ThemeColor.gradientMainStart, ThemeColor.gradientMainEnd]
                  : [Colors.transparent, Colors.transparent]),
          child: Container(
            margin: EdgeInsets.all(Adapt.px(2)),
            height: Adapt.px(102),
            width: Adapt.px(width - 28 * 2),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                  Radius.circular(16),
                ),
                border: Border.all(color: ThemeColor.color180, width: 2),
                color: ThemeColor.color180),
            child: Row(
              children: [
                SizedBox(
                  width: Adapt.px(20),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          child: GradientText(
                              assetsEntity?.productList?[index].title ?? '',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                  color: ThemeColor.titleColor),
                              colors: index == seletIndex
                                  ? [
                                      ThemeColor.gradientMainStart,
                                      ThemeColor.gradientMainEnd
                                    ]
                                  : [ThemeColor.color0, ThemeColor.color0]),
                        ),
                        SizedBox(
                          width: Adapt.px(5),
                        ),
                        assetsEntity?.productList?[index].hotFlag == true
                            ? Container(
                                alignment: Alignment.center,
                                height: Adapt.px(20),
                                width: Adapt.px(50),
                                // margin: EdgeInsets.symmetric(vertical: Adapt.px(5)),
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(4),
                                  ),
                                  border: Border.all(
                                      color: ThemeColor.color180, width: 2),
                                  gradient: LinearGradient(colors: [
                                    ThemeColor.gradientMainStart,
                                    ThemeColor.gradientMainEnd
                                  ]),
                                ),
                                child: Text(
                                  'Hot!!',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: ThemeColor.color0),
                                ),
                              )
                            : Container(),
                      ],
                    ),
                    SizedBox(
                      height: Adapt.px(5),
                    ),
                    Container(
                      constraints: BoxConstraints(maxWidth: Adapt.px(180)),
                      child: GradientText(
                          assetsEntity?.productList?[index].description ?? '',
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              color: ThemeColor.color100),
                          colors: index == seletIndex
                              ? [ThemeColor.gradientMainStart, ThemeColor.gradientMainEnd]
                              : [ThemeColor.color100, ThemeColor.color100]),
                    ),
                  ],
                ),
                Spacer(),
                Container(
                  child: GradientText(
                      '${assetsEntity?.productList?[index].currency}${assetsEntity?.productList?[index].price}',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: ThemeColor.titleColor),
                      colors: index == seletIndex
                          ? [ThemeColor.gradientMainStart, ThemeColor.gradientMainEnd]
                          : [ThemeColor.color0, ThemeColor.color0]),
                ),
                SizedBox(
                  width: Adapt.px(5),
                ),
                index == seletIndex
                    ? CommonImage(
                        iconName: "selected_icon.png",
                        width: Adapt.px(24),
                        height: Adapt.px(24),
                      )
                    : CommonImage(
                        iconName: "not_selected.png",
                        width: Adapt.px(24),
                        height: Adapt.px(24),
                      ),
                SizedBox(
                  width: Adapt.px(20),
                ),
              ],
            ),
          ),
          onPressed: () {
            seletIndex = index;
            if(mounted){
              setState(() {
                // _purchasePending = false;
              });
            }
          },
        ),
      ),
    );
  }
}
