class EksepsiApi implements Exception {
  final int? statusCode;
  final String pesan;

  EksepsiApi(this.pesan, {this.statusCode});

  @override
  String toString() => 'EksepsiApi(statusCode: $statusCode, pesan: $pesan)';
}
