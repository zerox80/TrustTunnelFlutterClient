import 'package:flutter/material.dart';
import 'package:vpn/common/theme/light_theme.dart';
import 'package:vpn_plugin/platform_api.g.dart';

abstract class DependencyFactory {
  ThemeData get lightThemeData;

  PlatformApi get platformApi;

  void close();
}

class DependencyFactoryImpl implements DependencyFactory {
  DependencyFactoryImpl();

  ThemeData? _lightThemeData;

  PlatformApi? _platformApi;

  @override
  ThemeData get lightThemeData => _lightThemeData ??= LightTheme().data;

  @override
  PlatformApi get platformApi => _platformApi ??= PlatformApi();

  @override
  void close() {
    // TODO implement close
  }
}
