import 'package:flutter/material.dart';
import 'package:yl_common/utils/adapt.dart';

class NoticeButton extends StatelessWidget {
  final String? title;
  final Color? titleColor, backgroundColor;
  final double? height;
  final GestureTapCallback? onTap;
  final double? horizontalPadding;
  final LinearGradient? gradient;

  const NoticeButton({
    Key? key,
    this.title,
    this.titleColor,
    this.backgroundColor,
    this.onTap,
    this.height,
    this.horizontalPadding,
    this.gradient,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: horizontalPadding ?? Adapt.px(24),
        right: horizontalPadding ?? Adapt.px(24),
        bottom: Adapt.px(20),
      ),
      child: GestureDetector(
        child: Container(
          alignment: Alignment.center,
          width: double.infinity,
          height: height ?? Adapt.px(48),
          child: Text(
            title ?? "",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: titleColor ?? Colors.white,
              fontSize: Adapt.px(15),
              fontWeight: FontWeight.w600,
            ),
          ),
          decoration: BoxDecoration(
            color: backgroundColor ?? Colors.black,
            borderRadius: BorderRadius.circular(Adapt.px(12)),
            gradient: gradient,
          ),
        ),
        onTap: onTap ?? () {},
      ),
    );
  }
}
