import 'package:flutter/cupertino.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:yl_common/log_util.dart';
import 'package:yl_common/utils/theme_color.dart';
import 'package:yl_usercenter/model/my_assets_entity.dart';
import 'package:yl_usercenter/model/my_pregod_entity.dart';
import 'package:yl_usercenter/page/usercenter_page.dart';

class UserCenterNFTPage extends StatefulWidget {
  const UserCenterNFTPage({Key? key}) : super(key: key);

  @override
  State<UserCenterNFTPage> createState() => _UserCenterNFTPageState();
}

class _UserCenterNFTPageState extends State<UserCenterNFTPage> with AutomaticKeepAliveClientMixin{
  MyAssetsEntity? assetsEntity;
  MyPreGod? preGod;

  @override
  void initState() {
    super.initState();
    _getAccountInfoFn();
  }

  void _getAccountInfoFn() async {
    assetsEntity = await getMyAssets();
    preGod = await getMyPreGods();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return buildBoby();
  }

  Widget buildBoby(){
    LogUtil.e('Bison=====1== ${assetsEntity?.assets?.length}');
    return  assetsEntity == null ? Container(color: ThemeColor.bgColor,) : Container(
      color: ThemeColor.bgColor,
      child: MasonryGridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 18,
        crossAxisSpacing: 16,
        padding: EdgeInsets.only(left: 16, right: 16, top: 15),
        itemBuilder: (context, index) {
          return Container();
        //   return ImageTile(
        //     index: index,
        //     width: 100,
        //     height: 130,
        //     imgUrl: assetsEntity?.assets?[index].imageThumbnailUrl ?? '',
        //   );
         },
        itemCount: assetsEntity?.assets?.length,
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
