import 'dart:typed_data';

import 'package:http/http.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';
import 'package:web3dart/credentials.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/src/crypto/secp256k1.dart';
import 'package:web3dart/web3dart.dart';
import 'package:yl_login/walletconnect/transaction_tester.dart';
import 'package:yl_login/walletconnect/yl_ethereum_walletconnect_provider.dart';

class WalletConnectEthereumCredentials extends CustomTransactionSender {
  WalletConnectEthereumCredentials({required this.provider});

  final YLEthereumWalletConnectProvider provider;

  @override
  Future<EthereumAddress> extractAddress() {
    // TODO: implement extractAddress
    throw UnimplementedError();
  }

  @override
  Future<String> sendTransaction(Transaction transaction) async {
    final hash = await provider.sendTransaction(
      from: transaction.from!.hex,
      to: transaction.to?.hex,
      data: transaction.data,
      gas: transaction.maxGas,
      gasPrice: transaction.gasPrice?.getInWei,
      value: transaction.value?.getInWei,
      nonce: transaction.nonce,
    );

    return hash;
  }

  @override
  Future<MsgSignature> signToSignature(Uint8List payload,
      {int? chainId, bool isEIP1559 = false}) {
    // TODO: implement signToSignature
    throw UnimplementedError();
  }

  @override
  // TODO: implement address
  EthereumAddress get address => throw UnimplementedError();

  @override
  MsgSignature signToEcSignature(Uint8List payload, {int? chainId, bool isEIP1559 = false}) {
    // TODO: implement signToEcSignature
    throw UnimplementedError();
  }
}

class EthereumTransactionTester extends TransactionTester {
  final Web3Client ethereum;
  final YLEthereumWalletConnectProvider provider;

  EthereumTransactionTester._internal({
    required WalletConnect connector,
    required this.ethereum,
    required this.provider,
  }) : super(connector: connector);

  factory EthereumTransactionTester() {
    final ethereum = Web3Client('https://ropsten.infura.io/', Client());

    final connector = WalletConnect(
      bridge: 'https://bridge.walletconnect.org',
      clientMeta: PeerMeta(
        name: 'WalletConnect',
        description: 'WalletConnect Developer App',
        url: 'https://walletconnect.org',
        icons: [
          'https://gblobscdn.gitbook.com/spaces%2F-LJJeCjcLrr53DcT1Ml7%2Favatar.png?alt=media'
        ],
      ),
    );

    final provider = YLEthereumWalletConnectProvider(connector);

    return EthereumTransactionTester._internal(
      connector: connector,
      ethereum: ethereum,
      provider: provider,
    );
  }

  @override
  Future<SessionStatus> connect({OnDisplayUriCallback? onDisplayUri}) async {
    return connector.connect(chainId: 1, onDisplayUri: onDisplayUri);
  }

  @override
  Future<void> disconnect() async {
    await connector.killSession();
  }

  @override
  Future<String> signTransaction(SessionStatus session) async {
    final sender = EthereumAddress.fromHex(session.accounts[0]);

    final transaction = Transaction(
      to: sender,
      from: sender,
      gasPrice: EtherAmount.inWei(BigInt.one),
      maxGas: 100000,
      value: EtherAmount.fromUnitAndValue(EtherUnit.finney, 1),
    );

    final credentials = WalletConnectEthereumCredentials(provider: provider);

    // Sign the transaction
    final txBytes = await ethereum.sendTransaction(credentials, transaction);

    // Kill the session
    connector.killSession();

    return txBytes;
  }

  @override
  Future<String> signTransactions(SessionStatus session) {
    // TODO: implement signTransactions
    throw UnimplementedError();
  }

  @override
  Future<String> sign(String message, String address) async {
    // TODO: implement sign

    // base64Encode(message);
    // print("xxx=====   " + message);
    // message = "486920746865726521";

    // final credentials = WalletConnectEthereumCredentials(provider: provider);
    print('Signature: 1111');
    // final signature = await credentials
    // .signPersonalMessage(ascii.encode('A test message'), chainId: 11);
    // print('Signature: ${base64.encode(signature)}');

    // ascii.encode('A test message').toString()
    // String message1 = await _signMessage(message ?? '');
    final result =
        await provider.sign(message: 'A test message', address: address);
    // final result = await provider.sign(
    //     message: ascii.encode('A test message').toString(), address: address);
    print('Signature: ${result}');
    return result;
  }

  Future<String> personalSign({required String message, required String address, required String password}) async {
    final result = await connector.sendCustomRequest(
      method: 'personal_sign',
      params: [address, message, password],
    );

    return result;
  }
  // Future<String> _signMessage(String data) async {
  //   if (data == null || data.isEmpty) {
  //     return "";
  //   }
  //   Uint8List uint8ListData = hexToBytes(data);
  //   EthPrivateKey ethPrivateKey = EthPrivateKey.fromHex(
  //       'a1bde198def90d8674c201c992eeb4a386459194a1d3bf02f8929b3ce4036159');
  //   Uint8List signedData =
  //       await ethPrivateKey.signPersonalMessage(uint8ListData);
  //
  //   String signedDataHex = bytesToHex(signedData);
  //   return signedDataHex;
  // }
}
