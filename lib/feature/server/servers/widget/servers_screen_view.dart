import 'package:flutter/material.dart';
import 'package:vpn/common/assets/asset_icons.dart';
import 'package:vpn/common/extensions/context_extensions.dart';
import 'package:vpn/common/localization/localization.dart';
import 'package:vpn/data/model/server.dart';
import 'package:vpn/feature/server/server_details/widgets/server_details_popup.dart';
import 'package:vpn/feature/server/servers/widget/scope/servers_scope.dart';
import 'package:vpn/feature/server/servers/widget/scope/servers_scope_aspect.dart';
import 'package:vpn/feature/server/servers/widget/servers_card.dart';
import 'package:vpn/feature/server/servers/widget/servers_empty_placeholder.dart';
import 'package:vpn/widgets/buttons/custom_floating_action_button.dart';
import 'package:vpn/widgets/custom_app_bar.dart';
import 'package:vpn/widgets/scaffold_wrapper.dart';

class ServersScreenView extends StatefulWidget {
  const ServersScreenView({
    super.key,
  });

  @override
  State<ServersScreenView> createState() => _ServersScreenViewState();
}

class _ServersScreenViewState extends State<ServersScreenView> {
  late List<Server> _servers;

  @override
  void initState() {
    super.initState();
    final initialController = ServersScope.controllerOf(context, listen: false);
    _servers = initialController.servers;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _servers = ServersScope.controllerOf(
      context,
      aspect: ServersScopeAspect.servers,
    ).servers;
  }

  @override
  Widget build(BuildContext context) => ScaffoldWrapper(
    child: ScaffoldMessenger(
      child: Scaffold(
        appBar: CustomAppBar(
          title: context.ln.servers,
        ),
        body: _servers.isEmpty
            ? const ServersEmptyPlaceholder()
            : ListView.builder(
                padding: const EdgeInsets.only(bottom: 80),
                itemCount: _servers.length,
                itemBuilder: (_, index) => Column(
                  children: [
                    ServersCard(
                      server: _servers[index],
                    ),

                    if (index != _servers.length - 1) const Divider(),
                  ],
                ),
              ),
        floatingActionButton: _servers.isEmpty
            ? const SizedBox.shrink()
            : CustomFloatingActionButton.extended(
                icon: AssetIcons.add,
                onPressed: () => _pushServerDetailsScreen(context),
                label: context.ln.addServer,
              ),
      ),
    ),
  );

  void _pushServerDetailsScreen(BuildContext context) async {
    final controller = ServersScope.controllerOf(context, listen: false);

    await context.push(
      const ServerDetailsPopUp(),
    );

    controller.fetchServers();
  }
}
