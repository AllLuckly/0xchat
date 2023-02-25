import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/diagnostics.dart';
import 'package:yl_common/log_util.dart';
import 'package:yl_common/model/yl_user_info.dart';
import 'package:yl_common/navigator/navigator.dart';
import 'package:yl_common/utils/adapt.dart';
import 'package:yl_common/utils/theme_color.dart';
import 'package:yl_common/utils/yl_userinfo_manager.dart';
import 'package:yl_common/widgets/categoryView/yl_indicator.dart';
import 'package:yl_common/widgets/common_appbar.dart';
import 'package:yl_common/widgets/common_button.dart';
import 'package:yl_common/widgets/common_image.dart';
import 'package:yl_localizable/yl_localizable.dart';
import 'package:yl_theme/yl_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../usercenter_nft_page.dart';
import 'avatar_shop_list_page.dart';

class AvatarShopPage extends StatefulWidget {
  const AvatarShopPage({Key? key}) : super(key: key);

  @override
  State<AvatarShopPage> createState() => _AvatarShopPageState();
}

class _AvatarShopPageState extends State<AvatarShopPage> with SingleTickerProviderStateMixin, YLUserInfoObserver, WidgetsBindingObserver{

  late ScrollController _nestedScrollController;
  int selectedIndex = 0;
  final PageController _pageController = PageController();

  final GlobalKey globalKey = GlobalKey();
  String? headImgUrl;

  double get _topHeight {
    return kToolbarHeight + Adapt.px(52);
  }

  TabController? _tabController;

  double _scrollY = 0.0;

  @override
  void initState() {
    super.initState();
    imageCache.clear();
    imageCache.maximumSize = 10;
    bool isLogin = YLUserInfoManager.sharedInstance.isLogin;
    LogUtil.e("==================isLogin : $isLogin");
    // if (isLogin == false) {
    //   _navigateToLoginPage(context);
    // }
    YLUserInfoManager.sharedInstance.addObserver(this);
    WidgetsBinding.instance.addObserver(this);
    ThemeManager.addOnThemeChangedCallback(onThemeStyleChange);
    _nestedScrollController = ScrollController()
      ..addListener(() {
        // LogUtil.e("_scrollY:");
        if (_nestedScrollController.offset > _topHeight) {
          _scrollY = _nestedScrollController.offset - _topHeight;
          // _contentOnePageKey.currentState?.updateTabbarHeight(_scrollY);
          // _contentTwoPageKey.currentState?.updateTabbarHeight(_scrollY);
          // LogUtil.e("_scrollY:${_scrollY}");
        } else {
          if (_scrollY > 0) {
            _scrollY = 0.0;
            // _contentOnePageKey.currentState?.updateTabbarHeight(_scrollY);
            // _contentTwoPageKey.currentState?.updateTabbarHeight(_scrollY);
          }
        }
      });
    _tabController = TabController(vsync: this, length: 1);
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
          // buildHeadImage(),
          // buildTabBar(),
          Expanded(child: buildTabView()),
        ],
      ),

    );
  }

  Widget buildHeadImage(){
    double width = MediaQuery.of(context).size.width;
    headImgUrl = YLUserInfoManager.sharedInstance.currentUserInfo?.headUrl ?? "";
    String localAvatarPath = 'assets/images/user_image.png';
    Image placeholderImage = Image.asset(
      localAvatarPath,
      fit: BoxFit.cover,
      width: Adapt.px(width),
      height: Adapt.px(width - 100),
      package: 'yl_wowchat',
    );
    return Container(
      child: Center(
        child:  Container(
          width: Adapt.px(width),
          height: Adapt.px(width - 100),
          child: CachedNetworkImage(
            imageUrl: headImgUrl!,
            //预览图
            fit: BoxFit.cover,
            placeholder:  (context, url) => placeholderImage,
            errorWidget: (context, url, error) => placeholderImage,
            width: Adapt.px(width),
            height: Adapt.px(width),
          ),
        ),
      ),
    );
  }

  Widget buildTabBar(){
    double width = MediaQuery.of(context).size.width;
    return TabBar(
      controller: _tabController,
      tabs: const [
        Tab(text: "Shop")
      ],
      labelStyle: TextStyle(fontSize: 20,color: ThemeColor.titleColor),
      unselectedLabelStyle: TextStyle(fontSize: 18,color: ThemeColor.gray3),
      padding: EdgeInsets.only(right: width - Adapt.px(96)),//60
      labelPadding: EdgeInsets.only(left: Adapt.px(16), right: Adapt.px(30)),//RIGHT 30
      indicator: RoundTabIndicator(
        borderSide: BorderSide(color: Colors.blue, width: 4),
        gradient: const LinearGradient(colors: [
          Color(0xff44FF35),
          Color(0xff8792FF),
          Color(0xffA67EFF)
        ]),
        isRound: true,
        radius: 2,
        width: 28,
        insets: EdgeInsets.only(left: Adapt.px(16), right: Adapt.px(30)), //RIGHT 30
      )
    );
  }

  Widget buildTabView(){
    return TabBarView(controller: _tabController, children:const [
       AvatarShopListPage(),
    ]
    );
  }

  onThemeStyleChange() {
    if (mounted) setState(() {});
  }

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
}


