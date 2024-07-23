import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:vpn_plugin/platform_api.g.dart';

part 'routing_bloc.freezed.dart';
part 'routing_event.dart';
part 'routing_state.dart';

class RoutingBloc extends Bloc<RoutingEvent, RoutingState> {
  RoutingBloc() : super(const RoutingState()) {
    on<_Init>(_init);
    on<_SelectProfile>(_selectProfile);
  }

  void _init(
    _Init event,
    Emitter<RoutingState> emit,
  ) {
    // TODO implement routing init
    final defaultRoutingProfile = RoutingProfile(
      id: 0,
      name: 'Default profile',
      defaultMode: RoutingMode.vpn,
      bypassRules: [],
      vpnRules: [],
    );
    emit(
      state.copyWith(
        defaultRoutingProfile: defaultRoutingProfile,
        selectedRoutingProfile: defaultRoutingProfile,
        routingList: List.generate(
          10,
          (i) => RoutingProfile(
            id: i + 1,
            name: 'Profile $i',
            defaultMode: RoutingMode.bypass,
            bypassRules: [],
            vpnRules: [],
          ),
        ),
      ),
    );
  }

  // TODO implement select profile
  void _selectProfile(_SelectProfile event, Emitter<RoutingState> emit) => emit(
        state.copyWith(
          selectedRoutingProfile: event.routingProfile,
        ),
      );
}
