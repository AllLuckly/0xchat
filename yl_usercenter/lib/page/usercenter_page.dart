import 'package:flutter/material.dart';
import 'package:yl_cache_manager/yl_cache_manager.dart';
import 'package:yl_common/log_util.dart';
import 'package:yl_common/mixin/common_state_view_mixin.dart';
import 'package:yl_common/model/yl_user_info.dart';
import 'package:yl_common/navigator/navigator.dart';
import 'package:yl_common/network/network_tool.dart';
import 'package:yl_common/utils/adapt.dart';
import 'package:yl_common/utils/storage_key_tool.dart';
import 'package:yl_common/utils/theme_color.dart';
import 'package:yl_common/utils/yl_userinfo_manager.dart';
import 'package:yl_common/widgets/base_page_state.dart';
import 'package:yl_common/widgets/categoryView/rectangular_indicator.dart';
import 'package:yl_common/widgets/common_appbar.dart';
import 'package:yl_common/widgets/common_button.dart';
import 'package:yl_common/widgets/common_image.dart';
import 'package:yl_common/widgets/common_status_view.dart';
import 'package:yl_common/widgets/common_svg.dart';
import 'package:yl_common/widgets/common_toast.dart';
import 'package:yl_localizable/yl_localizable.dart';
import 'package:yl_module_service/yl_module_service.dart';
import 'package:yl_theme/yl_theme.dart';
import 'package:yl_usercenter/model/DynamicSubmodulePageType.dart';
import 'dart:math';

import 'package:yl_usercenter/model/my_assets_entity.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:yl_usercenter/model/my_generation_ai_steps_entity.dart';
import 'package:yl_usercenter/model/my_mainnet_entity.dart';
import 'package:yl_usercenter/model/my_pregod_entity.dart';
import 'package:yl_usercenter/page/nft_avatar/nft_avatar_generate_done_page.dart';
import 'package:yl_usercenter/page/set_up/avatar_preview_page.dart';
import 'package:yl_usercenter/page/set_up/set_up_page.dart';

// import 'package:yl_usercenter/page/usercenter_create_avatar.dart';
import 'package:yl_usercenter/page/usercenter_dynamic_page.dart';
import 'package:yl_usercenter/page/usercenter_dynamic_submodule_page.dart';
import 'package:yl_usercenter/page/usercenter_dynamic_submodule_page_rss.dart';

// import 'package:yl_usercenter/page/usercenter_magic_avatar.dart';
import 'package:yl_usercenter/page/usercenter_nft_page.dart';
import 'package:yl_usercenter/page/usercenter_platform_nft.dart';
import 'package:yl_usercenter/uitls/choose_image_upload.dart';
import 'package:yl_usercenter/yl_usercenter.dart';
import 'package:yl_common/widgets/categoryView/yl_indicator.dart';

import 'package:flutter/services.dart';
import 'package:yl_localizable/yl_localizable.dart';
import 'package:yl_common/widgets/common_gradient_border_widget.dart';
import 'dart:io';
import 'package:flutter/services.dart';

import 'package:extended_image/extended_image.dart';
import 'package:yl_wowchat/page/community_my_idcard_dialog.dart';

class UserCenterPage extends StatefulWidget {
  const UserCenterPage({Key? key}) : super(key: key);

  @override
  State<UserCenterPage> createState() => _UserCenterPageState();
}

class _UserCenterPageState extends BasePageState<UserCenterPage>
    with TickerProviderStateMixin, YLUserInfoObserver, WidgetsBindingObserver, CommonStateViewMixin {
  MyAssetsEntity? assetsEntity;
  MyPreGod? preGod;
  late ScrollController _nestedScrollController;
  int selectedIndex = 0;
  final PageController _pageController = PageController();

  final GlobalKey globalKey = GlobalKey();

  double get _topHeight {
    return kToolbarHeight + Adapt.px(52);
  }

  TabController? _tabController;
  late TabController _dynamicTabController;

  double _scrollY = 0.0;

  late String _addressStr;

  String mHostName = ''; //当前的domain

  num friendsLength = 0;

  num nftHotChatLength = 0;

  num nftLength = 0;

  bool isShowSos = false; //展示

  bool isCloseSos = false; //是否手动关闭

  bool isShowLoading = true;

  List<OwnedNfts> showOwnedNfts = [];
  List<OwnedNfts> showPreGodList = [];

  MyGenerationAiStepsEntity? _myGenerationAiStepsEntity;

  @override
  void initState() {
    super.initState();
    imageCache.clear();
    imageCache.maximumSize = 10;
    YLUserInfoManager.sharedInstance.addObserver(this);
    WidgetsBinding.instance.addObserver(this);

    _addressStr = YLUserInfoManager.sharedInstance.currentUserInfo?.token ?? '';
    ThemeManager.addOnThemeChangedCallback(onThemeStyleChange);
    CachedNetworkImage.logLevel = CacheManagerLogLevel.debug;
    _getAccountInfoFn();
    _nestedScrollController = ScrollController()
      ..addListener(() {
        if (_nestedScrollController.offset > _topHeight) {
          _scrollY = _nestedScrollController.offset - _topHeight;
        } else {
          if (_scrollY > 0) {
            _scrollY = 0.0;
          }
        }
      });
    _tabController = TabController(vsync: this, length: 2);
    _dynamicTabController = TabController(vsync: this, length: 4);
    initFromCache();
    _initInterface();
  }

  @override
  stateViewCallBack(CommonStateView commonStateView) {
    switch (commonStateView) {
      case CommonStateView.CommonStateView_None:
        break;
      case CommonStateView.CommonStateView_NetworkError:
      case CommonStateView.CommonStateView_NoData:
        break;
      case CommonStateView.CommonStateView_NotLogin:
        break;
    }
  }

  void _initInterface() async {
    _myGenerationAiStepsEntity = await ChooseImageUploadNetManage.getAiGenerationSteps(
        ownerAddress: _addressStr,
        processId: await YLCacheManager.defaultYLCacheManager.getForeverData('processId', defaultValue: ''));
    if (mounted) setState(() {});
  }

  void initFromCache() async {
    mHostName = await YLCacheManager.defaultYLCacheManager.getForeverData(StorageKeyTool.APP_DOMAIN_NAME, defaultValue: 'yl.com');
  }

  void _getAccountInfoFn() async {
    bool isLogin = YLUserInfoManager.sharedInstance.isLogin;
    if (!isLogin) {
      return;
    }
    friendsLength = await YLModuleService.invoke("yl_wowchat", "getFriendsLength", []);
    friendsLength = friendsLength < 0 ? 0 : friendsLength;
    nftHotChatLength = await YLModuleService.invoke("yl_wowchat", "getNftHotChatLength", []);
    List<OwnedNfts> ethList = await _getMyEthEntitys();
    List<OwnedNfts> mainnetList = await _getMyMainnetEntitys();
    isShowLoading = false;
    nftLength = ethList.length + mainnetList.length;
    isShowSos = nftLength > 0 ? false : true;
    if (mounted) setState(() {});
  }

  Future<List<OwnedNfts>> _getMyMainnetEntitys() async {
    bool isLogin = YLUserInfoManager.sharedInstance.isLogin;
    if (!isLogin) {
      return [];
    }
    //0x96d7cf71f6391a6092487c0390c4977052e78ddb
    //0xC8b960D09C0078c18Dcbe7eB9AB9d816BcCa8944
    MyMainnetEntity? mainnetEntity = await getMyMainnetEntitys(account: _addressStr);
    if (mainnetEntity != null) {
      showOwnedNfts.addAll(mainnetEntity.ownedNfts!);
    }
    return showOwnedNfts;
  }

  Future<List<OwnedNfts>> _getMyEthEntitys() async {
    bool isLogin = YLUserInfoManager.sharedInstance.isLogin;
    if (!isLogin) {
      return [];
    }
    //0x96d7cf71f6391a6092487c0390c4977052e78ddb
    //0xC8b960D09C0078c18Dcbe7eB9AB9d816BcCa8944
    MyMainnetEntity? mainnetEntity = await getMyEthEntitys(account: _addressStr);
    if (mainnetEntity != null) {
      showPreGodList.addAll(mainnetEntity.ownedNfts!);
    }
    return showPreGodList;
  }

  _navigateToLoginPage(BuildContext context) async {
    LogUtil.e("_navigateToLoginPage");
    await YLModuleService.pushPage(
      context,
      "yl_login",
      "LoginPage",
      {},
    );
  }

  @override
  Widget build(BuildContext context) {
    LogUtil.e((isShowSos && isCloseSos == true));
    bool isLogin = YLUserInfoManager.sharedInstance.isLogin;
    return Scaffold(
      backgroundColor: ThemeColor.color200,
      appBar: CommonAppBar(
        backgroundColor: ThemeColor.color200,
        title: '',
        useLargeTitle: false,
        centerTitle: false,
        canBack: false,
        actions: <Widget>[
          isLogin
              ? Container(
                  margin: EdgeInsets.only(right: Adapt.px(5), top: Adapt.px(12)),
                  color: Colors.transparent,
                  child: YLEButton(
                    highlightColor: Colors.transparent,
                    color: Colors.transparent,
                    minWidth: Adapt.px(44),
                    height: Adapt.px(44),
                    child: CommonImage(
                      iconName: "nav_more_dot.png",
                      width: Adapt.px(24),
                      height: Adapt.px(24),
                    ),
                    onPressed: () {
                      YLNavigator.pushPage(context, (context) => SetUpPage()).then((value) {
                        setState(() {});
                      });
                    },
                  ),
                )
              : Container(),
        ],
      ),
      // body: buildBoby(),
      body: commonStateViewWidget(
        context,
        Container(
          child: NestedScrollView(
            controller: _nestedScrollController,
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  backgroundColor: ThemeColor.color200,
                  pinned: true,
                  floating: true,
                  expandedHeight: (isShowSos && isCloseSos == false) ? Adapt.px(391 + 76) : Adapt.px(391),
                  elevation: 0,
                  flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.pin,
                    background: Container(
                      //头部整个背景颜色
                      height: double.infinity,
                      color: ThemeColor.color200,
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: Adapt.px(3),
                          ),
                          Visibility(
                              child: Container(
                                width: Adapt.px(MediaQuery.of(context).size.width - 24 * 2),
                                margin: EdgeInsets.only(left: Adapt.px(24), right: Adapt.px(24), bottom: Adapt.px(16)),
                                height: Adapt.px(60),
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(16),
                                  ),
                                  border: Border.all(color: ThemeColor.color180, width: 0),
                                  gradient: LinearGradient(colors: [ThemeColor.gradientMainStart, ThemeColor.gradientMainEnd]),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      constraints: BoxConstraints(
                                        maxWidth: Adapt.px(280),
                                      ),
                                      margin: EdgeInsets.only(left: Adapt.px(16), right: Adapt.px(5)),
                                      child: Text("You don't have an NFT avatar yet, use 0xavatar to create one!",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                            color: ThemeColor.color0,
                                          ),
                                          maxLines: 2),
                                    ),
                                    GestureDetector(
                                      child: CommonImage(
                                        iconName: "close_icon_white.png",
                                        width: Adapt.px(24),
                                        height: Adapt.px(24),
                                      ),
                                      onTap: () {
                                        isCloseSos = true;
                                        setState(() {});
                                      },
                                    ),
                                    SizedBox(
                                      width: Adapt.px(16),
                                    ),
                                  ],
                                ),
                              ),
                              visible: (isShowSos && isCloseSos == false)

                              // visible: true
                              ),
                          SizedBox(
                            height: Adapt.px(3),
                          ),
                          buildHeadImage(),
                          SizedBox(
                            height: Adapt.px(13),
                          ),
                          buildHeadName(),
                          buildHeadDesc(),
                          buildHeadStatistics(),
                          buildHeadAdditional(),
                        ],
                      ),
                    ),
                  ),
                  bottom: PreferredSize(
                    preferredSize: Size.fromHeight(50),
                    child: Container(
                        height: 50,
                        color: ThemeColor.color200,
                        child: Theme(
                          data: ThemeData(
                            backgroundColor: Colors.transparent,

                            ///点击的高亮颜色
                            highlightColor: Colors.transparent,

                            ///水波纹颜色
                            splashColor: Colors.transparent,
                          ),
                          child: TabBar(
                            controller: _tabController,
                            tabs: [
                              // Tab(text: "Digital Collectibles"),
                              Tab(text: "NFTs"),
                              Tab(text: Localized.text("yl_usercenter.动态")),
                              // Tab(text: Localized.text("yl_usercenter.全部")),
                              // Tab(text: Localized.text("yl_usercenter.交易")),
                              // Tab(text: Localized.text("yl_usercenter.捐赠")),
                              // Tab(text: Localized.text("yl_usercenter.文章")),
                            ],
                            labelStyle: TextStyle(fontSize: 14, color: ThemeColor.titleColor, fontWeight: FontWeight.w600),
                            unselectedLabelStyle: TextStyle(fontSize: 14, color: ThemeColor.color120, fontWeight: FontWeight.w400),
                            padding: EdgeInsets.symmetric(horizontal: Adapt.screenW()/4),
                            //RIGHT 30
                            indicator: RoundTabIndicator(
                                borderSide: BorderSide(width: Adapt.px(6)),
                                gradient: LinearGradient(
                                  colors: [
                                    ThemeColor.gradientMainEnd,
                                    ThemeColor.gradientMainStart,
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                                isRound: true,
                                radius: Adapt.px(6),
                                width: Adapt.px(6),
                                insets: EdgeInsets.only(left: 0, right: 10)), //RIGHT 30
                          ),
                        )),
                  ),
                ),
              ];
            },
            body: TabBarView(controller: _tabController, children: [
              // UserCenterNFTPage(),
              isShowLoading
                  ? _showLoading()
                  : UsercenterDynamicSubmodulePage(
                      pageType: DynamicSubmodulePageType.maticType,
                      showOwnedNfts: showOwnedNfts,
                      showPreGodList: showPreGodList,
                    ),
              Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: Adapt.px(15), right: Adapt.px(15), top: Adapt.px(15)),
                    height: Adapt.px(31),
                    padding: EdgeInsets.only(left: Adapt.px(2), right: Adapt.px(2), top: Adapt.px(2), bottom: Adapt.px(2)),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(4.0)),
                      border: Border.all(
                        width: 1,
                      ),
                      color: ThemeColor.gray6,
                    ),
                    child: TabBar(
                      controller: _dynamicTabController,
                      tabs: [
                        _tabBarItem("全部"),
                        _tabBarItem("交易"),
                        _tabBarItem("捐赠"),
                        _tabBarItem("文章", showRightImage: false),
                      ],
                      isScrollable: false,
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.white,
                      labelStyle: TextStyle(fontSize: 13),
                      unselectedLabelStyle: TextStyle(fontSize: 13),
                      indicator: RectangularIndicator(
                        bottomLeftRadius: 7,
                        bottomRightRadius: 7,
                        topLeftRadius: 7,
                        topRightRadius: 7,
                        color: ThemeColor.gray7,
                      ),
                    ),
                  ),
                  Container(
                    height: Adapt.screenH() - MediaQuery.of(context).padding.top - Adapt.px(31 + 15 + 44),
                    child: TabBarView(
                      physics: NeverScrollableScrollPhysics(),
                      controller: _dynamicTabController,
                      children: <Widget>[
                        UsercenterDynamicSubmoduleRssPage(
                          pageType: DynamicSubmodulePageType.allType,
                        ),
                        UsercenterDynamicSubmoduleRssPage(
                          pageType: DynamicSubmodulePageType.tradeType,
                        ),
                        UsercenterDynamicSubmoduleRssPage(
                          pageType: DynamicSubmodulePageType.donateType,
                        ),
                        UsercenterDynamicSubmoduleRssPage(
                          pageType: DynamicSubmodulePageType.articleType,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _tabBarItem(String title, {bool showRightImage = true}) {
    return Tab(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: Center(
            child: Text(title),
          ),
        ),
      ],
    ));
  }

  Widget buildHeadImage() {
    String headImgUrl = YLUserInfoManager.sharedInstance.currentUserInfo?.headUrl ?? "";
    LogUtil.e("headImgUrl: ${headImgUrl}");
    final map = <String, String>{};
    String host = getHostUrl(headImgUrl ?? '');
    if (host.length > 0) {
      map['Host'] = host;
      map['User-Agent'] = 'PostmanRuntime/7.26.8';
    }
    String localAvatarPath = 'assets/images/user_image.png';

    Image placeholderImage = Image.asset(
      localAvatarPath,
      fit: BoxFit.cover,
      width: Adapt.px(76),
      height: Adapt.px(76),
      package: 'yl_wowchat',
    );

    Map<String, String> headers = {'Host': 'css.' + mHostName};
    if (Platform.isIOS) {
      headers = {};
    }
    return Container(
      width: Adapt.px(128),
      height: Adapt.px(128),
      child: Stack(
        children: [
          Container(
            alignment: Alignment.center,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(Adapt.px(124)),
              child: CachedNetworkImage(
                imageUrl: headImgUrl!,
                // imageUrl: "https://cryptobuds.site/logo.gif",
                //预览图
                fit: BoxFit.cover,
                placeholder: (context, url) => placeholderImage,
                errorWidget: (context, url, error) => placeholderImage,
                width: Adapt.px(124),
                height: Adapt.px(124),
                httpHeaders: map,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: double.infinity,
            child: Center(
              child: Container(
                width: Adapt.px(115),
                height: Adapt.px(115),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(Adapt.px(115)),
                  border: Border.all(
                    width: Adapt.px(3),
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              _jumpLogicForNft();
            },
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  alignment: Alignment.topRight,
                  child: Container(
                    width: Adapt.px(33),
                    height: Adapt.px(33),
                    child: Center(
                      child: CommonImage(
                        iconName: 'icon_ai_images.png',
                        width: Adapt.px(32),
                        height: Adapt.px(32),
                        package: 'yl_usercenter',
                      ),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  alignment: Alignment.topRight,
                  child: Container(
                    width: Adapt.px(33),
                    height: Adapt.px(33),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(Adapt.px(33)),
                      border: Border.all(
                        width: Adapt.px(3),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildHeadName() {
    String nickName = YLUserInfoManager.sharedInstance.currentUserInfo?.nickName ?? "";
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          nickName,
          style: TextStyle(color: ThemeColor.titleColor, fontSize: 20),
        ),
        // Container(
        //   decoration: BoxDecoration(
        //     border: Border.all(color: Colors.transparent, width: 1,style: BorderStyle.solid),
        //     borderRadius: BorderRadius.circular(Adapt.px(18)),
        //     color: ThemeColor.yellow1,
        //   ),
        //   child: Text(
        //     "27.6k热度",style: TextStyle(color: ThemeColor.titleColor, fontSize: 12),
        //   ),
        //   padding: EdgeInsets.only(left: 7,right: 7),
        //   margin: EdgeInsets.only(left: 5),
        // )
      ],
    );
  }

  Widget buildHeadDesc() {
    // String address = "0xC8b960D09C0078c18Dcbe7eB9AB9d816BcCa8944";
    String address = _addressStr;
    String addressFoot = address.substring(address.length - 4);
    String addressHead = address.substring(0, 6);
    String showAddress = '${addressHead}...${addressFoot}';
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        // SizedBox(
        //   height: Adapt.px(6),
        // ),
        // Container(
        //     margin: EdgeInsets.only(left: Adapt.px(52), right: Adapt.px(52)),
        //     child: Wrap(
        //       children: [
        //         Text(
        //           YLUserInfoManager.sharedInstance.currentUserInfo?.whatsUp ?? '',
        //           maxLines: 2,
        //           textAlign: TextAlign.center,
        //           style: TextStyle(color: ThemeColor.gray3, fontSize: 12),
        //         ),
        //       ],
        //     )),
        SizedBox(
          height: Adapt.px(2),
        ),
        GestureDetector(
          child: Center(
            child: Container(
              width: Adapt.px(158),
              height: Adapt.px(22),
              decoration: BoxDecoration(
                  // color: ThemeColor.purple2,
                  // borderRadius: BorderRadius.all(Radius.circular(35)),
                  ),
              child: Row(
                children: [
                  SizedBox(
                    width: Adapt.px(16),
                  ),
                  Expanded(
                      child: Text(
                    showAddress,
                    maxLines: 1,
                    style: TextStyle(color: ThemeColor.color120, fontSize: 16),
                    // overflow: TextOverflow.ellipsis,
                  )),
                  SizedBox(
                    width: Adapt.px(4),
                  ),
                  CommonImage(
                    iconName: "icon_copy.png",
                    width: Adapt.px(16),
                    height: Adapt.px(16),
                  ),
                  SizedBox(
                    width: Adapt.px(9),
                  )
                ],
              ),
            ),
          ),
          onTap: () {
            //点击复制
            Clipboard.setData(ClipboardData(text: address));
            CommonToast.instance.show(context, Localized.text("yl_usercenter.copy_successfully"));
          },
        )
      ],
      textBaseline: TextBaseline.alphabetic,
    );
  }

  Widget buildHeadStatistics() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatistics("$friendsLength", "Friends"),
        _buildStatistics("$nftHotChatLength", "Channels"),
        _buildStatistics("$nftLength", "NFTs"),
      ],
    );
  }

  Widget _buildStatistics(String num, String title) {
    return Container(
      margin: EdgeInsets.only(top: Adapt.px(24)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            num,
            style: TextStyle(fontSize: 16, color: ThemeColor.color0, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: Adapt.px(2)),
          Text(
            title,
            style: TextStyle(fontSize: 14, color: ThemeColor.color120, fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }

  Widget buildHeadAdditional() {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildHeadAdditionalButton("Share", 135, 48, onTap: () {
            showDialog(
                context: context,
                barrierDismissible: true,
                builder: (BuildContext context) {
                  return CommunityMyIdCardDialog();
                });
            // YLNavigator.pushPage(context, (context) => const UserCenterUploadAvatar());
          },
              linearGradient: LinearGradient(
                colors: [
                  ThemeColor.gradientMainEnd,
                  ThemeColor.gradientMainStart,
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              )),
          _buildHeadAdditionalButton("Edit Profile", 135, 48, onTap: () {
            YLNavigator.pushPage(context, (context) => const AvatarPreviewPage()).then((value) {
              setState(() {});
            });
            // YLNavigator.pushPage(context, (context) => SetUpPage());
            // YLNavigator.pushPage(context, (context) => const UserCenterCreateAvatar());
          }),
          _buildHeadAdditionalButton("...", 48, 48, onTap: () {
            YLNavigator.pushPage(context, (context) => const SetUpPage()).then((value) {
              setState(() {});
            });
            // YLNavigator.pushPage(context, (context) => const UserCenterMagicAvatar());
          })
        ],
      ),
    );
  }

  Widget _buildHeadAdditionalButton(String title, double width, double height, {required VoidCallback onTap, LinearGradient? linearGradient}) {
    return GestureDetector(
      child: Container(
        width: Adapt.px(width),
        height: Adapt.px(height),
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(fontSize: Adapt.px(15)),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: ThemeColor.color180,
          gradient: linearGradient,
        ),
      ),
      onTap: onTap,
    );
  }

  Widget _showLoading() {
    return Container(
      constraints: const BoxConstraints.expand(),
      color: ThemeColor.color200,
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

  onThemeStyleChange() {
    if (mounted) setState(() {});
  }

  void _jumpLogicForNft() {
    if (_myGenerationAiStepsEntity == null) {
      YLNavigator.pushPage(context, (context) => const UserCenterPlatformNFT());
    } else {
      if (_myGenerationAiStepsEntity!.canGenerateNFTAvatarCount == 0 ||
          (_myGenerationAiStepsEntity!.generateAiImageFinishFlag && _myGenerationAiStepsEntity!.generateNFTAvatarFinishFlag)) {
        YLNavigator.pushPage(context, (context) => const UserCenterPlatformNFT());
      } else {
        if (_myGenerationAiStepsEntity!.generateAiImageFinishFlag && !_myGenerationAiStepsEntity!.generateNFTAvatarFinishFlag) {
          //还有购买NFT生成次数，并且AI已生成，NFT未生成的情况
          YLNavigator.pushPage(context, (context) => NFTAvatarGenerateDonePage(myGenerationAiStepsEntity: _myGenerationAiStepsEntity));
        } else {
          YLNavigator.pushPage(context, (context) => const UserCenterPlatformNFT());
        }
      }
    }
  }

  @override
  void didLoginSuccess(YLUserInfo? userInfo) {
    if (this.mounted) {
      setState(() {
        updateStateView(CommonStateView.CommonStateView_None);
        _getAccountInfoFn();
      });
    }
  }

  @override
  void didLogout() {
    LogUtil.e("useercenter.didLogout");
    if (this.mounted) {
      setState(() {
        updateStateView(CommonStateView.CommonStateView_NotLogin);
      });
    }
  }

  String getHostUrl(String url) {
    RegExp regExp = new RegExp(r"^.*?://(.*?)/.*?$");
    RegExpMatch? match = regExp.firstMatch(url);
    if (match != null) {
      return match.group(1) ?? '';
    }
    return '';
  }

  Widget buildBoby() {
    // LogUtil.e('Bison=====1== ${assetsEntity?.assets?.length}');
    return assetsEntity == null
        ? Container()
        : Container(
            child: MasonryGridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 1,
              crossAxisSpacing: 1,
              itemBuilder: (context, index) {
                return Container();
              },
              itemCount: assetsEntity?.assets?.length,
            ),
          );
  }

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class ImageTile extends StatelessWidget {
  const ImageTile({Key? key, required this.index, required this.width, required this.height, required this.imgUrl, required this.item}) : super(key: key);

  final int index;
  final int width;
  final int height;
  final String imgUrl;
  final OwnedNfts item;

  @override
  Widget build(BuildContext context) {
    final map = <String, String>{};
    // String host = getHostUrl(imgUrl);
    // if(host.length > 0){
    //   map['Host'] =  host;
    //   map['User-Agent'] = 'PostmanRuntime/7.26.8';
    // }
    // LogUtil.e('Bison======= ${host} =====  ${imgUrl}');
    // Image image = new Image(image: new CachedNetworkImageProvider(imgUrl));

    Size? imgSize;
    double xwidth = MediaQuery.of(context).size.width;
    Widget image = ExtendedImage.network(
      imgUrl,
      width: Adapt.px((xwidth - 32) / 2),
      height: Adapt.px((xwidth - 32) / 2),
      shape: BoxShape.rectangle,
      clearMemoryCacheWhenDispose: true,
      border: Border.all(color: ThemeColor.gray5, width: 1.0),
      borderRadius: const BorderRadius.all(
        Radius.circular(10.0),
      ),
      fit: BoxFit.cover,
      loadStateChanged: (ExtendedImageState value) {
        if (value.extendedImageLoadState == LoadState.loading) {
          Widget loadingWidget = Container(
            width: Adapt.px((xwidth - 32) / 2),
            height: Adapt.px((xwidth - 32) / 2),
            alignment: Alignment.center,
            color: ThemeColor.gray5,
            child: CircularProgressIndicator(
              strokeWidth: 2.0,
              valueColor: AlwaysStoppedAnimation<Color>(ThemeColor.purple1),
            ),
          );

          //todo: not work in web
          loadingWidget = AspectRatio(
            aspectRatio: 1.0,
            child: loadingWidget,
          );

          return loadingWidget;
        } else if (value.extendedImageLoadState == LoadState.completed) {
          // item.imgSize = Size(
          //     value.extendedImageInfo!.image.width.toDouble(),
          //     value.extendedImageInfo!.image.height.toDouble());
        } else if (value.extendedImageLoadState == LoadState.failed) {
          return Stack(
            children: [
              Container(
                width: Adapt.px((xwidth - 32) / 2),
                height: Adapt.px((xwidth - 32) / 2),
                color: ThemeColor.color190,
              ),
              Align(
                alignment: const Alignment(0, 0),
                child: CommonImage(
                  iconName: 'image_default_icon.png',
                  width: Adapt.px(48),
                  height: Adapt.px(48),
                  fit: BoxFit.cover,
                ),
              )

            ],
          );
        }
        return null;
      },
    );

// if (item.imgSize != null && item.imgSize?.width != 0) {
//   LogUtil.e('item.imgSize ===== :${item.imgSize}');
//     if (image != null){
//       image = AspectRatio(
//       aspectRatio: imgSize!.width / imgSize!.height,
//       child: image,
//       );
//     }
//   }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(
          height: 5.0,
        ),
        image,
        const SizedBox(
          height: 5.0,
        ),
      ],
    );
  }

  String getHostUrl(String url) {
    RegExp regExp = new RegExp(r"^.*?://(.*?)/.*?$");
    RegExpMatch? match = regExp.firstMatch(url);
    if (match != null) {
      return match.group(1) ?? '';
    }
    return '';
  }
}
