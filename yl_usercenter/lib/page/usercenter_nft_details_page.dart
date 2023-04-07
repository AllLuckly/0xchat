import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:extended_sliver/extended_sliver.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/rendering.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:pull_to_refresh_notification/pull_to_refresh_notification.dart';
import 'package:yl_common/log_util.dart';
import 'package:yl_common/model/yl_user_info.dart';
import 'package:yl_common/navigator/navigator.dart';
import 'package:yl_common/utils/adapt.dart';
import 'package:yl_common/utils/in_app_purchase_verification_ios.dart';
import 'package:yl_common/utils/theme_color.dart';
import 'package:yl_common/utils/yl_userinfo_manager.dart';
import 'package:yl_common/widgets/common_hint_dialog.dart';
import 'package:yl_common/widgets/common_toast.dart';
import 'package:yl_common/widgets/common_webview.dart';
import 'package:yl_common/widgets/yl_loading.dart';
import 'package:yl_localizable/yl_localizable.dart';
import 'package:yl_module_service/yl_module_service.dart';

import 'package:yl_usercenter/model/my_nft_detail_entity.dart';
import 'package:in_app_purchase_android/billing_client_wrappers.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'package:yl_common/utils/in_app_purchase_verification_ios.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/my_mainnet_entity.dart';

class UserCenterNftDetailsPage extends StatefulWidget {
  final OwnedNfts ownedNfts;
  String? nftId;
  String? imgUrl;
  UserCenterNftDetailsPage({Key? key,this.nftId,this.imgUrl, required this.ownedNfts}) : super(key: key);

  @override
  State<UserCenterNftDetailsPage> createState() => _UserCenterNftDetailsPageState();
}

class _UserCenterNftDetailsPageState extends State<UserCenterNftDetailsPage> {
  String? nftId;

  final GlobalKey<PullToRefreshNotificationState> refreshKey =
  GlobalKey<PullToRefreshNotificationState>();
  StreamController<void> onBuildController = StreamController<void>.broadcast();
  StreamController<bool> followButtonController = StreamController<bool>();
  int listlength = 100;
  double maxDragOffset = 100;
  bool showFollowButton = false;
  MyNftDetailEntity?  nftDetailEntity;

  late bool isGuestLogin;
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  ProductDetails? buyProductDetails;
  // Auto-consume must be true on iOS.
  // To try without auto-consume on another platform, change `true` to `false` here.
  final bool _kAutoConsume = Platform.isIOS || true;

  @override
  void dispose() {
    onBuildController.close();
    followButtonController.close();
    super.dispose();
  }

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
      setState(() {
      });
      return;
    }

    bool isVerification = await handleLocalValidation();
    if(isVerification){//提醒一下或者别的什么操作
      YLCommonHintDialog.show(context,title: Localized.text('yl_usercenter.unfinished_order_sos'),actionList: [
        YLCommonHintAction.sure(text: Localized.text('yl_usercenter.next_step') , onTap: () async {
          YLNavigator.pop(context);
          final verificationData = await getLocalVerificationData();
          updateNFT(verificationData!);
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
    Set<String> _kIds = <String>{nftDetailEntity?.inPurchasingId ?? ''};
    final ProductDetailsResponse productDetailResponse = await _inAppPurchase.queryProductDetails(_kIds);
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
          if (purchaseDetails.productID == nftDetailEntity?.inPurchasingId) {
            await _inAppPurchase.completePurchase(purchaseDetails);
            CommonToast.instance.show(context, Localized.text("yl_usercenter.Cancel purchase"));
          }
        }
        if (Platform.isAndroid) {
          if (!_kAutoConsume && purchaseDetails.productID == nftDetailEntity?.inPurchasingId) {
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
    setState(() {
      // _purchasePending = false;
    });
  }

  Future<void> deliverProduct(PurchaseDetails purchaseDetails) async {
    // IMPORTANT!! Always verify purchase details before delivering the product.
    if (purchaseDetails.productID == nftDetailEntity?.inPurchasingId) {
      updateNFT(purchaseDetails.verificationData.localVerificationData);
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
    LogUtil.e("localVerificationData : ${purchaseDetails.verificationData.localVerificationData}");
    saveVerificationData(purchaseDetails.verificationData.localVerificationData);
    YLLoading.dismiss();
    _inAppPurchase.completePurchase(purchaseDetails);

    if(Platform.isIOS) {
      return await handleValidation(verificationData: purchaseDetails.verificationData.serverVerificationData);
    } else{
      return true;
    }
  }

  ///去后台重新验证购买
  void updateNFT(String receiptData) async{
    Map<String, dynamic> dataMap = {
      "receiptData":receiptData,
      "nftId":nftDetailEntity?.id,
      "ownerAddress":YLUserInfoManager.sharedInstance.currentUserInfo?.token ?? ''
    };
    // LogUtil.e("updateNFT : ${dataMap}");
    final dataJson = await YLModuleService.invoke("yl_wowchat", "buyNftData", [dataMap]);
    if(dataJson){//购买成功
      removeVerificationData();
      YLNavigator.pop(context);
      CommonToast.instance.show(context, Localized.text("yl_usercenter.purchase_successful"));
      // setState(() {
      //
      // });
    }else{
      // CommonToast.instance.show(context, Localized.text("yl_usercenter.purchase_successful"));
    }
    LogUtil.e("updateNFT dataJson: ${dataJson}");
  }

  getData() async {
    final dataJson = await YLModuleService.invoke("yl_wowchat", "getNftDetailsData", [widget.nftId]);
    LogUtil.e("UserCenterNftDetailsPage : ${dataJson}");
    nftDetailEntity = MyNftDetailEntity.fromJson(json.decode(dataJson));
    // LogUtil.e("dataJson1 : ${nftListEntity?.myList}");
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {

    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      body: SafeArea(
        top: false,
        child: PullToRefreshNotification(
          pullBackOnRefresh: true,
          onRefresh: onRefresh,
          key: refreshKey,
          maxDragOffset: maxDragOffset,
          child: CustomScrollView(
            ///in case,list is not full screen and remove ios Bouncing
            physics: const AlwaysScrollableClampingScrollPhysics(),
            slivers: <Widget>[
              PullToRefreshContainer(
                      (PullToRefreshScrollNotificationInfo? info) {
                    final double offset = info?.dragOffset ?? 0.0;
                    Widget actions = const Icon(
                      Icons.more_horiz,
                      color: Colors.transparent,
                    );
                    if (info?.refreshWidget != null) {
                      actions = const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.transparent,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.transparent),
                          strokeWidth: 3,
                        ),
                      );
                    }

                    actions = Row(
                      children: <Widget>[
                        // StreamBuilder<bool>(
                        //   stream: followButtonController.stream,
                        //   builder:
                        //     (BuildContext context, AsyncSnapshot<bool> data) {
                        //     //hide FollowButton
                        //     if (!data.data!) {
                        //       return Container();
                        //     }
                        //     return OutlinedButton(
                        //       child: const Text('Follow'),
                        //       style: ButtonStyle(
                        //         textStyle: MaterialStateProperty.all(
                        //           const TextStyle(color: Colors.white),
                        //         ),
                        //         foregroundColor:
                        //         MaterialStateProperty.all(Colors.white),
                        //         side: MaterialStateProperty.all(
                        //           const BorderSide(
                        //             color: Colors.orange,
                        //           ),
                        //         ),
                        //       ),
                        //       onPressed: () {},
                        //     );
                        //   },
                        //   initialData: showFollowButton,
                        // ),
                        const SizedBox(
                          width: 10,
                        ),
                        actions,
                      ],
                    );
                    return ExtendedSliverAppbar(
                      toolBarColor: Colors.transparent,
                      onBuild: (
                          BuildContext context,
                          double shrinkOffset,
                          double? minExtent,
                          double maxExtent,
                          bool overlapsContent,
                          ) {
                        if (shrinkOffset > 0) {
                          onBuildController.sink.add(null);
                        }
                      },
                      title: Text(
                        nftDetailEntity?.nftName ?? '',
                        style: const TextStyle(color: Colors.white),
                      ),
                      leading: const BackButton(
                        onPressed: null,
                        color: Colors.white,
                      ),
                      background: DefaultTextStyle(
                        style: const TextStyle(color: Colors.white),
                        child: Stack(
                          children: <Widget>[
                            Positioned.fill(
                                child: CachedNetworkImage(imageUrl: widget.imgUrl ?? '',
                                  fit: BoxFit.cover,)),
                            Padding(
                              padding: EdgeInsets.only(
                                top: kToolbarHeight + statusBarHeight,
                                bottom: 0,
                              ),
                              child: Container(
                                width: double.infinity,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    SizedBox(
                                      height: offset,
                                    ),
                                    SizedBox(height: 220,),
                                    Container(
                                      height: 30,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(30),
                                            topRight: Radius.circular(30),
                                          ),
                                          color: ThemeColor.color200
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      actions: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: actions,
                      ),
                    );
                  }),
              //pinned box
              SliverPinnedToBoxAdapter(
                child: Container(
                  color: Colors.transparent,
                  height: 0.01,
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                    Widget returnWidget = Container();
                    if(index == 0){
                      returnWidget = Container(
                        color: ThemeColor.color200,
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              margin: EdgeInsets.only(left: Adapt.px(16)),
                              child: Text(nftDetailEntity?.nftName ?? '', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: ThemeColor.titleColor),),
                            ),
                            SizedBox(height: Adapt.px(10),),
                            Row(
                              children: [
                                SizedBox(width: Adapt.px(16),),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      Adapt.px(30)),
                                  child:
                                  CachedNetworkImage(imageUrl: widget.imgUrl ?? '',
                                    width: Adapt.px(30),
                                    height: Adapt.px(30),
                                    fit: BoxFit.cover,),
                                ),
                                SizedBox(width: Adapt.px(6),),
                                Container(
                                  margin: EdgeInsets.only(right: Adapt.px(16)),
                                  child: Text("by ${widget.ownedNfts.contractMetadata?.symbol}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: ThemeColor.gray1),maxLines: 1,),
                                ),
                              ],
                            ),
                            SizedBox(height: Adapt.px(20),),
                            Container(
                              alignment: Alignment.centerLeft,
                              margin: EdgeInsets.only(left: Adapt.px(16)),
                              child: Text(Localized.text("yl_usercenter.DESCRIPTION"), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: ThemeColor.gray1),),
                            ),
                            SizedBox(height: Adapt.px(20),),
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.only(left: Adapt.px(16),right: Adapt.px(16)),
                              child: Text(widget.ownedNfts.description ?? '', style: TextStyle(fontWeight: FontWeight.normal, fontSize: 13, color: ThemeColor.titleColor),maxLines: 2,),
                            ),
                            SizedBox(height: Adapt.px(20),),
                          ],
                        ),
                      );
                    }else if(index == 1){
                      returnWidget = Container();
                    }
                    else if(index == 2){
                      returnWidget = Container(
                        // height: 300,
                          color: ThemeColor.color200,
                          child: Column(
                            mainAxisAlignment:MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: Adapt.px(20),),
                              Container(
                                alignment: Alignment.centerLeft,
                                margin: EdgeInsets.only(left: Adapt.px(16)),
                                child: Text(Localized.text("yl_usercenter.DETAILS"), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: ThemeColor.gray1),),
                              ),
                              SizedBox(height: Adapt.px(20),),
                              SizedBox(height: Adapt.px(20),),
                              InkWell(
                                child: Container(
                                  // constraints: BoxConstraints(minWidth: Adapt.px(100)),
                                  height: Adapt.px(45),
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.only(left: Adapt.px(16), right: Adapt.px(16)),
                                  padding:EdgeInsets.only(left: Adapt.px(10), right: Adapt.px(10)),
                                  child: Text(Localized.text("yl_usercenter.view_on_explorer"), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: ThemeColor.gray2),),
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(Radius.circular(45),),
                                      border: Border.all(color: ThemeColor.gray5, width: 1),
                                      color: ThemeColor.gray5
                                  ),
                                ),
                                onTap: (){
                                  if(widget.ownedNfts.tokenUri?.gateway == null){
                                    return;
                                  }
                                  YLNavigator.pushPage(
                                    context,
                                        (context) => CommonWebView(
                                          widget.ownedNfts.tokenUri?.gateway ?? '',
                                      title: Localized.text("yl_usercenter.view_on_explorer"),
                                    ),
                                  );
                                },
                              ),
                              SizedBox(height: Adapt.px(10),),
                              InkWell(
                                child: Container(
                                  // constraints: BoxConstraints(minWidth: Adapt.px(100)),
                                  height: Adapt.px(45),
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.only(left: Adapt.px(16), right: Adapt.px(16)),
                                  padding:EdgeInsets.only(left: Adapt.px(10), right: Adapt.px(10)),
                                  child: Text(Localized.text("yl_usercenter.view_on_ipfs"), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: ThemeColor.gray2),),
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(Radius.circular(45),),
                                      border: Border.all(color: ThemeColor.gray5, width: 1),
                                      color: ThemeColor.gray5
                                  ),
                                ),
                                onTap: (){
                                  if(nftDetailEntity?.imageUrl == null){
                                    return;
                                  }
                                  YLNavigator.pushPage(
                                    context,
                                        (context) => CommonWebView(
                                      nftDetailEntity?.imageUrl ?? '',
                                      title: Localized.text("yl_usercenter.view_on_ipfs"),
                                    ),
                                  );
                                },
                              ),
                              SizedBox(height: Adapt.px(10),),
                              InkWell(
                                child: Container(
                                  // constraints: BoxConstraints(minWidth: Adapt.px(100)),
                                  height: Adapt.px(45),
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.only(left: Adapt.px(16), right: Adapt.px(16)),
                                  padding:EdgeInsets.only(left: Adapt.px(10), right: Adapt.px(10)),
                                  child: Text(Localized.text("yl_usercenter.ipfs_metadata"), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: ThemeColor.gray2),),
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(Radius.circular(45),),
                                      border: Border.all(color: ThemeColor.gray5, width: 1),
                                      color: ThemeColor.gray5
                                  ),
                                ),
                                onTap: (){
                                  if(nftDetailEntity?.metadataUrl == null){
                                    return;
                                  }
                                  YLNavigator.pushPage(
                                    context,
                                        (context) => CommonWebView(
                                      nftDetailEntity?.metadataUrl ?? '',
                                      title: Localized.text("yl_usercenter.ipfs_metadata"),
                                    ),
                                  );
                                },
                              )

                            ],
                          )
                      );
                    }else if(index == 3){
                      returnWidget = widget.ownedNfts.metadata?.external_link == null ? Container(
                        height: 300,
                        color: ThemeColor.color200,
                      ) : Container(
                        // height: 300,
                        color: ThemeColor.color200,
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.start,
                          // crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: Adapt.px(20),
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                margin: EdgeInsets.only(left: Adapt.px(16)),
                                child: Text(
                                  Localized.text("yl_usercenter.ABOUT_THE_CREATOR"),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: ThemeColor.gray1),
                                ),
                              ),
                              SizedBox(
                                height: Adapt.px(20),
                              ),
                              InkWell(
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  margin: EdgeInsets.only(left: Adapt.px(16), right: Adapt.px(16)),
                                  child: Text(widget.ownedNfts.metadata?.external_link ?? '', style: TextStyle(fontSize: 15, color: ThemeColor.titleColor),),
                                ),
                                onTap: (){
                                  YLNavigator.pushPage(
                                    context,
                                        (context) => CommonWebView(
                                          widget.ownedNfts.metadata?.external_link ?? '',
                                      // title: 'ETH Details',
                                    ),
                                  );
                                },
                              ),
                              SizedBox(
                                height: Adapt.px(20),
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                margin: EdgeInsets.only(left: Adapt.px(16), right: Adapt.px(16)),
                                child: Text(nftDetailEntity?.creatorDesc ?? '', style: TextStyle(fontSize: 15, color: ThemeColor.titleColor),),
                              ),
                              SizedBox(
                                height: Adapt.px(20),
                              ),
                            ]),
                      );
                    }
                    return returnWidget;
                  },
                  childCount: 4,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(color: Colors.transparent,height: Adapt.px(0.1),),
      // floatingActionButton: FloatingActionButton(
      //   child: const Icon(Icons.refresh),
      //   onPressed: () {
      //     refreshKey.currentState!.show(
      //       notificationDragOffset: maxDragOffset,
      //     );
      //   },
      // ),
    );
  }
  List<Widget>getChildrenWidget(){
    List<Widget> widgetList = [];
    nftDetailEntity?.benefits?.forEach((element) {
      Benefits benefit =  element;
      LogUtil.e("benefit : ${benefit.imageUrl}");
      Widget widget = Container(
          height: Adapt.px(100),
          // color: Colors.purple,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(Adapt.px(10)),
            child: CachedNetworkImage(
              fit: BoxFit.cover,
              height: Adapt.px(160),
              width: double.infinity,
              imageUrl: benefit.imageUrl ?? '',
              placeholder: (context, url) => Container(
                color: ThemeColor.gray5,
              ),
              errorWidget: (context, url, error) => Container(
                color: ThemeColor.gray5,
              ),
            ),
          ),
          decoration: BoxDecoration(
            border:  Border.all(width: 0.3, color: ThemeColor.gray5),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          )
      );
      widgetList.add(widget);
    });
    return widgetList;
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

  Future<bool> onRefresh() {
    return Future<bool>.delayed(const Duration(seconds: 2), () {
      setState(() {
        listlength += 10;
      });
      return true;
    });
  }
}

class FollowButton extends StatefulWidget {
  const FollowButton(this.onBuildController, this.followButtonController);
  final StreamController<void> onBuildController;
  final StreamController<bool> followButtonController;
  @override
  _FollowButtonState createState() => _FollowButtonState();
}

class _FollowButtonState extends State<FollowButton> {
  bool showFollowButton = false;
  @override
  void initState() {
    super.initState();
    widget.onBuildController.stream.listen((_) {
      if (mounted) {
        final double statusBarHeight = MediaQuery.of(context).padding.top;
        final RenderBox renderBox = context.findRenderObject() as RenderBox;
        final Offset position = renderBox.localToGlobal(Offset.zero);
        final bool show = position.dy + renderBox.size.height <
            statusBarHeight + kToolbarHeight;
        if (showFollowButton != show) {
          showFollowButton = show;
          widget.followButtonController.sink.add(showFollowButton);
        }
        //print('${position.dy + renderBox.size.height} ----- ${statusBarHeight + kToolbarHeight}');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      //MaterialTapTargetSize.padded min 48
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      child: OutlinedButton(
        child: const Text('Follow'),
        style: ButtonStyle(
          textStyle: MaterialStateProperty.all(
            const TextStyle(color: Colors.white),
          ),
          foregroundColor: MaterialStateProperty.all(Colors.white),
          side: MaterialStateProperty.all(
            const BorderSide(
              color: Colors.orange,
            ),
          ),
        ),
        onPressed: () {},
      ),
    );
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