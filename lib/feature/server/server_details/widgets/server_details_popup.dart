import 'package:flutter/material.dart';
import 'package:vpn/feature/server/server_details/widgets/scope/server_details_scope.dart';
import 'package:vpn/feature/server/server_details/widgets/server_details_view.dart';
import 'package:vpn/widgets/scaffold_wrapper.dart';

class ServerDetailsPopUp extends StatelessWidget {
  final int? serverId;

  const ServerDetailsPopUp({
    super.key,
    this.serverId,
  });

  @override
  Widget build(BuildContext context) => ScaffoldWrapper(
    child: ServerDetailsScope(
      serverId: serverId,
      child: const ServerDetailsView(),
    ),
  );
}
