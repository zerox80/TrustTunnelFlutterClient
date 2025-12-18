import 'package:flutter/material.dart';
import 'package:vpn/common/assets/assets_images.dart';
import 'package:vpn/common/extensions/context_extensions.dart';
import 'package:vpn/common/localization/localization.dart';
import 'package:vpn/feature/server/server_details/widgets/server_details_popup.dart';
import 'package:vpn/feature/server/servers/widget/scope/servers_scope.dart';
import 'package:vpn/widgets/default_page.dart';

class ServersEmptyPlaceholder extends StatelessWidget {
  const ServersEmptyPlaceholder({super.key});

  @override
  Widget build(BuildContext context) => DefaultPage(
    title: context.ln.serversEmptyTitle,
    descriptionText: context.ln.serversEmptyDescription,
    imagePath: AssetImages.server,
    imageSize: const Size.square(248),
    buttonText: context.ln.create,
    onButtonPressed: () => _pushServerDetailsScreen(context),
    alignment: Alignment.center,
  );

  void _pushServerDetailsScreen(BuildContext context) async {
    final controller = ServersScope.controllerOf(context, listen: false);

    await context.push(
      const ServerDetailsPopUp(),
    );

    controller.fetchServers();
  }
}
