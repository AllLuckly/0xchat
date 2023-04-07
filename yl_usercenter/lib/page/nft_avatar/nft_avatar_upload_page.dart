import 'dart:convert';
import 'dart:math';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:yl_cache_manager/yl_cache_manager.dart';
import 'package:yl_common/log_util.dart';
import 'package:yl_common/navigator/navigator.dart';
import 'package:yl_common/network/network_general.dart';
import 'package:yl_common/utils/adapt.dart';
import 'package:yl_common/utils/theme_color.dart';
import 'package:yl_common/utils/yl_userinfo_manager.dart';
import 'package:yl_common/widgets/common_appbar.dart';
import 'package:yl_usercenter/page/nft_avatar/nft_avatar_base_page.dart';
import 'package:yl_usercenter/page/nft_avatar/nft_avatar_generate_page.dart';
import 'package:yl_usercenter/uitls/choose_image_upload.dart';
import 'package:yl_usercenter/widget/custom_circular_progress_indicator.dart';

typedef ProgressCallback = double Function();

class NFTAvatarUploadPage extends NFTAvatarBasePage {
  // final int total;
  // final ProgressCallback progressCallback;
  List<File?> fileList;//图片上传的数据
  int gender;//性别
  num nftAvatarCount;//买了几个nft头像
  String productId;
  NFTAvatarUploadPage({
    // this.total = 0,
    required this.fileList,
    required this.gender,
    required this.nftAvatarCount,
    required this.productId,
    Key? key,
  }) : super(key: key);

  @override
  _NFTAvatarUploadPageState createState() => _NFTAvatarUploadPageState();
}

class _NFTAvatarUploadPageState
    extends NFTAvatarBasePageState<NFTAvatarUploadPage> {
  //正在上传的图片数
  int _count = 1;

  //上传进度
  double _progressValue = 0;

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 600),
    );
    animationController.forward();
    animationController.addListener(() {
      setState(() {});
      // if (_progressValue == 1) {
      //   YLNavigator.pushPage(context, (context) => const NFTAvatarCreatePage());
      // }
    });

    _uploadNftMultipartFile();
    super.initState();
  }

  @override
  PreferredSizeWidget buildAppBar() {
    return CommonAppBar(
      title: 'Create NFT avatar',
      useLargeTitle: false,
      centerTitle: true,
      canBack: false,
      backgroundColor: ThemeColor.color200,
      leading: Container(),
    );
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
      value: _progressValue,
    );
  }

  @override
  Widget buildCenterLabel(String label) {
    int _total = widget.fileList.length;

    _count = min((_total * _progressValue).ceil() + 1, _total);
    return super.buildCenterLabel("Uploading $_count/$_total...");
  }

  @override
  buildCenterRemind(String remind) {
    return Text(
      "Please keep the app open.",
      textAlign: TextAlign.center,
      style: TextStyle(
          color: ThemeColor.color60,
          fontSize: Adapt.px(14),
          fontWeight: FontWeight.w400),
    );
  }

  @override
  Widget buildBottomButton({String title = ''}) {
    return super.buildBottomButton(title: "Please ReUpload");
  }

  @override
  onCancel() {
    setState(() {
      super.isShowButton = false;
      _uploadNftMultipartFile();
    });
  }

  _uploadNftMultipartFile() async {
    try {
      LogUtil.e("上传的图片:${widget.fileList.length}");

      //多图批量上传
      YLResponse responese =
      await ChooseImageUploadNetManage.uploadNftMultipartFile(
        imgFileList: widget.fileList,
        fileServerUrl: "https://www.0xchat.com/oxchat/file/uploadFiles",
        ownerAddress:
        YLUserInfoManager.sharedInstance.currentUserInfo?.token ?? '',
        gender: widget.gender,
        paymentType: Platform.isIOS ? 0 : 1,
        productId: widget.productId,
        context: context,
        progressCallback: (int count, int data) {
          setState(() {
            _progressValue = count / data;
            LogUtil.e("上传进度:$count ---- $data ---- $_progressValue");
          });
        },
      );

      if (responese != null) {
        LogUtil.e("NFTAvatarUploadPage上传图片请求结果: ${responese.data}");
        Map<String, dynamic> dataMap = json.decode(responese.data['data']);
        if (dataMap['result'] == true) {
          LogUtil.e(dataMap['processId']);
          await YLCacheManager.defaultYLCacheManager
              .saveForeverData('processId', dataMap['processId']);

          //上传完毕
          if (_progressValue == 1) {
            YLNavigator.pushPage(
                context, (context) => const NFTAvatarGeneratePage());
          }
        } else {
          setState(() {
            super.isShowButton = true;
          });
        }
      } else {
        setState(() {
          super.isShowButton = true;
        });
      }
    } catch (e) {
      LogUtil.e("图片上传失败:$e");
      setState(() {
        super.isShowButton = true;
      });
    }
  }
}