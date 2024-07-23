import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vpn/common/extensions/context_extensions.dart';
import 'package:vpn/feature/settings/settings_excluded_routes/bloc/settings_excluded_routes_bloc.dart';
import 'package:vpn/feature/settings/settings_excluded_routes/view/widget/settings_excluded_routes_screen_view.dart';

class SettingsExcludedRoutesScreen extends StatelessWidget {
  const SettingsExcludedRoutesScreen({super.key});

  @override
  Widget build(BuildContext context) =>
      BlocProvider<SettingsExcludedRoutesBloc>(
        create: (context) => context.blocFactory.settingsExcludedRoutesBloc()
          ..add(const SettingsExcludedRoutesEvent.init()),
        child: const SettingsExcludedRoutesScreenView(),
      );
}
