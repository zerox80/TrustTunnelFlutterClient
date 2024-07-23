import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vpn/common/extensions/context_extensions.dart';
import 'package:vpn/common/localization/localization.dart';
import 'package:vpn/feature/settings/settings_excluded_routes/bloc/settings_excluded_routes_bloc.dart';

class SettingsExcludedRoutesButtonSection extends StatelessWidget {
  const SettingsExcludedRoutesButtonSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: context.isMobileBreakpoint
            ? CrossAxisAlignment.stretch
            : CrossAxisAlignment.end,
        children: [
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: BlocBuilder<SettingsExcludedRoutesBloc,
                SettingsExcludedRoutesState>(
              builder: (context, state) {
                return FilledButton(
                  onPressed: state.wasChanged
                      ? () => _saveExcludedRoutes(context)
                      : null,
                  child: Text(context.ln.save),
                );
              },
            ),
          ),
        ],
      );

  void _saveExcludedRoutes(BuildContext context) =>
      context.read<SettingsExcludedRoutesBloc>().add(
            const SettingsExcludedRoutesEvent.saveExcludedRoutes(),
          );
}
