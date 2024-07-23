import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vpn/common/extensions/context_extensions.dart';
import 'package:vpn/common/localization/localization.dart';
import 'package:vpn/feature/server/server_details/bloc/server_details_bloc.dart';
import 'package:vpn/feature/server/server_details/view/widget/server_details_form.dart';
import 'package:vpn/feature/server/server_details/view/widget/server_details_submit_button_section.dart';
import 'package:vpn/view/custom_app_bar.dart';
import 'package:vpn/view/scaffold_wrapper.dart';

class ServerDetailsScreenView extends StatefulWidget {
  const ServerDetailsScreenView({
    super.key,
  });

  @override
  State<ServerDetailsScreenView> createState() => _ServerDetailsScreenViewState();
}

class _ServerDetailsScreenViewState extends State<ServerDetailsScreenView> {
  @override
  Widget build(BuildContext context) => ScaffoldWrapper(
        child: BlocConsumer<ServerDetailsBloc, ServerDetailsState>(
          listenWhen: (previous, current) => current.action != const ServerDetailsAction.none(),
          listener: (context, state) {
            switch (state.action) {
              case ServerDetailsPresentationError(:final error):
                context.showInfoSnackBar(message: error.toLocalizedString(context));
              case ServerDetailsSaved():
                context.pop();
              default:
                break;
            }
          },
          buildWhen: (prev, curr) => prev.action == curr.action && prev.serverId != curr.serverId,
          builder: (context, state) => Scaffold(
            appBar: CustomAppBar(
              title: state.serverId == null ? context.ln.addServer : context.ln.editServer,
            ),
            body: Column(
              children: [
                const Expanded(
                  child: ServerDetailsForm(),
                ),
                ServerDetailsSubmitButtonSection(
                  serverId: state.serverId,
                ),
              ],
            ),
          ),
        ),
      );
}
