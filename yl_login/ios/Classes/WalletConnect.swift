//
//  Copyright © 2019 Gnosis Ltd. All rights reserved.
//

import Foundation
//import WalletConnectSwift

protocol WalletConnectDelegate {
//    func failedToConnect()
//    func didConnect(_ client: Client,session: Session)
//    func didDisconnect()
}

class WalletConnect {
//    var client: Client!
//    var session: Session!
//    var delegate: WalletConnectDelegate
//
//    let sessionKey = "sessionKey"
//
//    init(delegate: WalletConnectDelegate) {
//        self.delegate = delegate
//    }
//    @objc
//    public func connect() -> String {
//        // gnosis wc bridge: https://safe-walletconnect.gnosis.io/
//        // test bridge with latest protocol version: https://bridge.walletconnect.org
//        let wcUrl =  WCURL(topic: UUID().uuidString,
//                           bridgeURL: URL(string: "https://bridge.walletconnect.org")!,
//                           key: try! randomKey())
//        let clientMeta = Session.ClientMeta(name: "ExampleDApp",
//                                            description: "WalletConnectSwift",
//                                            icons: [],
//                                            url: URL(string: "https://safe.gnosis.io")!)
//        let dAppInfo = Session.DAppInfo(peerId: UUID().uuidString, peerMeta: clientMeta)
//        client = Client(delegate: self, dAppInfo: dAppInfo)
//
//        print("WalletConnect URL: \(wcUrl.absoluteString)")
//
//        try! client.connect(to: wcUrl)
//        return wcUrl.absoluteString
//    }
//
//    func reconnectIfNeeded() {
//        if let oldSessionObject = UserDefaults.standard.object(forKey: sessionKey) as? Data,
//            let session = try? JSONDecoder().decode(Session.self, from: oldSessionObject) {
//            client = Client(delegate: self, dAppInfo: session.dAppInfo)
//            try? client.reconnect(to: session)
//        }
//    }
//
//    // https://developer.apple.com/documentation/security/1399291-secrandomcopybytes
//    private func randomKey() throws -> String {
//        var bytes = [Int8](repeating: 0, count: 32)
//        let status = SecRandomCopyBytes(kSecRandomDefault, bytes.count, &bytes)
//        if status == errSecSuccess {
//            return Data(bytes: bytes, count: 32).toHexString()
//        } else {
//            // we don't care in the example app
//            enum TestError: Error {
//                case unknown
//            }
//            throw TestError.unknown
//        }
//    }
}

//extension WalletConnect: ClientDelegate {
//    func client(_ client: Client, didFailToConnect url: WCURL) {
//        delegate.failedToConnect()
//    }
//
//    func client(_ client: Client, didConnect url: WCURL) {
//        // do nothing
//    }
//
//    func client(_ client: Client, didConnect session: Session) {
//        self.session = session
//        let sessionData = try! JSONEncoder().encode(session)
//        UserDefaults.standard.set(sessionData, forKey: sessionKey)
//        delegate.didConnect(client,session: session)
////        print(session.walletInfo)
//        /*
//         (approved: true, accounts: ["0x87f987E195513266F10d89Abe1948a38f4C76A33"], chainId: 4, peerId: "9B571595-7F52-4816-8B81-5CA29C567784", peerMeta: WalletConnectSwift.Session.ClientMeta(name: "Test Wallet", description: nil, icons: [], url: https://safe.gnosis.io, scheme: nil)))
//         
//         */
//    }
//
//    func client(_ client: Client, didDisconnect session: Session) {
//        UserDefaults.standard.removeObject(forKey: sessionKey)
//        delegate.didDisconnect()
//    }
//
//    func client(_ client: Client, didUpdate session: Session) {
//        // do nothing
//    }
//}
