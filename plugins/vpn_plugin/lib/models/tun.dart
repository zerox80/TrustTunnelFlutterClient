final class Tun {
  final List<String> includedRoutes;
  final List<String> excludedRoutes;
  final int mtuSize;

  Tun({
    this.includedRoutes = const [
      '0.0.0.0/0',
      '2000::/3',
    ],
    this.excludedRoutes = const [
      '0.0.0.0/8',
      '10.0.0.0/8',
      '169.254.0.0/16',
      '172.16.0.0/12',
      '192.168.0.0/16',
      '224.0.0.0/3',
    ],
    this.mtuSize = 1500,
  }) : assert(mtuSize > 0, 'mtuSize must be greater than 0');
}
