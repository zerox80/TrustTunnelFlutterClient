part of 'servers_bloc.dart';

@freezed
class ServersEvent with _$ServersEvent {
  const factory ServersEvent.init() = _Init;

  const factory ServersEvent.dataChanged({
    required List<Server> servers,
    required int? selectedServerId,
    required VpnManagerState vpnManagerState,
  }) = _DataChanged;

  const factory ServersEvent.connectServer({
    required int serverId,
  }) = _ConnectServer;

  const factory ServersEvent.disconnectServer() = _DisconnectServer;
}
