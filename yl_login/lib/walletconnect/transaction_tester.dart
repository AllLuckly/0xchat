import 'package:walletconnect_dart/walletconnect_dart.dart';

abstract class TransactionTester {
  TransactionTester({required this.connector});

  final WalletConnect connector;

  Future<String> signTransaction(SessionStatus session);

  Future<String> signTransactions(SessionStatus session);

  Future<String> sign(String message, String address);

  Future<String> personalSign(
      {required String message,
      required String address,
      required String password});

  Future<SessionStatus> connect({OnDisplayUriCallback? onDisplayUri});

  Future<void> disconnect();
}
