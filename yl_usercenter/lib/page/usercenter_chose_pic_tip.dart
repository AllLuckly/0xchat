import 'dart:io';

import 'package:flutter/material.dart';
import 'package:yl_common/navigator/navigator.dart';
import 'package:yl_common/utils/adapt.dart';
import 'package:yl_common/utils/theme_color.dart';
import 'package:yl_common/widgets/base_page_state.dart';
import 'package:yl_common/widgets/common_appbar.dart';
import 'package:yl_common/widgets/yl_loading.dart';
import 'package:yl_usercenter/page/set_up/create_avatar_step_two.dart';
import 'package:yl_usercenter/uitls/widget_tool.dart';
import 'package:yl_common/log_util.dart';

import "package:images_picker/images_picker.dart";

///Title:
///Description: TODO(自填)
///Copyright: Copyright (c) 2022
///@author Michael
///CreateTime: 2023/1/6 10:45
class UserCenterChosePicTip extends StatefulWidget {
  const UserCenterChosePicTip({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _UserCenterChosePicTipState();
  }
}

class _UserCenterChosePicTipState extends BasePageState<UserCenterChosePicTip> {
  List<String> defaultNftList = [
    'icon_eg_1.png',
    'icon_eg_1.png',
    'icon_eg_1.png',
    'icon_eg_1.png',
  ];

  @override
  void initState() {
    super.initState();
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _tipImages(),
        Text(
          'Upload Selfies',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: Adapt.px(32),
          ),
        ).setPadding(EdgeInsets.only(left: Adapt.px(24), top: Adapt.px(24), right: Adapt.px(24))),
        Text(
          'Please upload a selfie according to the example above, the more looks you upload, the better the results will be.\nPlease upload same and only person，no nudes，no kids. Do not upload more than one person.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: ThemeColor.color60,
            fontSize: Adapt.px(14),
          ),
        ).setPadding(EdgeInsets.only(left: Adapt.px(24), top: Adapt.px(16), right: Adapt.px(24))),
      ],
    );
  }

  Widget _tipImages() {
    return GridView(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.only(
        left: Adapt.px(12),
        top: Adapt.px(16),
        right: Adapt.px(12),
      ),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: (Adapt.screenW() - Adapt.px(24)) / 2,
        crossAxisSpacing: Adapt.px(16),
        mainAxisSpacing: Adapt.px(16),
        childAspectRatio: 1,
      ),
      children: List.generate(defaultNftList.length, (index) {
        String avatarName = defaultNftList[index];
        return Stack(
          children : [
            assetIcon(
              avatarName,
              Adapt.px(160),
              Adapt.px(160),
            ),
            Container(
              alignment: Alignment.bottomRight,
              margin: EdgeInsets.only(right: Adapt.px(8), bottom: Adapt.px(8)),
              child: assetIcon(
                index == 1 ? 'icon_pic_selected.png':'icon_pic_not_selected.png',
                Adapt.px(32),
                Adapt.px(32),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _bottomNavigationBar() {
    return Container(
      alignment: Alignment.bottomCenter,
      height: Adapt.px(116),
      color: Colors.transparent,
      child: Center(
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            _goToChosePicAndResult();
          },
          child: Container(
            height: Adapt.px(48),
            margin: EdgeInsets.symmetric(horizontal: Adapt.px(24)),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              gradient: const LinearGradient(
                  begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFFC084FC), Color(0xFF818CF8)]),
              borderRadius: BorderRadius.all(Radius.circular(Adapt.px(12))),
            ),
            child: Text(
              'Choose 10-20 Selfies',
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

  void _goToChosePicAndResult() async {
    // final List<AssetEntity>? result = await AssetPicker.pickAssets(context,
    //     pickerConfig: const AssetPickerConfig(
    //       maxAssets: 20,
    //       requestType: RequestType.image,
    //     ));
    // List<File?> fileList = [];
    // YLLoading.show(status: 'Please do not leave while the picture is being processed');
    // await Future.wait(result!.map((element) async {
    //   AssetEntity entity = element;
    //   File? file = await entity.file;
    //   LogUtil.e(file?.path);
    //   fileList.add(file);
    // }));
    // YLLoading.dismiss();

    YLLoading.show(status: 'Please do not leave while the picture is being processed');
    List<Media>? res = await ImagesPicker.pick(
      count: 20, // 最大可选择数量
      pickType: PickType.image, // 选择媒体类型，默认图片
      quality: 0.8, // only for android
      maxSize: 1024,
      gif: false,
    );
    List<File?> fileList = [];
    if(res == null){
      YLLoading.dismiss();
      return;
    }
    await Future.wait(res.map((element) async {
      Media entity = element;
      File? file = File(entity.path);
      fileList.add(file);
      // await  ChooseImageUpload.uploadNftImgFile(file!, "https://www.0xchat.com/oxchat/file/uploadFiles", YLUserInfoManager.sharedInstance.currentUserInfo?.userId ?? '', context);
    }));
    YLLoading.dismiss();
    LogUtil.e("fileList ====== :${fileList}");
    YLNavigator.pushPage(context, (context) => CreateAvatarStepTwo(fileList: fileList));

  }
}
