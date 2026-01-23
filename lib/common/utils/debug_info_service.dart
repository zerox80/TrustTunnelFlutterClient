import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:trusttunnel/data/model/vpn_log.dart';
import 'package:trusttunnel/data/model/vpn_state.dart';

/// Service for gathering and formatting debug information.
class DebugInfoService {
  /// Generates a complete debug summary.
  static Future<String> generateSummary({
    required VpnState vpnState,
    required List<VpnLog> logs,
  }) async {
    final packageInfo = await PackageInfo.fromPlatform();
    final deviceInfo = DeviceInfoPlugin();
    
    final StringBuffer summary = StringBuffer();
    
    summary.writeln('--- TrustTunnel Debug Info ---');
    summary.writeln('Time: ${DateTime.now().toUtc().toIso8601String()}');
    
    summary.writeln('\n[App Info]');
    summary.writeln('Version: ${packageInfo.version}');
    summary.writeln('Build Number: ${packageInfo.buildNumber}');
    summary.writeln('Package: ${packageInfo.packageName}');
    
    summary.writeln('\n[Device Info]');
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      summary.writeln('OS: Android ${androidInfo.version.release} (SDK ${androidInfo.version.sdkInt})');
      summary.writeln('Device: ${androidInfo.manufacturer} ${androidInfo.model}');
      summary.writeln('Product: ${androidInfo.product}');
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      summary.writeln('OS: iOS ${iosInfo.systemVersion}');
      summary.writeln('Device: ${iosInfo.model} (${iosInfo.utsname.machine})');
    } else {
      summary.writeln('OS: ${Platform.operatingSystem} ${Platform.operatingSystemVersion}');
    }

    summary.writeln('\n[VPN State]');
    summary.writeln('Status: ${vpnState.name}');
    
    summary.writeln('\n[Recent Logs (Last 50)]');
    final recentLogs = logs.length > 50 ? logs.sublist(logs.length - 50) : logs;
    for (final log in recentLogs.reversed) {
      summary.writeln('${log.timeStamp.toIso8601String()} [${log.action.name.toUpperCase()}] ${log.protocol.name.toUpperCase()} ${log.source} -> ${log.destination}${log.domain != null ? " (${log.domain})" : ""}');
    }
    
    summary.writeln('\n--- End of Debug Info ---');
    
    return summary.toString();
  }

  /// Generates and copies the debug summary to the clipboard.
  static Future<void> copyToClipboard({
    required VpnState vpnState,
    required List<VpnLog> logs,
  }) async {
    final summary = await generateSummary(vpnState: vpnState, logs: logs);
    await Clipboard.setData(ClipboardData(text: summary));
  }
}
