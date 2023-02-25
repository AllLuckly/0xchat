import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yl_common/log_util.dart';
import 'package:yl_common/model/yl_user_info.dart';
import 'package:yl_common/navigator/navigator.dart';
import 'package:yl_common/utils/adapt.dart';
import 'package:yl_common/utils/theme_color.dart';
import 'package:yl_common/utils/yl_userinfo_manager.dart';
import 'package:yl_common/widgets/categoryView/yl_indicator.dart';
import 'package:yl_common/widgets/common_appbar.dart';
import 'package:yl_localizable/yl_localizable.dart';
import 'package:yl_usercenter/model/my_assets_entity.dart';
import 'package:yl_usercenter/model/my_pregod_entity.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:yl_usercenter/page/usercenter_page.dart';

import 'buy_nft_page.dart';
import 'nft_avatar_settings_submodule_page.dart';

class NFTAvatarSettingsPage extends StatefulWidget {
  const NFTAvatarSettingsPage({Key? key}) : super(key: key);

  @override
  State<NFTAvatarSettingsPage> createState() => _NFTAvatarSettingsPageState();
}

class _NFTAvatarSettingsPageState extends State<NFTAvatarSettingsPage> with SingleTickerProviderStateMixin, YLUserInfoObserver, WidgetsBindingObserver{
  MyAssetsEntity? assetsEntity;
  MyPreGod? preGod;
  List<PreGodList> showPreGodList = [];

  TabController? _tabController;

  @override
  void initState() {
      super.initState();
      bool isLogin = YLUserInfoManager.sharedInstance.isLogin;
      // LogUtil.e("==================isLogin : $isLogin");
      // if (isLogin == false) {
      //   _navigateToLoginPage(context);
      // }
      YLUserInfoManager.sharedInstance.addObserver(this);
      WidgetsBinding.instance.addObserver(this);
      // ThemeManager.addOnThemeChangedCallback(onThemeStyleChange);
      // CachedNetworkImage.logLevel = CacheManagerLogLevel.debug;
      // _getAccountInfoFn();
      // _nestedScrollController = ScrollController()
      //     ..addListener(() {
      //         // LogUtil.e("_scrollY:");
      //         if (_nestedScrollController.offset > _topHeight) {
      //             _scrollY = _nestedScrollController.offset - _topHeight;
      //             // _contentOnePageKey.currentState?.updateTabbarHeight(_scrollY);
      //             // _contentTwoPageKey.currentState?.updateTabbarHeight(_scrollY);
      //             // LogUtil.e("_scrollY:${_scrollY}");
      //         } else {
      //             if (_scrollY > 0) {
      //                 _scrollY = 0.0;
      //                 // _contentOnePageKey.currentState?.updateTabbarHeight(_scrollY);
      //                 // _contentTwoPageKey.currentState?.updateTabbarHeight(_scrollY);
      //             }
      //         }
      //     });
      _tabController = TabController(vsync: this, length: 2);
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
          backgroundColor: ThemeColor.bgColor,
          appBar: AppBar(
              backgroundColor: ThemeColor.bgColor,
              elevation: 0,
              titleSpacing: 0.0,//title widget两边不留间隙
              title: Container(
                  child:TabBar(
                      controller: _tabController,
                      tabs: [
                          Tab(text: "Digital Collectibles"),
                          Tab(text: "NFTs"),
                      ],
                      labelStyle: TextStyle(fontSize: 15,color: ThemeColor.titleColor, fontWeight: FontWeight.bold),
                      unselectedLabelStyle: TextStyle(fontSize: 13,color: ThemeColor.gray3, fontWeight: FontWeight.bold),
                      padding: EdgeInsets.only(right: 20),//60
                      labelPadding: EdgeInsets.only(left: 0, right:10),//RIGHT 30
                      indicator: RoundTabIndicator(
                        borderSide: BorderSide(color: Colors.blue, width: 4),
                        gradient: LinearGradient(colors: [
                            Color(0xff44FF35),
                            Color(0xff8792FF),
                            Color(0xffA67EFF)
                        ]),
                        isRound: true,
                        radius: 2,
                        width: 28,
                        insets: EdgeInsets.only(left: 0, right: 10)), //RIGHT 30
                  ),
              ),
          ),
          body: SafeArea(
              bottom: false,
              child: TabBarView(controller: _tabController, children: [
                      NFTAvatarSettingsSubmodulePage(pageType: NFTAvatarSettingsType.maticType,),
                      NFTAvatarSettingsSubmodulePage(pageType: NFTAvatarSettingsType.ethType,),
                  ],
                  // body: _buildBody(context),
              ),
          ),
      );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void didLoginSuccess(YLUserInfo? userInfo) {
    // TODO: implement didLoginSuccess
  }

  @override
  void didLogout() {
    // TODO: implement didLogout
  }

  @override
  void didSwitchUser(YLUserInfo? userInfo) {
    // TODO: implement didSwitchUser
  }


  // @override
  // void initState() {
  //     super.initState();
  //     _getAccountInfoFn();
  // }
  //
  // void _getAccountInfoFn() async {
  //   Map<String, dynamic> params = {};
  //   Map<String, dynamic> params2 = {};
  //   params["limit"] = 1000;
  //   params["exclude_tags"] = "POAP";
  //   params["latest"] = false;
  //
  //   // https://pregod.rss3.dev/v0.4.0/account:0xC8b960D09C0078c18Dcbe7eB9AB9d816BcCa8944@ethereum/notes?limit=1000&exclude_tags=POAP&tags=NFT&tags=ETH&latest=false
  //   params["tags"] = "NFT";
  //   params2["tags"] = "ETH";
  //
  //   ///组装请求参数
  //   for (String key in params.keys) {
  //     if (params2.containsKey(key)) {
  //       params2[key] = params[key] + "&" + key + "=" + params2[key];
  //     } else {
  //       params2[key] = params[key];
  //     }
  //   }
  //   preGod = await getMyPreGods(
  //     params: params2,
  //     account: '0xC8b960D09C0078c18Dcbe7eB9AB9d816BcCa8944');
  //   // LogUtil.e("1111=============xxxxxxxxxxxxxxx : ${preGod}=====${preGod!.list!}");
  //   if (preGod != null) {
  //     showPreGodList.addAll(preGod!.list!);
  //   }
  //   PreGodList addPreGod = PreGodList();
  //   showPreGodList.insert(0, addPreGod);//插入一个Add的Item
  //   if (mounted) setState(() {});
  // }
  //
  // @override
  // Widget build(BuildContext context) {
  //     super.build(context);
  //     return Scaffold(
  //         backgroundColor: ThemeColor.bgColor,
  //         appBar: CommonAppBar(
  //             title: Localized.text('yl_usercenter.NFT Avatar Settings'),
  //             useLargeTitle: false,
  //             centerTitle: true,
  //             canBack: false,
  //         ),
  //         body: buildBoby(),
  //     );
  // }
  //
  // Widget buildBoby(){
  //     LogUtil.e('Bison=====1== ${assetsEntity?.assets?.length}');
  //     return  showPreGodList.length == 0 ? Container(color: ThemeColor.bgColor,) : Container(
  //         color: ThemeColor.bgColor,
  //         child: MasonryGridView.count(
  //             crossAxisCount: 2,
  //             mainAxisSpacing: 18,
  //             crossAxisSpacing: 16,
  //             padding: EdgeInsets.only(left: 16, right: 16, top: 15),
  //             itemBuilder: (context, index) {
  //                 if(index == 0){
  //                     return ClipRRect(
  //                       borderRadius: BorderRadius.circular(Adapt.px(23)),
  //                       child: GestureDetector(
  //                           child: Container(
  //                               color: ThemeColor.gray5,
  //                               height: Adapt.px(200),
  //                               child: Icon(Icons.add,size: Adapt.px(150),),
  //                           ),
  //                           onTap: (){//点击购买NFT
  //                               YLNavigator.pushPage(context, (context) => BuyNftPage());
  //                           },
  //                       )
  //                     );
  //                 }
  //                 return InkWell(
  //                     child: ImageTile(
  //                         index: index,
  //                         width: 100,
  //                         height: 130,
  //                         imgUrl: showPreGodList[index].imgUrl ?? '',
  //                     ),
  //                     onTap: (){//点击设置NFT头像
  //                         YLNavigator.pop(context, "xxx2");
  //                     },
  //                 );
  //             },
  //             itemCount: showPreGodList.length,
  //         ),
  //     );
  // }
  //
  // @override
  // // TODO: implement wantKeepAlive
  // bool get wantKeepAlive => true;
}
