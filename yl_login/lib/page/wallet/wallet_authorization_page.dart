import 'package:flutter/cupertino.dart';
import 'package:yl_common/utils/adapt.dart';
import 'package:yl_common/utils/theme_color.dart';

import '../../channel/login_method_channel_utls.dart';

class WalletAuthorizationPage extends StatefulWidget {
  const WalletAuthorizationPage({Key? key}) : super(key: key);

  @override
  State<WalletAuthorizationPage> createState() => _WalletAuthorizationPageState();
}

class _WalletAuthorizationPageState extends State<WalletAuthorizationPage> {
  late List loginList;

  @override
  Widget build(BuildContext context) {
    return  Container(
        constraints: BoxConstraints(
        maxHeight: Adapt.px(350),
        ),
      child: buildListItems(),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loginList = [
    ];
    getApps();
  }

  getApps() async{
    bool isMetamask = await LoginMethodChannelUtils.checkAvailability('metamask://');
    if(isMetamask){
      // Map metamask =  {"title": 'MetaMask','iconName' : 'meta_icon.png', 'schema' :'wc'};
      Map metamask =  {"title": 'MetaMask','iconName' : 'meta_icon.png', 'schema' :'metamask'};//fix 会跳转到其他支持wc协议的app
      loginList.add(metamask);
    }
    bool isTrust = await LoginMethodChannelUtils.checkAvailability('trust://');
    if(isTrust){
      Map trust =  {"title": 'Trust Wallet','iconName' : 'trust_icon.png', 'schema' :'trust'};
      loginList.add(trust);
    }
    bool isImToken = await LoginMethodChannelUtils.checkAvailability('imtokenv2://');
    if(isImToken){
      Map imtokenv2 =  {"title": 'imToken','iconName' : 'imToken_icon.png', 'schema' :'imtokenv2'};
      loginList.add(imtokenv2);
    }
    if (mounted) setState(() {});
  }

  Widget buildListItems() {
    List<Widget> tiles = [];
    Widget content; //单独一个widget组件，用于返回需要生成的内容widget
    for (var i = 0; i < loginList.length; i++) {
      var item = loginList[i];
      if (i == loginList.length - 1) {
        tiles.add(new Container(
          color: ThemeColor.gray8,
          // height: 50,
          child: Column(
            children: [
              Container(
                height: 68,
                child: buildListRow(item),
                // padding: EdgeInsets.only(left: 16, right: 16),
              ),
            ],
          ),
        ));
      } else {
        tiles.add(new Container(
          height: 68,
          child: Column(
            children: [
              Container(
                height: 67.5,
                child: buildListRow(item),
                // padding: EdgeInsets.only(left: 16, right: 16),
              ),
              Container(
                height: 0.5,
                color: Color(0x1A000000),
              ),
            ],
          ),
        ));
      }
    }
    content = new Column(
        children: tiles //重点在这里，因为用编辑器写Column生成的children后面会跟一个<Widget>[]，
      //此时如果我们直接把生成的tiles放在<Widget>[]中是会报一个类型不匹配的错误，把<Widget>[]删了就可以了
    );
    return content;
  }

  Widget buildListRow(item) {
    return GestureDetector(
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(36)),
            child: Image.asset(
              'assets/images/${item['iconName']}',
              fit: BoxFit.cover,
              width: Adapt.px(36),
              height: Adapt.px(36),
              package: 'yl_login',
            ),
          ),
          SizedBox(
            width: Adapt.px(12),
          ),
          Text(
            item['title'],
            style: TextStyle(color: ThemeColor.gray1, fontSize: 17),
          ),
        ],
      ),
      onTap: ()  async{
        // print("欧尼tap");

        // loginSchema = item['schema'];
        // _login(captchaStr : loginSchema);

        // address = "0x96d7cf71f6391a6092487c0390c4977052e78ddb";
        // loginIm("0x117a2c4041d172a3447797fa3fceea72d2ffd4a2afcbfd954fe90e0a77828f686722ecb633070d8898d82ff2a67c365f398df2c4f6d9c8e2449ca169eb0b3e211b");
      },
    );
  }
}
