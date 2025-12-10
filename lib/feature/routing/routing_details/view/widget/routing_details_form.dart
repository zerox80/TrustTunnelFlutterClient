import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vpn/common/extensions/context_extensions.dart';
import 'package:vpn/common/localization/extensions/locale_enum_extension.dart';
import 'package:vpn/common/localization/localization.dart';
import 'package:vpn/data/model/routing_mode.dart';
import 'package:vpn/feature/routing/routing_details/bloc/routing_details_bloc.dart';
import 'package:vpn/feature/routing/routing_details/domain/routing_spell_check_service.dart';
import 'package:vpn/view/inputs/custom_text_field.dart';

class RoutingDetailsForm extends StatefulWidget {
  const RoutingDetailsForm({super.key});

  @override
  State<RoutingDetailsForm> createState() => _RoutingDetailsFormState();
}

class _RoutingDetailsFormState extends State<RoutingDetailsForm> {
  bool _bypassValid = true;
  bool _vpnValid = true;

  late final SpellCheckService _bypassSpellCheckService;
  late final SpellCheckService _vpnSpellCheckService;

  @override
  void initState() {
    super.initState();

    _bypassSpellCheckService = RoutingSpellCheckService(
      onChecked: (spellValid) => _onDataChanged(
        context,
        RoutingMode.bypass,
        spellValid: spellValid,
      ),
    );
    _vpnSpellCheckService = RoutingSpellCheckService(
      onChecked: (spellValid) => _onDataChanged(
        context,
        RoutingMode.vpn,
        spellValid: spellValid,
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(16.0),
    child: BlocBuilder<RoutingDetailsBloc, RoutingDetailsState>(
      buildWhen: (prev, current) => prev.action == current.action,
      builder: (context, state) => context.isMobileBreakpoint
          ? TabBarView(
              children: [
                _bypassRulesTextField(context, state),
                _vpnRulesTextField(context, state),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: _bypassRulesTextField(context, state, showLabel: true),
                ),
                const SizedBox(width: 16),
                Flexible(
                  child: _vpnRulesTextField(context, state, showLabel: true),
                ),
              ],
            ),
    ),
  );

  CustomTextField _vpnRulesTextField(
    BuildContext context,
    RoutingDetailsState state, {
    bool showLabel = false,
  }) => CustomTextField(
    label: showLabel ? RoutingMode.vpn.localized(context) : null,
    value: state.data.vpnRules.join('\n'),
    autofocus: true,
    hint: context.ln.enterRulesHint,
    spellCheckService: _vpnSpellCheckService,
    minLines: 40,
    maxLines: 40,
    showClearButton: false,
    onChanged: (vpnRules) => _onDataChanged(
      context,
      RoutingMode.vpn,
      vpnRules: vpnRules.split('\n').map((r) => r.trim()).where((r) => r.isNotEmpty).toList(),
    ),
  );

  CustomTextField _bypassRulesTextField(
    BuildContext context,
    RoutingDetailsState state, {
    bool showLabel = false,
  }) => CustomTextField(
    label: showLabel ? RoutingMode.bypass.localized(context) : null,
    value: state.data.bypassRules.join('\n'),
    autofocus: true,
    hint: context.ln.enterRulesHint,
    minLines: 40,
    maxLines: 40,
    spellCheckService: _bypassSpellCheckService,
    showClearButton: false,
    onChanged: (bypassRules) => _onDataChanged(
      context,
      RoutingMode.bypass,
      bypassRules: bypassRules.split('\n').map((r) => r.trim()).where((r) => r.isNotEmpty).toList(),
    ),
  );

  void _onDataChanged(
    BuildContext context,
    RoutingMode mode, {
    List<String>? vpnRules,
    List<String>? bypassRules,
    bool? spellValid,
  }) {
    if (mode == RoutingMode.bypass) {
      _bypassValid = spellValid ?? (_bypassValid || bypassRules?.isEmpty == true);
    }

    if (mode == RoutingMode.vpn) {
      _vpnValid = spellValid ?? (_vpnValid || vpnRules?.isEmpty == true);
    }

    context.read<RoutingDetailsBloc>().add(
      RoutingDetailsEvent.dataChanged(
        vpnRules: vpnRules,
        bypassRules: bypassRules,
        hasInvalidRules: !(_vpnValid && _bypassValid),
      ),
    );
  }
}
