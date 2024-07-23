part of 'settings_excluded_routes_bloc.dart';

@freezed
class SettingsExcludedRoutesEvent with _$SettingsExcludedRoutesEvent {
  const factory SettingsExcludedRoutesEvent.init() = _Init;

  const factory SettingsExcludedRoutesEvent.dataChanged({
    required String excludedRoutes,
  }) = _DataChanged;

  const factory SettingsExcludedRoutesEvent.saveExcludedRoutes() =
      _SaveExcludedRoutes;
}
