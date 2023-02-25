import 'dart:convert';

/// generateAiImageFinishFlag : true
/// imagesPaths : [{"images":["/Users/a001/Desktop/mulimages/New_1_9ffd2bc3-f59f-4983-85c9-4dda2204d600.jpeg"],"modelName":"Sport"},{"images":["/Users/a001/Desktop/mulimages/New_2_9ffd2bc3-f59f-4983-85c9-4dda2204d600.jpeg"],"modelName":"avatar"},{"images":["/Users/a001/Desktop/mulimages/New_3_9ffd2bc3-f59f-4983-85c9-4dda2204d600.jpeg"],"modelName":"Anime"}]
/// generateNFTAvatarFinishFlag : true
/// canGenerateNFTAvatarCount : 2
/// nftAvatarList : [{"images":["/Users/a001/Desktop/mulimages/New_1_9ffd2bc3-f59f-4983-85c9-4dda2204d600.jpeg"],"modelName":"Sport"},{"images":["/Users/a001/Desktop/mulimages/New_2_9ffd2bc3-f59f-4983-85c9-4dda2204d600.jpeg"],"modelName":"avatar"},{"images":["/Users/a001/Desktop/mulimages/New_3_9ffd2bc3-f59f-4983-85c9-4dda2204d600.jpeg"],"modelName":"Anime"}]

MyGenerationAiStepsEntity myGenerationAiStepsEntityFromJson(String str) =>
    MyGenerationAiStepsEntity.fromJson(json.decode(str));

String myGenerationAiStepsEntityToJson(MyGenerationAiStepsEntity data) => json.encode(data.toJson());

class MyGenerationAiStepsEntity {
  final bool generateAiImageFinishFlag;
  final List<ImagesPaths>? imagesPaths;
  final bool generateNFTAvatarFinishFlag;
  final num? canGenerateNFTAvatarCount;
  final List<NftAvatarList>? nftAvatarList;

  MyGenerationAiStepsEntity({

    this.generateAiImageFinishFlag = false,
    this.imagesPaths,
    this.generateNFTAvatarFinishFlag = false,
    this.canGenerateNFTAvatarCount = 0,
    this.nftAvatarList,
  });

  factory MyGenerationAiStepsEntity.fromJson(dynamic json) {
    List<ImagesPaths>? forList() {
      if (json['imagesPaths'] != null) {
        List<ImagesPaths> list = [];
        json['imagesPaths'].forEach((v) {
          list.add(ImagesPaths.fromJson(v));
        });
        return list;
      }
      return null;
    }

    List<NftAvatarList>? nftavatarList() {
      if (json['nftAvatarList'] != null) {
        List<NftAvatarList> list = [];
        json['nftAvatarList'].forEach((v) {
          list.add(NftAvatarList.fromJson(v));
        });
        return list;
      }
      return null;
    }
    return MyGenerationAiStepsEntity(
        generateAiImageFinishFlag: json['generateAiImageFinishFlag'] ?? false,
        canGenerateNFTAvatarCount: json['canGenerateNFTAvatarCount'] ?? 0,
        generateNFTAvatarFinishFlag: json['generateNFTAvatarFinishFlag'] ?? false,
        imagesPaths: forList(),
      nftAvatarList: nftavatarList(),
    );
  }


  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['generateAiImageFinishFlag'] = generateAiImageFinishFlag;
    if (imagesPaths != null) {
      map['imagesPaths'] = imagesPaths?.map((v) => v.toJson()).toList();
    }
    map['generateNFTAvatarFinishFlag'] = generateNFTAvatarFinishFlag;
    map['canGenerateNFTAvatarCount'] = canGenerateNFTAvatarCount;
    if (nftAvatarList != null) {
      map['nftAvatarList'] = nftAvatarList?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// images : ["/Users/a001/Desktop/mulimages/New_1_9ffd2bc3-f59f-4983-85c9-4dda2204d600.jpeg"]
/// modelName : "Sport"

NftAvatarList nftAvatarListFromJson(String str) => NftAvatarList.fromJson(json.decode(str));

String nftAvatarListToJson(NftAvatarList data) => json.encode(data.toJson());

class NftAvatarList {
  NftAvatarList({
    List<String>? images,
    String? modelName,
  }) {
    _images = images;
    _modelName = modelName;
  }

  NftAvatarList.fromJson(dynamic json) {
    _images = json['images'] != null ? json['images'].cast<String>() : [];
    _modelName = json['modelName'];
  }

  List<String>? _images;
  String? _modelName;

  NftAvatarList copyWith({
    List<String>? images,
    String? modelName,
  }) =>
      NftAvatarList(
        images: images ?? _images,
        modelName: modelName ?? _modelName,
      );

  List<String>? get images => _images;

  String? get modelName => _modelName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['images'] = _images;
    map['modelName'] = _modelName;
    return map;
  }
}

/// images : ["/Users/a001/Desktop/mulimages/New_1_9ffd2bc3-f59f-4983-85c9-4dda2204d600.jpeg"]
/// modelName : "Sport"

ImagesPaths imagesPathsFromJson(String str) => ImagesPaths.fromJson(json.decode(str));

String imagesPathsToJson(ImagesPaths data) => json.encode(data.toJson());

class ImagesPaths {
  ImagesPaths({
    List<String>? images,
    String? modelName,
  }) {
    _images = images;
    _modelName = modelName;
  }

  ImagesPaths.fromJson(dynamic json) {
    _images = json['images'] != null ? json['images'].cast<String>() : [];
    _modelName = json['modelName'];
  }

  List<String>? _images;
  String? _modelName;

  ImagesPaths copyWith({
    List<String>? images,
    String? modelName,
  }) =>
      ImagesPaths(
        images: images ?? _images,
        modelName: modelName ?? _modelName,
      );

  List<String>? get images => _images;

  String? get modelName => _modelName;

  set modelName(String? modelName){
    _modelName =modelName;
  }

  set images(List<String>? images){
    _images = images;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['images'] = _images;
    map['modelName'] = _modelName;
    return map;
  }
}
