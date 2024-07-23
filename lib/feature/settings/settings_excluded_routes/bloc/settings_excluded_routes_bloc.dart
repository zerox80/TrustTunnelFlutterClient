import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings_excluded_routes_bloc.freezed.dart';
part 'settings_excluded_routes_event.dart';
part 'settings_excluded_routes_state.dart';

class SettingsExcludedRoutesBloc
    extends Bloc<SettingsExcludedRoutesEvent, SettingsExcludedRoutesState> {
  SettingsExcludedRoutesBloc() : super(const SettingsExcludedRoutesState()) {
    on<_Init>(_init);
    on<_DataChanged>(_dataChanged);
    on<_SaveExcludedRoutes>(_saveExcludedRoutes);
  }

  Future<void> _init(
    _Init event,
    Emitter<SettingsExcludedRoutesState> emit,
  ) async {
    emit(
      // TODO: Implement logic to receive initial data
      state.copyWith(
        loadingStatus: SettingsExcludedRoutesStateLoadingStatus.idle,
      ),
    );
  }

  void _dataChanged(
    _DataChanged event,
    Emitter<SettingsExcludedRoutesState> emit,
  ) =>
      emit(state.copyWith(data: event.excludedRoutes));

  void _saveExcludedRoutes(
    _SaveExcludedRoutes event,
    Emitter<SettingsExcludedRoutesState> emit,
  ) {
    // TODO: Implement logic to update excluded routes
  }
}
