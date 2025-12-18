import 'dart:async';

import 'package:flutter/material.dart' hide Router;
import 'package:flutter/material.dart';
import 'package:vpn/di/model/initialization_helper.dart';
import 'package:vpn/di/widgets/dependency_scope.dart';
import 'package:vpn/feature/app/app.dart';
import 'package:vpn/feature/routing/routing/widgets/scope/routing_scope.dart';
import 'package:vpn/feature/server/servers/widget/scope/servers_scope.dart';
import 'package:vpn/feature/settings/excluded_routes/widgets/scope/excluded_routes_scope.dart';
import 'package:vpn/feature/vpn/widgets/vpn_scope.dart';

void main() => runZonedGuarded(
  () async {
    final initializationResult = await InitializationHelperIo().init();

    runApp(
      DependencyScope(
        dependenciesFactory: initializationResult.dependenciesFactory,
        repositoryFactory: initializationResult.repositoryFactory,

        child: ServersScope(
          child: RoutingScope(
            child: ExcludedRoutesScope(
              child: VpnScope(
                vpnRepository: initializationResult.repositoryFactory.vpnRepository,
                child: const App(),
              ),
            ),
          ),
        ),
      ),
    );
  },
  (e, st) {
    print('Error catched in main thread $e');
  },
);
