// lib/screens/FiturKehamilan/pregnancy_immunization_screen.dart
// Halaman Imunisasi Ibu Hamil (Tetanus) – SEJIWA
// Desa Hutabulu Mejan | Studi Kasus TA-2026
// Referensi: Buku KIA 2024 – Halaman 4 (Imunisasi Tetanus untuk Ibu Hamil)
//
// Prinsip GenderMag:
//   • Self-efficacy  → status jelas di atas, tidak ambigu
//   • Risk aversion  → penjelasan manfaat tersedia sebelum aksi
//   • Learning style → layout step per trimester, bukan tabel
//   • Motivation     → fokus ke perlindungan bayi, bukan kewajiban
//
// Prinsip HCAI:
//   • Transparansi   → chip biru menjelaskan mengapa TT penting
//   • Kontrol user   → ibu memilih sendiri tombol konfirmasi
//   • Tidak menggurui → tidak ada kata "Anda wajib", "harus"
//   • Asistif        → tampilan menyesuaikan usia kehamilan

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/sejiwa_data.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Warna – identik dengan pregnancy_screen & home_screen
// ─────────────────────────────────────────────────────────────────────────────
class _C {
  static const hijauDaun = Color(0xFF3A7D44);
  static const hijauPucat = Color(0xFFE8F5E9);
  static const hijauMuda = Color(0xFF6BBF73);
  static const biruMuda = Color(0xFFE3F2FD);
  static const biruTeks = Color(0xFF1565C0);
  static const kuning = Color(0xFFF9A825);
  static const kuningPucat = Color(0xFFFFF8E1);
  static const putih = Color(0xFFFFFFFF);
  static const abuBg = Color(0xFFF5F5F5);
  static const abuBorder = Color(0xFFE0E0E0);
  static const teksUtama = Color(0xFF212121);
  static const teksAbu = Color(0xFF757575);
  static const kuningGelap = Color(0xFF7B5800);
}

// ─────────────────────────────────────────────────────────────────────────────
// PregnancyImmunizationScreen
// ─────────────────────────────────────────────────────────────────────────────
class PregnancyImmunizationScreen extends StatefulWidget {
  const PregnancyImmunizationScreen({super.key});

  @override
  State<PregnancyImmunizationScreen> createState() =>
      _PregnancyImmunizationScreenState();
}

class _PregnancyImmunizationScreenState
    extends State<PregnancyImmunizationScreen> {
  DataKehamilan get _k => globalDataKehamilan;

  String _fmtTanggal(DateTime dt) => DateFormat('d MMMM yyyy', 'id').format(dt);

  // ────────────────────────────────────────────────────────────────────────────
  // BUILD
  // ────────────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final rekomendasi = hitungRekomendasiTT(_k);

    return Scaffold(
      backgroundColor: _C.abuBg,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                _buildChipTransparansi(rekomendasi),
                const SizedBox(height: 20),
                _buildTimeline(),
                const SizedBox(height: 16),
                _buildRiwayatTT(),
                const SizedBox(height: 20),
                if (rekomendasi.perluAksi) _buildTombolKonfirmasi(),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────
  // APP BAR
  // ─────────────────────────────────────
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: _C.hijauDaun,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
        tooltip: 'Kembali',
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Imunisasi Ibu Hamil',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            'Imunisasi Tetanus (TT) – Buku KIA 2024',
            style: TextStyle(fontSize: 11, color: Colors.white70),
          ),
        ],
      ),
      actions: [
        Tooltip(
          message: 'Apa itu imunisasi tetanus?',
          child: IconButton(
            icon: const Icon(Icons.help_outline, color: Colors.white),
            onPressed: _showInfoTT,
          ),
        ),
        const SizedBox(width: 4),
      ],
    );
  }

  // ─────────────────────────────────────
  // CHIP HCAI – TRANSPARANSI
  // ─────────────────────────────────────
  Widget _buildChipTransparansi(RekomendasiTT rekomendasi) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: _C.biruMuda,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.lightbulb_outline, size: 18, color: _C.biruTeks),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              rekomendasi.penjelasan,
              style: const TextStyle(
                fontSize: 13,
                color: _C.biruTeks,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────
  // TIMELINE PER TRIMESTER
  // (GenderMag: step-by-step, bukan tabel)
  // ─────────────────────────────────────
  Widget _buildTimeline() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Jadwal Imunisasi Tetanus',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: _C.teksUtama,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Berdasarkan Buku KIA 2024',
          style: TextStyle(fontSize: 12, color: _C.teksAbu),
        ),
        const SizedBox(height: 16),

        // Trimester 1 – TT ke-1
        _stepTrimester(
          nomor: 1,
          judulTrimester: 'Trimester 1  (Minggu 1–12)',
          namaVaksin: 'Imunisasi Tetanus ke-1',
          catatan: 'Sebaiknya dilakukan sedini mungkin saat kehamilan.',
          sudahDilakukan: _k.riwayatTT.isNotEmpty,
          tanggalKonfirmasi: _k.riwayatTT.isNotEmpty
              ? _k.riwayatTT.first.tanggal
              : null,
          isTrimesterSaatIni: _k.trimester == Trimester.pertama,
        ),

        _garsisPenghubung(),

        // Trimester 2 – TT ke-2
        _stepTrimester(
          nomor: 2,
          judulTrimester: 'Trimester 2  (Minggu 13–27)',
          namaVaksin: 'Imunisasi Tetanus ke-2',
          catatan: 'Minimal 4 minggu setelah TT pertama.',
          sudahDilakukan: _k.riwayatTT.length >= 2,
          tanggalKonfirmasi: _k.riwayatTT.length >= 2
              ? _k.riwayatTT[1].tanggal
              : null,
          isTrimesterSaatIni: _k.trimester == Trimester.kedua,
          pesanTambahan: _k.riwayatTT.length == 1 && !_k.bolehTT2
              ? '⏳ Dapat dilakukan ${_k.hariMenujuTT2} hari lagi'
              : null,
        ),

        _garsisPenghubung(),

        // Trimester 3 – pengingat persalinan
        _stepInfoSaja(
          judulTrimester: 'Trimester 3  (Minggu 28–40)',
          isi:
              'Jika TT sudah lengkap (2 dosis), Anda dan bayi sudah '
              'terlindungi. Tetap pantau kesehatan bersama bidan.',
        ),
      ],
    );
  }

  Widget _stepTrimester({
    required int nomor,
    required String judulTrimester,
    required String namaVaksin,
    required String catatan,
    required bool sudahDilakukan,
    DateTime? tanggalKonfirmasi,
    bool isTrimesterSaatIni = false,
    String? pesanTambahan,
  }) {
    final Color warnaStep = sudahDilakukan
        ? _C.hijauDaun
        : (isTrimesterSaatIni ? _C.kuning : _C.teksAbu);
    final Color warnaBgStep = sudahDilakukan
        ? _C.hijauPucat
        : (isTrimesterSaatIni ? _C.kuningPucat : const Color(0xFFEEEEEE));

    return Container(
      decoration: BoxDecoration(
        color: _C.putih,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isTrimesterSaatIni && !sudahDilakukan
              ? _C.kuning.withOpacity(0.5)
              : _C.abuBorder,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Lingkaran nomor / centang
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: warnaBgStep,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: sudahDilakukan
                  ? const Icon(
                      Icons.check_rounded,
                      color: _C.hijauDaun,
                      size: 26,
                    )
                  : Text(
                      '$nomor',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: warnaStep,
                      ),
                    ),
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Label trimester saat ini
                if (isTrimesterSaatIni)
                  Container(
                    margin: const EdgeInsets.only(bottom: 6),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: _C.kuning.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      '📍 Fase kehamilan Anda saat ini',
                      style: TextStyle(
                        fontSize: 11,
                        color: _C.kuningGelap,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                // Judul trimester
                Text(
                  judulTrimester,
                  style: const TextStyle(
                    fontSize: 12,
                    color: _C.teksAbu,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 4),

                // Nama vaksin
                Text(
                  namaVaksin,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: sudahDilakukan ? _C.hijauDaun : _C.teksUtama,
                  ),
                ),
                const SizedBox(height: 4),

                // Catatan
                Text(
                  catatan,
                  style: const TextStyle(
                    fontSize: 13,
                    color: _C.teksAbu,
                    height: 1.3,
                  ),
                ),

                // Tanggal konfirmasi (jika sudah)
                if (tanggalKonfirmasi != null) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.event_available_outlined,
                        size: 14,
                        color: _C.hijauMuda,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Dilakukan: ${_fmtTanggal(tanggalKonfirmasi)}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: _C.hijauDaun,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],

                // Pesan tambahan (misal: hitung mundur TT2)
                if (pesanTambahan != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    pesanTambahan,
                    style: const TextStyle(
                      fontSize: 12,
                      color: _C.kuningGelap,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _stepInfoSaja({required String judulTrimester, required String isi}) {
    return Container(
      decoration: BoxDecoration(
        color: _C.putih,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _C.abuBorder),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: _C.hijauPucat,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.child_friendly_outlined,
              color: _C.hijauDaun,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  judulTrimester,
                  style: const TextStyle(fontSize: 12, color: _C.teksAbu),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Menuju Persalinan',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: _C.teksUtama,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isi,
                  style: const TextStyle(
                    fontSize: 13,
                    color: _C.teksAbu,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _garsisPenghubung() {
    return Padding(
      padding: const EdgeInsets.only(left: 21),
      child: Container(width: 2, height: 20, color: _C.abuBorder),
    );
  }

  // ─────────────────────────────────────
  // RIWAYAT TT
  // ─────────────────────────────────────
  Widget _buildRiwayatTT() {
    if (_k.riwayatTT.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Riwayat Imunisasi',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: _C.teksUtama,
          ),
        ),
        const SizedBox(height: 10),
        ...List.generate(_k.riwayatTT.length, (i) {
          final tt = _k.riwayatTT[i];
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: _C.putih,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _C.hijauMuda.withOpacity(0.4)),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    color: _C.hijauPucat,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.vaccines,
                    color: _C.hijauDaun,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tt.keterangan,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: _C.teksUtama,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _fmtTanggal(tt.tanggal),
                        style: const TextStyle(fontSize: 12, color: _C.teksAbu),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.check_circle, color: _C.hijauDaun, size: 20),
              ],
            ),
          );
        }),
      ],
    );
  }

  // ─────────────────────────────────────
  // TOMBOL KONFIRMASI BESAR
  // (GenderMag: tombol besar, label jelas)
  // ─────────────────────────────────────
  Widget _buildTombolKonfirmasi() {
    final dosis = _k.riwayatTT.length + 1;
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => _showBottomSheetKonfirmasi(dosis),
        icon: const Icon(Icons.vaccines_outlined, size: 22),
        label: Text(
          'Sudah Imunisasi Tetanus ke-$dosis',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: _C.hijauDaun,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 2,
        ),
      ),
    );
  }

  // ─────────────────────────────────────
  // BOTTOM SHEET KONFIRMASI
  // (HCAI: user control, tidak menggurui)
  // ─────────────────────────────────────
  void _showBottomSheetKonfirmasi(int dosis) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
        return Container(
          decoration: const BoxDecoration(
            color: _C.putih,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 36),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: _C.abuBorder,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),

              const SizedBox(height: 20),

              // Ikon besar
              Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                  color: _C.hijauPucat,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.vaccines,
                  color: _C.hijauDaun,
                  size: 32,
                ),
              ),

              const SizedBox(height: 16),

              Text(
                'Konfirmasi Imunisasi Tetanus ke-$dosis',
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: _C.teksUtama,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 10),

              const Text(
                'Apakah Anda sudah mendapatkan imunisasi tetanus hari ini '
                'di Posyandu, Puskesmas, atau fasilitas kesehatan lainnya?',
                style: TextStyle(fontSize: 14, color: _C.teksAbu, height: 1.5),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),

              // Chip HCAI dalam bottom sheet
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: _C.biruMuda,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.info_outline, size: 15, color: _C.biruTeks),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Data ini hanya tersimpan di perangkat Anda '
                        'untuk membantu pemantauan.',
                        style: TextStyle(fontSize: 12, color: _C.biruTeks),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Tombol Ya, Sudah
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    _konfirmasiTT(dosis);
                  },
                  icon: const Icon(Icons.check_rounded, size: 20),
                  label: const Text(
                    'Ya, Sudah Imunisasi',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _C.hijauDaun,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Tombol Belum
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: _C.abuBorder),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Belum, Tutup',
                    style: TextStyle(
                      fontSize: 15,
                      color: _C.teksAbu,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ── Proses simpan konfirmasi TT ──
  void _konfirmasiTT(int dosis) {
    setState(() {
      globalDataKehamilan.riwayatTT.add(
        KonfirmasiTT(
          tanggal: DateTime.now(),
          keterangan: 'Imunisasi Tetanus ke-$dosis',
        ),
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Text(
              'Imunisasi Tetanus ke-$dosis berhasil dicatat! 🌿',
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
        backgroundColor: _C.hijauDaun,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // ─────────────────────────────────────
  // DIALOG INFO TT
  // ─────────────────────────────────────
  void _showInfoTT() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.vaccines_outlined, color: _C.hijauDaun),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'Tentang Imunisasi Tetanus',
                style: TextStyle(fontSize: 16, color: _C.teksUtama),
              ),
            ),
          ],
        ),
        content: const Text(
          'Imunisasi Tetanus (TT) melindungi ibu hamil dan bayi '
          'dari penyakit tetanus yang berbahaya saat persalinan.\n\n'
          'Berdasarkan Buku KIA 2024, ibu hamil perlu mendapat '
          '2 dosis imunisasi tetanus:\n'
          '• TT ke-1: sedini mungkin saat hamil\n'
          '• TT ke-2: minimal 4 minggu setelah TT ke-1\n\n'
          'Imunisasi ini tersedia gratis di Posyandu dan Puskesmas.',
          style: TextStyle(fontSize: 14, height: 1.6, color: _C.teksAbu),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Mengerti',
              style: TextStyle(
                color: _C.hijauDaun,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
