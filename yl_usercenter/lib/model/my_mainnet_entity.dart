/// https://polygon-mainnet.g.alchemy.com/v2/6AdLOpPPOiEy5Bucjk6-5YoCRu49O856
/// 马蹄链获取NFT
///

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:yl_common/log_util.dart';
import 'package:yl_common/network/network_general.dart';
import 'package:yl_network/network_manager.dart';

import 'package:quiver/check.dart';

/// 马蹄链获取NFT
Future<MyMainnetEntity?> getMyMainnetEntitys({BuildContext? context, Map<String, dynamic>? params, String? account}) async {
  final map = <String, dynamic>{};

  // 'https://pregod.rss3.dev/v0.4.0/account:0xC8b960D09C0078c18Dcbe7eB9AB9d816BcCa8944@ethereum/notes?tags=NFT&exclude_tags=POAP'

  String url = 'https://polygon-mainnet.g.alchemyapi.io/nft/v2/6AdLOpPPOiEy5Bucjk6-5YoCRu49O856/getNFTs?owner=${account}&withMetadata=true';
  return YLNetwork.instance.doRequest(
    context,
    url: url,
    // header: map,
    showErrorToast: true,
    needCommonParams: false,
    needRSA: false,
    type: RequestType.GET,
    params: params
  ).then((YLResponse response){
    if (response.data is Map) {
      LogUtil.e("MyMainnetEntity=============xxxxxxxxxxxxxxx : ${response.data}");
      MyMainnetEntity assetsEntity = MyMainnetEntity.fromJson(Map<String, dynamic>.from(response.data));
      // LogUtil.e("MyMainnetEntity=============xxxxxxxxxxxxxxx : ${assetsEntity.ownedNfts!.first.metadata?.image}");
      return assetsEntity;
    }
    return null;
  }).catchError((e) {
    LogUtil.e("error=============xxxxxxxxxxxxxxx : $e");
    return null;
  });
}


/// eth获取NFT
Future<MyMainnetEntity?> getMyEthEntitys({BuildContext? context, Map<String, dynamic>? params, String? account}) async {
  final map = <String, dynamic>{};
  // 'https://pregod.rss3.dev/v0.4.0/account:0xC8b960D09C0078c18Dcbe7eB9AB9d816BcCa8944@ethereum/notes?tags=NFT&exclude_tags=POAP'
  String url = 'https://eth-mainnet.g.alchemy.com/nft/v2/6AdLOpPPOiEy5Bucjk6-5YoCRu49O856/getNFTs?owner=${account}&withMetadata=true';
  return YLNetwork.instance.doRequest(
    context,
    url: url,
    // header: map,
    showErrorToast: true,
    needCommonParams: false,
    needRSA: false,
    type: RequestType.GET,
    params: params
  ).then((YLResponse response){
    if (response.data is Map) {

      // LogUtil.e("MyMainnetEntity=============xxxxxxxxxxxxxxx : ${response.data}");
      
      MyMainnetEntity assetsEntity = MyMainnetEntity.fromJson(Map<String, dynamic>.from(response.data));
      return assetsEntity;
    }
    return null;
  }).catchError((e) {
    LogUtil.e("error=============xxxxxxxxxxxxxxx : $e");
    return null;
  });
}

//

class MyMainnetEntity {
  MyMainnetEntity({
      List<OwnedNfts>? ownedNfts, 
      String? pageKey, 
      int? totalCount, 
      String? blockHash,}){
    _ownedNfts = ownedNfts;
    _pageKey = pageKey;
    _totalCount = totalCount;
    _blockHash = blockHash;
}

  MyMainnetEntity.fromJson(dynamic json) {
    if (json['ownedNfts'] != null) {
      _ownedNfts = [];
      json['ownedNfts'].forEach((v) {
        Map<String, dynamic>item = v;
        if(item["metadata"] is Map){
          if(item["metadata"].containsKey('image') == true){
            bool? isGlb = item["metadata"]["image"]?.contains(".glb");
            bool? isIpfs = item["metadata"]["image"]?.contains("ipfs://");
            if(isGlb == false && isIpfs == false){
              LogUtil.e("metadata image : ${item["metadata"]["image"]}");
              _ownedNfts?.add(OwnedNfts.fromJson(v));
            }
          }
        }
      });
    }
    _pageKey = json['pageKey'];
    _totalCount = json['totalCount'];
    _blockHash = json['blockHash'];
  }
  List<OwnedNfts>? _ownedNfts;
  String? _pageKey;
  int? _totalCount;
  String? _blockHash;
MyMainnetEntity copyWith({  List<OwnedNfts>? ownedNfts,
  String? pageKey,
  int? totalCount,
  String? blockHash,
}) => MyMainnetEntity(  ownedNfts: ownedNfts ?? _ownedNfts,
  pageKey: pageKey ?? _pageKey,
  totalCount: totalCount ?? _totalCount,
  blockHash: blockHash ?? _blockHash,
);
  List<OwnedNfts>? get ownedNfts => _ownedNfts;
  String? get pageKey => _pageKey;
  int? get totalCount => _totalCount;
  String? get blockHash => _blockHash;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_ownedNfts != null) {
      map['ownedNfts'] = _ownedNfts?.map((v) => v.toJson()).toList();
    }
    map['pageKey'] = _pageKey;
    map['totalCount'] = _totalCount;
    map['blockHash'] = _blockHash;
    return map;
  }

}

/// contract : {"address":"0x00c799edd6bb8a19b843a6ee13f4126077a31f6b"}
/// id : {"tokenId":"0x0000000000000000000000000000000000000000000000000000000000000011","tokenMetadata":{"tokenType":"ERC721"}}
/// balance : "1"
/// title : "BUIDLCON2022"
/// description : "ticket BUIDL22."
/// tokenUri : {"raw":"data:application/json;base64,eyJuYW1lIjogIkJVSURMQ09OMjAyMiIsImRlc2NyaXB0aW9uIjogInRpY2tldCBCVUlETDIyLiIsImltYWdlIjogImlwZnM6Ly9RbWIxNHNOTEJBOGVuZ3hLS282MkprZU1XYnVCUjZRcjhUZ2FaVTR1RkJTeEN6In0=","gateway":""}
/// media : [{"raw":"ipfs://Qmb14sNLBA8engxKKo62JkeMWbuBR6Qr8TgaZU4uFBSxCz","gateway":"https://ipfs.io/ipfs/Qmb14sNLBA8engxKKo62JkeMWbuBR6Qr8TgaZU4uFBSxCz"}]
/// metadata : {"name":"BUIDLCON2022","description":"ticket BUIDL22.","image":"ipfs://Qmb14sNLBA8engxKKo62JkeMWbuBR6Qr8TgaZU4uFBSxCz"}
/// timeLastUpdated : "2022-06-01T09:14:26.006Z"
/// contractMetadata : {"name":"BUIDLCON 2022","symbol":"BUIDL22","totalSupply":"51","tokenType":"ERC721"}

class OwnedNfts {
  OwnedNfts({
      Contract? contract, 
      Id? id, 
      String? balance, 
      String? title, 
      String? description, 
      TokenUri? tokenUri, 
      List<Media>? media, 
      Metadata? metadata, 
      String? timeLastUpdated, 
      ContractMetadata? contractMetadata,}){
    _contract = contract;
    _id = id;
    _balance = balance;
    _title = title;
    _description = description;
    _tokenUri = tokenUri;
    _media = media;
    _metadata = metadata;
    _timeLastUpdated = timeLastUpdated;
    _contractMetadata = contractMetadata;
}

  OwnedNfts.fromJson(dynamic json) {
    _contract = json['contract'] != null ? Contract.fromJson(json['contract']) : null;
    _id = json['id'] != null ? Id.fromJson(json['id']) : null;
    _balance = json['balance'];
    _title = json['title'];
    _description = json['description'];
    _tokenUri = json['tokenUri'] != null ? TokenUri.fromJson(json['tokenUri']) : null;
    if (json['media'] != null) {
      _media = [];
      json['media'].forEach((v) {
        _media?.add(Media.fromJson(v));
      });
    }
    LogUtil.e("metadata=============== :${json['metadata']}");
    _metadata = json['metadata'] != null ? Metadata.fromJson(json['metadata']) : null;
    _timeLastUpdated = json['timeLastUpdated'];
    _contractMetadata = json['contractMetadata'] != null ? ContractMetadata.fromJson(json['contractMetadata']) : null;
  }
  Contract? _contract;
  Id? _id;
  String? _balance;
  String? _title;
  String? _description;
  TokenUri? _tokenUri;
  List<Media>? _media;
  Metadata? _metadata;
  String? _timeLastUpdated;
  ContractMetadata? _contractMetadata;
OwnedNfts copyWith({  Contract? contract,
  Id? id,
  String? balance,
  String? title,
  String? description,
  TokenUri? tokenUri,
  List<Media>? media,
  Metadata? metadata,
  String? timeLastUpdated,
  ContractMetadata? contractMetadata,
}) => OwnedNfts(  contract: contract ?? _contract,
  id: id ?? _id,
  balance: balance ?? _balance,
  title: title ?? _title,
  description: description ?? _description,
  tokenUri: tokenUri ?? _tokenUri,
  media: media ?? _media,
  metadata: metadata ?? _metadata,
  timeLastUpdated: timeLastUpdated ?? _timeLastUpdated,
  contractMetadata: contractMetadata ?? _contractMetadata,
);
  Contract? get contract => _contract;
  Id? get id => _id;
  String? get balance => _balance;
  String? get title => _title;
  String? get description => _description;
  TokenUri? get tokenUri => _tokenUri;
  List<Media>? get media => _media;
  Metadata? get metadata => _metadata;
  String? get timeLastUpdated => _timeLastUpdated;
  ContractMetadata? get contractMetadata => _contractMetadata;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_contract != null) {
      map['contract'] = _contract?.toJson();
    }
    if (_id != null) {
      map['id'] = _id?.toJson();
    }
    map['balance'] = _balance;
    map['title'] = _title;
    map['description'] = _description;
    if (_tokenUri != null) {
      map['tokenUri'] = _tokenUri?.toJson();
    }
    if (_media != null) {
      map['media'] = _media?.map((v) => v.toJson()).toList();
    }
    if (_metadata != null) {
      map['metadata'] = _metadata?.toJson();
    }
    map['timeLastUpdated'] = _timeLastUpdated;
    if (_contractMetadata != null) {
      map['contractMetadata'] = _contractMetadata?.toJson();
    }
    return map;
  }

}

/// name : "BUIDLCON 2022"
/// symbol : "BUIDL22"
/// totalSupply : "51"
/// tokenType : "ERC721"

class ContractMetadata {
  ContractMetadata({
      String? name, 
      String? symbol, 
      String? totalSupply, 
      String? tokenType,}){
    _name = name;
    _symbol = symbol;
    _totalSupply = totalSupply;
    _tokenType = tokenType;
}

  ContractMetadata.fromJson(dynamic json) {
    _name = json['name'];
    _symbol = json['symbol'];
    _totalSupply = json['totalSupply'];
    _tokenType = json['tokenType'];
  }
  String? _name;
  String? _symbol;
  String? _totalSupply;
  String? _tokenType;
ContractMetadata copyWith({  String? name,
  String? symbol,
  String? totalSupply,
  String? tokenType,
}) => ContractMetadata(  name: name ?? _name,
  symbol: symbol ?? _symbol,
  totalSupply: totalSupply ?? _totalSupply,
  tokenType: tokenType ?? _tokenType,
);
  String? get name => _name;
  String? get symbol => _symbol;
  String? get totalSupply => _totalSupply;
  String? get tokenType => _tokenType;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = _name;
    map['symbol'] = _symbol;
    map['totalSupply'] = _totalSupply;
    map['tokenType'] = _tokenType;
    return map;
  }

}

/// name : "BUIDLCON2022"
/// description : "ticket BUIDL22."
/// image : "ipfs://Qmb14sNLBA8engxKKo62JkeMWbuBR6Qr8TgaZU4uFBSxCz"

class Metadata {
  Metadata({
      String? name, 
      String? description, 
      String? image,
      String? external_link,
  }){
    _name = name;
    _description = description;
    _image = image;
    _external_link = external_link;
}

  Metadata.fromJson(dynamic json) {
    if(json is Map){
      if(json.containsKey('image') == true){
          _name = json['name'];
    _description = json['description'];
    _image = json['image'];
          _external_link = json['external_link'];
      }else{
         _name = '';
    _description = '';
    _image = '';
         _external_link = '';
      }
    }else{
      
      _name = '';
    _description = '';
    _image = '';
    _external_link = '';
    }
    
  }
  String? _name;
  String? _description;
  String? _image;
  String? _external_link;
Metadata copyWith({  String? name,
  String? description,
  String? image,
  String? external_link,
}) => Metadata(  name: name ?? _name,
  description: description ?? _description,
  image: image ?? _image,
  external_link:external_link ?? _external_link,
);
  dynamic get name => _name;
  dynamic get description => _description;
  dynamic get image => _image;
  dynamic get external_link => _external_link;
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = _name;
    map['description'] = _description;
    map['image'] = _image;
    map['external_link'] = _external_link;
    return map;
  }

}

/// raw : "ipfs://Qmb14sNLBA8engxKKo62JkeMWbuBR6Qr8TgaZU4uFBSxCz"
/// gateway : "https://ipfs.io/ipfs/Qmb14sNLBA8engxKKo62JkeMWbuBR6Qr8TgaZU4uFBSxCz"

class Media {
  Media({
      String? raw, 
      String? gateway,}){
    _raw = raw;
    _gateway = gateway;
}

  Media.fromJson(dynamic json) {
    _raw = json['raw'];
    _gateway = json['gateway'];
  }
  String? _raw;
  String? _gateway;
Media copyWith({  String? raw,
  String? gateway,
}) => Media(  raw: raw ?? _raw,
  gateway: gateway ?? _gateway,
);
  String? get raw => _raw;
  String? get gateway => _gateway;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['raw'] = _raw;
    map['gateway'] = _gateway;
    return map;
  }

}

/// raw : "data:application/json;base64,eyJuYW1lIjogIkJVSURMQ09OMjAyMiIsImRlc2NyaXB0aW9uIjogInRpY2tldCBCVUlETDIyLiIsImltYWdlIjogImlwZnM6Ly9RbWIxNHNOTEJBOGVuZ3hLS282MkprZU1XYnVCUjZRcjhUZ2FaVTR1RkJTeEN6In0="
/// gateway : ""

class TokenUri {
  TokenUri({
      String? raw, 
      String? gateway,}){
    _raw = raw;
    _gateway = gateway;
}

  TokenUri.fromJson(dynamic json) {
    _raw = json['raw'];
    _gateway = json['gateway'];
  }
  String? _raw;
  String? _gateway;
TokenUri copyWith({  String? raw,
  String? gateway,
}) => TokenUri(  raw: raw ?? _raw,
  gateway: gateway ?? _gateway,
);
  String? get raw => _raw;
  String? get gateway => _gateway;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['raw'] = _raw;
    map['gateway'] = _gateway;
    return map;
  }

}

/// tokenId : "0x0000000000000000000000000000000000000000000000000000000000000011"
/// tokenMetadata : {"tokenType":"ERC721"}

class Id {
  Id({
      String? tokenId, 
      TokenMetadata? tokenMetadata,}){
    _tokenId = tokenId;
    _tokenMetadata = tokenMetadata;
}

  Id.fromJson(dynamic json) {
    _tokenId = json['tokenId'];
    _tokenMetadata = json['tokenMetadata'] != null ? TokenMetadata.fromJson(json['tokenMetadata']) : null;
  }
  String? _tokenId;
  TokenMetadata? _tokenMetadata;
Id copyWith({  String? tokenId,
  TokenMetadata? tokenMetadata,
}) => Id(  tokenId: tokenId ?? _tokenId,
  tokenMetadata: tokenMetadata ?? _tokenMetadata,
);
  String? get tokenId => _tokenId;
  TokenMetadata? get tokenMetadata => _tokenMetadata;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['tokenId'] = _tokenId;
    if (_tokenMetadata != null) {
      map['tokenMetadata'] = _tokenMetadata?.toJson();
    }
    return map;
  }

}

/// tokenType : "ERC721"

class TokenMetadata {
  TokenMetadata({
      String? tokenType,}){
    _tokenType = tokenType;
}

  TokenMetadata.fromJson(dynamic json) {
    _tokenType = json['tokenType'];
  }
  String? _tokenType;
TokenMetadata copyWith({  String? tokenType,
}) => TokenMetadata(  tokenType: tokenType ?? _tokenType,
);
  String? get tokenType => _tokenType;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['tokenType'] = _tokenType;
    return map;
  }

}

/// address : "0x00c799edd6bb8a19b843a6ee13f4126077a31f6b"

class Contract {
  Contract({
      String? address,}){
    _address = address;
}

  Contract.fromJson(dynamic json) {
    _address = json['address'];
  }
  String? _address;
Contract copyWith({  String? address,
}) => Contract(  address: address ?? _address,
);
  String? get address => _address;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['address'] = _address;
    return map;
  }

}