import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yl_common/model/yl_user_info.dart';
import 'package:yl_common/navigator/navigator.dart';
import 'package:yl_common/utils/adapt.dart';
import 'package:yl_common/utils/theme_color.dart';
import 'package:yl_common/utils/yl_userinfo_manager.dart';
import 'package:yl_common/widgets/common_appbar.dart';
import 'package:yl_common/widgets/common_button.dart';
import 'package:yl_common/widgets/common_toast.dart';
import 'package:yl_localizable/yl_localizable.dart';
import 'package:yl_module_service/yl_module_service.dart';

class SetSignaturePage extends StatefulWidget {
  const SetSignaturePage({Key? key}) : super(key: key);

  @override
  State<SetSignaturePage> createState() => _SetSignaturePageState();
}

class _SetSignaturePageState extends State<SetSignaturePage> {
  TextEditingController? _controller;
  YLUserInfo? mCurrentUserInfo;
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    mCurrentUserInfo = YLUserInfoManager.sharedInstance.currentUserInfo;
    _controller?.text = mCurrentUserInfo?.whatsUp ?? '';
    // _controller?.addListener(() {
    //   print(_controller?.text);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //表示透明也响应处理
      behavior: HitTestBehavior.translucent,
      onTap: () {
        //收起键盘
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        backgroundColor: ThemeColor.bgColor,
        appBar: CommonAppBar(
          title:  Localized.text('yl_usercenter.Signature'),
          useLargeTitle: false,
          centerTitle: true,
          canBack: true,
          actions: <Widget>[
            Container(
              margin: EdgeInsets.only(right: Adapt.px(5)),
              color: Colors.transparent,
              child: ValueListenableBuilder(
                valueListenable:_controller!,
                builder: (_,__,___){
                  return CommonButton(
                      backgroundColor: Colors.transparent,
                      width: Adapt.px(44),
                      height: Adapt.px(44),
                      content : Localized.text('yl_usercenter.Done'),
                      fontColor: _controller!.text.isNotEmpty ? ThemeColor.white01 : ThemeColor.gray7,
                      onPressed: _controller!.text.isNotEmpty ? () async {
                        bool isSuc  = await YLModuleService.invoke("yl_wowchat", "doSubmitAndSaveForWhatsUp", [_controller?.text]);
                        if(isSuc) {
                          mCurrentUserInfo?.whatsUp = _controller?.text;
                          YLUserInfoManager.sharedInstance.updateUserInfo(mCurrentUserInfo!);
                          CommonToast.instance.show(context, Localized.text("yl_usercenter.Set successfully"));
                          YLNavigator.pop(context);
                          setState(() {

                          });
                        }else {
                          CommonToast.instance.show(context, Localized.text("yl_usercenter.set_failed"));
                        }
                        // YLNavigator.pushPage(context, (context) => SetUpPage());
                      } : (){}
                  );
                },
              ),
            ),
          ],
        ),
        body: createBoby(),
      ),
    )

    ;
  }

  Widget createBoby() {
    return Container(
      constraints: BoxConstraints(
        maxHeight: 255,
        minHeight: 110,
      ),
      width: double.infinity,
      margin: EdgeInsets.only(left: Adapt.px(16),right: Adapt.px(16), top: Adapt.px(60)),
      padding: EdgeInsets.only(bottom: Adapt.px(10)),
      decoration:BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        color: ThemeColor.gray5,
      ),
      child:_getTextField(),

    );
  }

  Widget _getTextField() {
    return TextField(
      maxLines:null,
      keyboardType: TextInputType.multiline,
      controller: _controller,
      cursorColor: ThemeColor.titleColor,
      textCapitalization: TextCapitalization.none,
      maxLength: 100,
      decoration: InputDecoration(
        //textfield占位语，类似于iOS中的placeholder
        hintText: Localized.text("yl_usercenter.Please enter your personal signature"),
        //占位语颜色
        hintStyle: TextStyle(color: ThemeColor.gray7),
        suffixIcon: IconButton(icon: Icon(Icons.close),onPressed: () {
          _controller?.clear();
        },
          color: ThemeColor.titleColor,
        ),
        //默认边框为红色，边框宽度为1
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.transparent,
            width: 1
          )
        ),
        suffixIconColor: ThemeColor.titleColor,
        //获取焦点后，边框为黑色，宽度为2
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.transparent,
            width: 1
          )
        ),

      ),
      inputFormatters: <TextInputFormatter>[
        LengthLimitingTextInputFormatter(100)//限制长度
      ],
    );
  }
}
