import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vpn/common/extensions/context_extensions.dart';
import 'package:vpn/common/localization/extensions/locale_enum_extension.dart';
import 'package:vpn/common/localization/localization.dart';
import 'package:vpn/data/model/routing_mode.dart';
import 'package:vpn/data/model/routing_profile.dart';
import 'package:vpn/data/model/vpn_state.dart';
import 'package:vpn/feature/routing/routing/bloc/routing_bloc.dart';
import 'package:vpn/feature/routing/routing/common/routing_profile_utils.dart';
import 'package:vpn/feature/routing/routing_details/bloc/routing_details_bloc.dart';
import 'package:vpn/feature/routing/routing_details/view/widget/routing_details_discard_changes_dialog.dart';
import 'package:vpn/feature/routing/routing_details/view/widget/routing_details_form.dart';
import 'package:vpn/feature/routing/routing_details/view/widget/routing_details_screen_app_bar_action.dart';
import 'package:vpn/feature/routing/routing_details/view/widget/routing_details_submit_button_section.dart';
import 'package:vpn/feature/server/servers/bloc/servers_bloc.dart';
import 'package:vpn/feature/settings/excluded_routes/bloc/excluded_routes_bloc.dart';
import 'package:vpn/feature/vpn/domain/entity/vpn_controller.dart';
import 'package:vpn/feature/vpn/widgets/vpn_scope.dart';
import 'package:vpn/view/custom_app_bar.dart';
import 'package:vpn/view/scaffold_wrapper.dart';

class RoutingDetailsScreenView extends StatelessWidget {
  const RoutingDetailsScreenView({super.key});

  @override
  Widget build(BuildContext context) => ScaffoldWrapper(
    child: DefaultTabController(
      length: RoutingMode.values.length,
      child: ScaffoldMessenger(
        child: BlocConsumer<RoutingDetailsBloc, RoutingDetailsState>(
          listenWhen: (previous, current) => current.action != const RoutingDetailsAction.none(),
          listener: (innerContext, state) {
            final vpnController = VpnScope.vpnControllerOf(context);
            final serversBloc = context.read<ServersBloc>();
            final routingProfilesBloc = context.read<RoutingBloc>();
            final excludedRoutesBloc = context.read<ExcludedRoutesBloc>();
            final routingProfile = RoutingProfile(
              id: state.routingId ?? -1,
              name: state.routingName,
              defaultMode: state.data.defaultMode,
              bypassRules: state.data.bypassRules,
              vpnRules: state.data.vpnRules,
            );

            serversBloc.add(const ServersEvent.fetch());
            routingProfilesBloc.add(const RoutingEvent.fetch());

            switch (state.action) {
              case RoutingDetailsPresentationError(:final error):
                context.showInfoSnackBar(message: error.toLocalizedString(context));
              case RoutingDetailsSaved():
                onUpdated(
                  vpnController,
                  serversBloc,
                  routingProfile,
                  excludedRoutesBloc,
                );
                context.pop();
                context.showInfoSnackBar(message: context.ln.changesSavedSnackbar);
              case RoutingDetailsCreated(:final name):
                context.pop();
                context.showInfoSnackBar(message: context.ln.profileCreatedSnackbar(name));
              case RoutingDetailsDeleted(:final name):
                final defaultProfile = context.read<RoutingBloc>().state.routingList.firstWhere(
                  (element) => element.id == RoutingProfileUtils.defaultRoutingProfileId,
                );
                onUpdated(
                  vpnController,
                  serversBloc,
                  defaultProfile,
                  excludedRoutesBloc,
                );
                context.pop();
                context.showInfoSnackBar(message: context.ln.profileDeletedSnackbar(name));

              case RoutingDetailsCleared():
                innerContext.showInfoSnackBar(message: context.ln.allRulesDeleted);
              case RoutingDetailsDefaultModeChanged():
                innerContext.showInfoSnackBar(message: context.ln.changesSavedSnackbar);
                onUpdated(
                  vpnController,
                  serversBloc,
                  routingProfile,
                  excludedRoutesBloc,
                );
              default:
                break;
            }
          },
          buildWhen: (prev, current) => prev.action == current.action,
          builder: (context, state) => Scaffold(
            appBar: CustomAppBar(
              leadingIconType: AppBarLeadingIconType.back,
              centerTitle: true,
              onBackPressed: state.hasChanges ? () => _showNotSavedChangesWarning(context) : null,
              title: state.routingName,
              actions: const [
                RoutingDetailsScreenAppBarAction(),
              ],
              bottomHeight: context.isMobileBreakpoint ? 48 : 0,
              bottomPadding: EdgeInsets.zero,
              bottom: context.isMobileBreakpoint
                  ? TabBar(
                      tabs: [
                        ...RoutingMode.values.map(
                          (item) => Text(
                            item.localized(context),
                          ),
                        ),
                      ],
                    )
                  : null,
            ),
            body: state.loadingStatus == RoutingDetailsLoadingStatus.idle
                ? const Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: RoutingDetailsForm(),
                      ),
                      RoutingDetailsSubmitButtonSection(),
                    ],
                  )
                : const SizedBox.shrink(),
          ),
        ),
      ),
    ),
  );

  void onUpdated(
    VpnController controller,
    ServersBloc bloc,
    RoutingProfile profile,
    ExcludedRoutesBloc excludedRoutesBloc,
  ) {
    final selectedServer = bloc.state.serverList.firstWhereOrNull((server) => server.id == bloc.state.selectedServerId);

    if (selectedServer != null) {
      bool picked = selectedServer.routingProfile.id == profile.id;
      bool running = controller.state != VpnState.disconnected;

      if (picked && running) {
        controller.start(
          server: selectedServer,
          routingProfile: profile,
          excludedRoutes: excludedRoutesBloc.state.excludedRoutes,
        );
      }
    }
  }

  void _showNotSavedChangesWarning(BuildContext context) => showDialog(
    context: context,
    builder: (_) => RoutingDetailsDiscardChangesDialog(
      onDiscardPressed: () => context.pop(),
    ),
  );
}
