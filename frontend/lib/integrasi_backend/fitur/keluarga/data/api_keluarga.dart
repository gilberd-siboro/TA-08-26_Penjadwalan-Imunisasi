import '../../../inti/jaringan/klien_api.dart';
import '../model/profil_keluarga.dart';

class ApiKeluarga {
  final KlienApi _klien;

  ApiKeluarga(this._klien);

  Future<ProfilKeluargaApiResponse> ambilProfilKeluarga() async {
    final res = await _klien.get('/profile/keluarga', auth: true);
    return ProfilKeluargaApiResponse.fromJson(res);
  }

  Future<Map<String, dynamic>> tambahAnak({
    required int idIbu,
    required String namaLengkap,
    required String jenisKelamin,
    required String tempatLahir,
    required String dusun,
    required String keterangan,
    String nik = '',
    String nomorTelepon = '',
    DateTime? tanggalLahir,
  }) async {
    return _klien.post(
      '/keluarga/anak',
      auth: true,
      body: {
        'id_ibu': idIbu,
        'nik': nik,
        'nomor_telepon': nomorTelepon,
        'nama_lengkap': namaLengkap,
        'jenis_kelamin': jenisKelamin,
        'tanggal_lahir': tanggalLahir?.toUtc().toIso8601String(),
        'tempat_lahir': tempatLahir,
        'dusun': dusun,
        'keterangan': keterangan,
      },
    );
  }
}
