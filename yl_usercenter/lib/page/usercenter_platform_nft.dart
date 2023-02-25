import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:yl_common/navigator/navigator.dart';
import 'package:yl_common/utils/adapt.dart';
import 'package:yl_common/utils/theme_color.dart';
import 'package:yl_common/utils/yl_userinfo_manager.dart';
import 'package:yl_common/widgets/base_page_state.dart';
import 'package:yl_common/widgets/common_appbar.dart';
import 'package:yl_usercenter/model/my_oxchat_nft_entity.dart';
import 'package:yl_usercenter/page/usercenter_chose_pic_tip.dart';
import 'package:yl_usercenter/uitls/choose_image_upload.dart';
import 'package:yl_usercenter/uitls/widget_tool.dart';

///Title:
///Description: TODO(自填)
///Copyright: Copyright (c) 2022
///@author Michael
///CreateTime: 2023/1/5 18:45
class UserCenterPlatformNFT extends StatefulWidget {
  const UserCenterPlatformNFT({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _UserCenterPlatformNFTState();
  }
}

class _UserCenterPlatformNFTState extends BasePageState<UserCenterPlatformNFT> {
  List<String> defaultNftList = [
    'icon_eg_1.png',
    'icon_eg_2.png',
    'icon_eg_3.png',
    'icon_eg_1.png',
  ];

  List<MyOxchatNftEntity>? oxNftList;


  @override
  void initState() {
    super.initState();
    initInterface();
  }

  void initInterface() async {
    oxNftList = await ChooseImageUploadNetManage.getUserOxchatAllNft(
        ownerAddress: YLUserInfoManager.sharedInstance.currentUserInfo?.token ?? '');
    if(mounted){
      setState((){});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: '',
        useLargeTitle: false,
        canBack: true,
      ),
      backgroundColor: ThemeColor.bgColor,
      extendBody: true,
      bottomNavigationBar: _bottomNavigationBar(),
      body: _body(),
    );
  }

  @override
  // TODO: implement routeName
  String get routeName => 'UserCenterPlatformNFT';

  Widget _body() {
    bool hadOxNft = oxNftList != null && oxNftList!.isNotEmpty;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        assetIcon(
          'icon_logo_ox.png',
          Adapt.px(160),
          Adapt.px(160),
        ),
        Container(
          margin: EdgeInsets.only(top: Adapt.px(18)),
          child: assetIcon(
            'icon_pagename_oxavatar.png',
            Adapt.px(134),
            Adapt.px(22),
          ),
        ),
        Text(
          'Use advanced AI tech to make the amazing NFT avatars',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: Adapt.px(14),
          ),
        ).setPadding(EdgeInsets.only(left: Adapt.px(24), top: Adapt.px(16), right: Adapt.px(24))),

        Expanded(child: GridView(
          padding: EdgeInsets.only(left: Adapt.px(12), top: Adapt.px(16), right: Adapt.px(12), ),
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: (Adapt.screenW() - Adapt.px(24))/2,
            crossAxisSpacing: Adapt.px(16),
            mainAxisSpacing: Adapt.px(16),
            childAspectRatio: 1,
          ),
          children: List.generate(hadOxNft ? oxNftList!.length : defaultNftList.length, (index) {
            String avatarName = '';
            if (hadOxNft) {
              avatarName = oxNftList![index].imageUrl ?? '';
            } else {
              avatarName = defaultNftList[index];
            }
            return Container(
              child: hadOxNft
                  ? ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(Adapt.px(24))),
                child: CachedNetworkImage(
                  imageUrl: avatarName,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => assetIcon('icon_eg_1.png', Adapt.px(163), Adapt.px(163)),
                  errorWidget: (context, url, error) => assetIcon('icon_eg_1.png', Adapt.px(163), Adapt.px(163)),
                  width: Adapt.px(163),
                  height: Adapt.px(163),
                ),
              )
                  : assetIcon(
                avatarName,
                Adapt.px(160),
                Adapt.px(160),
              ),
            );
          }),
        ),),


      ],
    );
  }

  Widget _bottomNavigationBar(){
    return Container(
      alignment: Alignment.bottomCenter,
      height: Adapt.px(116),
      color: Colors.transparent,
      child: Center(
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: (){
            YLNavigator.pushPage(context, (context) => const UserCenterChosePicTip());
          },
          child: Container(
            height: Adapt.px(48),
            margin: EdgeInsets.symmetric(horizontal: Adapt.px(24)),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFC084FC), Color(0xFF818CF8)]),
              borderRadius: BorderRadius.all(Radius.circular(Adapt.px(12))),
            ),
            child: Text('Creat NFT Avatar',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: Adapt.px(15),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
