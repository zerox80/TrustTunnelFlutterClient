part of 'settings_excluded_routes_bloc.dart';

@freezed
sealed class SettingsExcludedRoutesState with _$SettingsExcludedRoutesState {
  const SettingsExcludedRoutesState._();

  const factory SettingsExcludedRoutesState({
    @Default('') String data,
    @Default('') String initialData,
    @Default(SettingsExcludedRoutesStateLoadingStatus.initialLoading)
    SettingsExcludedRoutesStateLoadingStatus loadingStatus,
  }) = _SettingsExcludedRoutesState;

  bool get wasChanged => data != initialData;
}

enum SettingsExcludedRoutesStateLoadingStatus {
  initialLoading,
  loading,
  error,
  idle,
}
