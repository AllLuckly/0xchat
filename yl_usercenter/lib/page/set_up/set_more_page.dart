import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yl_common/model/yl_user_info.dart';
import 'package:yl_common/navigator/navigator.dart';
import 'package:yl_common/utils/adapt.dart';
import 'package:yl_common/utils/date_utils.dart';
import 'package:yl_common/utils/theme_color.dart';
import 'package:yl_common/utils/yl_userinfo_manager.dart';
import 'package:yl_common/widgets/common_appbar.dart';
import 'package:yl_common/widgets/common_image.dart';
import 'package:yl_localizable/yl_localizable.dart';
import 'package:yl_module_service/yl_module_service.dart';


class SetMorePage extends StatefulWidget {
  const SetMorePage({Key? key}) : super(key: key);

  @override
  State<SetMorePage> createState() => _SetMorePageState();
}

class _SetMorePageState extends State<SetMorePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ThemeColor.bgColor,
        appBar: CommonAppBar(
            title: Localized.text('yl_usercenter.More'),
            useLargeTitle: false,
            centerTitle: true,
            canBack: false,
        ),
        body: Container(
      height: 50,
      width: double.infinity,
      margin: EdgeInsets.only(left: Adapt.px(16),right: Adapt.px(16),top: Adapt.px(56)),
      decoration:BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      color: ThemeColor.gray5,
      ),
            child: InkWell(
                child: createRow(
                  isRightTitle: false,
                  isRightImage: false,
                  leftTitle: Localized.text('yl_usercenter.Delete account'),
                  rightTitle: '',
                  rightIconName: ''),
                onTap: ()  async {
                    // YLNavigator.pushPage(context, (context) => CommunityMyIdCard());
                    final isSuccess  = await YLModuleService.invoke("yl_wowchat", "deleteAccount", [YLUserInfoManager.sharedInstance.currentUserInfo?.userId ?? '']);
                    YLUserInfoManager.sharedInstance.logout();
                    Navigator.of(context).pop();
                    YLModuleService.pushPage(
                        context,
                        "yl_login",
                        "LoginPage",
                        {},
                    );
                },
            ),
        ),

    );
  }

  Widget createRow({required bool isRightTitle, required bool isRightImage,required String leftTitle, required String rightTitle,required String rightIconName}){
      return Container(
          height: Adapt.px(50),
          width: double.infinity,
          child: Row(
              children: [
                  SizedBox(width: Adapt.px(16),),
                  Text(leftTitle , style: TextStyle(color: ThemeColor.titleColor, fontSize: 18, fontWeight: FontWeight.bold),),
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
                      width: Adapt.px(100),
                  )
                    : (isRightImage
                    ? CommonImage(iconName: rightIconName, width: Adapt.px(20),height: Adapt.px(20),)
                    : Container()),
                  SizedBox(width: Adapt.px(0)),
                  CommonImage(iconName: "icon_arrow_right.png", width: Adapt.px(20),height: Adapt.px(20),),
                  SizedBox(width: Adapt.px(16),)
              ],
          ),
      );
  }
}
