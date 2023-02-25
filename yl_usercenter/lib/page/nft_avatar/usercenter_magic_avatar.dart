import 'package:flutter/material.dart';
import 'package:yl_common/utils/adapt.dart';

import '../../widget/notice_button_widget.dart';


class UserCenterMagicAvatar extends StatefulWidget {
  const UserCenterMagicAvatar({Key? key}) : super(key: key);

  @override
  _UserCenterMagicAvatarState createState() => _UserCenterMagicAvatarState();
}

class _UserCenterMagicAvatarState extends State<UserCenterMagicAvatar> {
  int remainTime = 18;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Magic Avatars",
          style: TextStyle(
            color: Colors.black,
            fontSize: Adapt.px(16),
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: GestureDetector(
          child: Center(
            child: Text(
              "关闭",
              style: TextStyle(color: Colors.grey, fontSize: Adapt.px(16)),
            ),
          ),
          onTap: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: Adapt.px(10),
              right: Adapt.px(10),
            ),
            child: SizedBox(
              width: double.infinity,
              height: Adapt.px(140),
              child: Card(
                color: Colors.grey[100],
                child: Padding(
                  padding: EdgeInsets.all(Adapt.px(10)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        "Pack #1",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: Adapt.px(25),
                        ),
                      ),
                      SizedBox(
                        height: Adapt.px(5),
                      ),
                      Expanded(
                        child: Text(
                          "正在创建头像......",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: Adapt.px(16),
                          ),
                        ),
                      ),
                      Text(
                        "还剩 $remainTime 分钟",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: Adapt.px(18),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const Spacer(),
          Text(
            "您将永远不会有相同的结果!",
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: Adapt.px(16)),
          ),
          Text(
            "每个人工智能（AI）都会生成独特的头像。",
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: Adapt.px(16)),
          ),
          const SizedBox(
            height: 20,
          ),
          NoticeButton(
            title: "创建头像",
            horizontalPadding: Adapt.px(18),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
