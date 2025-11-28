import 'package:vpn_plugin/models/upstream_protocol.dart';

final class Endpoint {
  final List<String> addresses;
  final List<String> dnsUpStreams;
  final List<String> exclusions;

  final String hostName;
  final String username;
  final String password;

  final String clientRandom;
  final String certificate;

  final UpStreamProtocol upStreamProtocol;
  final UpStreamProtocol? upStreamFallbackProtocol;

  final bool antiDpi;
  final bool hasIpv6;
  final bool skipVerification;

  Endpoint({
    this.addresses = const [],
    this.dnsUpStreams = const [],
    this.exclusions = const [],
    this.clientRandom = '',
    this.skipVerification = false,
    this.certificate = '',
    this.antiDpi = false,
    this.upStreamFallbackProtocol,

    required this.hostName,
    required this.hasIpv6,
    required this.username,
    required this.password,
    required this.upStreamProtocol,
  });
}
