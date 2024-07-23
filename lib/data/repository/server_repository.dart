import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:vpn_plugin/platform_api.g.dart';
import 'package:vpn_plugin/vpn_plugin.dart';

abstract class ServerRepository {
  ValueStream<VpnManagerState?> get vpnManagerStateStream;

  ValueStream<List<Server>?> get serverStream;

  ValueStream<int?> get selectedServerIdStream;

  Future<void> loadServers();

  Future<void> addServer({required AddServerRequest request});

  Future<void> updateServer({required UpdateServerRequest request});

  Future<Server> getServerById({required int id});

  Future<void> connect({required int serverId});

  Future<void> disconnect();

  Future<void> dispose();
}

class ServerRepositoryImpl implements ServerRepository {
  final PlatformApi _platformApi;
  late final StreamSubscription<dynamic> _vpnManagerStateSub;

  ServerRepositoryImpl({
    required PlatformApi platformApi,
  }) : _platformApi = platformApi {
    _init();
  }

  final BehaviorSubject<VpnManagerState?> _vpnManagerStateController = BehaviorSubject.seeded(null);

  final BehaviorSubject<List<Server>?> _serverController = BehaviorSubject.seeded(null);

  final BehaviorSubject<int?> _selectedServerIdController = BehaviorSubject.seeded(null);

  @override
  ValueStream<VpnManagerState?> get vpnManagerStateStream => _vpnManagerStateController.stream;

  @override
  ValueStream<List<Server>?> get serverStream => _serverController.stream;

  @override
  ValueStream<int?> get selectedServerIdStream => _selectedServerIdController.stream;

  void _init() async {
    _vpnManagerStateSub = VpnPlugin.eventChannel.receiveBroadcastStream().listen((event) {
      final state = VpnManagerState.values[event as int];
      _vpnManagerStateController.add(state);
    });

    _selectedServerIdController.add(await _platformApi.getSelectedServerId());
  }

  @override
  Future<void> dispose() async {
    await _vpnManagerStateSub.cancel();
    await _vpnManagerStateController.close();
  }

  @override
  Future<void> loadServers() async {
    final List<Server?> servers = await _platformApi.getAllServers();

    _serverController.add(servers.cast<Server>());
  }

  @override
  Future<void> addServer({required AddServerRequest request}) async {
    final Server server = await _platformApi.addServer(request: request);

    _serverController.add(
      List.of(_serverController.value ?? [])..add(server),
    );
  }

  @override
  Future<void> updateServer({required UpdateServerRequest request}) async {
    final Server server = await _platformApi.updateServer(request: request);

    final List<Server> servers = List.of(_serverController.value!);
    final int index = servers.indexWhere((element) => element.id == server.id);
    if (index == -1) throw Exception('Server not found');
    servers[index] = server;

    _serverController.add(servers);
  }

  @override
  Future<Server> getServerById({required int id}) => _platformApi.getServerById(id: id);

  @override
  Future<void> connect({required int serverId}) async {
    await _platformApi.setSelectedServerId(id: serverId);
    _selectedServerIdController.add(serverId);
    await _platformApi.start();
  }

  @override
  Future<void> disconnect() => _platformApi.stop();
}
