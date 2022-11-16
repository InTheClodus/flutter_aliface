package com.ljx.flutter_aliface

import android.app.Activity
import android.content.Context
import android.os.Build
import android.util.Log
import android.widget.Toast
import com.alibaba.fastjson.JSONException
import com.alibaba.fastjson.JSONObject
import com.alipay.face.api.ZIMFacade
import com.alipay.face.api.ZIMFacadeBuilder
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler

/**
 * AliAuthPersonPlugin
 */
class FlutterAlifacePlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private var channel: MethodChannel? = null

    // 上下文 Context
    private var context: Context? = null
    private var mActivity: Activity? = null
    private var eventSink: EventChannel.EventSink? = null

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_aliface")
        channel!!.setMethodCallHandler(this)
        context = flutterPluginBinding.applicationContext
        val eventChannel =
            EventChannel(flutterPluginBinding.binaryMessenger, "ali_auth_person_plugin_event")
        eventChannel.setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(o: Any, eventSink: EventChannel.EventSink) {
                this@FlutterAlifacePlugin.eventSink = eventSink
            }

            override fun onCancel(o: Any) {
                eventSink = null
            }
        })
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        if (call.method == "getPlatformVersion") {
            result.success("Android " + Build.VERSION.RELEASE)
        } else if (call.method == "getMetaInfos") {
            //获取本机参数
            val metaInfo: String = ZIMFacade.getMetaInfos(mActivity)
            result.success(metaInfo)
        } else if (call.method == "verify") {
            //进行实名认证
            val certifyId: String = call.arguments()
            if (certifyId.isEmpty()) {
                Toast.makeText(context, "certifyId 不能为空！", Toast.LENGTH_SHORT).show()
                return
            }
            ZIMFacade.install(mActivity)
            val zimFacade: ZIMFacade = ZIMFacadeBuilder.create(mActivity)
            zimFacade.verify(certifyId, true) { response ->
                if (null != response && 1000 == response.code) {
                    // 认证成功
                    val jsonObject = JSONObject()
                    try {
                        jsonObject.put("code", response.code)
                        jsonObject.put("msg", response.msg)
                        jsonObject.put("deviceToken", response.deviceToken)
                        jsonObject.put("videoFilePath", response.videoFilePath)
                    } catch (e: JSONException) {
                        e.printStackTrace()
                    }
                    result.success(jsonObject.toString())
                } else {
                    result.error(response.code.toString(), response.msg, "认证失败")
                }
                true
            }
        } else {
            result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel!!.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        mActivity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {}
    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {}
    override fun onDetachedFromActivity() {}
}