import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:vpn/common/error/error_utils.dart';
import 'package:vpn/common/error/model/presentation_error.dart';
import 'package:vpn/common/error/model/presentation_field.dart';
import 'package:vpn/common/error/model/presentation_field_error.dart';
import 'package:vpn/data/repository/server_repository.dart';
import 'package:vpn/feature/server/server_details/data/server_details_data.dart';
import 'package:vpn/feature/server/server_details/domain/server_details_service.dart';
import 'package:vpn_plugin/platform_api.g.dart';

part 'server_details_bloc.freezed.dart';
part 'server_details_event.dart';
part 'server_details_state.dart';

class ServerDetailsBloc extends Bloc<ServerDetailsEvent, ServerDetailsState> {
  final ServerRepository _serverRepository;
  final ServerDetailsService _serverDetailsService;

  ServerDetailsBloc({
    int? serverId,
    required ServerRepository serverRepository,
    required ServerDetailsService serverDetailsService,
  })  : _serverRepository = serverRepository,
        _serverDetailsService = serverDetailsService,
        super(ServerDetailsState(
          serverId: serverId,
        )) {
    on<_Init>(_init);
    on<_DataChanged>(_dataChanged);
    on<_Submit>(_submit);
  }

  Future<void> _init(
    _Init event,
    Emitter<ServerDetailsState> emit,
  ) async {
    if (state.serverId != null) {
      final Server server = await _serverRepository.getServerById(id: state.serverId!);
      final ServerDetailsData initialData = _serverDetailsService.toServerDetailsData(server: server);

      emit(
        state.copyWith(
          data: initialData,
          initialData: initialData,
          loadingStatus: ServerDetailsLoadingStatus.idle,
        ),
      );
    }
  }

  void _dataChanged(
    _DataChanged event,
    Emitter<ServerDetailsState> emit,
  ) {
    final serverName = event.serverName ?? state.data.serverName;
    final ipAddress = event.ipAddress ?? state.data.ipAddress;
    final domain = event.domain ?? state.data.domain;
    final username = event.username ?? state.data.username;
    final password = event.password ?? state.data.password;
    final protocol = event.protocol ?? state.data.protocol;
    final dnsServers = event.dnsServers ?? state.data.dnsServers;

    emit(
      state.copyWith(
        data: state.data.copyWith(
          serverName: serverName,
          ipAddress: ipAddress,
          domain: domain,
          username: username,
          password: password,
          protocol: protocol,
          dnsServers: dnsServers,
        ),
      ),
    );
  }

  Future<void> _submit(
    _Submit event,
    Emitter<ServerDetailsState> emit,
  ) async {
    final List<PresentationField> filedErrors = _serverDetailsService.validateData(data: state.data);

    if (filedErrors.isNotEmpty) {
      emit(state.copyWith(fieldErrors: filedErrors));
      return;
    }

    try {
      if (state.isEditing) {
        await _serverRepository.updateServer(
          request: _serverDetailsService.toUpdateServerRequest(
            id: state.serverId!,
            data: state.data,
          ),
        );
      } else {
        await _serverRepository.addServer(
          request: _serverDetailsService.toAddServerRequest(
            data: state.data,
          ),
        );
      }

      emit(state.copyWith(action: const ServerDetailsAction.saved()));
      emit(state.copyWith(action: const ServerDetailsAction.none()));
    } catch (e) {
      final PresentationError error = ErrorUtils.toPresentationError(exception: e);

      if (error is PresentationFieldError) {
        emit(state.copyWith(fieldErrors: error.fields));
      }

      emit(state.copyWith(action: ServerDetailsAction.presentationError(error)));
      emit(state.copyWith(action: const ServerDetailsAction.none()));
    }
  }
}
