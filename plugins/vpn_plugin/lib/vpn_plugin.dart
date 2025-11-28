// You have generated a new plugin project without specifying the `--platforms`
// flag. A plugin project with no platform support was generated. To add a
// platform, run `flutter create -t plugin --platforms <platforms> .` under the
// same directory. You can also find a detailed instruction on how to add
// platforms in the `pubspec.yaml` at
// https://flutter.dev/docs/development/packages-and-plugins/developing-packages#plugin-platforms.

import 'package:flutter/services.dart';
import 'package:vpn_plugin/domain/configuration_encoder.dart';
import 'package:vpn_plugin/models/configuration.dart';
import 'package:vpn_plugin/platform_api.g.dart';

class VpnPlugin {
  VpnPlugin({EventChannel? channel})
    : _api = IVpnManager(),
      _channel = channel ?? const EventChannel('vpn_plugin_event_channel');

  final IVpnManager _api;
  final EventChannel _channel;

  Future<VpnManagerState> getCurrentState() => _api.getCurrentState();

  Future<void> start({required Configuration configuration}) {
    final config = ConfigurationEncoder().convert(configuration);
    
    return _api.start(config: config);
  }

  Future<void> stop() => _api.stop();

  Stream<VpnManagerState> get states => _channel.receiveBroadcastStream().map(_mapNativeToState).distinct();

  static VpnManagerState _mapNativeToState(dynamic raw) {
    if (raw is int) {
      switch (raw) {
        case 0:
          return VpnManagerState.disconnected;
        case 1:
          return VpnManagerState.connecting;
        case 2:
          return VpnManagerState.connected;
        case 3:
          return VpnManagerState.waitingForRecovery;
        case 4:
          return VpnManagerState.recovering;
        case 5:
          return VpnManagerState.waitingForNetwork;
      }
    }

    return VpnManagerState.disconnected;
  }
}
