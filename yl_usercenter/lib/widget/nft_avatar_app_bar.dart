import 'package:flutter/material.dart';
import 'package:yl_common/utils/adapt.dart';
import 'package:yl_common/utils/theme_color.dart';
import 'package:yl_common/widgets/common_appbar.dart';
import 'package:yl_common/widgets/common_button.dart';
import 'package:yl_common/widgets/common_image.dart';

class NFTAvatarAppBar extends StatelessWidget {
  final String? title;

  const NFTAvatarAppBar({super.key, this.title});

  @override
  CommonAppBar build(BuildContext context) {
    return CommonAppBar(
      backgroundColor: ThemeColor.color200,
      title: title ?? 'Create NFT avatar',
      useLargeTitle: false,
      centerTitle: true,
      canBack: false,
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
              Navigator.pop(context);
            },
          ),
        ),
      ],
    );
  }
}
