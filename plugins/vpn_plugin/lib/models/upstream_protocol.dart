enum UpStreamProtocol {
  http2('http2'),
  http3('http3');

  final String value;

  const UpStreamProtocol(this.value);
}
