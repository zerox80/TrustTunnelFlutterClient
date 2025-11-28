import 'package:vpn_plugin/models/configuration_log_level.dart';
import 'package:vpn_plugin/models/endpoint.dart';
import 'package:vpn_plugin/models/socks.dart';
import 'package:vpn_plugin/models/tun.dart';
import 'package:vpn_plugin/models/vpn_mode.dart';

final class Configuration {
  final ConfigurationLogLevel logLevel;
  final VpnMode vpnMode;
  
  final Endpoint endpoint;
  final Tun tun;
  final Socks socks;

  final bool killSwitchEnabled;
  final bool postQuantumGroupEnabled;

  Configuration({
    this.logLevel = ConfigurationLogLevel.debug,
    this.killSwitchEnabled = true,
    this.postQuantumGroupEnabled = false,
    required this.vpnMode,
    required this.endpoint,
    required this.tun,
    required this.socks,
  });
}



