

import 'package:flutter/cupertino.dart';
import 'package:yl_common/log_util.dart';
import 'package:yl_common/network/network_general.dart';
import 'package:yl_network/network_manager.dart';
import 'dart:convert';

class MyAssetsEntity {
  MyAssetsEntity({
      String? next, 
      dynamic previous, 
      List<Assets>? assets,}){
    _next = next;
    _previous = previous;
    _assets = assets;
}

  MyAssetsEntity.fromJson(dynamic json) {
    _next = json['next'];
    _previous = json['previous'];
    if (json['assets'] != null) {
      _assets = [];
      json['assets'].forEach((v) {
        _assets?.add(Assets.fromJson(v));
      });
    }
  }
  String? _next;
  dynamic _previous;
  List<Assets>? _assets;
MyAssetsEntity copyWith({  String? next,
  dynamic previous,
  List<Assets>? assets,
}) => MyAssetsEntity(  next: next ?? _next,
  previous: previous ?? _previous,
  assets: assets ?? _assets,
);
  String? get next => _next;
  dynamic get previous => _previous;
  List<Assets>? get assets => _assets;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['next'] = _next;
    map['previous'] = _previous;
    if (_assets != null) {
      map['assets'] = _assets?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// 账户信息接口
Future<MyAssetsEntity?> getMyAssets({BuildContext? context, params}) async {
  final map = <String, dynamic>{};
  map['X-API-KEY'] = '';
  return YLNetwork.instance.doRequest(
    context,
    url: 'https://api.opensea.io/api/v1/assets?order_direction=desc&limit=50&include_orders=false&owner=0xC8b960D09C0078c18Dcbe7eB9AB9d816BcCa8944',
    header: map,
    showErrorToast: true,
    needCommonParams: false,
    needRSA: false,
    type: RequestType.GET
  ).then((YLResponse response){
    if (response.data is Map) {
      MyAssetsEntity assetsEntity = MyAssetsEntity.fromJson(Map<String, dynamic>.from(response.data));
      return assetsEntity;
    }
    return null;
  }).catchError((e) {
    return null;
  });
}

class Assets {
  Assets({
    int? id,
      int? numSales,
      dynamic backgroundColor,
      String? imageUrl,
      String? imagePreviewUrl,
      String? imageThumbnailUrl,
      String? imageOriginalUrl,
      dynamic animationUrl,
      dynamic animationOriginalUrl,
      String? name,
      String? description,
      String? externalLink,
      AssetContract? assetContract,
      String? permalink,
      Collection? collection,
      dynamic decimals,
      String? tokenMetadata,
      bool? isNsfw,
      Owner? owner,
      dynamic sellOrders,
      dynamic seaportSellOrders,
      Creator? creator,
      List<Traits>? traits,
      dynamic lastSale,
      dynamic topBid,
      dynamic listingDate,
      bool? isPresale,
      dynamic transferFeePaymentToken,
      dynamic transferFee,
      String? tokenId,
  }){
    _id = id;
    _numSales = numSales;
    _backgroundColor = backgroundColor;
    _imageUrl = imageUrl;
    _imagePreviewUrl = imagePreviewUrl;
    _imageThumbnailUrl = imageThumbnailUrl;
    _imageOriginalUrl = imageOriginalUrl;
    _animationUrl = animationUrl;
    _animationOriginalUrl = animationOriginalUrl;
    _name = name;
    _description = description;
    _externalLink = externalLink;
    _assetContract = assetContract;
    _permalink = permalink;
    _collection = collection;
    _decimals = decimals;
    _tokenMetadata = tokenMetadata;
    _isNsfw = isNsfw;
    _owner = owner;
    _sellOrders = sellOrders;
    _seaportSellOrders = seaportSellOrders;
    _creator = creator;
    _traits = traits;
    _lastSale = lastSale;
    _topBid = topBid;
    _listingDate = listingDate;
    _isPresale = isPresale;
    _transferFeePaymentToken = transferFeePaymentToken;
    _transferFee = transferFee;
    _tokenId = tokenId;
}

  Assets.fromJson(dynamic json) {
    _id = json['id'];
    _numSales = json['num_sales'];
    _backgroundColor = json['background_color'];
    _imageUrl = json['image_url'];
    _imagePreviewUrl = json['image_preview_url'];
    _imageThumbnailUrl = json['image_thumbnail_url'];
    _imageOriginalUrl = json['image_original_url'];
    _animationUrl = json['animation_url'];
    _animationOriginalUrl = json['animation_original_url'];
    _name = json['name'];
    _description = json['description'];
    _externalLink = json['external_link'];
    _assetContract = json['asset_contract'] != null ? AssetContract.fromJson(json['asset_contract']) : null;
    _permalink = json['permalink'];
    _collection = json['collection'] != null ? Collection.fromJson(json['collection']) : null;
    _decimals = json['decimals'];
    _tokenMetadata = json['token_metadata'];
    _isNsfw = json['is_nsfw'];
    _owner = json['owner'] != null ? Owner.fromJson(json['owner']) : null;
    _sellOrders = json['sell_orders'];
    _seaportSellOrders = json['seaport_sell_orders'];
    _creator = json['creator'] != null ? Creator.fromJson(json['creator']) : null;
    if (json['traits'] != null) {
      _traits = [];
      json['traits'].forEach((v) {
        _traits?.add(Traits.fromJson(v));
      });
    }
    _lastSale = json['last_sale'];
    _topBid = json['top_bid'];
    _listingDate = json['listing_date'];
    _isPresale = json['is_presale'];
    _transferFeePaymentToken = json['transfer_fee_payment_token'];
    _transferFee = json['transfer_fee'];
    _tokenId = json['token_id'];
  }
  int? _id;
  int? _numSales;
  dynamic _backgroundColor;
  String? _imageUrl;
  String? _imagePreviewUrl;
  String? _imageThumbnailUrl;
  String? _imageOriginalUrl;
  dynamic _animationUrl;
  dynamic _animationOriginalUrl;
  String? _name;
  String? _description;
  String? _externalLink;
  AssetContract? _assetContract;
  String? _permalink;
  Collection? _collection;
  dynamic _decimals;
  String? _tokenMetadata;
  bool? _isNsfw;
  Owner? _owner;
  dynamic _sellOrders;
  dynamic _seaportSellOrders;
  Creator? _creator;
  List<Traits>? _traits;
  dynamic _lastSale;
  dynamic _topBid;
  dynamic _listingDate;
  bool? _isPresale;
  dynamic _transferFeePaymentToken;
  dynamic _transferFee;
  String? _tokenId;
Assets copyWith({  int? id,
  int? numSales,
  dynamic backgroundColor,
  String? imageUrl,
  String? imagePreviewUrl,
  String? imageThumbnailUrl,
  String? imageOriginalUrl,
  dynamic animationUrl,
  dynamic animationOriginalUrl,
  String? name,
  String? description,
  String? externalLink,
  AssetContract? assetContract,
  String? permalink,
  Collection? collection,
  dynamic decimals,
  String? tokenMetadata,
  bool? isNsfw,
  Owner? owner,
  dynamic sellOrders,
  dynamic seaportSellOrders,
  Creator? creator,
  List<Traits>? traits,
  dynamic lastSale,
  dynamic topBid,
  dynamic listingDate,
  bool? isPresale,
  dynamic transferFeePaymentToken,
  dynamic transferFee,
  String? tokenId,
}) => Assets(  id: id ?? _id,
  numSales: numSales ?? _numSales,
  backgroundColor: backgroundColor ?? _backgroundColor,
  imageUrl: imageUrl ?? _imageUrl,
  imagePreviewUrl: imagePreviewUrl ?? _imagePreviewUrl,
  imageThumbnailUrl: imageThumbnailUrl ?? _imageThumbnailUrl,
  imageOriginalUrl: imageOriginalUrl ?? _imageOriginalUrl,
  animationUrl: animationUrl ?? _animationUrl,
  animationOriginalUrl: animationOriginalUrl ?? _animationOriginalUrl,
  name: name ?? _name,
  description: description ?? _description,
  externalLink: externalLink ?? _externalLink,
  assetContract: assetContract ?? _assetContract,
  permalink: permalink ?? _permalink,
  collection: collection ?? _collection,
  decimals: decimals ?? _decimals,
  tokenMetadata: tokenMetadata ?? _tokenMetadata,
  isNsfw: isNsfw ?? _isNsfw,
  owner: owner ?? _owner,
  sellOrders: sellOrders ?? _sellOrders,
  seaportSellOrders: seaportSellOrders ?? _seaportSellOrders,
  creator: creator ?? _creator,
  traits: traits ?? _traits,
  lastSale: lastSale ?? _lastSale,
  topBid: topBid ?? _topBid,
  listingDate: listingDate ?? _listingDate,
  isPresale: isPresale ?? _isPresale,
  transferFeePaymentToken: transferFeePaymentToken ?? _transferFeePaymentToken,
  transferFee: transferFee ?? _transferFee,
  tokenId: tokenId ?? _tokenId,
);
  dynamic get id => _id;
  dynamic get numSales => _numSales;
  dynamic get backgroundColor => _backgroundColor;
  String? get imageUrl => _imageUrl;
  String? get imagePreviewUrl => _imagePreviewUrl;
  String? get imageThumbnailUrl => _imageThumbnailUrl;
  String? get imageOriginalUrl => _imageOriginalUrl;
  dynamic get animationUrl => _animationUrl;
  dynamic get animationOriginalUrl => _animationOriginalUrl;
  String? get name => _name;
  String? get description => _description;
  String? get externalLink => _externalLink;
  AssetContract? get assetContract => _assetContract;
  String? get permalink => _permalink;
  Collection? get collection => _collection;
  dynamic get decimals => _decimals;
  String? get tokenMetadata => _tokenMetadata;
  bool? get isNsfw => _isNsfw;
  Owner? get owner => _owner;
  dynamic get sellOrders => _sellOrders;
  dynamic get seaportSellOrders => _seaportSellOrders;
  Creator? get creator => _creator;
  List<Traits>? get traits => _traits;
  dynamic get lastSale => _lastSale;
  dynamic get topBid => _topBid;
  dynamic get listingDate => _listingDate;
  bool? get isPresale => _isPresale;
  dynamic get transferFeePaymentToken => _transferFeePaymentToken;
  dynamic get transferFee => _transferFee;
  String? get tokenId => _tokenId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['num_sales'] = _numSales;
    map['background_color'] = _backgroundColor;
    map['image_url'] = _imageUrl;
    map['image_preview_url'] = _imagePreviewUrl;
    map['image_thumbnail_url'] = _imageThumbnailUrl;
    map['image_original_url'] = _imageOriginalUrl;
    map['animation_url'] = _animationUrl;
    map['animation_original_url'] = _animationOriginalUrl;
    map['name'] = _name;
    map['description'] = _description;
    map['external_link'] = _externalLink;
    if (_assetContract != null) {
      map['asset_contract'] = _assetContract?.toJson();
    }
    map['permalink'] = _permalink;
    if (_collection != null) {
      map['collection'] = _collection?.toJson();
    }
    map['decimals'] = _decimals;
    map['token_metadata'] = _tokenMetadata;
    map['is_nsfw'] = _isNsfw;
    if (_owner != null) {
      map['owner'] = _owner?.toJson();
    }
    map['sell_orders'] = _sellOrders;
    map['seaport_sell_orders'] = _seaportSellOrders;
    if (_creator != null) {
      map['creator'] = _creator?.toJson();
    }
    if (_traits != null) {
      map['traits'] = _traits?.map((v) => v.toJson()).toList();
    }
    map['last_sale'] = _lastSale;
    map['top_bid'] = _topBid;
    map['listing_date'] = _listingDate;
    map['is_presale'] = _isPresale;
    map['transfer_fee_payment_token'] = _transferFeePaymentToken;
    map['transfer_fee'] = _transferFee;
    map['token_id'] = _tokenId;
    return map;
  }

}

/// trait_type : "Clothing"
/// value : "Flower Power Ringer Tee"
/// display_type : null
/// max_value : null
/// trait_count : 6
/// order : null

class Traits {
  Traits({
      String? traitType,
      dynamic value,
      dynamic displayType,
      dynamic maxValue,
      int? traitCount,
      dynamic order,
  }){
    _traitType = traitType;
    _value = value;
    _displayType = displayType;
    _maxValue = maxValue;
    _traitCount = traitCount;
    _order = order;
}

  Traits.fromJson(dynamic json) {
    _traitType = json['trait_type'];
    _value = json['value'];
    _displayType = json['display_type'];
    _maxValue = json['max_value'];
    _traitCount = json['trait_count'];
    _order = json['order'];
  }
  String? _traitType;
  dynamic _value;
  dynamic _displayType;
  dynamic _maxValue;
  int? _traitCount;
  dynamic _order;
Traits copyWith({  String? traitType,
  dynamic value,
  dynamic displayType,
  dynamic maxValue,
  int? traitCount,
  dynamic order,
}) => Traits(  traitType: traitType ?? _traitType,
  value: value ?? _value,
  displayType: displayType ?? _displayType,
  maxValue: maxValue ?? _maxValue,
  traitCount: traitCount ?? _traitCount,
  order: order ?? _order,
);
  String? get traitType => _traitType;
  dynamic get value => _value;
  dynamic get displayType => _displayType;
  dynamic get maxValue => _maxValue;
  dynamic get traitCount => _traitCount;
  dynamic get order => _order;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['trait_type'] = _traitType;
    map['value'] = _value;
    map['display_type'] = _displayType;
    map['max_value'] = _maxValue;
    map['trait_count'] = _traitCount;
    map['order'] = _order;
    return map;
  }

}

/// user : {"username":null}
/// profile_img_url : "https://storage.googleapis.com/opensea-static/opensea-profile/24.png"
/// address : "0x8b2bf4918d23eed65764b3f47e3a0c61999ef3c4"
/// config : ""

class Creator {
  Creator({
      User? user, 
      String? profileImgUrl, 
      String? address, 
      String? config,}){
    _user = user;
    _profileImgUrl = profileImgUrl;
    _address = address;
    _config = config;
}

  Creator.fromJson(dynamic json) {
    _user = json['user'] != null ? User.fromJson(json['user']) : null;
    _profileImgUrl = json['profile_img_url'];
    _address = json['address'];
    _config = json['config'];
  }
  User? _user;
  String? _profileImgUrl;
  String? _address;
  String? _config;
Creator copyWith({  User? user,
  String? profileImgUrl,
  String? address,
  String? config,
}) => Creator(  user: user ?? _user,
  profileImgUrl: profileImgUrl ?? _profileImgUrl,
  address: address ?? _address,
  config: config ?? _config,
);
  User? get user => _user;
  String? get profileImgUrl => _profileImgUrl;
  String? get address => _address;
  String? get config => _config;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_user != null) {
      map['user'] = _user?.toJson();
    }
    map['profile_img_url'] = _profileImgUrl;
    map['address'] = _address;
    map['config'] = _config;
    return map;
  }

}

/// username : null

class User {
  User({
      dynamic username,}){
    _username = username;
}

  User.fromJson(dynamic json) {
    _username = json['username'];
  }
  dynamic _username;
User copyWith({  dynamic username,
}) => User(  username: username ?? _username,
);
  dynamic get username => _username;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['username'] = _username;
    return map;
  }

}

/// user : {"username":"NullAddress"}
/// profile_img_url : "https://storage.googleapis.com/opensea-static/opensea-profile/1.png"
/// address : "0x0000000000000000000000000000000000000000"
/// config : ""

class Owner {
  Owner({
      User? user,
      String? profileImgUrl, 
      String? address, 
      String? config,}){
    _user = user;
    _profileImgUrl = profileImgUrl;
    _address = address;
    _config = config;
}

  Owner.fromJson(dynamic json) {
    _user = json['user'] != null ? User.fromJson(json['user']) : null;
    _profileImgUrl = json['profile_img_url'];
    _address = json['address'];
    _config = json['config'];
  }
  User? _user;
  String? _profileImgUrl;
  String? _address;
  String? _config;
Owner copyWith({  User? user,
  String? profileImgUrl,
  String? address,
  String? config,
}) => Owner(  user: user ?? _user,
  profileImgUrl: profileImgUrl ?? _profileImgUrl,
  address: address ?? _address,
  config: config ?? _config,
);
  User? get user => _user;
  String? get profileImgUrl => _profileImgUrl;
  String? get address => _address;
  String? get config => _config;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_user != null) {
      map['user'] = _user?.toJson();
    }
    map['profile_img_url'] = _profileImgUrl;
    map['address'] = _address;
    map['config'] = _config;
    return map;
  }

}

/// username : "NullAddress"

// class User {
//   User({
//       String? username,}){
//     _username = username;
// }
//
//   User.fromJson(dynamic json) {
//     _username = json['username'];
//   }
//   String? _username;
// User copyWith({  String? username,
// }) => User(  username: username ?? _username,
// );
//   String? get username => _username;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['username'] = _username;
//     return map;
//   }
//
// }

/// banner_image_url : "https://lh3.googleusercontent.com/y0tXbBKPplhOq9gQOFs6ptzcgMiCUY7HwUI-f_QI5GJMYk8UUlXyEdqsKEqUi0DAWpVJirQyP2ATa00Fdi-TGD7n15bfd1zMgLH24rQ=s2500"
/// chat_url : null
/// created_date : "2022-05-29T02:40:37.770485"
/// default_to_fiat : false
/// description : "[Beeing](https://thebeeings.link) yourself matters most, explore your creative side with us. You are a creative beeing, destined to create.\n\nPre-minted items are tradable after reclaiming.\n\nVisit [Website](https://thebeeings.link) and get tradable Beeings."
/// dev_buyer_fee_basis_points : "0"
/// dev_seller_fee_basis_points : "0"
/// discord_url : null
/// display_data : {"card_display_style":"contain"}
/// external_url : "https://thebeeings.link"
/// featured : false
/// featured_image_url : "https://lh3.googleusercontent.com/IhmXfkvD4svwTzGzaFrd1jW-KUJ2PrUysLzQ6f7bQk4BrP_cdVog5TcycQfyoFkeBzSBvmNWzIo9ZMStFo8rneBgNTgemq6dQPMv4w=s300"
/// hidden : false
/// safelist_request_status : "not_requested"
/// image_url : "https://lh3.googleusercontent.com/IhmXfkvD4svwTzGzaFrd1jW-KUJ2PrUysLzQ6f7bQk4BrP_cdVog5TcycQfyoFkeBzSBvmNWzIo9ZMStFo8rneBgNTgemq6dQPMv4w=s120"
/// is_subject_to_whitelist : false
/// large_image_url : "https://lh3.googleusercontent.com/IhmXfkvD4svwTzGzaFrd1jW-KUJ2PrUysLzQ6f7bQk4BrP_cdVog5TcycQfyoFkeBzSBvmNWzIo9ZMStFo8rneBgNTgemq6dQPMv4w=s300"
/// medium_username : null
/// name : "The Beeing Official"
/// only_proxied_transfers : false
/// opensea_buyer_fee_basis_points : "0"
/// opensea_seller_fee_basis_points : "250"
/// payout_address : null
/// require_email : false
/// short_description : null
/// slug : "the-beeing-official"
/// telegram_url : null
/// twitter_username : null
/// instagram_username : null
/// wiki_url : null
/// is_nsfw : false

class Collection {
  Collection({
      String? bannerImageUrl,
      dynamic chatUrl,
      String? createdDate,
      bool? defaultToFiat,
      String? description,
      String? devBuyerFeeBasisPoints,
      String? devSellerFeeBasisPoints,
      dynamic discordUrl,
      DisplayData? displayData,
      String? externalUrl,
      bool? featured,
      String? featuredImageUrl,
      bool? hidden,
      String? safelistRequestStatus,
      String? imageUrl,
      bool? isSubjectToWhitelist,
      String? largeImageUrl,
      dynamic mediumUsername,
      String? name,
      bool? onlyProxiedTransfers,
      String? openseaBuyerFeeBasisPoints,
      String? openseaSellerFeeBasisPoints,
      dynamic payoutAddress,
      bool? requireEmail,
      dynamic shortDescription,
      String? slug,
      dynamic telegramUrl,
      dynamic twitterUsername,
      dynamic instagramUsername,
      dynamic wikiUrl,
      bool? isNsfw,
  }){
    _bannerImageUrl = bannerImageUrl;
    _chatUrl = chatUrl;
    _createdDate = createdDate;
    _defaultToFiat = defaultToFiat;
    _description = description;
    _devBuyerFeeBasisPoints = devBuyerFeeBasisPoints;
    _devSellerFeeBasisPoints = devSellerFeeBasisPoints;
    _discordUrl = discordUrl;
    _displayData = displayData;
    _externalUrl = externalUrl;
    _featured = featured;
    _featuredImageUrl = featuredImageUrl;
    _hidden = hidden;
    _safelistRequestStatus = safelistRequestStatus;
    _imageUrl = imageUrl;
    _isSubjectToWhitelist = isSubjectToWhitelist;
    _largeImageUrl = largeImageUrl;
    _mediumUsername = mediumUsername;
    _name = name;
    _onlyProxiedTransfers = onlyProxiedTransfers;
    _openseaBuyerFeeBasisPoints = openseaBuyerFeeBasisPoints;
    _openseaSellerFeeBasisPoints = openseaSellerFeeBasisPoints;
    _payoutAddress = payoutAddress;
    _requireEmail = requireEmail;
    _shortDescription = shortDescription;
    _slug = slug;
    _telegramUrl = telegramUrl;
    _twitterUsername = twitterUsername;
    _instagramUsername = instagramUsername;
    _wikiUrl = wikiUrl;
    _isNsfw = isNsfw;
}

  Collection.fromJson(dynamic json) {
    _bannerImageUrl = json['banner_image_url'];
    _chatUrl = json['chat_url'];
    _createdDate = json['created_date'];
    _defaultToFiat = json['default_to_fiat'];
    _description = json['description'];
    _devBuyerFeeBasisPoints = json['dev_buyer_fee_basis_points'];
    _devSellerFeeBasisPoints = json['dev_seller_fee_basis_points'];
    _discordUrl = json['discord_url'];
    _displayData = json['display_data'] != null ? DisplayData.fromJson(json['display_data']) : null;
    _externalUrl = json['external_url'];
    _featured = json['featured'];
    _featuredImageUrl = json['featured_image_url'];
    _hidden = json['hidden'];
    _safelistRequestStatus = json['safelist_request_status'];
    _imageUrl = json['image_url'];
    _isSubjectToWhitelist = json['is_subject_to_whitelist'];
    _largeImageUrl = json['large_image_url'];
    _mediumUsername = json['medium_username'];
    _name = json['name'];
    _onlyProxiedTransfers = json['only_proxied_transfers'];
    _openseaBuyerFeeBasisPoints = json['opensea_buyer_fee_basis_points'];
    _openseaSellerFeeBasisPoints = json['opensea_seller_fee_basis_points'];
    _payoutAddress = json['payout_address'];
    _requireEmail = json['require_email'];
    _shortDescription = json['short_description'];
    _slug = json['slug'];
    _telegramUrl = json['telegram_url'];
    _twitterUsername = json['twitter_username'];
    _instagramUsername = json['instagram_username'];
    _wikiUrl = json['wiki_url'];
    _isNsfw = json['is_nsfw'];
  }
  String? _bannerImageUrl;
  dynamic _chatUrl;
  String? _createdDate;
  bool? _defaultToFiat;
  String? _description;
  String? _devBuyerFeeBasisPoints;
  String? _devSellerFeeBasisPoints;
  dynamic _discordUrl;
  DisplayData? _displayData;
  String? _externalUrl;
  bool? _featured;
  String? _featuredImageUrl;
  bool? _hidden;
  String? _safelistRequestStatus;
  String? _imageUrl;
  bool? _isSubjectToWhitelist;
  String? _largeImageUrl;
  dynamic _mediumUsername;
  String? _name;
  bool? _onlyProxiedTransfers;
  String? _openseaBuyerFeeBasisPoints;
  String? _openseaSellerFeeBasisPoints;
  dynamic _payoutAddress;
  bool? _requireEmail;
  dynamic _shortDescription;
  String? _slug;
  dynamic _telegramUrl;
  dynamic _twitterUsername;
  dynamic _instagramUsername;
  dynamic _wikiUrl;
  bool? _isNsfw;
Collection copyWith({  String? bannerImageUrl,
  dynamic chatUrl,
  String? createdDate,
  bool? defaultToFiat,
  String? description,
  String? devBuyerFeeBasisPoints,
  String? devSellerFeeBasisPoints,
  dynamic discordUrl,
  DisplayData? displayData,
  String? externalUrl,
  bool? featured,
  String? featuredImageUrl,
  bool? hidden,
  String? safelistRequestStatus,
  String? imageUrl,
  bool? isSubjectToWhitelist,
  String? largeImageUrl,
  dynamic mediumUsername,
  String? name,
  bool? onlyProxiedTransfers,
  String? openseaBuyerFeeBasisPoints,
  String? openseaSellerFeeBasisPoints,
  dynamic payoutAddress,
  bool? requireEmail,
  dynamic shortDescription,
  String? slug,
  dynamic telegramUrl,
  dynamic twitterUsername,
  dynamic instagramUsername,
  dynamic wikiUrl,
  bool? isNsfw,
}) => Collection(  bannerImageUrl: bannerImageUrl ?? _bannerImageUrl,
  chatUrl: chatUrl ?? _chatUrl,
  createdDate: createdDate ?? _createdDate,
  defaultToFiat: defaultToFiat ?? _defaultToFiat,
  description: description ?? _description,
  devBuyerFeeBasisPoints: devBuyerFeeBasisPoints ?? _devBuyerFeeBasisPoints,
  devSellerFeeBasisPoints: devSellerFeeBasisPoints ?? _devSellerFeeBasisPoints,
  discordUrl: discordUrl ?? _discordUrl,
  displayData: displayData ?? _displayData,
  externalUrl: externalUrl ?? _externalUrl,
  featured: featured ?? _featured,
  featuredImageUrl: featuredImageUrl ?? _featuredImageUrl,
  hidden: hidden ?? _hidden,
  safelistRequestStatus: safelistRequestStatus ?? _safelistRequestStatus,
  imageUrl: imageUrl ?? _imageUrl,
  isSubjectToWhitelist: isSubjectToWhitelist ?? _isSubjectToWhitelist,
  largeImageUrl: largeImageUrl ?? _largeImageUrl,
  mediumUsername: mediumUsername ?? _mediumUsername,
  name: name ?? _name,
  onlyProxiedTransfers: onlyProxiedTransfers ?? _onlyProxiedTransfers,
  openseaBuyerFeeBasisPoints: openseaBuyerFeeBasisPoints ?? _openseaBuyerFeeBasisPoints,
  openseaSellerFeeBasisPoints: openseaSellerFeeBasisPoints ?? _openseaSellerFeeBasisPoints,
  payoutAddress: payoutAddress ?? _payoutAddress,
  requireEmail: requireEmail ?? _requireEmail,
  shortDescription: shortDescription ?? _shortDescription,
  slug: slug ?? _slug,
  telegramUrl: telegramUrl ?? _telegramUrl,
  twitterUsername: twitterUsername ?? _twitterUsername,
  instagramUsername: instagramUsername ?? _instagramUsername,
  wikiUrl: wikiUrl ?? _wikiUrl,
  isNsfw: isNsfw ?? _isNsfw,
);
  String? get bannerImageUrl => _bannerImageUrl;
  dynamic get chatUrl => _chatUrl;
  String? get createdDate => _createdDate;
  bool? get defaultToFiat => _defaultToFiat;
  String? get description => _description;
  String? get devBuyerFeeBasisPoints => _devBuyerFeeBasisPoints;
  String? get devSellerFeeBasisPoints => _devSellerFeeBasisPoints;
  dynamic get discordUrl => _discordUrl;
  DisplayData? get displayData => _displayData;
  String? get externalUrl => _externalUrl;
  bool? get featured => _featured;
  String? get featuredImageUrl => _featuredImageUrl;
  bool? get hidden => _hidden;
  String? get safelistRequestStatus => _safelistRequestStatus;
  String? get imageUrl => _imageUrl;
  bool? get isSubjectToWhitelist => _isSubjectToWhitelist;
  String? get largeImageUrl => _largeImageUrl;
  dynamic get mediumUsername => _mediumUsername;
  String? get name => _name;
  bool? get onlyProxiedTransfers => _onlyProxiedTransfers;
  String? get openseaBuyerFeeBasisPoints => _openseaBuyerFeeBasisPoints;
  String? get openseaSellerFeeBasisPoints => _openseaSellerFeeBasisPoints;
  dynamic get payoutAddress => _payoutAddress;
  bool? get requireEmail => _requireEmail;
  dynamic get shortDescription => _shortDescription;
  String? get slug => _slug;
  dynamic get telegramUrl => _telegramUrl;
  dynamic get twitterUsername => _twitterUsername;
  dynamic get instagramUsername => _instagramUsername;
  dynamic get wikiUrl => _wikiUrl;
  bool? get isNsfw => _isNsfw;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['banner_image_url'] = _bannerImageUrl;
    map['chat_url'] = _chatUrl;
    map['created_date'] = _createdDate;
    map['default_to_fiat'] = _defaultToFiat;
    map['description'] = _description;
    map['dev_buyer_fee_basis_points'] = _devBuyerFeeBasisPoints;
    map['dev_seller_fee_basis_points'] = _devSellerFeeBasisPoints;
    map['discord_url'] = _discordUrl;
    if (_displayData != null) {
      map['display_data'] = _displayData?.toJson();
    }
    map['external_url'] = _externalUrl;
    map['featured'] = _featured;
    map['featured_image_url'] = _featuredImageUrl;
    map['hidden'] = _hidden;
    map['safelist_request_status'] = _safelistRequestStatus;
    map['image_url'] = _imageUrl;
    map['is_subject_to_whitelist'] = _isSubjectToWhitelist;
    map['large_image_url'] = _largeImageUrl;
    map['medium_username'] = _mediumUsername;
    map['name'] = _name;
    map['only_proxied_transfers'] = _onlyProxiedTransfers;
    map['opensea_buyer_fee_basis_points'] = _openseaBuyerFeeBasisPoints;
    map['opensea_seller_fee_basis_points'] = _openseaSellerFeeBasisPoints;
    map['payout_address'] = _payoutAddress;
    map['require_email'] = _requireEmail;
    map['short_description'] = _shortDescription;
    map['slug'] = _slug;
    map['telegram_url'] = _telegramUrl;
    map['twitter_username'] = _twitterUsername;
    map['instagram_username'] = _instagramUsername;
    map['wiki_url'] = _wikiUrl;
    map['is_nsfw'] = _isNsfw;
    return map;
  }

}

/// card_display_style : "contain"

class DisplayData {
  DisplayData({
      String? cardDisplayStyle,}){
    _cardDisplayStyle = cardDisplayStyle;
}

  DisplayData.fromJson(dynamic json) {
    _cardDisplayStyle = json['card_display_style'];
  }
  String? _cardDisplayStyle;
DisplayData copyWith({  String? cardDisplayStyle,
}) => DisplayData(  cardDisplayStyle: cardDisplayStyle ?? _cardDisplayStyle,
);
  String? get cardDisplayStyle => _cardDisplayStyle;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['card_display_style'] = _cardDisplayStyle;
    return map;
  }

}

/// address : "0x3b36c3882f6f9960cbed67d9a2ea48bb7f8506ab"
/// asset_contract_type : "semi-fungible"
/// created_date : "2022-05-29T02:08:09.925893"
/// name : "Unidentified contract"
/// nft_version : null
/// opensea_version : null
/// owner : null
/// schema_name : "ERC1155"
/// symbol : ""
/// total_supply : null
/// description : "[Beeing](https://thebeeings.link) yourself matters most, explore your creative side with us. You are a creative beeing, destined to create.\n\nPre-minted items are tradable after reclaiming.\n\nVisit [Website](https://thebeeings.link) and get tradable Beeings."
/// external_link : "https://thebeeings.link"
/// image_url : "https://lh3.googleusercontent.com/IhmXfkvD4svwTzGzaFrd1jW-KUJ2PrUysLzQ6f7bQk4BrP_cdVog5TcycQfyoFkeBzSBvmNWzIo9ZMStFo8rneBgNTgemq6dQPMv4w=s120"
/// default_to_fiat : false
/// dev_buyer_fee_basis_points : 0
/// dev_seller_fee_basis_points : 0
/// only_proxied_transfers : false
/// opensea_buyer_fee_basis_points : 0
/// opensea_seller_fee_basis_points : 250
/// buyer_fee_basis_points : 0
/// seller_fee_basis_points : 250
/// payout_address : null

class AssetContract {
  AssetContract({
      String? address, 
      String? assetContractType, 
      String? createdDate, 
      String? name, 
      dynamic nftVersion, 
      dynamic openseaVersion, 
      dynamic owner, 
      String? schemaName, 
      String? symbol, 
      dynamic totalSupply, 
      String? description, 
      String? externalLink, 
      String? imageUrl, 
      bool? defaultToFiat, 
      int? devBuyerFeeBasisPoints, 
      int? devSellerFeeBasisPoints, 
      bool? onlyProxiedTransfers, 
      int? openseaBuyerFeeBasisPoints, 
      int? openseaSellerFeeBasisPoints, 
      int? buyerFeeBasisPoints, 
      int? sellerFeeBasisPoints, 
      dynamic payoutAddress,}){
    _address = address;
    _assetContractType = assetContractType;
    _createdDate = createdDate;
    _name = name;
    _nftVersion = nftVersion;
    _openseaVersion = openseaVersion;
    _owner = owner;
    _schemaName = schemaName;
    _symbol = symbol;
    _totalSupply = totalSupply;
    _description = description;
    _externalLink = externalLink;
    _imageUrl = imageUrl;
    _defaultToFiat = defaultToFiat;
    _devBuyerFeeBasisPoints = devBuyerFeeBasisPoints;
    _devSellerFeeBasisPoints = devSellerFeeBasisPoints;
    _onlyProxiedTransfers = onlyProxiedTransfers;
    _openseaBuyerFeeBasisPoints = openseaBuyerFeeBasisPoints;
    _openseaSellerFeeBasisPoints = openseaSellerFeeBasisPoints;
    _buyerFeeBasisPoints = buyerFeeBasisPoints;
    _sellerFeeBasisPoints = sellerFeeBasisPoints;
    _payoutAddress = payoutAddress;
}

  AssetContract.fromJson(dynamic json) {
    _address = json['address'];
    _assetContractType = json['asset_contract_type'];
    _createdDate = json['created_date'];
    _name = json['name'];
    _nftVersion = json['nft_version'];
    _openseaVersion = json['opensea_version'];
    _owner = json['owner'];
    _schemaName = json['schema_name'];
    _symbol = json['symbol'];
    _totalSupply = json['total_supply'];
    _description = json['description'];
    _externalLink = json['external_link'];
    _imageUrl = json['image_url'];
    _defaultToFiat = json['default_to_fiat'];
    _devBuyerFeeBasisPoints = json['dev_buyer_fee_basis_points'];
    _devSellerFeeBasisPoints = json['dev_seller_fee_basis_points'];
    _onlyProxiedTransfers = json['only_proxied_transfers'];
    _openseaBuyerFeeBasisPoints = json['opensea_buyer_fee_basis_points'];
    _openseaSellerFeeBasisPoints = json['opensea_seller_fee_basis_points'];
    _buyerFeeBasisPoints = json['buyer_fee_basis_points'];
    _sellerFeeBasisPoints = json['seller_fee_basis_points'];
    _payoutAddress = json['payout_address'];
  }
  String? _address;
  String? _assetContractType;
  String? _createdDate;
  String? _name;
  dynamic _nftVersion;
  dynamic _openseaVersion;
  dynamic _owner;
  String? _schemaName;
  String? _symbol;
  dynamic _totalSupply;
  String? _description;
  String? _externalLink;
  String? _imageUrl;
  bool? _defaultToFiat;
  int? _devBuyerFeeBasisPoints;
  int? _devSellerFeeBasisPoints;
  bool? _onlyProxiedTransfers;
  int? _openseaBuyerFeeBasisPoints;
  int? _openseaSellerFeeBasisPoints;
  int? _buyerFeeBasisPoints;
  int? _sellerFeeBasisPoints;
  dynamic _payoutAddress;
AssetContract copyWith({  String? address,
  String? assetContractType,
  String? createdDate,
  String? name,
  dynamic nftVersion,
  dynamic openseaVersion,
  dynamic owner,
  String? schemaName,
  String? symbol,
  dynamic totalSupply,
  String? description,
  String? externalLink,
  String? imageUrl,
  bool? defaultToFiat,
  int? devBuyerFeeBasisPoints,
  int? devSellerFeeBasisPoints,
  bool? onlyProxiedTransfers,
  int? openseaBuyerFeeBasisPoints,
  int? openseaSellerFeeBasisPoints,
  int? buyerFeeBasisPoints,
  int? sellerFeeBasisPoints,
  dynamic payoutAddress,
}) => AssetContract(  address: address ?? _address,
  assetContractType: assetContractType ?? _assetContractType,
  createdDate: createdDate ?? _createdDate,
  name: name ?? _name,
  nftVersion: nftVersion ?? _nftVersion,
  openseaVersion: openseaVersion ?? _openseaVersion,
  owner: owner ?? _owner,
  schemaName: schemaName ?? _schemaName,
  symbol: symbol ?? _symbol,
  totalSupply: totalSupply ?? _totalSupply,
  description: description ?? _description,
  externalLink: externalLink ?? _externalLink,
  imageUrl: imageUrl ?? _imageUrl,
  defaultToFiat: defaultToFiat ?? _defaultToFiat,
  devBuyerFeeBasisPoints: devBuyerFeeBasisPoints ?? _devBuyerFeeBasisPoints,
  devSellerFeeBasisPoints: devSellerFeeBasisPoints ?? _devSellerFeeBasisPoints,
  onlyProxiedTransfers: onlyProxiedTransfers ?? _onlyProxiedTransfers,
  openseaBuyerFeeBasisPoints: openseaBuyerFeeBasisPoints ?? _openseaBuyerFeeBasisPoints,
  openseaSellerFeeBasisPoints: openseaSellerFeeBasisPoints ?? _openseaSellerFeeBasisPoints,
  buyerFeeBasisPoints: buyerFeeBasisPoints ?? _buyerFeeBasisPoints,
  sellerFeeBasisPoints: sellerFeeBasisPoints ?? _sellerFeeBasisPoints,
  payoutAddress: payoutAddress ?? _payoutAddress,
);
  String? get address => _address;
  String? get assetContractType => _assetContractType;
  String? get createdDate => _createdDate;
  String? get name => _name;
  dynamic get nftVersion => _nftVersion;
  dynamic get openseaVersion => _openseaVersion;
  dynamic get owner => _owner;
  String? get schemaName => _schemaName;
  String? get symbol => _symbol;
  dynamic get totalSupply => _totalSupply;
  String? get description => _description;
  String? get externalLink => _externalLink;
  String? get imageUrl => _imageUrl;
  bool? get defaultToFiat => _defaultToFiat;
  dynamic get devBuyerFeeBasisPoints => _devBuyerFeeBasisPoints;
  dynamic get devSellerFeeBasisPoints => _devSellerFeeBasisPoints;
  bool? get onlyProxiedTransfers => _onlyProxiedTransfers;
  dynamic get openseaBuyerFeeBasisPoints => _openseaBuyerFeeBasisPoints;
  dynamic get openseaSellerFeeBasisPoints => _openseaSellerFeeBasisPoints;
  dynamic get buyerFeeBasisPoints => _buyerFeeBasisPoints;
  dynamic get sellerFeeBasisPoints => _sellerFeeBasisPoints;
  dynamic get payoutAddress => _payoutAddress;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['address'] = _address;
    map['asset_contract_type'] = _assetContractType;
    map['created_date'] = _createdDate;
    map['name'] = _name;
    map['nft_version'] = _nftVersion;
    map['opensea_version'] = _openseaVersion;
    map['owner'] = _owner;
    map['schema_name'] = _schemaName;
    map['symbol'] = _symbol;
    map['total_supply'] = _totalSupply;
    map['description'] = _description;
    map['external_link'] = _externalLink;
    map['image_url'] = _imageUrl;
    map['default_to_fiat'] = _defaultToFiat;
    map['dev_buyer_fee_basis_points'] = _devBuyerFeeBasisPoints;
    map['dev_seller_fee_basis_points'] = _devSellerFeeBasisPoints;
    map['only_proxied_transfers'] = _onlyProxiedTransfers;
    map['opensea_buyer_fee_basis_points'] = _openseaBuyerFeeBasisPoints;
    map['opensea_seller_fee_basis_points'] = _openseaSellerFeeBasisPoints;
    map['buyer_fee_basis_points'] = _buyerFeeBasisPoints;
    map['seller_fee_basis_points'] = _sellerFeeBasisPoints;
    map['payout_address'] = _payoutAddress;
    return map;
  }

}