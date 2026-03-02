// lib/data/sejiwa_data.dart
// ─── Single Source of Truth – Model & Data Bersama SEJIWA ───
// Digunakan oleh: child_data_screen.dart, schedule_screen.dart,
//                 pregnancy_screen.dart, pregnancy_immunization_screen.dart
// Desa Hutabulu Mejan | Studi Kasus TA-2026

// ─────────────────────────────────────────────────────────────────────────────
// Enum Jenis Kelamin
// ─────────────────────────────────────────────────────────────────────────────
enum JenisKelamin { lakilaki, perempuan }

// ─────────────────────────────────────────────────────────────────────────────
// Model DataAnak
// ─────────────────────────────────────────────────────────────────────────────
class DataAnak {
  final String id;
  String nama;
  DateTime tanggalLahir;
  JenisKelamin jenisKelamin;
  double? beratLahirKg;
  String? golonganDarah;

  /// Nama vaksin yang sudah ditandai selesai oleh pengguna / dikonfirmasi bidan
  final Set<String> vaksinSudahDone;

  DataAnak({
    required this.id,
    required this.nama,
    required this.tanggalLahir,
    required this.jenisKelamin,
    this.beratLahirKg,
    this.golonganDarah,
    Set<String>? vaksinSudahDone,
  }) : vaksinSudahDone = vaksinSudahDone ?? {};

  // ── Usia dalam bulan penuh (untuk kalkulasi jadwal) ──
  int get usiaBulan {
    final now = DateTime.now();
    int bulan =
        (now.year - tanggalLahir.year) * 12 + now.month - tanggalLahir.month;
    // Koreksi: jika hari bulan ini belum sampai hari lahir
    if (now.day < tanggalLahir.day) bulan--;
    return bulan < 0 ? 0 : bulan;
  }

  // ── Usia dalam teks bahasa sederhana ──
  String get usiaTeks {
    final selisihHari = DateTime.now().difference(tanggalLahir).inDays;
    if (selisihHari < 30) return '$selisihHari hari';
    if (selisihHari < 365) return '${(selisihHari / 30).floor()} bulan';
    final tahun = (selisihHari / 365).floor();
    final bulan = ((selisihHari % 365) / 30).floor();
    if (bulan == 0) return '$tahun tahun';
    return '$tahun tahun $bulan bulan';
  }

  String get inisial => nama.isNotEmpty ? nama[0].toUpperCase() : '?';
}

// ─────────────────────────────────────────────────────────────────────────────
// Tabel milestone vaksin – urutan Buku KIA 2024
// Tuple: (usiaBulan, namaVaksin)
// ─────────────────────────────────────────────────────────────────────────────
const List<(int, String)> kMilestoneVaksin = [
  (0, 'Hepatitis B (HB-0)'),
  (0, 'Polio 0 (OPV)'),
  (1, 'BCG'),
  (1, 'Polio 1 (OPV)'),
  (2, 'DPT-HB-Hib 1'),
  (2, 'Polio 2 (OPV)'),
  (2, 'PCV 1'),
  (2, 'Rotavirus 1'),
  (3, 'DPT-HB-Hib 2'),
  (3, 'Polio 3 (OPV)'),
  (3, 'PCV 2'),
  (3, 'Rotavirus 2'),
  (4, 'DPT-HB-Hib 3'),
  (4, 'Polio 4 (OPV + IPV)'),
  (4, 'PCV 3'),
  (9, 'Campak-Rubela (MR) 1'),
  (9, 'PCV 4'),
  (9, 'JE (Japanese Encephalitis)'),
  (12, 'Influenza'),
  (18, 'DPT-HB-Hib 4 (Booster)'),
  (18, 'Campak-Rubela (MR) 2 (Booster)'),
  (24, 'Tifoid'),
  (24, 'Hepatitis A'),
  (60, 'DPT 5 (Booster)'),
  (60, 'Campak-Rubela (MR) 3'),
  (60, 'Polio (IPV 2)'),
];

// ─────────────────────────────────────────────────────────────────────────────
// Hitung vaksin berikutnya berdasarkan usia & riwayat selesai
// ─────────────────────────────────────────────────────────────────────────────
String hitungVaksinBerikutnya(DataAnak anak) {
  final bln = anak.usiaBulan;

  // 1) Prioritaskan "segera" (usia tepat atau 1 bulan ke depan)
  for (final (usia, nama) in kMilestoneVaksin) {
    if (!anak.vaksinSudahDone.contains(nama) &&
        usia >= bln &&
        usia <= bln + 1) {
      return nama;
    }
  }
  // 2) Jika ada yang terlewat tapi belum selesai
  for (final (usia, nama) in kMilestoneVaksin) {
    if (!anak.vaksinSudahDone.contains(nama) && usia < bln) {
      return nama;
    }
  }
  // 3) Vaksin berikutnya di masa depan
  for (final (_, nama) in kMilestoneVaksin) {
    if (!anak.vaksinSudahDone.contains(nama)) {
      return nama;
    }
  }
  return 'Semua lengkap ✓';
}

// ─────────────────────────────────────────────────────────────────────────────
// Daftar anak bersama – satu sumber kebenaran (mutable list)
//
// Dummy data per 26 Feb 2026:
//   • Bayi Asri  → lahir 26 Des 2025 → usia 2 bulan
//   • Kakak Budi → lahir 10 Nov 2022 → usia ±39 bulan (3 thn 3 bln)
// ─────────────────────────────────────────────────────────────────────────────
final List<DataAnak> globalAnakList = [
  DataAnak(
    id: '1',
    nama: 'Bayi Asri',
    tanggalLahir: DateTime(2025, 12, 26),
    jenisKelamin: JenisKelamin.perempuan,
    beratLahirKg: 3.2,
    golonganDarah: 'A',
    // Usia 2 bulan → vaksin 0 & 1 bulan sudah selesai
    vaksinSudahDone: {
      'Hepatitis B (HB-0)',
      'Polio 0 (OPV)',
      'BCG',
      'Polio 1 (OPV)',
    },
  ),
  DataAnak(
    id: '2',
    nama: 'Kakak Budi',
    tanggalLahir: DateTime(2022, 11, 10),
    jenisKelamin: JenisKelamin.lakilaki,
    beratLahirKg: 3.5,
    // Usia ±39 bulan → semua vaksin s.d. 24 bulan sudah selesai
    vaksinSudahDone: {
      'Hepatitis B (HB-0)',
      'Polio 0 (OPV)',
      'BCG',
      'Polio 1 (OPV)',
      'DPT-HB-Hib 1',
      'Polio 2 (OPV)',
      'PCV 1',
      'Rotavirus 1',
      'DPT-HB-Hib 2',
      'Polio 3 (OPV)',
      'PCV 2',
      'Rotavirus 2',
      'DPT-HB-Hib 3',
      'Polio 4 (OPV + IPV)',
      'PCV 3',
      'Campak-Rubela (MR) 1',
      'PCV 4',
      'JE (Japanese Encephalitis)',
      'Influenza',
      'DPT-HB-Hib 4 (Booster)',
      'Campak-Rubela (MR) 2 (Booster)',
      'Tifoid',
      'Hepatitis A',
    },
  ),
];

// ═════════════════════════════════════════════════════════════════════════════
// BAGIAN KEHAMILAN – Model, Enum & Data
// Referensi: Buku KIA 2024 – Imunisasi Tetanus untuk Ibu Hamil
// Prinsip: HCAI + GenderMag | Hanya TT – tidak ada vaksin lain untuk ibu
// ═════════════════════════════════════════════════════════════════════════════

// ─────────────────────────────────────────────────────────────────────────────
// Enum Trimester kehamilan
// ─────────────────────────────────────────────────────────────────────────────
enum Trimester { pertama, kedua, ketiga }

// ─────────────────────────────────────────────────────────────────────────────
// Enum Status Imunisasi TT ibu hamil
// ─────────────────────────────────────────────────────────────────────────────
enum StatusTT { belum, sudah1x, lengkap }

// ─────────────────────────────────────────────────────────────────────────────
// Model KonfirmasiTT – satu entri riwayat suntik TT
// ─────────────────────────────────────────────────────────────────────────────
class KonfirmasiTT {
  final DateTime tanggal;
  final String keterangan; // contoh: "Imunisasi Tetanus ke-1"

  KonfirmasiTT({required this.tanggal, required this.keterangan});
}

// ─────────────────────────────────────────────────────────────────────────────
// Model DataKehamilan – data lengkap kehamilan ibu
// ─────────────────────────────────────────────────────────────────────────────
class DataKehamilan {
  String namaIbu;

  /// Hari Pertama Haid Terakhir – dasar kalkulasi usia kehamilan
  DateTime tanggalHPHT;

  /// Riwayat konfirmasi TT yang sudah dilakukan selama kehamilan ini
  final List<KonfirmasiTT> riwayatTT;

  DataKehamilan({
    required this.namaIbu,
    required this.tanggalHPHT,
    List<KonfirmasiTT>? riwayatTT,
  }) : riwayatTT = riwayatTT ?? [];

  // ── Usia kehamilan dalam minggu penuh ──
  int get usiaMinggu {
    final selisih = DateTime.now().difference(tanggalHPHT).inDays;
    return (selisih / 7).floor().clamp(0, 42);
  }

  // ── Taksiran Persalinan (HPL) = HPHT + 280 hari (40 minggu) ──
  DateTime get hariPerkiraanLahir => tanggalHPHT.add(const Duration(days: 280));

  // ── Teks usia kehamilan dalam bahasa sederhana ──
  String get usiaTeks {
    final w = usiaMinggu;
    if (w < 4) return '$w minggu';
    final bln = (w / 4.3).floor();
    final sisaW = w - (bln * 4.3).round();
    if (sisaW <= 0) return '$bln bulan';
    return '$bln bulan $sisaW minggu';
  }

  // ── Trimester berdasarkan usia kehamilan ──
  Trimester get trimester {
    final w = usiaMinggu;
    if (w <= 12) return Trimester.pertama;
    if (w <= 27) return Trimester.kedua;
    return Trimester.ketiga;
  }

  // ── Label trimester ──
  String get trimesterTeks {
    switch (trimester) {
      case Trimester.pertama:
        return 'Trimester 1 (Minggu 1–12)';
      case Trimester.kedua:
        return 'Trimester 2 (Minggu 13–27)';
      case Trimester.ketiga:
        return 'Trimester 3 (Minggu 28–40)';
    }
  }

  // ── Label trimester singkat ──
  String get trimesterSingkat {
    switch (trimester) {
      case Trimester.pertama:
        return 'Trimester 1';
      case Trimester.kedua:
        return 'Trimester 2';
      case Trimester.ketiga:
        return 'Trimester 3';
    }
  }

  // ── Status TT berdasarkan jumlah konfirmasi ──
  StatusTT get statusTT {
    if (riwayatTT.isEmpty) return StatusTT.belum;
    if (riwayatTT.length == 1) return StatusTT.sudah1x;
    return StatusTT.lengkap;
  }

  // ── Apakah TT ke-2 sudah boleh dilakukan (min. 4 minggu setelah TT1) ──
  bool get bolehTT2 {
    if (riwayatTT.isEmpty) return false;
    final selisih = DateTime.now().difference(riwayatTT.first.tanggal).inDays;
    return selisih >= 28; // 4 minggu = 28 hari
  }

  // ── Sisa hari menuju boleh TT2 ──
  int get hariMenujuTT2 {
    if (riwayatTT.isEmpty || bolehTT2) return 0;
    final selisih = DateTime.now().difference(riwayatTT.first.tanggal).inDays;
    return 28 - selisih;
  }

  // ── Teks status TT ringkas ──
  String get statusTTTeks {
    switch (statusTT) {
      case StatusTT.belum:
        return 'Belum imunisasi';
      case StatusTT.sudah1x:
        return 'Sudah 1 kali';
      case StatusTT.lengkap:
        return 'Imunisasi lengkap ✓';
    }
  }

  // ── Inisial nama ibu untuk avatar ──
  String get inisial => namaIbu.isNotEmpty ? namaIbu[0].toUpperCase() : '?';
}

// ─────────────────────────────────────────────────────────────────────────────
// Rule-based: Rekomendasi TT berdasarkan kondisi kehamilan
// Referensi: Buku KIA 2024
// Tidak menggunakan API – kalkulasi murni frontend
// ─────────────────────────────────────────────────────────────────────────────
class RekomendasiTT {
  /// Pesan singkat yang ditampilkan di status card
  final String pesan;

  /// Penjelasan panjang untuk HCAI transparansi (chip biru)
  final String penjelasan;

  /// Apakah perlu tombol "Sudah Imunisasi" ditampilkan
  final bool perluAksi;

  const RekomendasiTT({
    required this.pesan,
    required this.penjelasan,
    required this.perluAksi,
  });
}

/// Engine rule-based: menerima [DataKehamilan] dan mengembalikan [RekomendasiTT]
RekomendasiTT hitungRekomendasiTT(DataKehamilan k) {
  final status = k.statusTT;

  // ── Sudah 2 kali → lengkap ──
  if (status == StatusTT.lengkap) {
    return const RekomendasiTT(
      pesan: 'Imunisasi tetanus sudah lengkap untuk kehamilan ini.',
      penjelasan:
          'Anda sudah mendapat 2 dosis imunisasi tetanus. '
          'Ibu dan bayi sudah terlindungi dari infeksi tetanus saat persalinan. 🌿',
      perluAksi: false,
    );
  }

  // ── Sudah 1 kali – belum 4 minggu untuk TT2 ──
  if (status == StatusTT.sudah1x && !k.bolehTT2) {
    final hariLagi = k.hariMenujuTT2;
    return RekomendasiTT(
      pesan: 'TT ke-2 bisa dilakukan $hariLagi hari lagi.',
      penjelasan:
          'Imunisasi tetanus kedua perlu diberikan minimal 4 minggu '
          'setelah dosis pertama agar tubuh membentuk perlindungan yang cukup kuat.',
      perluAksi: false,
    );
  }

  // ── Sudah 1 kali – sudah boleh TT2 ──
  if (status == StatusTT.sudah1x && k.bolehTT2) {
    return const RekomendasiTT(
      pesan: 'TT ke-2 sudah bisa dilakukan. Segera imunisasi ke Posyandu.',
      penjelasan:
          'Imunisasi tetanus kedua sudah boleh dilakukan. '
          'Segera kunjungi bidan atau Posyandu terdekat untuk perlindungan lengkap '
          'bagi ibu dan bayi.',
      perluAksi: true,
    );
  }

  // ── Belum sama sekali – Trimester 1 ──
  if (k.trimester == Trimester.pertama) {
    return const RekomendasiTT(
      pesan: 'Belum imunisasi — Segera lakukan di Trimester 1.',

      penjelasan:
          'Imunisasi tetanus pertama sebaiknya dilakukan sedini mungkin '
          'saat kehamilan agar tubuh punya waktu membentuk antibodi sebelum persalinan.',
      perluAksi: true,
    );
  }

  // ── Belum sama sekali – Trimester 2 atau 3 ──
  return const RekomendasiTT(
    pesan: 'Belum imunisasi — Segera lakukan sekarang.',
    penjelasan:
        'Imunisasi tetanus sangat penting untuk melindungi ibu dan bayi. '
        'Kunjungi bidan atau Posyandu sesegera mungkin.',
    perluAksi: true,
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// Data kehamilan bersama – satu sumber kebenaran (mutable)
//
// Dummy data per 2 Maret 2026:
//   • Ibu Asri → HPHT 10 Oktober 2025 → usia ±20 minggu (Trimester 2)
//   • Sudah TT ke-1 tanggal 5 Desember 2025 (Trimester 1)
//   • TT ke-2 sudah boleh (>4 minggu dari TT1) → tombol aksi muncul
// ─────────────────────────────────────────────────────────────────────────────
final DataKehamilan globalDataKehamilan = DataKehamilan(
  namaIbu: 'Asri',
  tanggalHPHT: DateTime(2025, 10, 10),
  riwayatTT: [
    KonfirmasiTT(
      tanggal: DateTime(2025, 12, 5),
      keterangan: 'Imunisasi Tetanus ke-1',
    ),
  ],
);

// ─────────────────────────────────────────────────────────────────────────────
// Model Data Pengguna – diisi saat registrasi
// ─────────────────────────────────────────────────────────────────────────────
class DataPengguna {
  String namaLengkap;
  String nomorHP;
  String desa;

  DataPengguna({
    required this.namaLengkap,
    required this.nomorHP,
    this.desa = '',
  });
}

/// Satu sumber kebenaran pengguna yang sedang login.
/// Diisi saat registrasi dan dapat diperbarui kemudian.
DataPengguna globalPengguna = DataPengguna(namaLengkap: 'Asri', nomorHP: '');
