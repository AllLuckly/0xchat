import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yl_cache_manager/yl_cache_manager.dart';
import 'package:yl_common/model/yl_user_info.dart';
import 'package:yl_common/navigator/navigator.dart';
import 'package:yl_common/utils/storage_key_tool.dart';
import 'package:yl_common/utils/theme_color.dart';
import 'package:yl_common/utils/yl_userinfo_manager.dart';
import 'package:yl_common/widgets/common_appbar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:io';
import 'package:yl_common/utils/adapt.dart';
import 'package:yl_common/widgets/common_button.dart';
import 'package:yl_common/widgets/common_image.dart';
import 'package:photo_view/photo_view.dart';
import 'package:yl_localizable/yl_localizable.dart';
import 'package:yl_module_service/yl_module_service.dart';

import 'nft_avatar_settings_page.dart';

class AvatarPreviewPage extends StatefulWidget {
  const AvatarPreviewPage({Key? key}) : super(key: key);

  @override
  State<AvatarPreviewPage> createState() => _AvatarPreviewPageState();
}

class _AvatarPreviewPageState extends State<AvatarPreviewPage> {
  YLUserInfo? mCurrentUserInfo;
  String mHostName = '';
  String? imgPath;

  @override
  void initState() {
    super.initState();
    mCurrentUserInfo = YLUserInfoManager.sharedInstance.currentUserInfo;
    _initData();
  }

  void _initData() async {
    mHostName = await YLCacheManager.defaultYLCacheManager.getForeverData(StorageKeyTool.APP_DOMAIN_NAME, defaultValue: 'yl.com' );
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.bgColor,
      appBar: CommonAppBar(
        title: Localized.text('yl_usercenter.Profile picture'),
        useLargeTitle: false,
        centerTitle: true,
        canBack: true,
        actions: <Widget>[
          Container(
            margin: EdgeInsets.only(right: Adapt.px(5), top: Adapt.px(12)),
            color: Colors.transparent,
            child: YLEButton(
              highlightColor: Colors.transparent,
              color: Colors.transparent,
              minWidth: Adapt.px(44),
              height: Adapt.px(44),
              child: CommonImage(
                iconName: "nav_more_new.png",
                width: Adapt.px(24),
                height: Adapt.px(24),
                // package: "yl_wowchat",
              ),
              onPressed: () async {
                YLNavigator.pushPage(context, (context) => NFTAvatarSettingsPage()).then((value){
                  String headUrl = value as String;
                  if(headUrl.length == 0){
                    return ;
                  }
                  mCurrentUserInfo?.headUrl = value as String?;
                  setState(() {

                  });
                });

                // final ImagePicker _picker = ImagePicker();
                // XFile? imageFile = await _picker.pickImage(source: ImageSource.gallery);
                // print("${imageFile?.path}");
                //
                // final CroppedFile? croppedFile =  await ImageCropper().cropImage(
                //   sourcePath: imageFile?.path ?? '',
                //   aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
                //   uiSettings: [
                //     AndroidUiSettings(
                //       toolbarTitle: 'Cropper',
                //       toolbarColor: Colors.deepOrange,
                //       toolbarWidgetColor: Colors.white,
                //       initAspectRatio: CropAspectRatioPreset.original,
                //       lockAspectRatio: false),
                //     IOSUiSettings(
                //       title: 'Cropper',
                //     ),
                //   ],
                // );
                // imgPath = croppedFile?.path;
                // final String headUrl =  await YLModuleService.invoke("yl_wowchat", "processImagePickerComplete", [imgPath]);
                // mCurrentUserInfo?.headUrl = headUrl;
                // YLUserInfoManager.sharedInstance.updateUserInfo(mCurrentUserInfo!);
                // setState(() {
                //
                // });

                // YLNavigator.pushPage(context, (context) => SetUpPage());
              },
            ),
          ),
        ],
      ),
      body: createBoby(),
    );
  }

  Widget createBoby() {
    Map<String,String> headers = {'Host':'css.'+mHostName};
    if(Platform.isIOS){
      headers = {};
    }
    String localAvatarPath = 'assets/images/user_image.png';
    Image placeholderImage = Image.asset(
      localAvatarPath,
      fit: BoxFit.cover,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width,
      package: 'yl_wowchat',
    );
    return Container(
      color: ThemeColor.bgColor,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Align(
        alignment: Alignment(1,-0.5),
          child: imgPath != null
              ? PhotoView(
                  imageProvider:
                      FileImage(File(imgPath ?? ''), scale: 1),
                  errorBuilder: (_, __, ___) {
                    return placeholderImage;
                  })
              : PhotoView(
                  imageProvider: CachedNetworkImageProvider(
                      '${mCurrentUserInfo?.headUrl}'
                  ),
                  errorBuilder: (_, __, ___) {
                    return placeholderImage;
                  })
      ),
    );
  }
}
