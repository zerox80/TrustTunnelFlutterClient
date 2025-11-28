import 'package:vpn/data/model/vpn_request.dart';

abstract class SettingsDataSource {
  Future<List<VpnRequest>> getAllRequests();

  Future<void> setExcludedRoutes(String routes);

  Future<String> getExcludedRoutes();
}
