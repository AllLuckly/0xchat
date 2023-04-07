import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yl_common/log_util.dart';
import 'package:yl_common/model/yl_user_info.dart';
import 'package:yl_common/navigator/navigator.dart';
import 'package:yl_common/utils/adapt.dart';
import 'package:yl_common/utils/theme_color.dart';
import 'package:yl_common/utils/yl_userinfo_manager.dart';
import 'package:yl_common/widgets/common_status_view.dart';
import 'package:yl_common/widgets/common_toast.dart';
import 'package:yl_localizable/yl_localizable.dart';
import 'package:yl_module_service/yl_module_service.dart';
import 'package:yl_usercenter/model/my_assets_entity.dart';
import 'package:yl_usercenter/model/my_mainnet_entity.dart';
import 'package:yl_usercenter/model/my_pregod_entity.dart';
import 'package:yl_usercenter/page/usercenter_page.dart';
import 'package:yl_wowchat/channel/chat_method_channel_utls.dart';

import 'avatar_shop_page.dart';
import 'buy_nft_page.dart';

import 'package:waterfall_flow/waterfall_flow.dart';
import 'package:keframe/keframe.dart';

enum NFTAvatarSettingsType {
  ethType, //Eth
  maticType, //马蹄链（Matic/Polygon
}

// ignore: must_be_immutable
class NFTAvatarSettingsSubmodulePage extends StatefulWidget {
  NFTAvatarSettingsType? pageType;

  NFTAvatarSettingsSubmodulePage({Key? key, this.pageType}) : super(key: key);

  @override
  State<NFTAvatarSettingsSubmodulePage> createState() =>
      _NFTAvatarSettingsSubmodulePageState();
}

class _NFTAvatarSettingsSubmodulePageState
    extends State<NFTAvatarSettingsSubmodulePage>
    with AutomaticKeepAliveClientMixin {
  NFTAvatarSettingsType? pageType;
  MyAssetsEntity? assetsEntity;
  MyPreGod? preGod;
  MyMainnetEntity? mainnetEntity;

  // List<PreGodList> showPreGodList = [];
  List<OwnedNfts> showOwnedNfts = [];
  List<OwnedNfts> showPreGodList = [];

  bool isShowLoading = true;

  @override
  void initState() {
    super.initState();
    pageType = widget.pageType;
    if (pageType == NFTAvatarSettingsType.ethType) {
      _getMyEthEntitys();
    } else if (pageType == NFTAvatarSettingsType.maticType) {
      _getMyMainnetEntitys();
    }
  }

  void _getMyMainnetEntitys() async {
    //0x96d7cf71f6391a6092487c0390c4977052e78ddb
    //0xC8b960D09C0078c18Dcbe7eB9AB9d816BcCa8944
    mainnetEntity = await getMyMainnetEntitys(
        account: YLUserInfoManager.sharedInstance.currentUserInfo?.token);
    isShowLoading = false;
    if (mainnetEntity != null) {
      showOwnedNfts.addAll(mainnetEntity!.ownedNfts!);
    }
    OwnedNfts nedNFT = OwnedNfts();
    showOwnedNfts.insert(0, nedNFT);
    if (mounted) setState(() {});
  }

  void _getMyEthEntitys() async {
    //0x96d7cf71f6391a6092487c0390c4977052e78ddb
    //0xC8b960D09C0078c18Dcbe7eB9AB9d816BcCa8944
    mainnetEntity = await getMyEthEntitys(
        account: YLUserInfoManager.sharedInstance.currentUserInfo?.token);
    isShowLoading = false;
    if (mainnetEntity != null) {
      showPreGodList.addAll(mainnetEntity!.ownedNfts!);
    }
    if (mounted) setState(() {});
  }



  @override
  Widget build(BuildContext context) {
    super.build(context);
    return buildBoby();
  }

  Widget buildBoby() {
    double xwidth = MediaQuery.of(context).size.width;
    if (pageType == NFTAvatarSettingsType.maticType) {
      return isShowLoading ?  _showLoading() : showOwnedNfts.length == 0
          ? Container(
              color: ThemeColor.bgColor,
              child: CommonStatusView(pageStatus: PageStatus.noData),
            )
          : Container(
              color: ThemeColor.bgColor,
              child: SizeCacheWidget(
                child: WaterfallFlow.builder(
                  //cacheExtent: 0.0,
                  //reverse: true,
                  addAutomaticKeepAlives: false,
                  addRepaintBoundaries: false,
                  padding: const EdgeInsets.all(5.0),
                  gridDelegate:
                      const SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 18,
                    mainAxisSpacing: 16,
                    // collectGarbage: (List<int> garbages) {
                    //   print('collect garbage : $garbages');
                    // },
                    // viewportBuilder: (int firstIndex, int lastIndex) {
                    //   print('viewport : [$firstIndex,$lastIndex]');
                    // },
                  ),
                  itemBuilder: (BuildContext c, int index) {
                    bool? isIpfs = showOwnedNfts[index]
                        .metadata
                        ?.image
                        ?.contains("ipfs://");
                    // bool isHttp = json['image']!.contains("http");
                    String? imageUrl = '';
                    if (isIpfs == true) {
                      imageUrl = showOwnedNfts[index]
                          .metadata
                          ?.image
                          ?.replaceAll(
                              "ipfs://", "https://infura-ipfs.io/ipfs/");
                    } else {
                      imageUrl = showOwnedNfts[index].metadata?.image;
                    }
                    if (index == 0 &&
                        (pageType == NFTAvatarSettingsType.maticType)) {
                      return ClipRRect(
                          borderRadius: BorderRadius.circular(Adapt.px(10)),
                          child: GestureDetector(
                            child: Container(
                              color: ThemeColor.gray5,
                              height: Adapt.px((xwidth-26)/2),
                              child: Icon(
                                Icons.add,
                                size: Adapt.px(100),
                              ),
                            ),
                            onTap: () {
                              //点击购买NFT
                              // YLNavigator.pushPage(
                              //     context, (context) => BuyNftPage());

                              YLNavigator.pushPage(context, (context) => AvatarShopPage());
                            },
                          ));
                    }
                    return FrameSeparateWidget(
                      child: InkWell(
                        child: ImageTile(
                          index: index,
                          width: 100,
                          height: 130,
                          imgUrl: imageUrl ?? '',
                          item: showOwnedNfts[index],
                        ),
                        onTap: () async {
                          _requestSetNFTAvatar(showOwnedNfts, index);
                        },
                      ),
                    );
                  },
                  //itemCount: 19,
                  itemCount: showOwnedNfts.length,
                ),
              ));

    }
    return isShowLoading ? _showLoading() : showOwnedNfts.length == 0
        ? Container(
            color: ThemeColor.bgColor,
            child: CommonStatusView(pageStatus: PageStatus.noData),
          )
        : Container(
            color: ThemeColor.bgColor,
            child: SizeCacheWidget(
              child: WaterfallFlow.builder(
                //cacheExtent: 0.0,
                //reverse: true,
                addAutomaticKeepAlives: false,
                addRepaintBoundaries: false,
                padding: const EdgeInsets.all(5.0),
                gridDelegate:
                    const SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 18,
                  mainAxisSpacing: 16,
                  // collectGarbage: (List<int> garbages) {
                  //   print('collect garbage : $garbages');
                  // },
                  // viewportBuilder: (int firstIndex, int lastIndex) {
                  //   print('viewport : [$firstIndex,$lastIndex]');
                  // },
                ),
                itemBuilder: (BuildContext c, int index) {
                  bool? isIpfs = showPreGodList[index]
                      .metadata
                      ?.image
                      ?.contains("ipfs://");
                  // bool isHttp = json['image']!.contains("http");
                  String? imageUrl = '';
                  if (isIpfs == true) {
                    imageUrl = showPreGodList[index]
                        .metadata
                        ?.image
                        ?.replaceAll("ipfs://", "https://infura-ipfs.io/ipfs/");
                  } else {
                    imageUrl = showPreGodList[index].metadata?.image;
                  }

                  return FrameSeparateWidget(
                    child: InkWell(
                      child: ImageTile(
                        index: index,
                        width: 100,
                        height: 130,
                        imgUrl: imageUrl ?? '',
                        item: showPreGodList[index],
                      ),
                      onTap: () async {
                        _requestSetNFTAvatar(showPreGodList, index);
                      },
                    ),
                  );
                },
                //itemCount: 19,
                itemCount: showPreGodList.length,
              ),
            )
    );
  }

  Widget _showLoading() {
    return Container(
      constraints: const BoxConstraints.expand(),
      color: ThemeColor.bgColor,
      child: Center(
        child: SizedBox(
          width: Adapt.px(36),
          height: Adapt.px(36),
          child: CircularProgressIndicator(
            strokeWidth: 2.0,
            valueColor: AlwaysStoppedAnimation<Color>(ThemeColor.purple1),
          ),
        ),
      ),
    );
  }

  String _getTokenId(String hex) {
    hex = hex.substring(2);
    final number = BigInt.parse(hex,radix: 16).toRadixString(10);
    LogUtil.e("number : ${number}");
    return number.toString();
  }



  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;


  void _requestSetNFTAvatar(List<OwnedNfts> nfts, int index) async {
    LogUtil.e('Michael: pageType =${( (pageType == NFTAvatarSettingsType.maticType) ? 'Matic_NFT' : 'ETH_NFT')}');
    //点击设置NFT头像
    String? nftAvatar = await YLModuleService.invoke("yl_wowchat", "setNftAvatar", [
      {
        'nftId': _getTokenId(nfts[index].id?.tokenId ?? ''),
        'contractAddress': nfts[index].contract?.address,
        'loginUserAddress': YLUserInfoManager.sharedInstance.currentUserInfo?.token,
        'nftType': (pageType == NFTAvatarSettingsType.maticType) ? 'Matic_NFT' : 'ETH_NFT'
      }
    ]);
    LogUtil.e('Michael: nftAvatar =${nftAvatar?.length}');
    if (nftAvatar != null && nftAvatar.isNotEmpty) {
      YLUserInfo? userInfo = YLUserInfoManager
          .sharedInstance.currentUserInfo;
      ChatMethodChannelUtils.synchronizeSDKUserInfo(
          {'userAvatarFileName': nftAvatar});
      userInfo?.headUrl = nftAvatar;
      YLUserInfoManager.sharedInstance
          .updateUserInfo(userInfo!);
      CommonToast.instance.show(
          context,
          Localized.text(
              "yl_usercenter.Set successfully"));

      YLNavigator.pop(context, nftAvatar);
    } else {
      CommonToast.instance.show(
          context,
          Localized.text(
              "yl_usercenter.set_failed"));
    }
  }
}
