// lib/screens/FiturKehamilan/pregnancy_screen.dart
// Halaman Hub Perjalanan Kehamilan – SEJIWA
// Desa Hutabulu Mejan | Studi Kasus TA-2026
// Referensi: Buku KIA 2024
// Pendekatan: HCAI + GenderMag | Fokus: ibu desa, literasi digital beragam

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/sejiwa_data.dart';
import 'pregnancy_immunization_screen.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Warna – konsisten dengan home_screen & child_data_screen
// ─────────────────────────────────────────────────────────────────────────────
class _C {
  static const hijauDaun = Color(0xFF3A7D44);
  static const hijauPucat = Color(0xFFE8F5E9);
  static const hijauMuda = Color(0xFF6BBF73);
  static const biruMuda = Color(0xFFE3F2FD);
  static const biruTeks = Color(0xFF1565C0);
  static const ungu = Color(0xFF6A1B9A);
  static const unguPucat = Color(0xFFF3E5F5);
  static const kuning = Color(0xFFF9A825);
  static const kuningPucat = Color(0xFFFFF8E1);
  static const putih = Color(0xFFFFFFFF);
  static const abuBg = Color(0xFFF5F5F5);
  static const teksUtama = Color(0xFF212121);
  static const teksAbu = Color(0xFF757575);
}

// ─────────────────────────────────────────────────────────────────────────────
// PregnancyScreen
// ─────────────────────────────────────────────────────────────────────────────
class PregnancyScreen extends StatefulWidget {
  const PregnancyScreen({super.key});

  @override
  State<PregnancyScreen> createState() => _PregnancyScreenState();
}

class _PregnancyScreenState extends State<PregnancyScreen> {
  // Ambil data dari sumber kebenaran tunggal
  DataKehamilan get _k => globalDataKehamilan;

  // ── Format tanggal Indonesia ──
  String _fmtTanggal(DateTime dt) => DateFormat('d MMMM yyyy', 'id').format(dt);

  // ── Warna & ikon per trimester ──
  Color _warnaTrimester(Trimester t) {
    switch (t) {
      case Trimester.pertama:
        return const Color(0xFF1976D2);
      case Trimester.kedua:
        return _C.hijauDaun;
      case Trimester.ketiga:
        return _C.ungu;
    }
  }

  Color _warnaBgTrimester(Trimester t) {
    switch (t) {
      case Trimester.pertama:
        return _C.biruMuda;
      case Trimester.kedua:
        return _C.hijauPucat;
      case Trimester.ketiga:
        return _C.unguPucat;
    }
  }

  IconData _ikonTrimester(Trimester t) {
    switch (t) {
      case Trimester.pertama:
        return Icons.spa_outlined;
      case Trimester.kedua:
        return Icons.favorite_outline;
      case Trimester.ketiga:
        return Icons.child_friendly_outlined;
    }
  }

  // ── Warna badge status TT ──
  Color _warnaTT(StatusTT s) {
    switch (s) {
      case StatusTT.belum:
        return const Color(0xFFBF360C);
      case StatusTT.sudah1x:
        return _C.kuning;
      case StatusTT.lengkap:
        return _C.hijauDaun;
    }
  }

  Color _warnaBgTT(StatusTT s) {
    switch (s) {
      case StatusTT.belum:
        return const Color(0xFFFBE9E7);
      case StatusTT.sudah1x:
        return _C.kuningPucat;
      case StatusTT.lengkap:
        return _C.hijauPucat;
    }
  }

  // ────────────────────────────────────────────────────────────────────────────
  // BUILD
  // ────────────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _C.abuBg,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderBanner(),
              const SizedBox(height: 20),
              _buildCardRingkasan(),
              const SizedBox(height: 12),
              _buildChipHCAI(),
              const SizedBox(height: 20),
              _buildSeksiSubFitur(),
              const SizedBox(height: 32),
            ],
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
        tooltip: 'Kembali ke halaman utama',
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Perjalanan Kehamilan',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            'Ibu & Bayi Sehat bersama SEJIWA',
            style: TextStyle(fontSize: 11, color: Colors.white70),
          ),
        ],
      ),
      actions: [
        Tooltip(
          message: 'Informasi fitur kehamilan',
          child: IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.white),
            onPressed: () => _showInfoDialog(),
          ),
        ),
        const SizedBox(width: 4),
      ],
    );
  }

  // ─────────────────────────────────────
  // HEADER BANNER (hijau melengkung)
  // ─────────────────────────────────────
  Widget _buildHeaderBanner() {
    final t = _k.trimester;
    final warnaTrim = _warnaTrimester(t);
    final warnaBgTrim = _warnaBgTrimester(t);

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: _C.hijauDaun,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nama ibu + avatar
          Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: Colors.white.withOpacity(0.25),
                child: Text(
                  _k.inisial,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ibu ${_k.namaIbu}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const Text(
                    'Pemantauan Kehamilan',
                    style: TextStyle(fontSize: 13, color: Colors.white70),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Pill usia kehamilan + trimester
          Row(
            children: [
              Flexible(
                child: _pillInfo(
                  ikon: Icons.pregnant_woman,
                  label: '${_k.usiaMinggu} Minggu',
                  sub: 'Usia Kehamilan',
                  warnaTeks: Colors.white,
                  warnaBg: Colors.white.withOpacity(0.18),
                ),
              ),
              const SizedBox(width: 10),
              Flexible(
                child: _pillInfo(
                  ikon: _ikonTrimester(t),
                  label: _k.trimesterSingkat,
                  sub: 'Fase Saat Ini',
                  warnaTeks: warnaTrim,
                  warnaBg: warnaBgTrim,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _pillInfo({
    required IconData ikon,
    required String label,
    required String sub,
    required Color warnaTeks,
    required Color warnaBg,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: warnaBg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(ikon, color: warnaTeks, size: 20),
          const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: warnaTeks,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  sub,
                  style: TextStyle(
                    fontSize: 11,
                    color: warnaTeks.withOpacity(0.85),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────
  // CARD RINGKASAN KEHAMILAN
  // ─────────────────────────────────────
  Widget _buildCardRingkasan() {
    final rekomendasi = hitungRekomendasiTT(_k);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: _C.putih,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header card
              const Row(
                children: [
                  Icon(
                    Icons.pregnant_woman_outlined,
                    color: _C.hijauDaun,
                    size: 22,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Ringkasan Kehamilan',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _C.teksUtama,
                    ),
                  ),
                ],
              ),

              const Divider(height: 24),

              // Baris data kehamilan
              _barisInfo(
                Icons.calendar_today_outlined,
                'Hari Pertama Haid Terakhir',
                _fmtTanggal(_k.tanggalHPHT),
              ),
              const SizedBox(height: 12),
              _barisInfo(
                Icons.child_friendly_outlined,
                'Taksiran Persalinan (HPL)',
                _fmtTanggal(_k.hariPerkiraanLahir),
              ),
              const SizedBox(height: 12),
              _barisInfo(
                Icons.schedule_outlined,
                'Usia Kehamilan',
                '${_k.usiaMinggu} minggu (${_k.usiaTeks})',
              ),
              const SizedBox(height: 12),
              _barisInfo(
                Icons.layers_outlined,
                'Fase Kehamilan',
                _k.trimesterTeks,
              ),

              const Divider(height: 24),

              // Status TT ringkas
              Row(
                children: [
                  const Icon(
                    Icons.vaccines_outlined,
                    color: _C.hijauDaun,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  const Flexible(
                    child: Text(
                      'Status Imunisasi Tetanus:',
                      style: TextStyle(fontSize: 13, color: _C.teksAbu),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _warnaBgTT(_k.statusTT),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _k.statusTTTeks,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: _warnaTT(_k.statusTT),
                      ),
                    ),
                  ),
                ],
              ),

              // Pesan rekomendasi
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: rekomendasi.perluAksi ? _C.kuningPucat : _C.hijauPucat,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(
                      _k.statusTT == StatusTT.belum
                          ? Icons.notifications_active_outlined
                          : Icons.check_circle_outline,
                      size: 18,
                      color: rekomendasi.perluAksi ? _C.kuning : _C.hijauDaun,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        rekomendasi.pesan,
                        style: TextStyle(
                          fontSize: 13,
                          color: rekomendasi.perluAksi
                              ? const Color(0xFF7B5800)
                              : const Color(0xFF1B5E20),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _barisInfo(IconData ikon, String label, String nilai) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(ikon, size: 18, color: _C.hijauMuda),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 12, color: _C.teksAbu),
              ),
              const SizedBox(height: 2),
              Text(
                nilai,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: _C.teksUtama,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────
  // HCAI CHIP BIRU – transparansi AI
  // ─────────────────────────────────────
  Widget _buildChipHCAI() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: _C.biruMuda,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Icon(Icons.info_outline, size: 18, color: _C.biruTeks),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'Semua informasi di halaman ini bersumber dari '
                'Buku KIA 2024. Sistem membantu Anda memantau '
                'kehamilan sesuai panduan resmi kesehatan.',
                style: TextStyle(fontSize: 13, color: _C.biruTeks, height: 1.4),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────
  // SEKSI SUB-FITUR KEHAMILAN
  // ─────────────────────────────────────
  Widget _buildSeksiSubFitur() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Layanan Kehamilan',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: _C.teksUtama,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Pilih layanan yang ingin Anda periksa',
            style: TextStyle(fontSize: 13, color: _C.teksAbu),
          ),
          const SizedBox(height: 14),

          // Kartu Imunisasi TT – fitur utama
          _kartulayanan(
            ikon: Icons.vaccines_outlined,
            warnaIkon: _C.hijauDaun,
            warnaBg: _C.hijauPucat,
            judul: 'Imunisasi Ibu Hamil',
            deskripsi:
                'Pantau status imunisasi tetanus '
                'untuk melindungi ibu dan bayi.',
            badgeLabel: _k.statusTTTeks,
            warnaBadge: _warnaTT(_k.statusTT),
            warnaBgBadge: _warnaBgTT(_k.statusTT),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const PregnancyImmunizationScreen(),
              ),
            ).then((_) => setState(() {})), // refresh saat kembali
          ),
        ],
      ),
    );
  }

  Widget _kartulayanan({
    required IconData ikon,
    required Color warnaIkon,
    required Color warnaBg,
    required String judul,
    required String deskripsi,
    required String badgeLabel,
    required Color warnaBadge,
    required Color warnaBgBadge,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: _C.putih,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: warnaIkon.withOpacity(0.15)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Ikon bulat
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: warnaBg,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(ikon, color: warnaIkon, size: 28),
            ),

            const SizedBox(width: 14),

            // Teks
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          judul,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: _C.teksUtama,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: warnaBgBadge,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          badgeLabel,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: warnaBadge,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    deskripsi,
                    style: const TextStyle(
                      fontSize: 13,
                      color: _C.teksAbu,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),
            Icon(
              Icons.chevron_right_rounded,
              color: warnaIkon.withOpacity(0.5),
              size: 22,
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────
  // DIALOG INFO
  // ─────────────────────────────────────
  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.info_outline, color: _C.hijauDaun),
            SizedBox(width: 8),
            Text(
              'Tentang Fitur Ini',
              style: TextStyle(fontSize: 16, color: _C.teksUtama),
            ),
          ],
        ),
        content: const Text(
          'Fitur Perjalanan Kehamilan membantu ibu memantau '
          'kesehatan selama masa kehamilan berdasarkan panduan '
          'Buku KIA 2024 dari Kementerian Kesehatan RI.\n\n'
          'Informasi yang ditampilkan bersifat edukatif dan '
          'tidak menggantikan saran medis dari bidan atau dokter.',
          style: TextStyle(fontSize: 14, height: 1.5, color: _C.teksAbu),
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

  // ─────────────────────────────────────
  // HELPER
  // ─────────────────────────────────────
}
