
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yl_cache_manager/yl_cache_manager.dart';
import 'package:yl_common/model/yl_user_info.dart';
import 'package:yl_common/navigator/navigator.dart';
import 'package:yl_common/utils/adapt.dart';
import 'package:yl_common/utils/storage_key_tool.dart';
import 'package:yl_common/utils/theme_color.dart';
import 'package:yl_common/utils/yl_userinfo_manager.dart';
import 'package:yl_common/widgets/common_appbar.dart';
import 'package:yl_common/widgets/common_gradient_border_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:yl_common/widgets/common_image.dart';
import 'package:yl_localizable/yl_localizable.dart';
import 'package:yl_usercenter/page/set_up/avatar_preview_page.dart';
import 'package:yl_usercenter/page/set_up/set_more_page.dart';
import 'package:yl_usercenter/page/set_up/set_nickname_page.dart';
import 'package:yl_usercenter/page/set_up/set_signature_page.dart';
import 'package:yl_wowchat/page/community_my_idcard.dart';

import 'avatar_shop_page.dart';

class SetUpPage extends StatefulWidget {
  const SetUpPage({Key? key}) : super(key: key);

  @override
  State<SetUpPage> createState() => _SetUpPageState();
}

class _SetUpPageState extends State<SetUpPage> {
  YLUserInfo? mCurrentUserInfo;
  String mHostName = '';

  @override
  void initState() {
    super.initState();
    mCurrentUserInfo = YLUserInfoManager.sharedInstance.currentUserInfo;

    _initData();
  }

  void _initData() async {
    mHostName = await YLCacheManager.defaultYLCacheManager
        .getForeverData(StorageKeyTool.APP_DOMAIN_NAME, defaultValue: 'yl.com');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.bgColor,
      appBar: CommonAppBar(
        title: Localized.text('yl_usercenter.Personal information'),
        useLargeTitle: false,
        centerTitle: true,
        canBack: false,
      ),
      body: createBoby(),
    );
  }

  Widget createBoby() {
    return Container(
      color: ThemeColor.bgColor,
      child: CustomScrollView(
        shrinkWrap: true,
        slivers: <Widget>[
          new SliverPadding(
            padding: const EdgeInsets.all(0.0),
            sliver: new SliverList(
              delegate: new SliverChildListDelegate(
                <Widget>[
                  createHeadImgView(),
                  createInfoSetUpView(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget createHeadImgView() {
    // Map<String,String> headers = {'Host':'css.'+mHostName};
    // if(Platform.isIOS){
    //   headers = {};
    // }

    final map = <String, String>{};
    String host = getHostUrl(YLUserInfoManager.sharedInstance.currentUserInfo?.headUrl ?? '');
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
    return GestureDetector(
      child: Container(
        height: 107,
        width: double.infinity,
        margin: EdgeInsets.only(left: Adapt.px(16), right: Adapt.px(16), top: Adapt.px(26), bottom: Adapt.px(16)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          color: ThemeColor.gray5,
        ),
        child: Row(
          children: [
            SizedBox(
              width: Adapt.px(16),
            ),
            Text(
              Localized.text('yl_usercenter.Profile picture'),
              style: TextStyle(color: ThemeColor.titleColor, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Spacer(),
            Container(
              width: Adapt.px(76),
              height: Adapt.px(76),
              child: CommonGradientBorderWidget(
                strokeWidth: 2,
                radius: Adapt.px(76),
                gradient: SweepGradient(colors: [
                  ThemeColor.purple1,
                  ThemeColor.purple2,
                  ThemeColor.green1,
                  ThemeColor.purple2,
                  ThemeColor.purple2
                ]),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(Adapt.px(76)),
                  child: CachedNetworkImage(
                    imageUrl: YLUserInfoManager.sharedInstance.currentUserInfo?.headUrl ?? '',
                    //预览图
                    fit: BoxFit.cover,
                    placeholder: (context, url) => placeholderImage,
                    errorWidget: (context, url, error) => placeholderImage,
                    width: Adapt.px(74),
                    height: Adapt.px(74),
                    httpHeaders: map,
                  ),
                ),
                onPressed: () {
                  onChangeHeadImg();
                },
              ),
            ),
            SizedBox(width: Adapt.px(5)),
            CommonImage(
              iconName: "icon_arrow_right.png",
              width: Adapt.px(20),
              height: Adapt.px(20),
            ),
            SizedBox(
              width: Adapt.px(16),
            )
          ],
        ),
      ),
      onTap: () {
        //去设置头像
        onChangeHeadImg();
      },
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

  ///点击修改头像
  onChangeHeadImg() async {
    // return;

    // YLNavigator.pushPage(context, (context) => CreateAvatarStepTwo(fileList: [])).then((value){
    //   setState(() {
    //
    //   });
    // });

    // return;
    //多图选择
    //   final List<AssetEntity>? result = await AssetPicker.pickAssets(
    //       context,
    //       pickerConfig: const AssetPickerConfig(maxAssets: 10,
    //         requestType: RequestType.image,
    //       ));
    //   List<File?> fileList = [];
    //   await Future.wait(result!.map((element) async {
    //     AssetEntity entity = element;
    //     File? file = await entity.file;
    //     LogUtil.e(file?.path);
    //     fileList.add(file);
    //     // await  ChooseImageUpload.uploadNftImgFile(file!, "https://www.0xchat.com/oxchat/file/uploadFiles", YLUserInfoManager.sharedInstance.currentUserInfo?.userId ?? '', context);
    //   }));
    //   // LogUtil.e(pathList);
    //   //多图批量上传
    //   YLResponse responese = await ChooseImageUploadNetManage.uploadNftMultipartFile(
    //       imgFileList:fileList,
    //       fileServerUrl:"https://www.0xchat.com/oxchat/file/uploadFiles",
    //       ownerAddress:YLUserInfoManager.sharedInstance.currentUserInfo?.token ?? '',
    //       gender:0,
    //       paymentType:0,
    //       productId: 0,
    //       context:context,
    //       progressCallback: (int count, int data){
    //
    //       },
    //   );
    //   LogUtil.e(responese.data);
    //   Map<String, dynamic> dataMap = json.decode(responese.data['data']);
    //   if(dataMap['result'] == true){
    //       LogUtil.e(dataMap['processId']);
    //       await YLCacheManager.defaultYLCacheManager.saveForeverData('processId', dataMap['processId']);
    //       final params = <String, dynamic>{};
    //       params['processId'] = dataMap['processId'];
    //       params['ownerAddress'] = YLUserInfoManager.sharedInstance.currentUserInfo?.token ?? '';
    //       LogUtil.e(params);
    //       //获取ai返回的图片模型
    //       MyAiGenerateEntity? entity =  await ChooseImageUploadNetManage.getAiImages(params:params, context: context);
    //
    //
    //       ///查询生成ai和头像到哪一步了
    //       // MyGenerationAiStepsEntity? aiStepsEntity = await ChooseImageUploadNetManage.getAiGenerationSteps(
    //       //     ownerAddress:
    //       //     YLUserInfoManager.sharedInstance.currentUserInfo?.token ?? '',
    //       //     processId: entity?.processId ?? '');
    //       ///获取价格列表和是否订阅
    //       // MyProductListEntity? assetsEntity = await ChooseImageUploadNetManage.getPriceListAndWhetherToSubscribe(ownerAddress:YLUserInfoManager.sharedInstance.currentUserInfo?.token ?? '');
    //       final createAiImageParams = <String, dynamic>{};
    //       createAiImageParams['aiImagePath'] = ['https://img1.baidu.com/it/u=375961569,3322016917&fm=253&fmt=auto&app=138&f=JPEG?w=889&h=500','https://up.enterdesk.com/edpic_source/f0/71/61/f07161ca540523b4755d684d27f22dba.jpg'];
    //       createAiImageParams['processId'] = dataMap['processId'];
    //       createAiImageParams['ownerAddress'] = YLUserInfoManager.sharedInstance.currentUserInfo?.token ?? '';
    //       //选择生成的头像 上传为nft头像
    //       bool? isTrue = await ChooseImageUploadNetManage.createAiImageNftAvatar(params: createAiImageParams);
    //       LogUtil.e("isTrue :${isTrue}");
    //   }
    //
    //   //查询用户所拥有的oxchat nft
    //   // List<MyOxchatNftEntity>? list = await ChooseImageUploadNetManage.getMyOxchatNft(ownerAddress:YLUserInfoManager.sharedInstance.currentUserInfo?.token ?? '');
    //
    //   LogUtil.e(responese.toString());
    //   LogUtil.e("上传完毕");

    YLNavigator.pushPage(context, (context) => AvatarPreviewPage()).then((value) {
      setState(() {});
    });
  }

  Widget createInfoSetUpView() {
    return Container(
      height: 252,
      width: double.infinity,
      margin: EdgeInsets.only(left: Adapt.px(16), right: Adapt.px(16), bottom: Adapt.px(16)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        color: ThemeColor.gray5,
      ),
      child: Column(
        children: [
          InkWell(
            child: createRow(
                isRightTitle: true,
                isRightImage: false,
                leftTitle: Localized.text('yl_usercenter.Nickname'),
                rightTitle: mCurrentUserInfo?.nickName ?? '',
                rightIconName: ''),
            onTap: () {
              YLNavigator.pushPage(context, (context) => SetNicknamePage()).then((value) {
                setState(() {});
              });
            },
          ),
          Container(
            color: ThemeColor.gray6,
            height: Adapt.px(0.5),
            width: double.infinity,
          ),
          InkWell(
            child: createRow(
                isRightTitle: true,
                isRightImage: false,
                leftTitle: Localized.text('yl_usercenter.Signature'),
                rightTitle: '',
                rightIconName: ''),
            onTap: () {
              YLNavigator.pushPage(context, (context) => const SetSignaturePage()).then((value) {
                setState(() {});
              });
            },
          ),
          Container(
            color: ThemeColor.gray6,
            height: Adapt.px(0.5),
            width: double.infinity,
          ),
          InkWell(
            child: createRow(
                isRightTitle: false,
                isRightImage: true,
                leftTitle: Localized.text('yl_usercenter.My QR code'),
                rightTitle: '',
                rightIconName: 'icon_qrcode.png'),
            onTap: () {
              YLNavigator.pushPage(context, (context) => CommunityMyIdCard());
            },
          ),
          Container(
            color: ThemeColor.gray6,
            height: Adapt.px(0.5),
            width: double.infinity,
          ),
          InkWell(
            child: createRow(
                isRightTitle: true,
                isRightImage: false,
                leftTitle: Localized.text('yl_usercenter.NFT Purchase'),
                rightTitle: '',
                rightIconName: ''),
            onTap: () {
              YLNavigator.pushPage(context, (context) => const AvatarShopPage());
            },
          ),
          Container(
            color: ThemeColor.gray6,
            height: Adapt.px(0.5),
            width: double.infinity,
          ),
          InkWell(
            child: createRow(
                isRightTitle: false,
                isRightImage: false,
                leftTitle: Localized.text('yl_usercenter.More'),
                rightTitle: '',
                rightIconName: ''),
            onTap: () {
              YLNavigator.pushPage(context, (context) => const SetMorePage());
            },
          ),
        ],
      ),
    );
  }

  Widget createRow(
      {required bool isRightTitle,
      required bool isRightImage,
      required String leftTitle,
      required String rightTitle,
      required String rightIconName}) {
    return Container(
      height: Adapt.px(50),
      width: double.infinity,
      child: Row(
        children: [
          SizedBox(
            width: Adapt.px(16),
          ),
          Text(
            leftTitle,
            style: TextStyle(color: ThemeColor.titleColor, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Spacer(),
          isRightTitle
              ? Container(
                  child: Text(rightTitle,
                      style: TextStyle(
                        color: ThemeColor.gray4,
                        fontSize: 16,
                        fontWeight: FontWeight.w200,
                      ),
                      maxLines: 1,
                      textAlign: TextAlign.end),
                  width: Adapt.px(150),
                )
              : (isRightImage
                  ? CommonImage(
                      iconName: rightIconName,
                      width: Adapt.px(20),
                      height: Adapt.px(20),
                    )
                  : Container()),
          SizedBox(width: Adapt.px(0)),
          CommonImage(
            iconName: "icon_arrow_right.png",
            width: Adapt.px(20),
            height: Adapt.px(20),
          ),
          SizedBox(
            width: Adapt.px(16),
          )
        ],
      ),
    );
  }
}
