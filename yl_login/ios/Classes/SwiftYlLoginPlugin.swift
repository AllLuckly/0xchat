import Flutter
import UIKit
//import WalletConnectSwift


@objc public class SwiftYlLoginPlugin: NSObject, FlutterPlugin {
//    public typealias SuccessSelectBlock = (String)->Void
//    public typealias ConnectWalletSuccessSelectBlock = (String)->Void
//    var walletConnect: WalletConnect!
//    @objc public var successSelectBlock:SuccessSelectBlock?
//    @objc public var connectWalletSuccessSelectBlock:ConnectWalletSuccessSelectBlock?
//
//
    
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "yl_login", binaryMessenger: registrar.messenger())
        let instance = SwiftYlLoginPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
//
//    @objc
//    public static func registerOC(with registrar: FlutterPluginRegistrar, channel: FlutterMethodChannel, instance : SwiftYlLoginPlugin) {
//
//        registrar.addMethodCallDelegate(instance, channel: channel)
//    }
//
//
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
//         result("iOS " + UIDevice.current.systemVersion)
        var uriSchema = ""
        let arguments = call.arguments as? NSDictionary
        switch call.method {
          case "checkAvailability":
            uriSchema = (arguments!["uri"] as? String)!
            result(checkAvailability(uri: uriSchema))
            break
          case "launchApp":
            uriSchema = (arguments!["uri"] as? String)!
            launchApp(uri: uriSchema, result: result)
            break
          default:
            break
        }
    }
    public func checkAvailability (uri: String) -> Bool {
      let url = URL(string: uri)
      return UIApplication.shared.canOpenURL(url!)
    }
    
    public func launchApp (uri: String, result: @escaping FlutterResult) {
      let url = URL(string: uri)
      if (checkAvailability(uri: uri)) {
        UIApplication.shared.openURL(url!)
        result(true)
      }
      result(false)
    }
//
//    @objc
//    public func connectWallet(schemaStr : String){
//        let connectionUrl = walletConnect.connect()
//        //      let deepLinkUrl = "imtokenv2://wc?uri=\(connectionUrl)"
//        let deepLinkUrl = schemaStr + "://wc?uri=\(connectionUrl)"
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            if let url = URL(string: deepLinkUrl), UIApplication.shared.canOpenURL(url) {
//                UIApplication.shared.open(url, options: [:], completionHandler: nil)
//            } else {
//                ///打不开的话,直接返回需要生成二维码的字符串;通过flutter字符串判断打开二维码界面
//                self.successSelectBlock?(connectionUrl)
//            }
//        }
//    }
//
//    public override init() {
//        super.init()
//        walletConnect = WalletConnect(delegate: self)
//        walletConnect.reconnectIfNeeded()
//    }
//
//    func onMainThread(_ closure: @escaping () -> Void) {
//        if Thread.isMainThread {
//            closure()
//        } else {
//            DispatchQueue.main.async {
//                closure()
//            }
//        }
//    }
}



extension SwiftYlLoginPlugin: WalletConnectDelegate {
//    func failedToConnect() {
//        onMainThread { [unowned self] in
////            if let handshakeController = self.handshakeController {
////                handshakeController.dismiss(animated: true)
////            }
////            UIAlertController.showFailedToConnect(from: self)
////            delegate.failedToConnect()
//        }
//    }
//
//    func didConnect(_ client: Client,session: Session) {
//        print("session didConnect =====" + session.url.absoluteString + "/=====/" + session.walletInfo!.accounts[0])
//        self.connectWalletSuccessSelectBlock!(session.walletInfo!.accounts[0])
//        onMainThread { [unowned self] in
//            try? client.personal_sign(url: session.url, message: "hello! oxchat", account: session.walletInfo!.accounts[0]) {
//                [weak self] response in
//                if let error = response.error {
//                    print("Error" + error.localizedDescription)
//                    return
//                }
//                do {
//                    let result = try response.result(as: String.self)
//                    self?.successSelectBlock?(result)
//                    print(result)
//                } catch {
//
//                }
//
//            }
//        }
//    }
//
//    func didDisconnect() {
//        onMainThread { [unowned self] in
//
//        }
//    }
}


