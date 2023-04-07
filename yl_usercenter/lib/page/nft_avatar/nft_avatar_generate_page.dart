import 'dart:async';

import 'package:flutter/material.dart';
import 'package:yl_cache_manager/yl_cache_manager.dart';
import 'package:yl_common/log_util.dart';
import 'package:yl_common/navigator/navigator.dart';
import 'package:yl_common/utils/adapt.dart';
import 'package:yl_common/utils/theme_color.dart';
import 'package:yl_common/utils/yl_userinfo_manager.dart';
import 'package:yl_usercenter/model/my_ai_generate_entity.dart';
import 'package:yl_usercenter/model/my_generation_ai_steps_entity.dart';
import 'package:yl_usercenter/page/nft_avatar/nft_avatar_base_page.dart';
import 'package:yl_usercenter/page/nft_avatar/nft_avatar_generate_done_page.dart';
import 'package:yl_usercenter/uitls/choose_image_upload.dart';
import 'package:yl_usercenter/widget/custom_circular_progress_indicator.dart';

class NFTAvatarGeneratePage extends NFTAvatarBasePage {
  const NFTAvatarGeneratePage({Key? key}) : super(key: key);

  @override
  _NFTAvatarCreatePageState createState() => _NFTAvatarCreatePageState();
}

class _NFTAvatarCreatePageState extends NFTAvatarBasePageState {
  int remainTime = 2;

  Timer? _timer;

  MyGenerationAiStepsEntity? _myGenerationAiStepsEntity;

  // MyAiGenerateEntity? _myAiGenerateEntity;

  bool? _generateAiImageFinishFlag;

  @override
  bool get isShowButton => true;

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 0),
    );
    animationController.forward();
    animationController.addListener(() {
      setState(() {});
    });
    _initInterface();
    super.initState();
  }

  @override
  buildCreateProgress() {
    return CustomCircularProgressIndicator(
      valueColor: ColorTween(
        begin: ThemeColor.gradientMainStart,
        end: ThemeColor.gradientMainEnd,
      ).animate(animationController),
      width: Adapt.px(240),
      strokeWidth: Adapt.px(6),
      value: animationController.value,
    );
  }

  @override
  buildCenterLabel(String label) {
    return super.buildCenterLabel("Generating Avatar");
  }

  @override
  buildCenterRemind(String remind) {
    return super.buildCenterRemind("Time left about $remainTime MIN");
  }

  _initInterface() async {
    _timer = Timer.periodic(const Duration(seconds: 15), (timer) {
      _getAiGenerationSteps();
      List<String> _aiImagePath = [];
      _myGenerationAiStepsEntity?.imagesPaths?.forEach((element) {
        _aiImagePath.addAll(element.images ?? []);
      });

      // if (_generateAiImageFinishFlag == true && _aiImagePath.isNotEmpty) {
      if (_generateAiImageFinishFlag == true) {
        _timer?.cancel();
        YLNavigator.pushPage(context, (context) => NFTAvatarGenerateDonePage(myGenerationAiStepsEntity: _myGenerationAiStepsEntity));
      }

      // _getAiImages();
      // if(_myAiGenerateEntity?.imagesPaths![0].images?.isNotEmpty ?? true){
      //   _myGenerationAiStepsEntity?.imagesPaths = _myAiGenerateEntity?.imagesPaths;
      //   YLNavigator.pushPage(context, (context) => NFTAvatarGenerateDonePage(myGenerationAiStepsEntity: _myGenerationAiStepsEntity));
      // }

    });
  }

  Future<void> _getAiGenerationSteps() async {
    _myGenerationAiStepsEntity =
    await ChooseImageUploadNetManage.getAiGenerationSteps(
        ownerAddress: YLUserInfoManager.sharedInstance.currentUserInfo?.token ?? '',
        processId: await YLCacheManager.defaultYLCacheManager.getForeverData('processId', defaultValue: ''),
        showLoading: false,
    );

    setState(() {
      _generateAiImageFinishFlag =
          _myGenerationAiStepsEntity?.generateAiImageFinishFlag;
    });
  }

  // Future<void> _getAiImages() async {
  //   _myAiGenerateEntity = await ChooseImageUploadNetManage.getAiImages(
  //     params: {
  //       "ownerAddress": YLUserInfoManager.sharedInstance.currentUserInfo?.token ?? '',
  //       "processId": await YLCacheManager.defaultYLCacheManager.getForeverData('processId', defaultValue: ''),
  //     },
  //   );
  //
  //   setState(() {
  //
  //   });
  // }

  @override
  void deactivate() {
    // TODO: implement deactivate
    _timer?.cancel();
    super.deactivate();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _timer?.cancel();
    super.dispose();
  }
}
