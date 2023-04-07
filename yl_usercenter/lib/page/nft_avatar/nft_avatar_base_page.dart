import 'package:flutter/material.dart';
import 'package:yl_common/navigator/navigator.dart';
import 'package:yl_common/utils/adapt.dart';
import 'package:yl_common/utils/theme_color.dart';
import 'package:yl_common/widgets/common_appbar.dart';
import 'package:yl_common/widgets/common_button.dart';
import 'package:yl_common/widgets/common_image.dart';
import 'package:yl_usercenter/page/usercenter_page.dart';
import 'package:yl_usercenter/widget/notice_button_widget.dart';

class NFTAvatarBasePage extends StatefulWidget {
  const NFTAvatarBasePage({Key? key}) : super(key: key);

  @override
  NFTAvatarBasePageState createState() => NFTAvatarBasePageState();
}

class NFTAvatarBasePageState<T extends NFTAvatarBasePage> extends State<T>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;

  bool isShowButton = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: ThemeColor.color200,
        appBar: buildAppBar(),
        body: Container(
          // decoration: const BoxDecoration(
          //   color: Colors.white,
          // ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: Adapt.px(57),
                width: double.infinity,
              ),
              buildCreateProgress(),
              SizedBox(
                height: Adapt.px(85),
              ),
              buildCenterLabel(""),
              SizedBox(
                height: Adapt.px(12),
              ),
              buildCenterRemind(""),
              const Spacer(),
              isShowButton ? buildBottomButton() : Container(),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget buildAppBar() {
    return CommonAppBar(
      backgroundColor: ThemeColor.color200,
      title: 'Create NFT avatar',
      useLargeTitle: false,
      centerTitle: true,
      canBack: false,
      leading: Container(),
      actions: [
        Container(
          margin: EdgeInsets.only(right: Adapt.px(5), top: Adapt.px(12)),
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
    );
  }

  Widget buildCreateProgress() {
    return Container();
  }

  Widget buildCenterLabel(String label) {
    return Text(
      label,
      textAlign: TextAlign.center,
      style: TextStyle(
          color: ThemeColor.color0,
          fontSize: Adapt.px(32),
          fontWeight: FontWeight.w600),
    );
  }

  Widget buildCenterRemind(String remind) {
    return Text(
      remind,
      textAlign: TextAlign.center,
      style: TextStyle(
          color: ThemeColor.white01,
          fontSize: Adapt.px(16),
          fontWeight: FontWeight.w400),
    );
  }

  Widget buildCenterTips() {
    return Container();
  }

  Widget buildBottomButton({String title = 'Hide this Page'}) {
    return SafeArea(
      child: Column(
        children: [
          NoticeButton(
            title: title,
            backgroundColor: ThemeColor.color180,
            onTap: onCancel,
          ),
        ],
      ),
    );
  }

  onConfirm() {
    print("onConfirm");
  }

  onCancel() {
    YLNavigator.popToPage(context, pageType: const UserCenterPage().runtimeType.toString());
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}
