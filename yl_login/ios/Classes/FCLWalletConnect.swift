//
//  FCLWalletConnect.swift
//  yl_login
//
//  Created by YueLe on 2023/2/16.
//

import Foundation
import FCL_SDK
import FlowSDK
import BloctoSDK
import AuthenticationServices
//@objcMembers
class FCLWalletConnect{
    
   class public func initFlow() {
        do {
            let bloctoWalletProvider = try BloctoWalletProvider(
                bloctoAppIdentifier: "dae54ce2-dbe1-4017-b253-621d3c249f26",
                window: keyWindow,
                network:.mainnet
            )
            let dapperWalletProvider = DapperWalletProvider.default
//            fcl.delegate = self
//            if isProduction {
                try fcl.config
                    .put(.network(.mainnet))
                    .put(.supportedWalletProviders(
                        [
                            bloctoWalletProvider,
//                            dapperWalletProvider,
                        ]
                    ))
//            } else {
//                try fcl.config
//                    .put(.network(.testnet))
//                    .put(.supportedWalletProviders(
//                        [
//                            bloctoWalletProvider,
//                            dapperWalletProvider,
//                        ]
//                    ))
//            }
        } catch {
            debugPrint(error)
        }
    }
    
    class public func authLogin(_ closure: @escaping (String) -> Void){
        /// 1. request account only
        /*
        Task {
            do {
                let address = try await fcl.login()
                self.requestAccountResultLabel.text = address.hexStringWithPrefix
                let hasAccountProof = fcl.currentUser?.accountProof != nil
                self.requestAccountCopyButton.isHidden = false
                self.requestAccountExplorerButton.isHidden = false
                self.accountProofVerifyButton.isHidden = !hasAccountProof
            } catch {
                self.handleRequestAccountError(error)
            }
        }
        */

        /// 2. Authanticate like FCL
        let accountProofData = FCLAccountProofData(
            appId: "0xchat",
            nonce: "75f8587e5bd5f9dcc9909d0dae1f0ac5814458b2ae129620502cb936fde7120b"
        )
        Task {
            do {
                let address = try await fcl.authanticate(accountProofData: accountProofData)
                closure(address.hexStringWithPrefix)
            } catch {
//                self.handleRequestAccountError(error)
                closure("")
                debugPrint(error)
            }
        }
    }
}


let keyWindow : UIWindow? = {
    if #available(iOS 13.0, *) {
        return UIApplication.shared.connectedScenes.filter { $0.activationState == .foregroundActive }
            .compactMap { $0 as? UIWindowScene }.first?.windows
            .filter { $0.isKeyWindow }.first;
    }else {
        return UIApplication.shared.keyWindow!
    }
}()

