import 'dart:async';

import 'package:flutter/material.dart';
import 'package:yl_cache_manager/yl_cache_manager.dart';
import 'package:yl_common/log_util.dart';
import 'package:yl_common/navigator/navigator.dart';
import 'package:yl_common/utils/adapt.dart';
import 'package:yl_common/utils/theme_color.dart';
import 'package:yl_common/utils/yl_userinfo_manager.dart';
import 'package:yl_common/widgets/categoryView/yl_indicator.dart';
import 'package:yl_common/widgets/common_appbar.dart';
import 'package:yl_common/widgets/common_button.dart';
import 'package:yl_common/widgets/common_image.dart';
import 'package:yl_common/widgets/common_toast.dart';
import 'package:yl_usercenter/model/my_generation_ai_steps_entity.dart';
import 'package:yl_usercenter/page/nft_avatar/nft_avatar_choose_tab.dart';
import 'package:yl_usercenter/page/usercenter_page.dart';
import 'package:yl_usercenter/uitls/choose_image_upload.dart';
import 'package:yl_usercenter/widget/custom_circular_progress_indicator.dart';
import 'package:yl_usercenter/widget/notice_button_widget.dart';
import 'package:yl_usercenter/widget/ntf_avatar_loading_card.dart';

enum CardType {
  label,
  loading,
  done,
  error,
}

class NFTAvatarGenerateDonePage extends StatefulWidget {
  final MyGenerationAiStepsEntity? myGenerationAiStepsEntity;

  const NFTAvatarGenerateDonePage({Key? key, this.myGenerationAiStepsEntity})
      : super(key: key);

  @override
  _NFTAvatarGenerateDonePageState createState() =>
      _NFTAvatarGenerateDonePageState();
}

class _NFTAvatarGenerateDonePageState extends State<NFTAvatarGenerateDonePage>
    with TickerProviderStateMixin {
  late ScrollController _scrollController;

  late final TabController _tabController;

  late AnimationController _animationController;

  final List<ImagesPaths> _selectedImages = [];

  CardType _cardType = CardType.label;

  Timer? _timer;

  @override
  void initState() {
    _scrollController = ScrollController();

    _tabController = TabController(
        length: widget.myGenerationAiStepsEntity?.imagesPaths?.length ?? 2,
        vsync: this);

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );

    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<ImagesPaths> imagesPaths =
        widget.myGenerationAiStepsEntity?.imagesPaths ?? [];

    var _canGenerateNFTAvatarCount =
        widget.myGenerationAiStepsEntity?.canGenerateNFTAvatarCount ?? 0;

    return Scaffold(
      backgroundColor: ThemeColor.color200,
      appBar: CommonAppBar(
        backgroundColor: ThemeColor.color200,
        title: 'Create NFT avatar',
        useLargeTitle: false,
        centerTitle: true,
        canBack: false,
        leading: Container(),
        actions: [
          Container(
            margin: EdgeInsets.only(
              right: Adapt.px(5),
              top: Adapt.px(12),
            ),
            color: Colors.transparent,
            child: YLEButton(
              highlightColor: Colors.transparent,
              color: Colors.transparent,
              minWidth: Adapt.px(44),
              height: Adapt.px(44),
              child: CommonImage(
                iconName: "icon_right_close.png",
                width: Adapt.px(24),
                height: Adapt.px(24),
              ),
              onPressed: () {
                YLNavigator.popToPage(context, pageType: const UserCenterPage().runtimeType.toString());
              },
            ),
          ),
        ],
      ),
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: Adapt.px(24)),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    SizedBox(
                      height: Adapt.px(20),
                    ),
                    Center(
                      child: CustomCircularProgressIndicator(
                        width: Adapt.px(120),
                        strokeWidth: Adapt.px(3),
                        value: 1,
                        valueColor: ColorTween(
                          begin: ThemeColor.gradientMainStart,
                          end: ThemeColor.gradientMainEnd,
                        ).animate(_animationController),
                      ),
                    ),
                    SizedBox(
                      height: Adapt.px(32),
                    ),
                    Center(
                      child: Text(
                        "Generating Done",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: Adapt.px(32),
                            color: ThemeColor.color0),
                      ),
                    ),
                    SizedBox(
                      height: Adapt.px(12),
                    ),
                    Center(
                      child: Text(
                        "Select $selectedAvatarCount avatars to create as NFT avatars",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: Adapt.px(16),
                            color: ThemeColor.white01),
                      ),
                    ),
                    SizedBox(
                      height: Adapt.px(12),
                    ),
                    if (_cardType == CardType.label)
                      Center(
                        child: Text(
                          "0xavatar generate $totalAvatarCount avatars for you, and you can choose $_canGenerateNFTAvatarCount to create as NFT avatars",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: Adapt.px(14),
                              color: ThemeColor.color60),
                        ),
                      ),
                    if (_cardType == CardType.done)
                      NTFAvatarLoadingCard(
                        loadingType: LoadingType.done,
                        title: "Creating NFT Done",
                        centerLabel:
                            "$_canGenerateNFTAvatarCount NFT avatars are being created",
                        bottomLabel: "Creating Done",
                      ),
                    if (_cardType == CardType.loading)
                      NTFAvatarLoadingCard(
                        loadingType: LoadingType.loading,
                        title: "Creating NFT Avatar",
                        centerLabel:
                            "$_canGenerateNFTAvatarCount NFT avatars are being created",
                        bottomLabel: "Time left 2MIN",
                      ),
                    if (_cardType == CardType.error)
                      Center(
                        child: Container(
                            width: Adapt.px(100),
                            height: Adapt.px(100),
                            decoration: BoxDecoration(
                              color: ThemeColor.color180,
                              borderRadius: BorderRadius.circular(
                                Adapt.px(20),
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.error,
                                  size: Adapt.px(48),
                                  color: Colors.red,
                                ),
                                Text(
                                  "Error",
                                  style: TextStyle(fontSize: Adapt.px(16)),
                                ),
                              ],
                            )),
                      ),
                    SizedBox(
                      height: Adapt.px(32),
                    ),
                  ],
                ),
              ),
            ),
            SliverAppBar(
              expandedHeight: Adapt.px(50),
              backgroundColor: ThemeColor.color200,
              pinned: true,
              elevation: 0,
              automaticallyImplyLeading: false,
              flexibleSpace: Container(
                  height: Adapt.px(50),
                  color: ThemeColor.color200,
                  child: TabBar(
                    controller: _tabController,
                    tabs: imagesPaths
                        .map((element) => Tab(
                              text: '${element.modelName}',
                            ))
                        .toList(),
                    // tabs: [
                    //   for (int index = 0; index < imagesPaths.length; index++)
                    //     Tab(
                    //       text:
                    //           "${imagesPaths[index].modelName}}", //${getSelectedFlag(index)}
                    //     ),
                    // ],
                    labelStyle: TextStyle(
                        fontSize: 14,
                        color: ThemeColor.titleColor,
                        fontWeight: FontWeight.w600),
                    unselectedLabelStyle: TextStyle(
                        fontSize: 14,
                        color: ThemeColor.color120,
                        fontWeight: FontWeight.w400),
                    padding: const EdgeInsets.only(right: 0),
                    //60
                    labelPadding: const EdgeInsets.only(left: 0, right: 10),
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
                      insets: const EdgeInsets.only(left: 0, right: 10),
                    ), //RIGHT 30
                  )),
            ),
          ];
        },
        body: Column(
          children: [
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: imagesPaths
                    .map((element) => NFTAvatarChooseTab(
                          showNFTAvatar: element.images,
                          onSelected: (List<String> data) {
                            _selectedImages.add(
                              ImagesPaths(
                                modelName: element.modelName,
                                images: data,
                              ),
                            );
                            setState(() {
                              final ids = _selectedImages
                                  .map((e) => e.modelName)
                                  .toSet();
                              _selectedImages
                                  .retainWhere((x) => ids.remove(x.modelName));
                            });
                          },
                        ))
                    .toList(),
              ),
            ),
            SafeArea(
              child: NoticeButton(
                title: "Select $selectedAvatarCount/$totalAvatarCount avatar",
                horizontalPadding: Adapt.px(24),
                gradient: LinearGradient(
                  colors: [
                    ThemeColor.gradientMainEnd,
                    ThemeColor.gradientMainStart,
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                onTap: () async {
                  if (selectedAvatarCount > _canGenerateNFTAvatarCount) {
                    CommonToast.instance.show(context,
                        "Only $_canGenerateNFTAvatarCount Ai images can be selected");
                  } else if (selectedAvatarCount == 0) {
                    CommonToast.instance
                        .show(context, "Please select at least one Ai image");
                  } else {
                    LogUtil.e('选中的头像:$selectedAvatarList');
                    await _createAiImageNftAvatar(selectedAvatarList);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  int get totalAvatarCount {
    int _count = 0;
    widget.myGenerationAiStepsEntity?.imagesPaths?.forEach((element) {
      _count = (element.images?.length ?? 0) + _count;
    });
    return _count;
  }

  int get selectedAvatarCount {
    int _count = 0;
    for (var element in _selectedImages) {
      _count = (element.images?.length ?? 0) + _count;
    }
    return _count;
  }

  List<String> get selectedAvatarList {
    List<String> aiImagePath = [];
    _selectedImages.forEach((element) {
      aiImagePath.addAll(element.images ?? []);
    });

    return aiImagePath;
  }

  //创建NFT头像
  Future<void> _createAiImageNftAvatar(List<String> aiImagePath) async {
    try {
      setState(() {
        _cardType = CardType.loading;
      });

      bool? result = await ChooseImageUploadNetManage.createAiImageNftAvatar(
        params: {
          "aiImagePath": aiImagePath,
          "ownerAddress":
              YLUserInfoManager.sharedInstance.currentUserInfo?.token ?? '',
          "processId": await YLCacheManager.defaultYLCacheManager
              .getForeverData('processId', defaultValue: '')
        },
      );

      //接口请求成功，并且返回true时
      if (result == true) {
        setState(() {
          _cardType = CardType.done;
        });

        //2s后消失
        Timer(const Duration(seconds: 2),(){
          setState(() {
            _cardType = CardType.label;
            YLNavigator.popToPage(context, pageType: const UserCenterPage().runtimeType.toString());
          });
        });
      } else {
        setState(() {
          _cardType = CardType.error;
          CommonToast.instance.show(context, "Failed to create the NFT Avatar. Please re-create");
        });
      }

      // Test Code
      // Timer.periodic(const Duration(seconds: 10), (timer) {
      //   setState(() {
      //     _cardType = CardType.done;
      //     YLNavigator.pushPage(context, (context) => const UserCenterPage());
      //   });
      // });

    } catch (e) {
      setState(() {
        _cardType = CardType.error;
        CommonToast.instance.show(context, "Failed to create the NFT Avatar. Please re-create");
      });
    }
  }

// String getSelectedFlag(int index) {
//   return _selectedImages.isNotEmpty
//       ? "(${_selectedImages[index].images?.length})"
//       : "";
// }
}
