import 'package:flutter/cupertino.dart';
import 'package:yl_common/widgets/common_appbar.dart';

class BackupWalletPage extends StatefulWidget {
  final String walletAddress; //钱包地址
  final String mnemonic; //钱包备份助记词
  const BackupWalletPage({required this.walletAddress, required this.mnemonic});

  @override
  State<BackupWalletPage> createState() => _BackupWalletPageState();
}

class _BackupWalletPageState extends State<BackupWalletPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CommonAppBar(
          // canBack: true,
        ),
      ],
    );
  }
}
