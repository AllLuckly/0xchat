import 'package:flutter/material.dart';
import 'package:yl_common/utils/adapt.dart';
import 'package:yl_common/widgets/common_image.dart';

///Title: widget_tool
///Description: TODO(自己填写)
///Copyright: Copyright (c) 2021
///@author George
///CreateTime: 2023/1/9 9:26 PM
Widget MyText(String content, double fontSize, Color txtColor, {TextAlign? textAlign, double? height, FontWeight fontWeight = FontWeight.w400}) {
  return Text(
    content,
    textAlign: textAlign,
    softWrap: true,
    style: TextStyle(fontSize: Adapt.px(fontSize), color: txtColor, fontWeight: fontWeight, height: height),
  );
}

Widget assetIcon(String iconName, double widthD, double heightD, {bool useTheme = false, BoxFit? fit}) {
  return CommonImage(
    useTheme: useTheme,
    iconName: iconName,
    width: Adapt.px(widthD),
    height: Adapt.px(heightD),
    fit: fit,
    package: 'yl_usercenter'
  );
}

extension YLWowchatWidget on Widget {
  Widget setPadding(EdgeInsets padding) {
    return Padding(
      padding: padding,
      child: this,
    );
  }
}