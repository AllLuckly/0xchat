import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yl_common/log_util.dart';
import 'package:yl_common/navigator/navigator.dart';
import 'package:yl_common/utils/adapt.dart';
import 'package:yl_common/utils/theme_color.dart';
import 'package:yl_module_service/yl_module_service.dart';
import 'package:yl_usercenter/page/set_up/avatar_shop_details_page.dart';
import 'package:yl_usercenter/model/my_nft_list_entity.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AvatarShopListPage extends StatefulWidget {
  const AvatarShopListPage({Key? key}) : super(key: key);

  @override
  State<AvatarShopListPage> createState() => _AvatarShopListPageState();
}

class _AvatarShopListPageState extends State<AvatarShopListPage> {
  MyNftListEntity? nftListEntity;

  @override
  Widget build(BuildContext context) {
    if (nftListEntity == null) {
      return Container();
    }
    return CustomScrollView(
      controller: null,
      slivers: <Widget>[
        SliverList(
            delegate:
                SliverChildBuilderDelegate((BuildContext context, int index) {
          return initGroupHead(index);
        }, childCount: nftListEntity?.myList?.length)),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    // LogUtil.e("dataJson :initState");
    getData();
    // LogUtil.e("dataJson :initState1");
  }

  getData() async {
    final dataJson =
        await YLModuleService.invoke("yl_wowchat", "getNftListData", []);
    nftListEntity = MyNftListEntity.fromJson(json.decode(dataJson));
    // LogUtil.e("dataJson1 : ${nftListEntity?.myList}");
    setState(() {});
  }

  initGroupHead(int index) {
    //第一层纵向list的item
    List<Shops>? _shops = nftListEntity?.myList?[index].shops;
    return Container(
      padding: EdgeInsets.all(5.0),
      child: Column(
        children: <Widget>[
          Container(
            child: titletagwidget(index == 0 ? 'MEME' : nftListEntity?.myList?[index].title ?? ""),
            margin: EdgeInsets.all(11.0),
            alignment: Alignment.centerLeft,
          ),
          Container(
            height: 230,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _shops?.length,
                itemBuilder: (context, index) {
                  LogUtil.e("shop: ${_shops}");
                  return initShopList(context, _shops![index]);
                }),
          ),

        ],
      ),
    );
  }

  initShopList(BuildContext context, Shops shop) {
    //第二层横向list的item

    return InkWell(
      child: Container(
        width: MediaQuery.of(context).size.width / 2 - 32,
        padding: EdgeInsets.only(left: Adapt.px(15), top: Adapt.px(5), bottom: Adapt.px(5), right: Adapt.px(0)),
        child: Column(
          children: <Widget>[
            // Image.network(shop.previewUrl ?? ''),
            Container(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(Adapt.px(10)),
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    height: Adapt.px(160),
                    width: double.infinity,
                    imageUrl: shop.previewUrl ?? '',
                    placeholder: (context, url) => Container(
                      color: ThemeColor.gray5,
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: ThemeColor.gray5,
                    ),
                  ),
                ),
                decoration: BoxDecoration(
                  border:  Border.all(width: 0.3, color: ThemeColor.gray5),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                )),

            Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                child: Text(
                  shop.nftName ?? '',
                  style: TextStyle(
                    color: ThemeColor.titleColor,
                  ),
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                )),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 3, 0, 0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      "${shop.currency ?? ''} ${shop.amount ?? ''}",
                      style:TextStyle(color: ThemeColor.gray2, fontSize: 14),
                    ),
                    flex: 2,
                  ),
                  Expanded(
                    child: Text(
                      "", //663人已购
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    flex: 1,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      onTap: () {
        LogUtil.e("previewUrl : ${shop.previewUrl ?? ''}");
        YLNavigator.pushPage(context, (context) => AvatarShopDetailsPage(nftId: shop.id, imgUrl: shop.previewUrl,));
      },
    );
  }

  Widget titletagwidget(String title) {
    return Text(title);
  }
}
