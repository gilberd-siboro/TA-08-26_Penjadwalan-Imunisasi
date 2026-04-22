import '../../../inti/jaringan/klien_api.dart';
import '../../../inti/penyimpanan/penyimpanan_sesi.dart';
import '../model/hasil_login.dart';

class ApiAutentikasi {
  final KlienApi _klien;
  final PenyimpananSesi _sesi;

  ApiAutentikasi(this._klien, this._sesi);

  Future<HasilLogin> login({
    required String nomorTelepon,
    required String kataSandi,
  }) async {
    final res = await _klien.post(
      '/login',
      body: {'nomor_telepon': nomorTelepon, 'kata_sandi': kataSandi},
    );

    final data = (res['data'] ?? {}) as Map<String, dynamic>;
    final hasil = HasilLogin.fromJson(data);

    await _sesi.simpanSesi(token: hasil.token, role: hasil.role);

    return hasil;
  }

  Future<void> logout() async {
    try {
      await _klien.post('/logout', auth: true, body: {});
    } catch (_) {
      // Abaikan error logout di server, tetap hapus sesi lokal.
    } finally {
      await _sesi.hapusSesi();
    }
  }

  Future<String> changePassword({
    required String kataSandiLama,
    required String kataSandiBaru,
    required String konfirmasiKataSandiBaru,
  }) async {
    final response = await _klien.post(
      '/change-password',
      body: {
        'kata_sandi_lama': kataSandiLama,
        'kata_sandi_baru': kataSandiBaru,
        'konfirmasi_kata_sandi_baru': konfirmasiKataSandiBaru,
      },
      auth: true,
    );

    final body = response['data'];
    if (body is Map<String, dynamic>) {
      final success = body['success'] == true;
      final message = (body['message'] ?? '').toString();

      if (success) {
        return message.isNotEmpty ? message : 'Kata sandi berhasil diubah';
      }

      throw Exception(
        message.isNotEmpty ? message : 'Gagal mengubah kata sandi',
      );
    }

    throw Exception('Format response change password tidak valid');
  }
}
