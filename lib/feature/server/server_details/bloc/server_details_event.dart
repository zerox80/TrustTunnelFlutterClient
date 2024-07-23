part of 'server_details_bloc.dart';

@freezed
class ServerDetailsEvent with _$ServerDetailsEvent {
  const factory ServerDetailsEvent.init() = _Init;

  const factory ServerDetailsEvent.dataChanged({
    String? serverName,
    String? ipAddress,
    String? domain,
    String? username,
    String? password,
    VpnProtocol? protocol,
    // TODO add routingProfile
    // RoutingProfile routingProfile,
    List<String>? dnsServers,
  }) = _DataChanged;

  const factory ServerDetailsEvent.submit() = _Submit;
}
