package com.yl.yl_login

import android.content.Context
import android.content.Intent
import android.net.Uri
import android.util.Log
import android.view.View
import com.squareup.moshi.Moshi
import com.yl.yl_login.server.BridgeServer
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import okhttp3.OkHttpClient
import org.komputing.khex.extensions.toNoPrefixHexString
import org.walletconnect.Session
import org.walletconnect.impls.*
import org.walletconnect.nullOnThrow
import java.io.File
import java.util.*

/**
 * Title: WalletConnectManager
 * Description: TODO(自己填写)
 * Copyright: Copyright (c) 2018
 * Company:  zsdk Teachnology22
 * CreateTime: 2022/3/31 4:44 下午
 *
 * @author Michael
 * @CheckItem 自己填写
 * @since JDK1.8
 */
class WalletConnectManager private constructor() : Session.Callback{
    companion object {
        private var instance: WalletConnectManager? = null
            get(){
                if (field ==null){
                    field = WalletConnectManager()
                }
                return field
            }
        fun get(): WalletConnectManager {
            return instance!!
        }

    }

    var context: Context? = null


    fun initWalletConnectAll(context: Context) {
        this.context = context;
        initMoshi()
        initClient()
        initBridge()
        initSessionStorage()
    }

    private fun initClient() {
        client = OkHttpClient.Builder().build()
    }

    private fun initMoshi() {
        moshi = Moshi.Builder().build()
    }

    private fun initBridge() {
        bridge = BridgeServer(moshi)
        bridge.start()
    }

    private fun initSessionStorage() {
        storage = FileWCSessionStore(File(context?.cacheDir, "session_store.json").apply { createNewFile() }, moshi)
    }

//
//    companion object : Session.Callback {
//
//    }

    private lateinit var client: OkHttpClient
    private lateinit var moshi: Moshi
    private lateinit var bridge: BridgeServer
    private lateinit var storage: WCSessionStore
    lateinit var config: Session.Config
    lateinit var session: Session

    lateinit var mListener : ApprovedAccountListener

    private val uiScope = CoroutineScope(Dispatchers.Main)

    fun resetSession(){
        nullOnThrow { session }?.clearCallbacks()
        val key = ByteArray(32).also { Random().nextBytes(it) }.toNoPrefixHexString()
        config = Session.Config(UUID.randomUUID().toString(), "https://bridge.walletconnect.org" , key);
        session = WCSession(
            config,
            MoshiPayloadAdapter(moshi),
            storage,
            OkHttpTransport.Builder(client, moshi),
            Session.PeerMeta(name = "oxchat")
        )
        session.offer()
    }

    fun openMetaMask(context: Context, scheme: String, listener: ApprovedAccountListener){
        this.mListener = listener;
        resetSession()
        session.addCallback(this)
        val intentGo = Intent(Intent.ACTION_VIEW)
        var wcUri = Uri.parse(scheme +config.toWCUri())
        intentGo.data = wcUri
        context.startActivity(intentGo)
    }

    interface ApprovedAccountListener{
        fun authCalled(result: List<String>?)
    }

    override fun onMethodCall(call: Session.MethodCall) {
        //TODO("Not yet implemented")
    }

    override fun onStatus(status: Session.Status) {
        when(status) {
            Session.Status.Approved -> sessionApproved()
            Session.Status.Closed -> sessionClosed()
            Session.Status.Connected,
            Session.Status.Disconnected,
            is Session.Status.Error -> {
                // Do Stuff
            }
        }
    }

    private fun sessionApproved() {
        uiScope.launch {
            Log.e("Michael", "sessionApproved   approvedAccounts = "+session.approvedAccounts());
            mListener.authCalled(session.approvedAccounts())
            Log.e("Michael", "sessionApproved   peerMeta = "+session.peerMeta());

        }
    }

    private fun sessionClosed() {
        uiScope.launch {
            //TODO something
        }
    }




}