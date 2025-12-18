import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:vpn/common/assets/asset_icons.dart';
import 'package:vpn/common/extensions/context_extensions.dart';
import 'package:vpn/common/localization/localization.dart';
import 'package:vpn/data/model/routing_profile.dart';
import 'package:vpn/data/model/vpn_state.dart';
import 'package:vpn/common/utils/routing_profile_utils.dart';
import 'package:vpn/feature/routing/routing/model/routing_profile_modification_result.dart';
import 'package:vpn/feature/routing/routing/widgets/routing_delete_profile_dialog.dart';
import 'package:vpn/feature/routing/routing/widgets/routing_edit_name_dialog.dart';
import 'package:vpn/feature/routing/routing/widgets/scope/routing_scope.dart';

import 'package:vpn/feature/routing/routing_details/widgets/routing_details_screen.dart';
import 'package:vpn/feature/server/servers/widget/scope/servers_scope.dart';
import 'package:vpn/feature/settings/excluded_routes/widgets/scope/excluded_routes_scope.dart';
import 'package:vpn/feature/vpn/widgets/vpn_scope.dart';
import 'package:vpn/widgets/common/custom_list_tile_separated.dart';
import 'package:vpn/widgets/custom_icon.dart';

class RoutingCard extends StatelessWidget {
  final RoutingProfile routingProfile;

  const RoutingCard({
    super.key,
    required this.routingProfile,
  });

  @override
  Widget build(BuildContext context) => CustomListTileSeparated(
    title: routingProfile.name,
    onTileTap: () => _pushDetailsScreen(context),
    trailing: PopupMenuButton(
      icon: const CustomIcon(
        icon: AssetIcons.moreVert,
        size: 24,
      ),
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          onTap: () => _onEditName(context),
          child: Row(
            children: [
              const CustomIcon(
                icon: AssetIcons.modeEdit,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                context.ln.editProfile,
                style: context.textTheme.bodyLarge,
              ),
            ],
          ),
        ),
        if (!RoutingProfileUtils.isDefaultRoutingProfile(profile: routingProfile))
          PopupMenuItem<String>(
            onTap: () => _onDeleteProfile(context),
            child: Row(
              children: [
                CustomIcon.medium(
                  icon: AssetIcons.delete,
                  color: context.colors.error,
                ),
                const SizedBox(width: 12),
                Text(
                  context.ln.deleteProfile,
                  style: context.textTheme.bodyLarge?.copyWith(
                    color: context.colors.error,
                  ),
                ),
              ],
            ),
          ),
      ],
    ),
  );

  void _onEditName(BuildContext context) {
    final controller = RoutingScope.controllerOf(context, listen: false);
    controller.pickProfileToChangeName();

    showDialog(
      context: context,
      builder: (_) => RoutingScopeValue(
        controller: RoutingScope.controllerOf(context),
        child: RoutingEditNameDialog(
          currentRoutingName: routingProfile.name,
          id: routingProfile.id,
        ),
      ),
    );
  }

  void _onDeleteProfile(BuildContext context) async {
    final serversController = ServersScope.controllerOf(context, listen: false);
    final excludedRoutes = ExcludedRoutesScope.controllerOf(context, listen: false).excludedRoutes;
    final controller = RoutingScope.controllerOf(context, listen: false);
    final result = await showDialog(
      context: context,
      builder: (_) => RoutingScopeValue(
        controller: RoutingScope.controllerOf(context),
        child: RoutingDeleteProfileDialog(
          profileName: routingProfile.name,
          profileId: routingProfile.id,
        ),
      ),
    );

    serversController.fetchServers();

    if (!context.mounted || result != RoutingProfileModificationResult.deleted) {
      return;
    }

    final vpnScope = VpnScope.vpnControllerOf(context);

    final connected = vpnScope.state != VpnState.disconnected;
    final selectedServerId = serversController.selectedServer?.id;
    final pickedServer = serversController.servers.firstWhereOrNull((s) => s.id == selectedServerId);
    final picked = pickedServer?.routingProfile.id == routingProfile.id;
    final defaultProfile = controller.routingList.firstWhere(
      (s) => s.id == RoutingProfileUtils.defaultRoutingProfileId,
    );

    if (picked && connected) {
      vpnScope.start(
        server: pickedServer!,
        routingProfile: defaultProfile,
        excludedRoutes: excludedRoutes,
      );
    }
  }

  void _pushDetailsScreen(BuildContext context) => context.push(
    RoutingDetailsScreen(
      routingId: routingProfile.id,
    ),
  );
}
