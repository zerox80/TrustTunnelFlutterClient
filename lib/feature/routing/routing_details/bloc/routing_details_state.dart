part of 'routing_details_bloc.dart';

@freezed
sealed class RoutingDetailsState with _$RoutingDetailsState {
  const factory RoutingDetailsState({
    int? routingId,
    @Default('') String routingName,
    @Default(RoutingDetailsData()) RoutingDetailsData data,
    @Default(RoutingDetailsData()) RoutingDetailsData initialData,
    @Default(RoutingDetailsLoadingStatus.initialLoading) RoutingDetailsLoadingStatus loadingStatus,
    @Default(RoutingDetailsAction.none()) RoutingDetailsAction action,
    @Default(false) bool hasInvalidRules,
  }) = _RoutingDetailsState;

  const RoutingDetailsState._();

  bool get hasChanges {
    print('''
Bypass equals ${listEquals(data.bypassRules, initialData.bypassRules)},
Vpn equals ${listEquals(data.vpnRules, initialData.vpnRules)},
Default mode equals ${data.defaultMode == initialData.defaultMode}
''');

    return !listEquals(data.bypassRules, initialData.bypassRules) || !listEquals(data.vpnRules, initialData.vpnRules);
  }

  bool get isEditing => routingId != null;
}

enum RoutingDetailsLoadingStatus {
  initialLoading,
  idle,
}

@Freezed(
  copyWith: false,
  fromJson: false,
  toJson: false,
)
sealed class RoutingDetailsAction with _$RoutingDetailsAction {
  const factory RoutingDetailsAction.presentationError(
    PresentationError error,
  ) = RoutingDetailsPresentationError;

  const factory RoutingDetailsAction.saved() = RoutingDetailsSaved;

  const factory RoutingDetailsAction.created(
    String name,
  ) = RoutingDetailsCreated;

  const factory RoutingDetailsAction.deleted(
    String name,
  ) = RoutingDetailsDeleted;

  const factory RoutingDetailsAction.cleared() = RoutingDetailsCleared;

  const factory RoutingDetailsAction.defaultModeChanged() = RoutingDetailsDefaultModeChanged;

  const factory RoutingDetailsAction.none() = _RoutingDetailsNone;
}
