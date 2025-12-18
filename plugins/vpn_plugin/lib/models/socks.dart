/// {@template socks}
/// SOCKS configuration.
///
/// This model describes where and how a local SOCKS listener should be exposed
/// (when supported by the backend).
///
/// Credentials are optional and may be left empty to allow unauthenticated
/// access on the bound address.
/// {@endtemplate}
final class Socks {
  /// {@template socks_address}
  /// Address to bind the SOCKS listener to.
  ///
  /// Typically expressed as `host:port` (for example `127.0.0.1:1080`).
  /// {@endtemplate}
  final String address;

  /// {@template socks_username}
  /// Optional username for SOCKS authentication.
  /// {@endtemplate}
  final String username;

  /// {@template socks_password}
  /// Optional password for SOCKS authentication.
  /// {@endtemplate}
  final String password;

  /// {@macro socks}
  ///
  /// Defaults bind to localhost with no authentication.
  Socks({
    this.address = '127.0.0.1:1080',
    this.username = '',
    this.password = '',
  });
}
