package com.example.vpn_plugin

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.cancel
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch
import java.io.Closeable

/** VpnPlugin */
class VpnPlugin: FlutterPlugin{
  private val eventChannelName = "vpn_plugin_event_channel"
  private lateinit var platformApi: Closeable

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    val platformApi = MockPlatformApi()
    PlatformApi.setUp(flutterPluginBinding.binaryMessenger, platformApi)
    val eventChannel = EventChannel(flutterPluginBinding.binaryMessenger, eventChannelName)
    eventChannel.setStreamHandler(platformApi)
    this.platformApi = platformApi
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    platformApi.close()
  }
}