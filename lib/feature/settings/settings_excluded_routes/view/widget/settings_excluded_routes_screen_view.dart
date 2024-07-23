import 'package:flutter/material.dart';
import 'package:vpn/common/localization/localization.dart';
import 'package:vpn/feature/settings/settings_excluded_routes/view/widget/settings_excluded_routes_button_section.dart';
import 'package:vpn/feature/settings/settings_excluded_routes/view/widget/settings_excluded_routes_form.dart';
import 'package:vpn/view/custom_app_bar.dart';
import 'package:vpn/view/scaffold_wrapper.dart';

class SettingsExcludedRoutesScreenView extends StatelessWidget {
  const SettingsExcludedRoutesScreenView({
    super.key,
  });

  @override
  Widget build(BuildContext context) => ScaffoldWrapper(
        child: Scaffold(
          appBar: CustomAppBar(
            title: context.ln.excludedRoutes,
          ),
          body: const Column(
            children: [
              Expanded(
                child: SettingsExcludedRoutesForm(),
              ),
              SettingsExcludedRoutesButtonSection(),
            ],
          ),
        ),
      );
}
