import 'dart:convert';
import 'dart:io';
/// id : "20000000000000001"
/// benefits : [{"benefit":"Stand out in Comments","imageUrl":"https://0xchat.com/ipfs/QmQ6WHeH8fcJoJNF6SoG6AKGDZ9WxY4e2RmPAgJLQhHpZB"},{"benefit":"Adds card to profile","imageUrl":"https://0xchat.com/ipfs/QmQ6WHeH8fcJoJNF6SoG6AKGDZ9WxY4e2RmPAgJLQhHpZB"},{"benefit":"Mix with other avatar gear","imageUrl":"https://0xchat.com/ipfs/QmQ6WHeH8fcJoJNF6SoG6AKGDZ9WxY4e2RmPAgJLQhHpZB"},{"benefit":"Collectible ,part of a series","imageUrl":"https://0xchat.com/ipfs/QmQ6WHeH8fcJoJNF6SoG6AKGDZ9WxY4e2RmPAgJLQhHpZB"}]
/// creatorUrl : "https://twitter.com/hekathena"
/// amount : 9.9000000000000004
/// previewUrl : "https://www.dontdiememe.com/ipfs/QmQF4fVbdqmkjQ4v3f5EyydabyiqkNv4Y37wAMtxyhjQwf"
/// creatorDesc : "I call myself an audio/visual witch from the future. 3D and music were one of the best discoveries in my life. I found my way how to free my self-realization instinct and that’s what makes me happy, opens my fantasy even more, and shows me the way and opportunities that this is a never-ending adventure."
/// nftDesc : "Meme Kids - Meme Kids Gen 0 is a collection all minted from DontDieMeme genesis pool, you can start farming here"
/// nftType : "0"
/// creator : "Hekathena"
/// inPurchasingType : 1
/// nftName : "Meme Kids #1518"
/// currency : "USD"

MyNftDetailEntity myNftDetailEntityFromJson(String str) => MyNftDetailEntity.fromJson(json.decode(str));
String myNftDetailEntityToJson(MyNftDetailEntity data) => json.encode(data.toJson());
class MyNftDetailEntity {
  MyNftDetailEntity({
      String? id, //nft id
      List<Benefits>? benefits, //相关的Benefit
      String? creatorUrl, //创建者链接
      num? amount, //价格
      String? previewUrl, 
      String? creatorDesc, //创建者描述
      String? nftDesc, //nft描述
      String? nftType,
      String? creator,//创建者
      String? inPurchasingId,//ios内购id
      String? inPurchasingIdAndroid,//android内购id
      String? nftName, //nft 名
      String? currency,//当前 币种
    String? termsUrl,//协议链接
    String? openseaUrl,//opensea 链接
    String? imageUrl, //view on ipfs 链接
    String? metadataUrl,//ipfs metadata 链接
  }){
    _id = id;
    _benefits = benefits;
    _creatorUrl = creatorUrl;
    _amount = amount;
    _previewUrl = previewUrl;
    _creatorDesc = creatorDesc;
    _nftDesc = nftDesc;
    _nftType = nftType;
    _creator = creator;
    _inPurchasingId = inPurchasingId;
    _inPurchasingIdAndroid = _inPurchasingIdAndroid;
    _nftName = nftName;
    _currency = currency;
    _termsUrl = termsUrl;
    _openseaUrl = openseaUrl;
    _imageUrl = imageUrl;
    _metadataUrl = metadataUrl;

}

  MyNftDetailEntity.fromJson(dynamic json) {
    _id = json['id'];
    if (json['benefits'] != null) {
      _benefits = [];
      json['benefits'].forEach((v) {
        _benefits?.add(Benefits.fromJson(v));
      });
    }
    _creatorUrl = json['creatorUrl'];
    _amount = json['amount'];
    _previewUrl = json['previewUrl'];
    _creatorDesc = json['creatorDesc'];
    _nftDesc = json['nftDesc'];
    _nftType = json['nftType'];
    _creator = json['creator'];
    _inPurchasingId = json['inPurchasingId'];
    _inPurchasingIdAndroid = json['_inPurchasingIdAndroid'];
    _nftName = json['nftName'];
    _currency = json['currency'];
    _termsUrl = json['termsUrl'];
    _openseaUrl = json['openseaUrl'];
    _imageUrl = json['imageUrl'];
    _metadataUrl = json['metadataUrl'];
  }
  String? _id;
  List<Benefits>? _benefits;
  String? _creatorUrl;
  num? _amount;
  String? _previewUrl;
  String? _creatorDesc;
  String? _nftDesc;
  String? _nftType;
  String? _creator;
  String? _inPurchasingId;
  String? _inPurchasingIdAndroid;
  String? _nftName;
  String? _currency;

  String? _termsUrl;
  String? _openseaUrl;
  String? _imageUrl;
  String? _metadataUrl;
MyNftDetailEntity copyWith({  String? id,
  List<Benefits>? benefits,
  String? creatorUrl,
  num? amount,
  String? previewUrl,
  String? creatorDesc,
  String? nftDesc,
  String? nftType,
  String? creator,
  String? inPurchasingId,
  String? inPurchasingIdAndroid,
  String? nftName,
  String? currency,
  String? termsUrl,
  String? openseaUrl,
  String? imageUrl,
  String? metadataUrl,
}) => MyNftDetailEntity(  id: id ?? _id,
  benefits: benefits ?? _benefits,
  creatorUrl: creatorUrl ?? _creatorUrl,
  amount: amount ?? _amount,
  previewUrl: previewUrl ?? _previewUrl,
  creatorDesc: creatorDesc ?? _creatorDesc,
  nftDesc: nftDesc ?? _nftDesc,
  nftType: nftType ?? _nftType,
  creator: creator ?? _creator,
  inPurchasingId: inPurchasingId ?? _inPurchasingId,
  inPurchasingIdAndroid: inPurchasingIdAndroid ?? _inPurchasingIdAndroid,
  nftName: nftName ?? _nftName,
  currency: currency ?? _currency,

  termsUrl: termsUrl ?? _termsUrl,
  openseaUrl: openseaUrl ?? _openseaUrl,
  imageUrl: imageUrl ?? _imageUrl,
  metadataUrl: metadataUrl ?? _metadataUrl,
);
  String? get id => _id;
  List<Benefits>? get benefits => _benefits;
  String? get creatorUrl => _creatorUrl;
  num? get amount => _amount;
  String? get previewUrl => _previewUrl;
  String? get creatorDesc => _creatorDesc;
  String? get nftDesc => _nftDesc;
  String? get nftType => _nftType;
  String? get creator => _creator;
  String? get inPurchasingId => Platform.isAndroid ? _inPurchasingIdAndroid :_inPurchasingId;
  String? get inPurchasingIdAndroid => _inPurchasingIdAndroid;
  String? get nftName => _nftName;
  String? get currency => _currency;

  String? get termsUrl => _termsUrl;
  String? get openseaUrl => _openseaUrl;
  String? get imageUrl => _imageUrl;
  String? get metadataUrl => _metadataUrl;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    if (_benefits != null) {
      map['benefits'] = _benefits?.map((v) => v.toJson()).toList();
    }
    map['creatorUrl'] = _creatorUrl;
    map['amount'] = _amount;
    map['previewUrl'] = _previewUrl;
    map['creatorDesc'] = _creatorDesc;
    map['nftDesc'] = _nftDesc;
    map['nftType'] = _nftType;
    map['creator'] = _creator;
    map['inPurchasingId'] = _inPurchasingId;
    map['inPurchasingIdAndroid'] = _inPurchasingIdAndroid;
    map['nftName'] = _nftName;
    map['currency'] = _currency;

    map['termsUrl'] = _termsUrl;
    map['openseaUrl'] = _openseaUrl;
    map['imageUrl'] = _imageUrl;
    map['metadataUrl'] = _metadataUrl;
    return map;
  }

}

/// benefit : "Stand out in Comments"
/// imageUrl : "https://0xchat.com/ipfs/QmQ6WHeH8fcJoJNF6SoG6AKGDZ9WxY4e2RmPAgJLQhHpZB"

Benefits benefitsFromJson(String str) => Benefits.fromJson(json.decode(str));
String benefitsToJson(Benefits data) => json.encode(data.toJson());
class Benefits {
  Benefits({
      String? benefit, 
      String? imageUrl,}){
    _benefit = benefit;
    _imageUrl = imageUrl;
}

  Benefits.fromJson(dynamic json) {
    _benefit = json['benefit'];
    _imageUrl = json['imageUrl'];
  }
  String? _benefit;
  String? _imageUrl;
Benefits copyWith({  String? benefit,
  String? imageUrl,
}) => Benefits(  benefit: benefit ?? _benefit,
  imageUrl: imageUrl ?? _imageUrl,
);
  String? get benefit => _benefit;
  String? get imageUrl => _imageUrl;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['benefit'] = _benefit;
    map['imageUrl'] = _imageUrl;
    return map;
  }

}