import 'dart:convert';
/// contract : "0x2953399124f0cbb46d2cbacd8a89cf0599974963"
/// imageUrl : "https://res.cloudinary.com/alchemyapi/image/upload/thumbnail/matic-mainnet/a7a30f326e0a51cf2525e63c2b1aacad"
/// tokenId : "97950114208832865802933688509359382563840435332008702124366545527088334503937"

MyOxchatNftEntity myOxchatNftEntityFromJson(String str) => MyOxchatNftEntity.fromJson(json.decode(str));
String myOxchatNftEntityToJson(MyOxchatNftEntity data) => json.encode(data.toJson());
class MyOxchatNftEntity {
  MyOxchatNftEntity({
      String? contract, 
      String? imageUrl, 
      String? tokenId,}){
    _contract = contract;
    _imageUrl = imageUrl;
    _tokenId = tokenId;
}

  MyOxchatNftEntity.fromJson(dynamic json) {
    _contract = json['contract'];
    _imageUrl = json['imageUrl'];
    _tokenId = json['tokenId'];
  }
  String? _contract;
  String? _imageUrl;
  String? _tokenId;
MyOxchatNftEntity copyWith({  String? contract,
  String? imageUrl,
  String? tokenId,
}) => MyOxchatNftEntity(  contract: contract ?? _contract,
  imageUrl: imageUrl ?? _imageUrl,
  tokenId: tokenId ?? _tokenId,
);
  String? get contract => _contract;
  String? get imageUrl => _imageUrl;
  String? get tokenId => _tokenId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['contract'] = _contract;
    map['imageUrl'] = _imageUrl;
    map['tokenId'] = _tokenId;
    return map;
  }

}