import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:vpn_plugin/platform_api.g.dart';

part 'routing_details_data.freezed.dart';

@freezed
class RoutingDetailsData with _$RoutingDetailsData {
  const RoutingDetailsData._();

  const factory RoutingDetailsData({
    @Default(RoutingMode.vpn) RoutingMode defaultMode,
    @Default(<String>[]) List<String> bypassRules,
    @Default(<String>[]) List<String> vpnRules,
  }) = _RoutingDetailsData;
}
