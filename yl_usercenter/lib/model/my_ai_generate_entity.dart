import 'dart:convert';
/// processId : "5a53b165-d810-4c05-a183-1a3964f07f95"
/// imagesPaths : [{"modelName":"Model001","images":["https://www.baidu.com","https://google.com"]},{"modelName":"Model002","images":["https://www.baidu2.com","https://google2.com"]}]

MyAiGenerateEntity myAiGenerateEntityFromJson(String str) => MyAiGenerateEntity.fromJson(json.decode(str));
String myAiGenerateEntityToJson(MyAiGenerateEntity data) => json.encode(data.toJson());
class MyAiGenerateEntity {
  MyAiGenerateEntity({
      String? processId, 
      List<ImagesPaths>? imagesPaths,}){
    _processId = processId;
    _imagesPaths = imagesPaths;
}

  MyAiGenerateEntity.fromJson(dynamic json) {
    _processId = json['processId'];
    if (json['imagesPaths'] != null) {
      _imagesPaths = [];
      json['imagesPaths'].forEach((v) {
        _imagesPaths?.add(ImagesPaths.fromJson(v));
      });
    }
  }
  String? _processId;
  List<ImagesPaths>? _imagesPaths;
MyAiGenerateEntity copyWith({  String? processId,
  List<ImagesPaths>? imagesPaths,
}) => MyAiGenerateEntity(  processId: processId ?? _processId,
  imagesPaths: imagesPaths ?? _imagesPaths,
);
  String? get processId => _processId;
  List<ImagesPaths>? get imagesPaths => _imagesPaths;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['processId'] = _processId;
    if (_imagesPaths != null) {
      map['imagesPaths'] = _imagesPaths?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// modelName : "Model001"
/// images : ["https://www.baidu.com","https://google.com"]

ImagesPaths imagesPathsFromJson(String str) => ImagesPaths.fromJson(json.decode(str));
String imagesPathsToJson(ImagesPaths data) => json.encode(data.toJson());
class ImagesPaths {
  ImagesPaths({
      String? modelName, 
      List<String>? images,}){
    _modelName = modelName;
    _images = images;
}

  ImagesPaths.fromJson(dynamic json) {
    _modelName = json['modelName'];
    _images = json['images'] != null ? json['images'].cast<String>() : [];
  }
  String? _modelName;
  List<String>? _images;
ImagesPaths copyWith({  String? modelName,
  List<String>? images,
}) => ImagesPaths(  modelName: modelName ?? _modelName,
  images: images ?? _images,
);
  String? get modelName => _modelName;
  List<String>? get images => _images;

  set modelName(String? modelName){
    _modelName =modelName;
  }

  set images(List<String>? images){
    _images = images;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['modelName'] = _modelName;
    map['images'] = _images;
    return map;
  }

  @override
  String toString() {
    return 'ImagesPaths{_modelName: $_modelName, _images: $_images}';
  }
}