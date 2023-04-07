import 'package:flutter/material.dart';
import 'package:yl_common/utils/adapt.dart';
import 'package:yl_common/utils/theme_color.dart';

enum LoadingType {
  loading,
  done,
}

class NTFAvatarLoadingCard extends StatefulWidget {
  final String? title;
  final String? centerLabel;
  final String? bottomLabel;
  final LoadingType loadingType;

  const NTFAvatarLoadingCard(
      {Key? key,
      required this.loadingType,
      this.title,
      this.centerLabel,
      this.bottomLabel})
      : super(key: key);

  @override
  _NTFAvatarLoadingCardState createState() => _NTFAvatarLoadingCardState();
}

class _NTFAvatarLoadingCardState extends State<NTFAvatarLoadingCard> {
  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width - Adapt.px(48);

    return Center(
      child: Container(
        width: _width,
        height: Adapt.px(102),
        padding: EdgeInsets.symmetric(
          vertical: Adapt.px(15.5),
          horizontal: Adapt.px(20),
        ),
        decoration: BoxDecoration(
          color: ThemeColor.color180,
          borderRadius: BorderRadius.circular(Adapt.px(16)),
        ),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title ?? "",
                  style: TextStyle(
                      color: ThemeColor.white01,
                      fontSize: Adapt.px(18),
                      fontWeight: FontWeight.w600),
                ),
                Text(
                  widget.centerLabel ?? "",
                  style: TextStyle(
                      color: ThemeColor.color100,
                      fontSize: Adapt.px(12),
                      fontWeight: FontWeight.w400),
                ),
                const Spacer(),
                Text(
                  widget.bottomLabel ?? "",
                  style: TextStyle(
                      color: ThemeColor.white01,
                      fontSize: Adapt.px(12),
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
            const Spacer(),
            widget.loadingType == LoadingType.loading
                ? SizedBox(
                    width: Adapt.px(18),
                    height: Adapt.px(18),
                    child: CircularProgressIndicator(
                      color: ThemeColor.gradientMainStart,
                      backgroundColor: ThemeColor.white01,
                      strokeWidth: Adapt.px(1),
                    ),
                  )
                : Container(
                    width: Adapt.px(22.5),
                    height: Adapt.px(22.5),
                    decoration: BoxDecoration(
                      border:
                          Border.all(color: ThemeColor.gradientMainStart, width: 1),
                      borderRadius: BorderRadius.circular(
                        Adapt.px(11.25),
                      ),
                    ),
                    child: Checkbox(
                      value: true,
                      onChanged: (value) {},
                      activeColor: ThemeColor.color180,
                      checkColor: ThemeColor.gradientMainStart,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          Adapt.px(11.25),
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
