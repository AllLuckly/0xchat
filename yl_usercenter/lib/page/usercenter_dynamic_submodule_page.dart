import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:waterfall_flow/waterfall_flow.dart';
import 'package:yl_common/log_util.dart';
import 'package:yl_common/navigator/navigator.dart';
import 'package:yl_common/utils/adapt.dart';
import 'package:yl_common/utils/yl_userinfo_manager.dart';
import 'package:yl_common/widgets/common_status_view.dart';
import 'package:yl_common/widgets/common_webview.dart';
import 'package:yl_common/yl_common.dart';
import 'package:yl_common/utils/theme_color.dart';
import 'package:yl_common/widgets/common_glassmorphic_container.dart';
import 'package:yl_module_service/yl_module_service.dart';
import 'package:yl_usercenter/model/DynamicSubmodulePageType.dart';
import 'package:yl_usercenter/model/my_assets_entity.dart';
import 'package:yl_usercenter/model/my_mainnet_entity.dart';
import 'package:yl_usercenter/model/my_pregod_entity.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:yl_usercenter/page/usercenter_nft_details_page.dart';
import 'package:yl_usercenter/page/usercenter_page.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:keframe/keframe.dart';


class UsercenterDynamicSubmodulePage extends StatefulWidget {
  DynamicSubmodulePageType? pageType;
  List<OwnedNfts> showOwnedNfts = [];
  List<OwnedNfts> showPreGodList = [];

  UsercenterDynamicSubmodulePage({Key? key, this.pageType, required this.showOwnedNfts, required this.showPreGodList}) : super(key: key);

  @override
  State<UsercenterDynamicSubmodulePage> createState() =>
      _UsercenterDynamicSubmodulePageState();
}

class _UsercenterDynamicSubmodulePageState
    extends State<UsercenterDynamicSubmodulePage>
    with AutomaticKeepAliveClientMixin {
  DynamicSubmodulePageType? pageType;
  MyAssetsEntity? assetsEntity;
  MyPreGod? preGod;
  MyMainnetEntity? mainnetEntity;

  // List<PreGodList> showPreGodList = [];
  // List<OwnedNfts> showOwnedNfts = [];
  // List<OwnedNfts> showPreGodList = [];

  @override
  void initState() {
    super.initState();
    pageType = widget.pageType;
    // if (pageType == DynamicSubmodulePageType.nftType) {
    //   _getMyEthEntitys();
    // } else if (pageType == DynamicSubmodulePageType.maticType) {
    //   _getMyMainnetEntitys();
    // }
  }

  // void _getMyMainnetEntitys() async {
  //   //0x96d7cf71f6391a6092487c0390c4977052e78ddb
  //   //0xC8b960D09C0078c18Dcbe7eB9AB9d816BcCa8944
  //   mainnetEntity = await getMyMainnetEntitys(
  //       account: YLUserInfoManager.sharedInstance.currentUserInfo?.token);
  //   if (mainnetEntity != null) {
  //     widget.showOwnedNfts.addAll(mainnetEntity!.ownedNfts!);
  //   }
  //   // OwnedNfts nedNFT = OwnedNfts();
  //   // showOwnedNfts.insert(0, nedNFT);
  //   if (mounted) setState(() {});
  // }

  // void _getMyEthEntitys() async {
  //   //0x96d7cf71f6391a6092487c0390c4977052e78ddb
  //   //0xC8b960D09C0078c18Dcbe7eB9AB9d816BcCa8944
  //   mainnetEntity = await getMyEthEntitys(
  //       account: YLUserInfoManager.sharedInstance.currentUserInfo?.token);
  //   if (mainnetEntity != null) {
  //     showPreGodList.addAll(mainnetEntity!.ownedNfts!);
  //   }
  //   if (mounted) setState(() {});
  // }

  void _getAccountInfoFn() async {
    Map<String, dynamic> params = {};
    Map<String, dynamic> params2 = {};
    params["limit"] = 1000;
    params["exclude_tags"] = "POAP";
    params["latest"] = false;
    params["tags"] = "NFT";
    // https://pregod.rss3.dev/v0.4.0/account:0xC8b960D09C0078c18Dcbe7eB9AB9d816BcCa8944@ethereum/notes?limit=1000&exclude_tags=POAP&tags=NFT&tags=ETH&latest=false
    params2["tags"] = "ETH";

    ///组装请求参数
    for (String key in params.keys) {
      if (params2.containsKey(key)) {
        params2[key] = params[key] + "&" + key + "=" + params2[key];
      } else {
        params2[key] = params[key];
      }
    }
    // 0x4f714880A5847D335606bb37848CcAcbcD6d5836

    // preGod = await getMyPreGods(
    //   params:params2,
    //   account: '0x4f714880A5847D335606bb37848CcAcbcD6d5836'
    // );

    // preGod = await getMyPreGods(
    //     params: params2,
    //     account: YLUserInfoManager.sharedInstance.currentUserInfo?.token ??
    //         '0xC8b960D09C0078c18Dcbe7eB9AB9d816BcCa8944');
    LogUtil.e("1111=============xxxxxxxxxxxxxxx : ${params2}");
    // preGod = await getMyPreGods(
    //   params: params2,
    //   account: YLUserInfoManager.sharedInstance.currentUserInfo?.token);
    // // LogUtil.e("1111=============xxxxxxxxxxxxxxx : ${preGod}=====${preGod!.list!}");
    // if (preGod != null) {
    //     showPreGodList.addAll(preGod!.list!);
    // }
    // if(pageType == NFTAvatarSettingsType.maticType){
    //     PreGodList addPreGod = PreGodList();
    //     showPreGodList.insert(0, addPreGod);//插入一个Add的Item
    // }
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return buildBoby();
  }

  Widget buildBoby() {
    if (pageType == DynamicSubmodulePageType.maticType) {
      return widget.showPreGodList.length == 0
          ? Container(
              color: ThemeColor.color200,
              child: CommonStatusView(pageStatus: PageStatus.noData)
            )
          : Container(
              color: ThemeColor.color200,
              child: SizeCacheWidget(
                child: WaterfallFlow.builder(
                  //cacheExtent: 0.0,
                  //reverse: true,
                  addAutomaticKeepAlives: false,
                  addRepaintBoundaries: false,
                  padding: EdgeInsets.fromLTRB(Adapt.px(5), Adapt.px(5), Adapt.px(5), Adapt.px(100)),
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
                    bool? isIpfs = widget.showPreGodList[index]
                        .metadata
                        ?.image
                        ?.contains("ipfs://");
                    // bool isHttp = json['image']!.contains("http");
                    String? imageUrl = '';
                    if (isIpfs == true) {
                      imageUrl = widget.showPreGodList[index]
                          .metadata
                          ?.image
                          ?.replaceAll(
                              "ipfs://", "https://infura-ipfs.io/ipfs/");
                    } else {
                      imageUrl = widget.showPreGodList[index].metadata?.image;
                    }
                    return FrameSeparateWidget(
                        child: InkWell(
                            child: ImageTile(
                                index: index,
                                width: 100,
                                height: 130,
                                imgUrl: imageUrl ?? '',
                                item: widget.showPreGodList[index],
                            ),
                            onTap: () async {
                                //点击详情
                                YLNavigator.pushPage(
                                    context,
                                      (context) => UserCenterNftDetailsPage(ownedNfts: widget.showPreGodList[index], imgUrl: imageUrl),
                                );
                            },
                        ),
                    );
                  },
                  //itemCount: 19,
                  itemCount: widget.showPreGodList.length,
                ),
              ));
    }
    return widget.showPreGodList.length == 0
        ? Container(
            color: ThemeColor.color200,
            child: CommonStatusView(pageStatus: PageStatus.noData)
          )
        : Container(
            color: ThemeColor.color200,
            child: SizeCacheWidget(
              child: WaterfallFlow.builder(
                //cacheExtent: 0.0,
                //reverse: true,
                addAutomaticKeepAlives: false,
                addRepaintBoundaries: false,
                padding: EdgeInsets.fromLTRB(Adapt.px(5), Adapt.px(5), Adapt.px(5), Adapt.px(100)),
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
                  bool? isIpfs = widget.showPreGodList[index]
                      .metadata
                      ?.image
                      ?.contains("ipfs://");
                  // bool isHttp = json['image']!.contains("http");
                  String? imageUrl = '';
                  if (isIpfs == true) {
                    imageUrl = widget.showPreGodList[index]
                        .metadata
                        ?.image
                        ?.replaceAll("ipfs://", "https://infura-ipfs.io/ipfs/");
                  } else {
                    imageUrl = widget.showPreGodList[index].metadata?.image;
                  }

                  return FrameSeparateWidget(
                      child: InkWell(
                          child: ImageTile(
                              index: index,
                              width: 100,
                              height: 130,
                              imgUrl: imageUrl ?? '',
                              item: widget.showPreGodList[index],
                          ),
                          onTap: () async {
                              //点击进入详情
                              YLNavigator.pushPage(
                                  context,
                                    (context) =>  UserCenterNftDetailsPage(ownedNfts: widget.showPreGodList[index], imgUrl: imageUrl,),
                              );
                          },
                      ),
                  );
                },
                //itemCount: 19,
                itemCount: widget.showPreGodList.length,
              ),
            ));
  }

  String _getTokenId(String hex) {
    hex = hex.substring(2);
    LogUtil.e('Bison---_getTokenId ${hex}');
    int val = 0;
    int len = hex.length;
    for (int i = 0; i < len; i++) {
      int hexDigit = hex.codeUnitAt(i);
      if (hexDigit >= 48 && hexDigit <= 57) {
        val += (hexDigit - 48) * (1 << (4 * (len - 1 - i)));
      } else if (hexDigit >= 65 && hexDigit <= 70) {
        // A..F
        val += (hexDigit - 55) * (1 << (4 * (len - 1 - i)));
      } else if (hexDigit >= 97 && hexDigit <= 102) {
        // a..f
        val += (hexDigit - 87) * (1 << (4 * (len - 1 - i)));
      } else {
        throw new FormatException("Invalid hexadecimal value");
      }
    }
    return val.toString();
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

// MyPreGod? preGod;
// BuildContext? mContext;
// List<PreGodList> showPreGodList = [];

// @override
// void initState() {
//   super.initState();
//   pageType = widget.pageType;
//   _getAccountInfoFn();

// }

// void _getAccountInfoFn() async {
//   Map<String, dynamic> params = {};
//   Map<String, dynamic> params2 = {};
//   params["limit"] = 1000;
//   params["exclude_tags"] = "POAP";
//   params["latest"] = false;
//   LogUtil.e('${this.pageType.toString()}===========${widget.pageType}');
//   if(this.pageType == DynamicSubmodulePageType.tradeType){
//   // https://pregod.rss3.dev/v0.4.0/account:0xC8b960D09C0078c18Dcbe7eB9AB9d816BcCa8944@ethereum/notes?limit=1000&exclude_tags=POAP&tags=Token&tags=ETH&latest=false
//     params["tags"] = "Token";
//     // params2["tags"] = "ETH";
//   }else if(this.pageType == DynamicSubmodulePageType.donateType){
//   // https://pregod.rss3.dev/v0.4.0/account:0xC8b960D09C0078c18Dcbe7eB9AB9d816BcCa8944@ethereum/notes?limit=1000&exclude_tags=POAP&tags=Donation&tags=Gitcoin&latest=false
//     params["tags"] = "Donation";
//     params2["tags"] = "Gitcoin";
//   }else if(this.pageType == DynamicSubmodulePageType.nftType){
//   // https://pregod.rss3.dev/v0.4.0/account:0xC8b960D09C0078c18Dcbe7eB9AB9d816BcCa8944@ethereum/notes?limit=1000&exclude_tags=POAP&tags=NFT&tags=ETH&latest=false
//     params["tags"] = "NFT";
//     // params2["tags"] = "ETH";
//   }else if(this.pageType == DynamicSubmodulePageType.articleType){
//   // https://pregod.rss3.dev/v0.4.0/account:0xC8b960D09C0078c18Dcbe7eB9AB9d816BcCa8944@ethereum/notes?limit=1000&exclude_tags=POAP&tags=Mirror+Entry&latest=false
//     params["tags"] = "Mirror+Entry";
//   }
//   ///组装请求参数
//   for (String key in params.keys) {
//     if (params2.containsKey(key)) {
//       params2[key] = params[key] + "&" + key + "=" + params2[key];
//     } else {
//       params2[key] = params[key];
//     }
//   }

//   // 0x4f714880A5847D335606bb37848CcAcbcD6d5836

//   // preGod = await getMyPreGods(
//   //   params:params2,
//   //   account: '0x4f714880A5847D335606bb37848CcAcbcD6d5836'
//   // );

//   preGod = await getMyPreGods(
//     params:params2,
//     account: YLUserInfoManager.sharedInstance.currentUserInfo?.token ?? '0xC8b960D09C0078c18Dcbe7eB9AB9d816BcCa8944'
//   );
//   // LogUtil.e("1111=============xxxxxxxxxxxxxxx : ${preGod}=====${preGod!.list!}");
//   if(preGod != null){
//     showPreGodList.addAll(preGod!.list!);
//   }
//   if (mounted) setState(() {});
// }

// @override
// Widget build(BuildContext context) {
//   super.build(context);
//   mContext = context;
//   return buildBoby();
// }

// Widget buildBoby(){
//   return showPreGodList == null
//       ? Container(
//           color: ThemeColor.color200,
//         )
//       : Container(
//           padding: EdgeInsets.only(top: Adapt.px(10)),
//           color: ThemeColor.color200,
//           child: ListView.builder(
//               physics: NeverScrollableScrollPhysics(),
//               shrinkWrap: true,
//               itemCount: showPreGodList.length,
//               itemBuilder: (BuildContext context, int index) {
//                 return GestureDetector(
//                   child: itemBuild(index),
//                   onTap: (){
//                     PreGodList preGodItem = showPreGodList[index];
//                     String url = preGodItem.relatedUrls?[0] ?? '';
//                     YLNavigator.pushPage(
//                       context,
//                         (context) => CommonWebView(
//                         url,
//                         title: 'Transaction Details',
//                       ),
//                     );
//                   },
//                 );
//               }),
//         );
// }

// Widget itemBuild(int index) {
//   PreGodList preGodItem = showPreGodList[index];

//   Widget itemContainer =
//       itemContainerBuild(preGodItem);
//   return int.parse(preGodItem.showType ?? '0') == 2
//       ? itemImageBuild(index)
//       : itemNoImageContainerBuild(itemContainer,preGodItem);
// }
// Widget itemNoImageContainerBuild(Widget itemContainer, PreGodList preGodItem) {
//   return preGodItem.metaType == null ?  Container() : Stack(
//     children: [
//       Container(
//         margin: EdgeInsets.only(
//           left: Adapt.px(15),
//           right: Adapt.px(15),
//           top: Adapt.px(17),
//           bottom: Adapt.px(10)),
//         child: itemContainer,
//       ),
//       Container(
//         margin: EdgeInsets.only(
//           left: Adapt.px(12),
//           top: Adapt.px(17),
//         ),
//         width: 33,
//         height: 17,
//         color: getTagColor(preGodItem),
//       )
//     ],
//   );
// }

// Widget itemImageBuild(int index) {
//   PreGodList preGodItem = showPreGodList[index];
//   double width = MediaQuery.of(context).size.width - (Adapt.px(15) * 2);
//   return Container(
//     width: width,
//     height: width,
//     margin: EdgeInsets.only(
//       left: Adapt.px(15),
//       right: Adapt.px(15),
//       top: Adapt.px(17),
//       bottom: Adapt.px(10)),
//     decoration: BoxDecoration(
//       color: ThemeColor.gray8,
//       borderRadius: BorderRadius.all(Radius.circular(12)),
//     ),
//     child: Stack(
//       children: [
//         itemBgImageBuild(index),
//         itemBgImageVagueBuild(index),
//       ],
//     ),
//   );
// }
// Widget itemBgImageBuild(int index) {
//   double width = MediaQuery.of(context).size.width - (Adapt.px(15) * 2);
//   PreGodList preGodItem = showPreGodList[index];
//   final map = <String, String>{};
//   // preGodItem.imgUrl = 'https://lh3.googleusercontent.com/J1qAkKYMs9p2DsSdhN5iGKng0wSSpVOp_3RZ-5eGyN3ErGiqoM5QcIm6P2AOLo7kuDnJ17_4227dDNXWmZIORljGMzQsfnQgH0zRdg=s250';
//   LogUtil.e('preGodItem.imgUrl: ${preGodItem.imgUrl}');
//   String host = getHostUrl(preGodItem.imgUrl ?? '');
//   if(host.length > 0){
//     map['Host'] =  host;
//     map['User-Agent'] = 'PostmanRuntime/7.26.8';
//   }
//   return ClipRRect(
//     borderRadius: BorderRadius.all(Radius.circular(12)),
//     child: CachedNetworkImage(
//       imageUrl: preGodItem.imgUrl ?? '',
//       placeholder: (context, url) =>  Container(
//         color: Colors.transparent,
//       ),
//       errorWidget: (context, url, error) => Container(
//         color: Colors.transparent,
//       ),
//       width: width,
//       height: width,
//       fit: BoxFit.cover,
//       httpHeaders: map,
//     ),
//   );
// }
// ///背景模糊
// Widget itemBgImageVagueBuild(int index) {
//   PreGodList preGodItem = showPreGodList[index];
//   Widget itemContainer =
//   itemContainerBuild(preGodItem);
//   return Positioned(
//     child: Container(
//       padding: EdgeInsets.only(top: 30),
//       child: Stack(
//         children: [
//           ClipRRect(
//             borderRadius: BorderRadius.all(Radius.circular(12)),
//             // 可裁切矩形
//             child: BackdropFilter(
//               // 背景过滤器
//               filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
//               child: Opacity(
//                 opacity: 0.8,
//                 child: Container(
//                   child: itemContainer,
//                 ),
//               ),
//             ),
//           ),
//           Container(
//             margin: EdgeInsets.only(
//               left: Adapt.px(0),
//               top: Adapt.px(0),
//             ),
//             width: 33,
//             height: 17,
//             color: getTagColor(preGodItem),
//           )

//         ],
//       )

//     ),
//     bottom: 0,
//     left: 0,
//     right: 0,
//   );
// }

// Color getTagColor(PreGodList preGodItem){
//   if(preGodItem.metaType == "1"){
//     return ThemeColor.yellow1;
//   }else if(preGodItem.metaType == "2"){
//     return ThemeColor.green1;
//   }
//   else if(preGodItem.metaType == "3"){
//     return ThemeColor.blue1;
//   }
//   else if(preGodItem.metaType == "4"){
//     return ThemeColor.purple2;
//   }
//   return Colors.transparent;
// }

// Widget itemContainerBuild(PreGodList preGodItem){
//   String subTitle = '';
//   String title = '';
//   // LogUtil.e("preGodItem.metaType : ${preGodItem.metaType}");
//   if(preGodItem.metaType != null && int.parse(preGodItem.metaType ?? '0') == 1){//交易
//     double dividend = 10;
//     for(int i =1; i < (preGodItem.metadata?.decimal ?? 0); i++){
//       dividend = dividend * 10;
//     }
//     // num dividend = pow(10, preGodItem.metadata?.decimal ?? 0);
//     double titleDouble =  double.parse(preGodItem.metadata?.amount ?? '0') / dividend;
//     title = '${titleDouble.toString()} ${preGodItem.metadata?.tokenSymbol!}';

//     if((preGodItem.metadata?.from ?? '') == '0xc8b960d09c0078c18dcbe7eb9ab9d816bcca8944'){
//         // print("sssssssssssssssssssssssssssss");
//       subTitle = '${preGodItem.metadata?.from} sent to ${preGodItem.metadata?.to}';
//     }else{
//       subTitle = '${preGodItem.metadata?.from} swapped on ${preGodItem.metadata?.network}';
//     }
//     // subTitle = '${preGodItem.metadata.from} '

//   } else if(preGodItem.metaType != null && int.parse(preGodItem.metaType ?? '0') == 3){//文章
//     // rss3://account:0xc8b960d09c0078c18dcbe7eb9ab9d816bcca8944@ethereum
//     String? temStr = "";
//     temStr = preGodItem.authors?[0].replaceAll("rss3://account:", "");
//     temStr = temStr?.replaceAll("@ethereum", "");
//     subTitle = '${temStr} posted on Mirror';
//     title = preGodItem.title ?? '';
//   }else if(preGodItem.metaType != null && int.parse(preGodItem.metaType ?? '0') == 4){//NFT
//     String? temStr = preGodItem.metadata?.collectionAddress ?? '';
//     subTitle = '${temStr} minted an NFT';
//     title = preGodItem.title ?? '';
//   }else if(preGodItem.metaType != null && int.parse(preGodItem.metaType ?? '0') == 2){//捐赠
//     String? temStr = preGodItem.metadata?.from ?? '';
//     double dividend = 10;
//     for(int i =1; i < (preGodItem.metadata?.decimal ?? 0); i++){
//       dividend = dividend * 10;
//     }
//     // num dividend = pow(10, preGodItem.metadata?.decimal ?? 0);
//     double titleDouble =  double.parse(preGodItem.metadata?.amount ?? '0') / dividend;
//     temStr = '${temStr} donated ${titleDouble.toString()} ${preGodItem.metadata?.tokenSymbol!}';
//     subTitle = '${temStr}';
//     title = preGodItem.title ?? '';
//   }
//   else{
//     title = preGodItem.title ?? '';
//   }

//   if(preGodItem.metaType == null){
//     return Container();
//   }

//   return Container(
//     decoration: BoxDecoration(
//       color: ThemeColor.gray8,
//       borderRadius: BorderRadius.all(Radius.circular(12)),
//     ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(height: 23,),
//           Container(
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 SizedBox(width: 12,),
//                 Expanded(child: Text(subTitle, style: TextStyle(fontSize: 13, color: ThemeColor.titleColor),maxLines: 2,overflow: TextOverflow.ellipsis,),)
//                 ,
//                 SizedBox(width: 12,),
//                 Text(RelativeDateFormat.format(DateTime.parse(preGodItem.dateCreated ?? '')), style: TextStyle(fontSize: 12, color: ThemeColor.gray9),),
//                 SizedBox(width: 12,),
//               ],
//             ),
//           ),
//           SizedBox(height: Adapt.px(10),),
//           Container(
//             height: 1,
//             color: ThemeColor.gray5,
//             margin: EdgeInsets.only(left: 12,right: 12),
//           ),
//           Container(
//             margin: EdgeInsets.only(left: 12,right: 12, top: 10),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Text("Love, Death + Robots: Night of", style: TextStyle(fontSize: 13, color: ThemeColor.titleColor),textAlign: TextAlign.left,),
//                 Text(title, style: TextStyle(fontSize: 13, color: ThemeColor.titleColor, ),maxLines: 2,overflow: TextOverflow.ellipsis,),
//                 SizedBox(height: 3,),
//                 Text(preGodItem.summary ?? '', style: TextStyle(fontSize: 12, color: ThemeColor.gray9, ),maxLines: 2,overflow: TextOverflow.ellipsis,),
//               ],
//             ),
//           ),
//           SizedBox(height: 23,),
//         ],
//       ),
//     );
// }

// String getHostUrl(String url){
//   RegExp regExp = new RegExp(r"^.*?://(.*?)/.*?$");
//   RegExpMatch? match = regExp.firstMatch(url);
//   if (match != null) {
//     return match.group(1) ?? '';
//   }
//   return '';
// }

// @override
// // TODO: implement wantKeepAlive
// bool get wantKeepAlive => true;
}

class RelativeDateFormat {
  static final num ONE_MINUTE = 60000;
  static final num ONE_HOUR = 3600000;
  static final num ONE_DAY = 86400000;
  static final num ONE_WEEK = 604800000;

  static final String ONE_SECOND_AGO = "秒前";
  static final String ONE_MINUTE_AGO = "分钟前";
  static final String ONE_HOUR_AGO = "小时前";
  static final String ONE_DAY_AGO = "天前";
  static final String ONE_MONTH_AGO = "月前";
  static final String ONE_YEAR_AGO = "年前";

//时间转换
  static String format(DateTime date) {
    num delta =
        DateTime.now().millisecondsSinceEpoch - date.millisecondsSinceEpoch;
    if (delta < 1 * ONE_MINUTE) {
      num seconds = toSeconds(delta);
      return (seconds <= 0 ? 1 : seconds).toInt().toString() + ONE_SECOND_AGO;
    }
    if (delta < 60 * ONE_MINUTE) {
      num minutes = toMinutes(delta);
      return (minutes <= 0 ? 1 : minutes).toInt().toString() + ONE_MINUTE_AGO;
    }
    if (delta < 24 * ONE_HOUR) {
      num hours = toHours(delta);
      return (hours <= 0 ? 1 : hours).toInt().toString() + ONE_HOUR_AGO;
    }
    if (delta < 48 * ONE_HOUR) {
      return "昨天";
    }
    if (delta < 10 * ONE_DAY) {
      num days = toDays(delta);
      return (days <= 0 ? 1 : days).toInt().toString() + ONE_DAY_AGO;
    }

    return DateFormat("yyyy/MM/dd").format(date).toString();
    // if (delta < 12 * 4 * ONE_WEEK) {
    //   num months = toMonths(delta);
    //   return (months <= 0 ? 1 : months).toInt().toString() + ONE_MONTH_AGO;
    // } else {
    //   num years = toYears(delta);
    //   return (years <= 0 ? 1 : years).toInt().toString() + ONE_YEAR_AGO;
    // }
  }

  static num toSeconds(num date) {
    return date / 1000;
  }

  static num toMinutes(num date) {
    return toSeconds(date) / 60;
  }

  static num toHours(num date) {
    return toMinutes(date) / 60;
  }

  static num toDays(num date) {
    return toHours(date) / 24;
  }

  static num toMonths(num date) {
    return toDays(date) / 30;
  }

  static num toYears(num date) {
    return toMonths(date) / 365;
  }
}
