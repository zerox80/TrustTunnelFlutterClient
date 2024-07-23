import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vpn/common/extensions/context_extensions.dart';
import 'package:vpn/common/localization/localization.dart';
import 'package:vpn/feature/server/server_details/bloc/server_details_bloc.dart';

class ServerDetailsSubmitButtonSection extends StatelessWidget {
  final int? serverId;

  const ServerDetailsSubmitButtonSection({
    super.key,
    required this.serverId,
  });

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: context.isMobileBreakpoint ? CrossAxisAlignment.stretch : CrossAxisAlignment.end,
        children: [
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: FilledButton(
              onPressed: () => _submit(context),
              child: Text(
                serverId == null ? context.ln.add : context.ln.save,
              ),
            ),
          ),
        ],
      );

  void _submit(BuildContext context) => context.read<ServerDetailsBloc>().add(
        const ServerDetailsEvent.submit(),
      );
}
