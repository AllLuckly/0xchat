import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:yl_common/log_util.dart';
import 'package:yl_common/network/network_general.dart';
import 'package:yl_common/network/network_utils.dart';
import 'package:yl_common/websocket/spot/websocket_service_spot.dart';

part 'my_flow_nft_entity.g.dart';

@JsonSerializable()
class MyFlowNftEntity {
  @JsonKey(defaultValue: '')
  final String name;
  @JsonKey(defaultValue: '')
  final String rating;
  @JsonKey(defaultValue: '')
  final String image;
  @JsonKey(name: 'swing_velocity', defaultValue: '')
  final String swingVelocity;
  @JsonKey(name: 'swing_angle', defaultValue: '')
  final String swingAngle;

  const MyFlowNftEntity({
    required this.name,
    required this.rating,
    required this.image,
    required this.swingVelocity,
    required this.swingAngle,
  });

  factory MyFlowNftEntity.fromJson(Map<String, dynamic> json) =>
      _$MyFlowNftEntityFromJson(json);

  Map<String, dynamic> toJson() => _$MyFlowNftEntityToJson(this);
}


///获取ai生成的图片
Future<List<MyFlowNftEntity>?> getFlowNFTs({BuildContext? context, params}) async {
  LogUtil.e("getFlowNFTs params: ${params}");
  final map = <String, dynamic>{};
  map['Content-Type'] = 'application/json';
  final baseUrl = await NetworkUtils.getBaseUrl();
//   final baseUrl = "http://8.210.109.173:9306/oxchat/";
  return YLNetwork.instance
      .doRequest(
    context,
    url: '${baseUrl}outside/flow/getNfts?address=${params['address']}',
    showErrorToast: true,
    needCommonParams: false,
    needRSA: false,
    params: params,
    type: RequestType.POST,
    header: map,
  )
      .then((YLResponse response) {
// Map<String, dynamic> dataMap =
// Map<String, dynamic>.from(response.data['data']);
    LogUtil.e("getFlowNFTs ：${response.data['data']}");

    List<MyFlowNftEntity> flowList = [];
    if (response.data['data'] is List) {
       final List dataList = response.data['data'];
       for (var element in dataList) {
         MyFlowNftEntity flowNftEntity = MyFlowNftEntity.fromJson(element);
         flowList.add(flowNftEntity);
       }
    }

    return flowList;
  }).catchError((e) {
    LogUtil.e("getFlowNFTs catchError ：${e}");
    return null;
  });
}
