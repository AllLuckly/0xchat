import 'dart:convert';
/// productList : [{"aiImageCount":25,"currency":"$","description":"Choose 1 of the 25+ unique avatars to creat NFT avatar","price":1.0,"productId":"1","title":"1 NFT Avatar"},{"aiImageCount":25,"currency":"$","description":"Choose 2 of the 25+ unique avatars to creat NFT avatar","price":2.0,"productId":"2","title":"2 NFT Avatar"},{"aiImageCount":25,"currency":"$","description":"Choose 5 of the 25+ unique avatars to creat NFT avatar","price":4.0,"productId":"3","title":"5 NFT Avatar"}]

MyProductListEntity myProductListEntityFromJson(String str) => MyProductListEntity.fromJson(json.decode(str));
String myProductListEntityToJson(MyProductListEntity data) => json.encode(data.toJson());
class MyProductListEntity {
  MyProductListEntity({
      List<ProductList>? productList,}){
    _productList = productList;
}

  MyProductListEntity.fromJson(dynamic json) {
    if (json['productList'] != null) {
      _productList = [];
      json['productList'].forEach((v) {
        _productList?.add(ProductList.fromJson(v));
      });
    }
  }
  List<ProductList>? _productList;
MyProductListEntity copyWith({  List<ProductList>? productList,
}) => MyProductListEntity(  productList: productList ?? _productList,
);
  List<ProductList>? get productList => _productList;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_productList != null) {
      map['productList'] = _productList?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// aiImageCount : 25
/// currency : "$"
/// description : "Choose 1 of the 25+ unique avatars to creat NFT avatar"
/// price : 1.0
/// productId : "1"
/// title : "1 NFT Avatar"

ProductList productListFromJson(String str) => ProductList.fromJson(json.decode(str));
String productListToJson(ProductList data) => json.encode(data.toJson());
class ProductList {
  ProductList({
      num? aiImageCount,
    num? nftAvatarCount,
    String? currency,
      String? description, 
      num? price, 
      String? productId, 
      String? title,
    String? inPurchasingIdAndroid,
    String? inPurchasingId,
    bool? hotFlag,
  }){
    _aiImageCount = aiImageCount;
    _currency = currency;
    _description = description;
    _price = price;
    _productId = productId;
    _title = title;
    _inPurchasingIdAndroid = inPurchasingIdAndroid;
    _inPurchasingId = inPurchasingId;
    _hotFlag = hotFlag;
    _nftAvatarCount= nftAvatarCount;
}

  ProductList.fromJson(dynamic json) {
    _aiImageCount = json['aiImageCount'];
    _currency = json['currency'];
    _description = json['description'];
    _price = json['price'];
    _productId = json['productId'];
    _title = json['title'];
    _inPurchasingIdAndroid = json['inPurchasingIdAndroid'];
    _inPurchasingId = json['inPurchasingId'];
    _hotFlag = json['hotFlag'];
    _nftAvatarCount = json['nftAvatarCount'];
  }
  num? _aiImageCount;
  String? _currency;
  String? _description;
  num? _price;
  String? _productId;
  String? _title;
  String? _inPurchasingIdAndroid;
  String? _inPurchasingId;
  bool? _hotFlag;
  num? _nftAvatarCount;
ProductList copyWith({  num? aiImageCount,
  String? currency,
  String? description,
  num? price,
  String? productId,
  String? title,
  String? inPurchasingIdAndroid,
  String? inPurchasingId,
  bool? hotFlag,
  num? nftAvatarCount,
}) => ProductList(  aiImageCount: aiImageCount ?? _aiImageCount,
  currency: currency ?? _currency,
  description: description ?? _description,
  price: price ?? _price,
  productId: productId ?? _productId,
  title: title ?? _title,
  inPurchasingIdAndroid: inPurchasingIdAndroid ?? _inPurchasingIdAndroid,
  inPurchasingId: inPurchasingId ?? _inPurchasingId,
  hotFlag: hotFlag ?? _hotFlag,
  nftAvatarCount: nftAvatarCount ?? _nftAvatarCount,
);
  num? get aiImageCount => _aiImageCount;
  num? get nftAvatarCount => _nftAvatarCount;
  String? get currency => _currency;
  String? get description => _description;
  num? get price => _price;
  String? get productId => _productId;
  String? get title => _title;
  String? get inPurchasingIdAndroid => _inPurchasingIdAndroid;
  String? get inPurchasingId => _inPurchasingId;
  bool? get hotFlag => _hotFlag;
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['aiImageCount'] = _aiImageCount;
    map['currency'] = _currency;
    map['description'] = _description;
    map['price'] = _price;
    map['productId'] = _productId;
    map['title'] = _title;
    map['inPurchasingIdAndroid'] = _inPurchasingIdAndroid;
    map['inPurchasingId'] = _inPurchasingId;
    map['hotFlag'] = _hotFlag;
    map['nftAvatarCount'] = _nftAvatarCount;
    return map;
  }

}