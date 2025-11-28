import 'dart:async';

import 'package:vpn/data/datasources/settings_datasource.dart';
import 'package:vpn/data/model/vpn_request.dart';

abstract class SettingsRepository {
  Future<List<VpnRequest>> getAllRequests();

  Future<void> setExcludedRoutes(String routes);

  Future<String> getExcludedRoutes();
}

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsDataSource _settingsDataSource;

  SettingsRepositoryImpl({
    required SettingsDataSource settingsDataSource,
  }) : _settingsDataSource = settingsDataSource;

  @override
  Future<List<VpnRequest>> getAllRequests() async {
    final requests = await _settingsDataSource.getAllRequests();

    return requests;
  }

  @override
  Future<String> getExcludedRoutes() => _settingsDataSource.getExcludedRoutes();

  @override
  Future<void> setExcludedRoutes(String routes) => _settingsDataSource.setExcludedRoutes(routes);
}
