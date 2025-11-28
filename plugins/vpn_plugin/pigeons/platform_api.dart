import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/platform_api.g.dart',
    dartOptions: DartOptions(),
    cppOptions: CppOptions(namespace: 'vpn_plugin'),
    cppHeaderOut: 'windows/runner/platform_api.g.h',
    cppSourceOut: 'windows/runner/platform_api.g.cpp',
    kotlinOut: 'android/src/main/kotlin/com/adguard/trusttunnel/vpn_plugin/PlatformApi.g.kt',
    kotlinOptions: KotlinOptions(
      package: 'com.adguard.trusttunnel.vpn_plugin',
    ),
    swiftOptions: SwiftOptions(),
  ),
)
@HostApi()
abstract class IVpnManager {
  @TaskQueue(type: TaskQueueType.serialBackgroundThread)
  void start({required String config});

  @TaskQueue(type: TaskQueueType.serialBackgroundThread)
  void stop();

  VpnManagerState getCurrentState();
}

enum VpnManagerState {
  disconnected,
  connecting,
  connected,
  waitingForRecovery,
  recovering,
  waitingForNetwork,
}

enum PlatformErrorCode {
  unknown,
}

enum PlatformFieldErrorCode {
  fieldWrongValue,
  alreadyExists,
}

enum PlatformFieldName {
  ipAddress,
  domain,
  serverName,
  dnsServers,
}

class PlatformErrorResponse {
  final PlatformErrorCode? code;
  final List<PlatformFieldError?>? fieldErrors;

  const PlatformErrorResponse({
    this.code,
    this.fieldErrors,
  });
}

class PlatformFieldError {
  final PlatformFieldErrorCode code;
  final PlatformFieldName fieldName;

  const PlatformFieldError({
    required this.code,
    required this.fieldName,
  });
}
