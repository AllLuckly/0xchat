
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yl_common/utils/adapt.dart';
import 'package:yl_common/utils/theme_color.dart';
import 'package:yl_common/widgets/categoryView/rectangular_indicator.dart';
import 'package:yl_usercenter/page/usercenter_dynamic_submodule_page.dart';
import 'package:sliver_grouped_list/sliver_grouped_list.dart';

class UsercenterDynamicPage extends StatefulWidget {
  const UsercenterDynamicPage({Key? key}) : super(key: key);

  @override
  State<UsercenterDynamicPage> createState() => _UsercenterDynamicPageState();
}

class _UsercenterDynamicPageState extends State<UsercenterDynamicPage>  with SingleTickerProviderStateMixin {
  TabController? _tabController;
  late ScrollController _nestedScrollController;
  static const double _kHeight = 150.0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 5);
    _nestedScrollController = ScrollController()
      ..addListener(() {});
  }

  @override
  Widget build(BuildContext context) {
    return
    //   SliverGroupedList<String, String>(
    //   data: {
    //     'A': ['My best friend', 'Good friend of mine', 'Guy I do not know'],
    //     'B': ['My cat', 'My dog', 'My fish', 'My bird'],
    //     'C': []
    //   },
    //   appBar: SliverAppBar(
    //     title: Text('SliverAppBar'),
    //     backgroundColor: Colors.green,
    //     expandedHeight: 200.0,
    //   ),
    //   header: SliverGrid.count(
    //     crossAxisCount: 3,
    //     children: [
    //       Container(color: Colors.white, height: _kHeight),
    //       Container(color: Colors.black, height: _kHeight),
    //       Container(color: Colors.grey, height: _kHeight),
    //       Container(color: Colors.grey, height: _kHeight),
    //       Container(color: Colors.white, height: _kHeight),
    //       Container(color: Colors.black, height: _kHeight),
    //       Container(color: Colors.black, height: _kHeight),
    //       Container(color: Colors.grey, height: _kHeight),
    //       Container(color: Colors.white, height: _kHeight),
    //     ],
    //   ),
    //   bodyHeaderMinHeight: 60.0,
    //   bodyHeaderMaxHeight: 100.0,
    //   bodyHeaderPinned: true,
    //   bodyHeaderFloating: false,
    //   bodyHeaderBuilder: (_, header) => Container(
    //     alignment: Alignment.center,
    //     child: Text(
    //       header,
    //       style: TextStyle(color: Colors.white),
    //     ),
    //     color: Colors.blue,
    //   ),
    //   bodyPlaceholderBuilder: (_, header) => Card(
    //     color: Colors.lightBlueAccent,
    //     child: Container(
    //       height: _kHeight,
    //       alignment: Alignment.center,
    //       child: Text(
    //         "There are no items available in $header",
    //         style: TextStyle(color: Colors.grey),
    //       ))),
    //   bodyEntryBuilder: (_, index, item) => GestureDetector(
    //     onTap: () {
    //       print(item);
    //       print(index);
    //     },
    //     child: Card(
    //       color: Colors.lightBlueAccent,
    //       child: Container(
    //         height: _kHeight,
    //         alignment: Alignment.center,
    //         child: Text(
    //           item,
    //           style: TextStyle(color: Colors.white),
    //         ))),
    //   ),
    //   footer: SliverFixedExtentList(
    //     itemExtent: _kHeight,
    //     delegate: SliverChildListDelegate(
    //       [
    //         Container(color: Colors.black),
    //         Container(color: Colors.white),
    //         Container(color: Colors.grey),
    //         Container(color: Colors.black),
    //         Container(color: Colors.white),
    //         Container(color: Colors.grey),
    //       ],
    //     ),
    //   ),
    // );




      Container(
      color: ThemeColor.bgColor,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(left: Adapt.px(15),right: Adapt.px(15), top: Adapt.px(15)),
            height: Adapt.px(31),
            padding: EdgeInsets.only(left: Adapt.px(2),right: Adapt.px(2), top: Adapt.px(2), bottom: Adapt.px(2)),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
              border: Border.all(width: 1,),
              color: ThemeColor.gray6,
            ),
            child:
            TabBar(
              controller: _tabController,
              tabs: [
                _tabBarItem("全部"),
                _tabBarItem("交易"),
                _tabBarItem("捐赠"),
                _tabBarItem("NFTs"),
                _tabBarItem("文章",showRightImage:false),
              ],
              isScrollable: false,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white,
              labelStyle: TextStyle(fontSize: 13),
              unselectedLabelStyle:TextStyle(fontSize: 13),
              indicator: RectangularIndicator(
                bottomLeftRadius: 7,
                bottomRightRadius: 7,
                topLeftRadius: 7,
                topRightRadius: 7,
                color: ThemeColor.gray7,
              ),
            ),
          ),
          TabBarView(
            physics: NeverScrollableScrollPhysics(),
            controller: _tabController,
            children: <Widget>[
              // UsercenterDynamicSubmodulePage(pageType: DynamicSubmodulePageType.allType,),
              // UsercenterDynamicSubmodulePage(pageType: DynamicSubmodulePageType.tradeType,),
              // UsercenterDynamicSubmodulePage(pageType: DynamicSubmodulePageType.donateType,),
              // UsercenterDynamicSubmodulePage(pageType: DynamicSubmodulePageType.nftType,),
              // UsercenterDynamicSubmodulePage(pageType: DynamicSubmodulePageType.articleType,),
            ]),
        ],
      ),
    );
  }

  Widget _buildBanner() {
    return SliverToBoxAdapter(
      child: Container(
        width: double.infinity,
        height: 200,
        child: Image.network(
          "http://image2.sina.com.cn/ent/s/j/p/2007-01-12/U1345P28T3D1407314F329DT20070112145144.jpg",
          height: double.infinity,
          fit: BoxFit.fill,
        ),
      ),
    );
  }


  Widget _buildStickyBar() {
    return SliverPersistentHeader(
      pinned: true, //是否固定在顶部
      floating: true,
      delegate: _SliverAppBarDelegate(
        minHeight: 50, //收起的高度
        maxHeight: 50, //展开的最大高度
        child: Container(
          color: ThemeColor.bgColor,
          child: Container(
            margin: EdgeInsets.only(
                left: Adapt.px(15), right: Adapt.px(15), top: Adapt.px(15)),
            height: Adapt.px(31),
            padding: EdgeInsets.only(
                left: Adapt.px(2),
                right: Adapt.px(2),
                top: Adapt.px(2),
                bottom: Adapt.px(2)),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
              border: Border.all(
                width: 1,
              ),
              color: ThemeColor.gray6,
            ),
            child: TabBar(
              controller: _tabController,
              tabs: [
                _tabBarItem("全部"),
                _tabBarItem("交易"),
                _tabBarItem("捐赠"),
                _tabBarItem("NFTs"),
                _tabBarItem("文章", showRightImage: false),
              ],
              isScrollable: false,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white,
              labelStyle: TextStyle(fontSize: 13),
              unselectedLabelStyle: TextStyle(fontSize: 13),
              indicator: RectangularIndicator(
                bottomLeftRadius: 7,
                bottomRightRadius: 7,
                topLeftRadius: 7,
                topRightRadius: 7,
                color: ThemeColor.gray7,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _tabBarItem(String title, {bool showRightImage = true}) {
    return Tab(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: Center(
            child: Text(title),
          ),
        ),
        // Expanded(child: Container(),),
        ///分割符自定义，可以放任何widget
        // showRightImage
        //     ? Container(
        //         color: ThemeColor.gray7,
        //         width: Adapt.px(1),
        //         // height: Adapt.px(15),
        //         margin: EdgeInsets.only(top: 2, bottom: 2),
        //         //   margin: EdgeInsets.only(top: 2, bottom: 2, left: 4),
        //       )
        //     : Container(
        //         width: 1,
        //         margin: EdgeInsets.only(top: 2, bottom: 2),
        //       )
      ],
    ));
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  Widget _buildTopTabBar() {
    return SliverPersistentHeader(
      pinned: true, //是否固定在顶部
      floating: true,
      delegate: _SliverAppBarDelegate(
        minHeight: 50, //收起的高度
        maxHeight: 50, //展开的最大高度
        child: Container(
          color: ThemeColor.bgColor,
          child: Container(
            margin: EdgeInsets.only(
                left: Adapt.px(15), right: Adapt.px(15), top: Adapt.px(15)),
            height: Adapt.px(31),
            padding: EdgeInsets.only(
                left: Adapt.px(2),
                right: Adapt.px(2),
                top: Adapt.px(2),
                bottom: Adapt.px(2)),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
              border: Border.all(
                width: 1,
              ),
              color: ThemeColor.gray6,
            ),
            child: TabBar(
              controller: _tabController,
              tabs: [
                _tabBarItem("全部"),
                _tabBarItem("交易"),
                _tabBarItem("捐赠"),
                _tabBarItem("NFTs"),
                _tabBarItem("文章", showRightImage: false),
              ],
              isScrollable: false,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white,
              labelStyle: TextStyle(fontSize: 13),
              unselectedLabelStyle: TextStyle(fontSize: 13),
              indicator: RectangularIndicator(
                bottomLeftRadius: 7,
                bottomRightRadius: 7,
                topLeftRadius: 7,
                topRightRadius: 7,
                color: ThemeColor.gray7,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabBarView() {
    return
      SliverToBoxAdapter(
      child: Expanded(
        child: Container(
          color: Colors.red,
        )
      )
    );
  }
}


class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => max(maxHeight, minHeight);

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
      minHeight != oldDelegate.minHeight ||
      child != oldDelegate.child;
  }
}