import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:trusttunnel/common/assets/assets_images.dart';
import 'package:trusttunnel/common/localization/localization.dart';
import 'package:trusttunnel/widgets/custom_app_bar.dart';
import 'package:trusttunnel/widgets/default_page.dart';
import 'package:trusttunnel/widgets/scaffold_wrapper.dart';
import 'package:trusttunnel/common/utils/debug_info_service.dart';
import 'package:trusttunnel/feature/vpn/widgets/vpn_scope.dart';
import 'package:trusttunnel/common/extensions/context_extensions.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) => ScaffoldWrapper(
    child: Scaffold(
      appBar: CustomAppBar(
        title: context.ln.about,
      ),
      body: FutureBuilder<String>(
        future: _getPackageVersion(),
        builder: (context, snapshot) => DefaultPage(
          title: 'TrustTunnel',
          imagePath: AssetImages.about,
          imageSize: const Size.square(248),
          alignment: Alignment.center,
          description: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (snapshot.hasData)
                Text(
                  snapshot.data!,
                  textAlign: TextAlign.center,
                  style: context.textTheme.bodyMedium,
                ),
              const SizedBox(height: 24),
              TextButton.icon(
                onPressed: () => _copyDebugInfo(context),
                icon: const Icon(Icons.copy),
                label: Text(context.ln.copyDebugInfo),
              ),
            ],
          ),
        ),
      ),
    ),
  );

  Future<void> _copyDebugInfo(BuildContext context) async {
    final vpnState = VpnScope.vpnControllerOf(context, listen: false).state;
    final logs = VpnScope.logsControllerOf(context, listen: false).logs;

    await DebugInfoService.copyToClipboard(
      vpnState: vpnState,
      logs: logs,
    );

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.ln.debugInfoCopied),
        ),
      );
    }
  }

  Future<String> _getPackageVersion() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();

    return 'V${packageInfo.version}';
  }
}
