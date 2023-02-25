import 'dart:convert';
/// myList : [{"shops":[{"amount":188.88,"currency":"HK","id":"000000001","nftName":"MEME VIP 001"},{"amount":88.879999999999995,"currency":"HK","id":"000000002","nftName":"MEME VIP 002"},{"amount":99.989999999999995,"currency":"HK","id":"000000003","nftName":"MEME VIP 003"}],"title":"MEME VIP"},{"shops":[{"amount":188.88,"currency":"HK","id":"000000004","nftName":"CloneX 001"},{"amount":88.879999999999995,"currency":"HK","id":"000000005","nftName":"CloneX 002"},{"amount":99.989999999999995,"currency":"HK","id":"000000006","nftName":"CloneX 003"}],"title":"CloneX"}]

MyNftListEntity myNftListEntityFromJson(String str) => MyNftListEntity.fromJson(json.decode(str));
String myNftListEntityToJson(MyNftListEntity data) => json.encode(data.toJson());
class MyNftListEntity {
  MyNftListEntity({
      List<MyList>? myList,}){
    _myList = myList;
}

  MyNftListEntity.fromJson(dynamic json) {
    if (json['list'] != null) {
      _myList = [];
      json['list'].forEach((v) {
        _myList?.add(MyList.fromJson(v));
      });
    }
  }
  List<MyList>? _myList;
MyNftListEntity copyWith({  List<MyList>? myList,
}) => MyNftListEntity(  myList: myList ?? _myList,
);
  List<MyList>? get myList => _myList;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_myList != null) {
      map['list'] = _myList?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// shops : [{"amount":188.88,"currency":"HK","id":"000000001","nftName":"MEME VIP 001"},{"amount":88.879999999999995,"currency":"HK","id":"000000002","nftName":"MEME VIP 002"},{"amount":99.989999999999995,"currency":"HK","id":"000000003","nftName":"MEME VIP 003"}]
/// title : "MEME VIP"

MyList myListFromJson(String str) => MyList.fromJson(json.decode(str));
String myListToJson(MyList data) => json.encode(data.toJson());
class MyList {
  MyList({
      List<Shops>? shops, 
      String? title,}){
    _shops = shops;
    _title = title;
}

  MyList.fromJson(dynamic json) {
    if (json['shops'] != null) {
      _shops = [];
      json['shops'].forEach((v) {
        _shops?.add(Shops.fromJson(v));
      });
    }
    _title = json['title'];
  }
  List<Shops>? _shops;
  String? _title;
MyList copyWith({  List<Shops>? shops,
  String? title,
}) => MyList(  shops: shops ?? _shops,
  title: title ?? _title,
);
  List<Shops>? get shops => _shops;
  String? get title => _title;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_shops != null) {
      map['shops'] = _shops?.map((v) => v.toJson()).toList();
    }
    map['title'] = _title;
    return map;
  }

}

/// amount : 188.88
/// currency : "HK"
/// id : "000000001"
/// nftName : "MEME VIP 001"

Shops shopsFromJson(String str) => Shops.fromJson(json.decode(str));
String shopsToJson(Shops data) => json.encode(data.toJson());
class Shops {
  Shops({
      num? amount, 
      String? currency, 
      dynamic id,
      String? nftName,
    dynamic previewUrl,
  }){
    _amount = amount;
    _currency = currency;
    _id = id;
    _nftName = nftName;
    _previewUrl = previewUrl;
}

  Shops.fromJson(dynamic json) {
    _amount = json['amount'];
    _currency = json['currency'];
    _id = json['id'];
    _nftName = json['nftName'];
    _previewUrl = json['previewUrl'];
  }
  num? _amount;
  String? _currency;
  dynamic _id;
  String? _nftName;
  dynamic _previewUrl;
Shops copyWith({  num? amount,
  String? currency,
  dynamic id,
  String? nftName,
  dynamic previewUrl,
}) => Shops(  amount: amount ?? _amount,
  currency: currency ?? _currency,
  id: id ?? _id,
  nftName: nftName ?? _nftName,
  previewUrl: previewUrl ?? _previewUrl,
);
  num? get amount => _amount;
  String? get currency => _currency;
  dynamic get id => _id;
  String? get nftName => _nftName;
  dynamic get previewUrl => _previewUrl;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['amount'] = _amount;
    map['currency'] = _currency;
    map['id'] = _id;
    map['nftName'] = _nftName;
    map['previewUrl'] = _previewUrl;
    return map;
  }

}