import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:yl_common/widgets/common_appbar.dart';
import 'package:yl_localizable/yl_localizable.dart';

class LoginQrPage extends StatelessWidget {
  final String message;
  LoginQrPage(this.message);
  @override
  Widget build(BuildContext context) {
    print("message =" + message);
    return Scaffold(
      appBar: CommonAppBar(
        title: Localized.text('yl_common.Profile'),
        useLargeTitle: false,
        centerTitle: true,
      ),
      body: builderBody(),
      backgroundColor: Colors.white,
    );
  }

  Widget builderBody() {
    print("message =" + message);
    return Material(
      child: SafeArea(
        top: true,
        bottom: true,
        child: Container(
          child: Column(
            children: <Widget>[
              Expanded(
                child: Center(
                  child: Container(
                    width: 280,
                    height: 280,
                    color: Colors.white,
                    child: QrImage(
                      data: message,
                      version: QrVersions.auto,
                      size: 200.0,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40)
                    .copyWith(bottom: 40),
                child: Text(message),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<ui.Image> _loadOverlayImage() async {
    final completer = Completer<ui.Image>();
    final byteData = await rootBundle.load('assets/images/login_bg.png');
    ui.decodeImageFromList(byteData.buffer.asUint8List(), completer.complete);
    return completer.future;
  }
}
