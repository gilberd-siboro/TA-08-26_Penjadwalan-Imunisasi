// lib/data/sejiwa_data.dart
// ─── Single Source of Truth – Model & Data Bersama SEJIWA ───
// Digunakan oleh: child_data_screen.dart & schedule_screen.dart
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
