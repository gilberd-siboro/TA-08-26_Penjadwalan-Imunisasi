import 'dart:convert';
import 'package:http/http.dart' as http;

import '../konfigurasi/konfigurasi_aplikasi.dart';
import '../penyimpanan/penyimpanan_sesi.dart';
import 'eksepsi_api.dart';

class KlienApi {
  final http.Client _http;
  final PenyimpananSesi _sesi;

  KlienApi({http.Client? httpClient, PenyimpananSesi? penyimpananSesi})
    : _http = httpClient ?? http.Client(),
      _sesi = penyimpananSesi ?? PenyimpananSesi();

  Uri _uri(String path) => Uri.parse('${KonfigurasiAplikasi.baseUrl}$path');

  Future<Map<String, dynamic>> get(String path, {bool auth = false}) async {
    final headers = await _headers(auth: auth);
    final res = await _http.get(_uri(path), headers: headers);
    return _parseResponse(res);
  }

  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? body,
    bool auth = false,
  }) async {
    final headers = await _headers(auth: auth);
    final res = await _http.post(
      _uri(path),
      headers: headers,
      body: jsonEncode(body ?? {}),
    );
    return _parseResponse(res);
  }

  Future<Map<String, String>> _headers({required bool auth}) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (auth) {
      final token = await _sesi.ambilToken();
      if (token == null || token.isEmpty) {
        throw EksepsiApi(
          'Sesi tidak ditemukan. Silakan login ulang.',
          statusCode: 401,
        );
      }
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  Map<String, dynamic> _parseResponse(http.Response res) {
    final decoded =
        jsonDecode(utf8.decode(res.bodyBytes)) as Map<String, dynamic>;
    final statusCode =
        (decoded['status_code'] as num?)?.toInt() ?? res.statusCode;
    final pesan = _parsePesan(decoded['message']);

    if (res.statusCode >= 200 && res.statusCode < 300) {
      return decoded;
    }

    throw EksepsiApi(
      pesan.isNotEmpty ? pesan.first : 'Request gagal',
      statusCode: statusCode,
    );
  }

  List<String> _parsePesan(dynamic raw) {
    if (raw is List) return raw.map((e) => e.toString()).toList();
    if (raw is String) return [raw];
    return ['Terjadi kesalahan'];
  }
}
