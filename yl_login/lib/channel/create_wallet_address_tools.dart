
import 'package:flutter/cupertino.dart';

import 'package:bip39/bip39.dart' as bip39;
import 'package:ed25519_hd_key/ed25519_hd_key.dart';
import 'package:bip32/bip32.dart' as bip32;
import "package:hex/hex.dart";
import 'package:web3dart/web3dart.dart';
import 'package:convert/convert.dart';

import 'dart:math';                                     // Random
import 'dart:typed_data';                               // Uint8List
import 'package:web3dart/crypto.dart';

Future<WalletInfo> getWalletAddress() async {
    //随机生成助记词
    String mnemonic = bip39.generateMnemonic();
     // seed = bip39.mnemonicToSeed(mnemonic);
    // List<int> seedBytes = hex.decode(seed);
    KeyData master = await ED25519_HD_KEY.getMasterKeyFromSeed(bip39.mnemonicToSeed(mnemonic));
    //通过助记词生成私钥
    String privateKey = HEX.encode(master.key);
    //通过私钥拿到地址信息
    final private = EthPrivateKey.fromHex(privateKey);
    final address = await private.extractAddress();
    // print("mnemonic : ${mnemonic} address : ${address.toString()}");
    return WalletInfo(mnemonic:mnemonic, address: address.toString());


    // Random rng = Random.secure();                            //安全随机数发生器
    // BigInt privKey = generateNewPrivateKey(rng);             //生成新的私钥
    // Uint8List pubKey = privateKeyToPublic(privKey);          //从私钥推导出公钥
    // print('public Key => ${bytesToHex(pubKey)}');            //显示其16进制字符串表示
    // Uint8List address = publicKeyToAddress(pubKey);          //从公钥推导出地址
    // String addressHex = bytesToHex(
    //   address,                           //地址字节数组
    //   include0x:true,                    //包含0x前缀
    //   forcePadLength:40                  //补齐到40字节
    // );
    // print('address => ${addressHex}');                       //显示地址
    //
    // return WalletInfo(mnemonic:bytesToHex(pubKey), address: addressHex);
}

class WalletInfo{

  final String? mnemonic;
  final String? address;

  WalletInfo({
    required this.mnemonic,
    required this.address,
  });
}
