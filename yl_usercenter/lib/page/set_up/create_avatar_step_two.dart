import 'dart:core';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:awesome_select/awesome_select.dart';
import 'package:flutter/material.dart';
import 'package:yl_common/navigator/navigator.dart';
import 'package:yl_common/utils/adapt.dart';
import 'package:yl_common/utils/theme_color.dart';
import 'package:yl_common/widgets/common_appbar.dart';
import 'package:yl_common/widgets/common_gradient_border_widget.dart';
import 'package:yl_common/widgets/common_image.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:yl_localizable/yl_localizable.dart';
import 'package:yl_usercenter/page/set_up/create_avatar_step_three.dart';

import '../nft_avatar/nft_avatar_upload_page.dart';

class CreateAvatarStepTwo extends StatefulWidget {
  List<File?> fileList;
  CreateAvatarStepTwo({Key? key, required this.fileList}): super(key: key);

  @override
  State<CreateAvatarStepTwo> createState() => _CreateAvatarStepTwoState();
}

class _CreateAvatarStepTwoState extends State<CreateAvatarStepTwo> {

  int seletIndex = 0;
  List<String> titleList = ['Female', 'Male', 'Other'];

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: ThemeColor.bgColor,
        appBar: CommonAppBar(
          // title: Localized.text('yl_usercenter.Personal information'),
          title: 'Step 2/3',
          useLargeTitle: false,
          centerTitle: true,
          canBack: false,
        ),
        bottomNavigationBar: GestureDetector(
          child: Container(
            alignment: Alignment.center,
            height: Adapt.px(48),
            margin: EdgeInsets.only(
              left: Adapt.px(24), right: Adapt.px(24), bottom: Adapt.px(20)),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(
                Radius.circular(12),
              ),
              border: Border.all(color: ThemeColor.color180, width: 2),
              gradient: LinearGradient(
                colors: [ThemeColor.purpleStart, ThemeColor.purpleEnd]),
            ),
            child: Text(
              'Creat NFT Avatar',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: ThemeColor.color0),
              textAlign: TextAlign.center,
            ),
          ),
          onTap: (){
            // YLNavigator.pushPage(context, (context) => CreateAvatarStepThree(fileList: widget.fileList,gender: seletIndex,)).then((value){
            //   setState(() {
            //   });
            // });
            YLNavigator.pushPage(context, (context) => NFTAvatarUploadPage(fileList: widget.fileList,gender:seletIndex ,nftAvatarCount : 5, productId:'9',));
          },
        ),
        body: SafeArea(
            child: CustomScrollView(slivers: [
          SliverList(
            delegate: SliverChildListDelegate(List.generate(3, (int index) {
              return itemBuilder(context, index);
            })),
          ),
          SliverToBoxAdapter(
            child: Container(
              alignment: Alignment.center,
              child: Text(
                "Your Gender",
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 32,
                    color: ThemeColor.color0),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.only(
                  left: Adapt.px(24), right: Adapt.px(24), top: Adapt.px(12)),
              alignment: Alignment.center,
              child: Text(
                  "AI tech will generate your favorite style based on your gender",
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: ThemeColor.color0),
                  textAlign: TextAlign.center),
            ),
          ),
        ])));
  }

  Widget itemBuilder(BuildContext context, int index) {
    double width = MediaQuery.of(context).size.width;

    return GestureDetector(
      child: Container(
        margin: EdgeInsets.only(
            left: Adapt.px(24),
            right: Adapt.px(24),
            top: Adapt.px(8),
            bottom: Adapt.px(8)),
        child: CommonGradientBorderWidget(
          strokeWidth: 2,
          radius: Adapt.px(16),
          gradient: SweepGradient(
              colors: index == seletIndex
                  ? [ThemeColor.purpleStart, ThemeColor.purpleEnd]
                  : [Colors.transparent, Colors.transparent]),
          child: Container(
            margin: EdgeInsets.all(Adapt.px(2)),
            height: Adapt.px(102),
            width: Adapt.px(width - 28 * 2),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                  Radius.circular(16),
                ),
                border: Border.all(color: ThemeColor.color180, width: 2),
                color: ThemeColor.color180),
            child: Row(
              children: [
                SizedBox(
                  width: Adapt.px(20),
                ),
                Container(
                  child: GradientText(titleList[index],
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: ThemeColor.titleColor),
                      colors: index == seletIndex
                          ? [ThemeColor.purpleStart, ThemeColor.purpleEnd]
                          : [ThemeColor.color0, ThemeColor.color0]),
                ),
                Spacer(),
                index == seletIndex
                    ? CommonImage(
                        iconName: "selected_icon.png",
                        width: Adapt.px(24),
                        height: Adapt.px(24),
                      )
                    : CommonImage(
                        iconName: "not_selected.png",
                        width: Adapt.px(24),
                        height: Adapt.px(24),
                      ),
                SizedBox(
                  width: Adapt.px(20),
                ),
              ],
            ),
          ),
          onPressed: () {
            seletIndex = index;
            setState(() {});
          },
        ),
      ),
    );
  }

// Widget seletItemBuilder(BuildContext context, int index){
//   return Container();
// }
}
