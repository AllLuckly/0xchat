import 'package:flutter/material.dart';
import 'package:yl_common/utils/adapt.dart';
import 'package:yl_common/utils/theme_color.dart';

class CustomCircularProgressIndicator extends StatefulWidget {
  final double? width;
  final double? strokeWidth;
  final double? value;
  final Animation<Color?>? valueColor;

  const CustomCircularProgressIndicator(
      {Key? key, this.width, this.strokeWidth, this.value, this.valueColor})
      : super(key: key);

  @override
  _CustomCircularProgressIndicatorState createState() =>
      _CustomCircularProgressIndicatorState();
}

class _CustomCircularProgressIndicatorState
    extends State<CustomCircularProgressIndicator> {
  @override
  Widget build(BuildContext context) {
    double _defaultWidth = MediaQuery.of(context).size.width - Adapt.px(80);

    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: widget.width ?? _defaultWidth,
          height: widget.width ?? _defaultWidth,
          child: CircularProgressIndicator(
            strokeWidth: widget.strokeWidth ?? Adapt.px(2),
            valueColor: widget.valueColor,
            backgroundColor: ThemeColor.color180,
            value: widget.value,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: ThemeColor.color180,
            shape: BoxShape.circle,
            image: const DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(
                'assets/images/icon_upload_progress_background_big.png',
                package: 'yl_usercenter'
              ),
            ),
          ),
          width: widget.width != null
              ? widget.width! - Adapt.px(16)
              : _defaultWidth - Adapt.px(16),
          height: widget.width != null
              ? widget.width! - Adapt.px(16)
              : _defaultWidth - Adapt.px(16),
        )
      ],
    );
  }
}
