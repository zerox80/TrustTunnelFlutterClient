import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vpn/common/localization/localization.dart';
import 'package:vpn/feature/settings/settings_excluded_routes/bloc/settings_excluded_routes_bloc.dart';
import 'package:vpn/view/inputs/custom_text_field.dart';

class SettingsExcludedRoutesForm extends StatelessWidget {
  const SettingsExcludedRoutesForm({super.key});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(16),
        child: BlocBuilder<SettingsExcludedRoutesBloc,
            SettingsExcludedRoutesState>(
          builder: (context, state) {
            return CustomTextField(
              value: state.data,
              hint: context.ln.typeSomething,
              minLines: 40,
              maxLines: 40,
              showClearButton: false,
              onChanged: (excludedRoutes) => _onDataChanged(
                context,
                excludedRoutes: excludedRoutes,
              ),
            );
          },
        ),
      );

  void _onDataChanged(
    BuildContext context, {
    required String excludedRoutes,
  }) =>
      context.read<SettingsExcludedRoutesBloc>().add(
            SettingsExcludedRoutesEvent.dataChanged(
              excludedRoutes: excludedRoutes,
            ),
          );
}
