import 'package:flutter/cupertino.dart';
import 'package:yl_common/log_util.dart';
import 'dart:io';
import 'package:yl_common/network/network_general.dart';
import 'package:yl_common/network/network_utils.dart';
import 'package:yl_common/widgets/common_toast.dart';
import 'package:yl_common/widgets/yl_loading.dart';
import 'package:yl_network/network_manager.dart';
import 'dart:convert';
import 'package:yl_usercenter/model/my_ai_generate_entity.dart';
import 'package:yl_common/sdk_network/sdk_network.dart';

import 'package:yl_usercenter/model/my_generation_ai_steps_entity.dart';

import '../model/my_oxchat_nft_entity.dart';
import '../model/my_product_list_entity.dart';
import 'package:dio/dio.dart';


class ChooseImageUploadNetManage {
  static Future<YLResponse> uploadNftImgFile(File imgFile, String fileServerUrl,
      String userUid, BuildContext context) async {
    List<FileModule> fileList = [];
    String fileName = imgFile.path.substring(imgFile.path.lastIndexOf('/') + 1);
    fileList.add(FileModule(
        fileKey: 'file', filePath: imgFile.path, fileName: fileName));
    return YLNetwork.instance.doUpload(context,
        showLoading: true,
        url: fileServerUrl,
        fileList: fileList,
        params: {
          'user_uid': userUid,
          'file_name': fileName,
        }).then((value) {
      YLResponse response = value;
      return Future.value(response);
    }).catchError((e) {
      YLNetworkError error = e;
      YLResponse response = YLResponse(
          code: error.code, message: error.message, data: error.data);
      return Future.value(response);
    });
  }

  //上传多张
  static Future<YLResponse> uploadNftMultipartFile(
      {required List<File?> imgFileList,
      required String fileServerUrl,
      required String ownerAddress,
      required int gender, //int gender   性别，0：女 1： 男 2：其他（景物或者建筑)
      required int
          paymentType, //int  paymentType   支付类型 0: 苹果支付 1：谷歌支付 2：。。。。。3：。。。。
      required String productId, //购买哪个套餐，0：第一个 1：第二个 2：第三个 3：第四个
      required BuildContext context,
        ProgressCallback? progressCallback
      }) async {
    List<FileModule> fileList = [];
    final baseUrl = await NetworkUtils.getBaseUrl();
    await Future.wait(imgFileList.map((imgFile) async {
      String fileName =
          imgFile?.path.substring(imgFile.path.lastIndexOf('/') + 1) ?? '';
      fileList.add(FileModule(
          fileKey: 'image_file', filePath: imgFile!.path, fileName: fileName));
      // fileList.add(FileModule(fileKey: 'file', filePath: imgFile!.path, fileName: fileName));
    }));
    return YLNetwork.instance.doUpload(context,
        showLoading: false,
        url: '${baseUrl}file/uploadFiles',
        fileList: fileList,
        params: {
          'ownerAddress': ownerAddress,
          'gender': gender,
          'paymentType': paymentType,
          'productId': productId,
        },
      progressCallback:progressCallback
        ).then((value) {
      YLResponse response = value;
      return Future.value(response);
    }).catchError((e) {
      YLNetworkError error = e;
      YLResponse response = YLResponse(
          code: error.code, message: error.message, data: error.data);
      return Future.value(response);
    });
  }

  ///获取ai生成的图片
  static Future<MyAiGenerateEntity?> getAiImages(
      {BuildContext? context, params}) async {
    final map = <String, dynamic>{};
    map['Content-Type'] = 'application/json';
    final baseUrl = await NetworkUtils.getBaseUrl();
    return YLNetwork.instance
        .doRequest(
      context,
      url: '${baseUrl}file/getAiImages',
      showErrorToast: true,
      needCommonParams: false,
      needRSA: false,
      params: params,
      type: RequestType.POST,
      header: map,
    )
        .then((YLResponse response) {
      Map<String, dynamic> dataMap =
          Map<String, dynamic>.from(response.data['data']);
      if (dataMap.isNotEmpty) {
        MyAiGenerateEntity assetsEntity =
            MyAiGenerateEntity.fromJson(Map<String, dynamic>.from(dataMap));
        LogUtil.e(response.data);
        LogUtil.e(json.encode(response.data));
        return assetsEntity;
      }
      return null;
    }).catchError((e) {
      // LogUtil.e("什么鬼？3 ：${e}");
      return null;
    });
  }


    ///创建ai image nft头像
    static Future<bool?> createAiImageNftAvatar  (
      {BuildContext? context, params}) async {
        final map = <String, dynamic>{};
        map['Content-Type'] = 'application/json';
        final baseUrl = await NetworkUtils.getBaseUrl();
        return YLNetwork.instance
          .doRequest(
            context,
            url: '${baseUrl}file/createAiNftAvatar',
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
            Map<String, dynamic> dataMap = json.decode(response.data['data']);
            LogUtil.e('xxx:${dataMap}');
            LogUtil.e('xxx1: ${json.encode(response.data)}');
            if (dataMap.isNotEmpty) {
                return dataMap['result'] as bool;
            }
            return false;
        }).catchError((e) {
            LogUtil.e("什么鬼？3 ：${e}");
            return false;
        });
    }

  //查询生成ai和头像到哪一步了
  //1008-26-20
  ///查询生成ai和头像到哪一步了
  static Future<MyGenerationAiStepsEntity?> getAiGenerationSteps(
      {BuildContext? context,
      required String ownerAddress,
      required String  processId, bool showLoading = true,
      }) async {
    // final map = <String, dynamic>{};
    // map['Content-Type'] = 'application/json';
    return SDKNetwork.post(
      context: context,
      processorId: 1008,
      jobDispatchId: 26,
      actionId: 20,
      params: {
        'ownerAddress': ownerAddress,
        'processId' : processId,
      },
      showLoading: showLoading,
    ).then((result) {
      YLLoading.dismiss();
      SDKResponse response = result;
      LogUtil.e("getAiGenerationSteps responseData :${response.data}");
      Map<String, dynamic> dataMap =
      Map<String, dynamic>.from(response.data);
      if (dataMap.isNotEmpty) {
        MyGenerationAiStepsEntity assetsEntity =
        MyGenerationAiStepsEntity.fromJson(Map<String, dynamic>.from(dataMap));
        LogUtil.e(json.encode(response.data));
        return assetsEntity;
      }
       return null;
    }).catchError((error) {
      SDKNetworkError networkErr = error;
      YLLoading.dismiss();
      CommonToast.instance.show(context, networkErr.message);
      return null;
    });
  }

  //获取价格列表和是否订阅
  //1008-26-21
  ///获取价格列表和是否订阅
  static Future<MyProductListEntity?> getPriceListAndWhetherToSubscribe(
      {BuildContext? context,
        required String ownerAddress,
      }) async {
    // final map = <String, dynamic>{};
    // map['Content-Type'] = 'application/json';
    return SDKNetwork.post(
      context: context,
      processorId: 1008,
      jobDispatchId: 26,
      actionId: 21,
      params: {
        'ownerAddress': ownerAddress,
      },
    ).then((result) {
      YLLoading.dismiss();
      SDKResponse response = result;
      // LogUtil.e("responseData :${response.data}");
      Map<String, dynamic> dataMap =
      Map<String, dynamic>.from(response.data);
      if (dataMap.isNotEmpty) {
        MyProductListEntity assetsEntity =
        MyProductListEntity.fromJson(Map<String, dynamic>.from(dataMap));
        LogUtil.e(json.encode(response.data));
        return assetsEntity;
      }
      return null;
    }).catchError((error) {
      // SDKNetworkError networkErr = error;
      LogUtil.e(error);
      YLLoading.dismiss();

      // CommonToast.instance.show(context, networkErr.message);
      return null;
    });
  }

  ///1008-26-22 查询用户所拥有的oxchat nft
  static Future<List<MyOxchatNftEntity>?> getUserOxchatAllNft(
      {BuildContext? context,
        required String ownerAddress,
        bool showErrorToast = false,
      }) async {
    // final map = <String, dynamic>{};
    // map['Content-Type'] = 'application/json';
    return SDKNetwork.post(
      context: context,
      processorId: 1008,
      jobDispatchId: 26,
      actionId: 22,
      params: {
        'ownerAddress': ownerAddress,
      },
      showErrorToast: showErrorToast,
    ).then((result) {
      YLLoading.dismiss();
      SDKResponse response = result;
      LogUtil.e("getUserOxchatAllNft responseData :${response}");
      LogUtil.e(json.encode(response.data));
      List dataList = List.from(response.data);

      List<MyOxchatNftEntity> nftEntityList = [];
      dataList.forEach((element) {
        MyOxchatNftEntity nftEntity = MyOxchatNftEntity.fromJson(Map<String, dynamic>.from(element));
        nftEntityList.add(nftEntity);
      });
      return nftEntityList;

      return null;
    }).catchError((error) {
      if(showErrorToast) {
        SDKNetworkError networkErr = error;
        YLLoading.dismiss();
        CommonToast.instance.show(context, networkErr.message);
      }
      return null;
    });
  }

  ///1008-26-23
  ///订阅后后端记录
  static Future<bool?> postRecordsAfterSubscription(
    {BuildContext? context,
        required String ownerAddress,
        required String receiptData,
    }) async {
      // final map = <String, dynamic>{};
      // map['Content-Type'] = 'application/json';
      return SDKNetwork.post(
          context: context,
          processorId: 1008,
          jobDispatchId: 26,
          actionId: 23,
          params: {
              'ownerAddress': ownerAddress,
              'receiptData': receiptData,
          },
      ).then((result) {
          YLLoading.dismiss();
          SDKResponse response = result;
          LogUtil.e("postRecordsAfterSubscription responseData :${response}");
          LogUtil.e(json.encode(response.data));

          Map<String, dynamic> dataMap =  Map<String, dynamic>.from(response.data);
          if (dataMap.isNotEmpty) {

              return dataMap['result'] as bool;
          }
          return false;
      }).catchError((error) {
          // SDKNetworkError networkErr = error;
          LogUtil.e(error);
          YLLoading.dismiss();
          // CommonToast.instance.show(context, networkErr.message);
          return false;
      });
  }

}
