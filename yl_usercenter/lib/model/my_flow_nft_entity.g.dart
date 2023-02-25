// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_flow_nft_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyFlowNftEntity _$MyFlowNftEntityFromJson(Map<String, dynamic> json) =>
    MyFlowNftEntity(
      name: json['name'] as String? ?? '',
      rating: json['rating'] as String? ?? '',
      image: json['image'] as String? ?? '',
      swingVelocity: json['swing_velocity'] as String? ?? '',
      swingAngle: json['swing_angle'] as String? ?? '',
    );

Map<String, dynamic> _$MyFlowNftEntityToJson(MyFlowNftEntity instance) =>
    <String, dynamic>{
      'name': instance.name,
      'rating': instance.rating,
      'image': instance.image,
      'swing_velocity': instance.swingVelocity,
      'swing_angle': instance.swingAngle,
    };
