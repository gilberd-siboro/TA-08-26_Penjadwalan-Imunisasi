class AnggotaKeluarga {
  final int idPenduduk;
  final String nik;
  final String namaLengkap;
  final String jenisKelamin;
  final String? tanggalLahir;
  final String kedudukanKeluarga;

  AnggotaKeluarga({
    required this.idPenduduk,
    required this.nik,
    required this.namaLengkap,
    required this.jenisKelamin,
    required this.tanggalLahir,
    required this.kedudukanKeluarga,
  });

  factory AnggotaKeluarga.fromJson(Map<String, dynamic> json) {
    return AnggotaKeluarga(
      idPenduduk: (json['id_penduduk'] as num).toInt(),
      nik: (json['nik'] ?? '').toString(),
      namaLengkap: (json['nama_lengkap'] ?? '').toString(),
      jenisKelamin: (json['jenis_kelamin'] ?? '').toString(),
      tanggalLahir: json['tanggal_lahir']?.toString(),
      kedudukanKeluarga: (json['kedudukan_keluarga'] ?? '').toString(),
    );
  }
}

class ProfilKeluarga {
  final int idPengguna;
  final int idNoKK;
  final String nomorTelepon;
  final String role;
  final List<AnggotaKeluarga> anggotaKeluarga;

  ProfilKeluarga({
    required this.idPengguna,
    required this.idNoKK,
    required this.nomorTelepon,
    required this.role,
    required this.anggotaKeluarga,
  });

  factory ProfilKeluarga.fromJson(Map<String, dynamic> json) {
    final list = (json['anggota_keluarga'] as List<dynamic>? ?? [])
        .map((e) => AnggotaKeluarga.fromJson(e as Map<String, dynamic>))
        .toList();

    return ProfilKeluarga(
      idPengguna: (json['id_pengguna'] as num).toInt(),
      idNoKK: (json['id_no_kk'] as num).toInt(),
      nomorTelepon: (json['nomor_telepon'] ?? '').toString(),
      role: (json['role'] ?? '').toString(),
      anggotaKeluarga: list,
    );
  }
}

class ProfilKeluargaApiResponse {
  final int statusCode;
  final List<String> message;
  final ProfilKeluarga data;

  ProfilKeluargaApiResponse({
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory ProfilKeluargaApiResponse.fromJson(Map<String, dynamic> json) {
    final rawMessage = json['message'];
    final parsedMessage = rawMessage is List
        ? rawMessage.map((e) => e.toString()).toList()
        : <String>[];

    final dataMap = (json['data'] ?? {}) as Map<String, dynamic>;

    return ProfilKeluargaApiResponse(
      statusCode: (json['status_code'] as num?)?.toInt() ?? 0,
      message: parsedMessage,
      data: ProfilKeluarga.fromJson(dataMap),
    );
  }
}
