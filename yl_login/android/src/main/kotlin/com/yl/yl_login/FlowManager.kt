package com.yl.yl_login

import android.app.Activity
import android.content.Context
import android.util.Log
import android.widget.TextView
import android.widget.Toast
import io.outblock.fcl.Fcl
import io.outblock.fcl.FlowEnvironment
import io.outblock.fcl.FlowNetwork
import io.outblock.fcl.config.AppMetadata
import io.outblock.fcl.models.FclResult
import io.outblock.fcl.provider.WalletProvider
import io.outblock.fcl.utils.FclException
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

/**
 * Title: FlowManager
 * Description: TODO(自填)
 * Copyright: Copyright (c) 2020
 * Company:  zsdk Teachnology
 * CreateTime: 2023/2/15 18:38
 *
 * @author George
 * @CheckItem 自己填写
 * @since JDK1.8
 */
class FlowManager {

    companion object {
        private var fInstance: FlowManager? = null

        @Synchronized
        fun getInstance(): FlowManager? {
            if (fInstance == null) {
                fInstance = FlowManager()
            }
            return fInstance
        }
    }

    var fContext: Context? = null

    fun initFlow() {
        val fEnvironment = FlowEnvironment(
            network = FlowNetwork.MAINNET,
            addressRegistry = listOf(
                Pair("0xFungibleToken", "0xf233dcee88fe0abe"),
                Pair("0xFUSD", "0x3c5959b568896393")
            )
        )

        val fAppMetadata = AppMetadata(
            appName = "0xchat",
            appIcon = "https://developer-dashboard-prod-logo.blocto.app/20230214T101046973Z026292.png",
            location = "https://www.0xchat.com",
            appId = "0xchat",
            nonce = "75f8587e5bd5f9dcc9909d0dae1f0ac5814458b2ae129620502cb936fde7120a"
        )
        Fcl.config(
            appMetadata = fAppMetadata,
            env = fEnvironment,
        )
    }

    fun authLogin(authLoginListener: AuthLoginListener) {
        val provider = Fcl.providers.get(WalletProvider.BLOCTO)
        CoroutineScope(Dispatchers.IO).launch {
            when (val result = Fcl.authenticate(provider)) {
                is FclResult.Success -> CoroutineScope(Dispatchers.Main).launch {
                    var address = result.value.data?.address;
                    authLoginListener.onResult(address);
                }
                is FclResult.Failure -> {
                    if (fContext != null) {
                        result.toast(fContext!!)
                    }
                }
            }
        }
        authLoginListener.onResult(null);
    }

    fun FclResult.Failure.toast(context: Context) {
        CoroutineScope(Dispatchers.Main).launch {
            val message = (throwable as? FclException)?.error?.toString() ?: throwable.message
            Toast.makeText(context, message, Toast.LENGTH_LONG).show()
        }
    }
}