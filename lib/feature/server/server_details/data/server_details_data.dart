import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:vpn_plugin/platform_api.g.dart';

part 'server_details_data.freezed.dart';

@freezed
class ServerDetailsData with _$ServerDetailsData {
  const ServerDetailsData._();

  const factory ServerDetailsData({
    @Default('') String serverName,
    @Default('') String ipAddress,
    @Default('') String domain,
    @Default('') String username,
    @Default('') String password,
    @Default(VpnProtocol.http2) VpnProtocol protocol,
    RoutingProfile? routingProfile,
    @Default(<String>[]) List<String> dnsServers,
  }) = _ServerDetailsData;
}
