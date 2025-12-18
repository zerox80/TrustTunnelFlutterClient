import 'package:flutter/material.dart';
import 'package:vpn/common/localization/localization.dart';
import 'package:vpn/feature/settings/excluded_routes/widgets/excluded_routes_button_section.dart';
import 'package:vpn/feature/settings/excluded_routes/widgets/excluded_routes_form.dart';
import 'package:vpn/widgets/custom_app_bar.dart';
import 'package:vpn/widgets/scaffold_wrapper.dart';

class ExcludedRoutesScreenView extends StatelessWidget {
  const ExcludedRoutesScreenView({
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
            child: ExcludedRoutesForm(),
          ),
          ExcludedRoutesButtonSection(),
        ],
      ),
    ),
  );
}
