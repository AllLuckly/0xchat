import 'package:flutter/material.dart';
import 'package:yl_common/utils/adapt.dart';

enum NFTAvatarChooseTabType {
  nftType,
  maticType,
}

class NFTAvatarChooseTab extends StatefulWidget {
  final NFTAvatarChooseTabType? tabType;
  List? showNFTAvatar = [];
  final ValueSetter<List<String>>? onSelected;

  NFTAvatarChooseTab(
      {this.tabType, this.showNFTAvatar, this.onSelected, Key? key})
      : super(key: key);

  @override
  _NFTAvatarChooseTabState createState() => _NFTAvatarChooseTabState();
}

class _NFTAvatarChooseTabState extends State<NFTAvatarChooseTab>
    with AutomaticKeepAliveClientMixin {
  final List<String> _selectedNFTAvatar = [];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
      ),
      padding: EdgeInsets.only(
        left: Adapt.px(24),
        right: Adapt.px(24),
        bottom: Adapt.px(24),
      ),
      itemBuilder: (context, index) {
        return Center(
          child: Stack(children: [
            Container(
              // width: Adapt.px(163),
              // height: Adapt.px(163),
              decoration: BoxDecoration(
                // color: Colors.red,
                borderRadius: BorderRadius.circular(Adapt.px(24)),
                image: DecorationImage(
                    image: NetworkImage(widget.showNFTAvatar![index]),
                    fit: BoxFit.cover),
              ),
            ),
            Positioned(
              right: Adapt.px(8),
              bottom: Adapt.px(8),
              child: SizedBox(
                width: Adapt.px(32),
                height: Adapt.px(32),
                child: Checkbox(
                  value:
                      _selectedNFTAvatar.contains(widget.showNFTAvatar?[index]),
                  // value: true,
                  onChanged: (bool? value) {
                    if (value!) {
                      _selectedNFTAvatar.add(widget.showNFTAvatar?[index]);
                    } else {
                      _selectedNFTAvatar.remove(widget.showNFTAvatar?[index]);
                    }
                    setState(() {});
                    widget.onSelected!(_selectedNFTAvatar);
                  },
                  activeColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      Adapt.px(16),
                    ),
                  ),
                ),
              ),
            ),
          ]),
        );
      },
      itemCount: widget.showNFTAvatar?.length,
    );
  }

  @override
  bool get wantKeepAlive => true;
}
