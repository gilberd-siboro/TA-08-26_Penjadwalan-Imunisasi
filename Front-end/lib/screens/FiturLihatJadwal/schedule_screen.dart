// lib/screens/schedule_screen.dart
// Halaman Jadwal Imunisasi Lengkap – SEJIWA
// Desa Hutabulu Mejan | Studi Kasus TA-2026
// Referensi: Buku KIA 2024 | Pendekatan: Human-Centered AI + GenderMag

import 'package:flutter/material.dart';
import '../../data/sejiwa_data.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Konstanta warna (sama dengan home_screen untuk konsistensi)
// ─────────────────────────────────────────────────────────────────────────────
class _C {
  static const hijauDaun = Color(0xFF3A7D44);
  static const hijauPucat = Color(0xFFE8F5E9);
  static const kuning = Color(0xFFF9A825);
  static const kuningBg = Color(0xFFFFF8E1);
  static const merah = Color(0xFFC62828);
  static const merahBg = Color(0xFFFFEBEE);
  static const abuTeks = Color(0xFF9E9E9E);
  static const abuBg = Color(0xFFF5F5F5);
  static const abuBorder = Color(0xFFE0E0E0);
  static const putih = Color(0xFFFFFFFF);
  static const teksUtama = Color(0xFF212121);
  static const teksAbu = Color(0xFF757575);
}

// ─────────────────────────────────────────────────────────────────────────────
// Enum & Model
// ─────────────────────────────────────────────────────────────────────────────
enum VaksinStatus { sudah, segera, terlewat, belum }

class VaksinItem {
  final String namaVaksin;
  final String usiaPemberian;
  final String deskripsi;
  VaksinStatus status;

  VaksinItem({
    required this.namaVaksin,
    required this.usiaPemberian,
    required this.deskripsi,
    required this.status,
  });
}

class GrupUsia {
  final String labelUsia;
  final String keterangan; // catatan kecil, mis. "Kunjungan Posyandu"
  final List<VaksinItem> vaksinList;

  const GrupUsia({
    required this.labelUsia,
    required this.keterangan,
    required this.vaksinList,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// Template jadwal dasar – Buku KIA 2024
// Status semua diset belum; _hitungStatusVaksin() akan override per anak
// ─────────────────────────────────────────────────────────────────────────────
List<GrupUsia> _buatJadwalDasar() {
  return [
    GrupUsia(
      labelUsia: '0 Bulan',
      keterangan: 'Diberikan saat lahir di fasilitas kesehatan',
      vaksinList: [
        VaksinItem(
          namaVaksin: 'Hepatitis B (HB-0)',
          usiaPemberian: '0–24 jam setelah lahir',
          deskripsi:
              'Vaksin Hepatitis B pertama diberikan sesegera mungkin setelah '
              'bayi lahir untuk mencegah penularan dari ibu ke bayi.',
          status: VaksinStatus.belum,
        ),
        VaksinItem(
          namaVaksin: 'Polio 0 (OPV)',
          usiaPemberian: '0–24 jam setelah lahir',
          deskripsi:
              'Vaksin Polio tetes pertama diberikan bersamaan dengan HB-0 '
              'untuk perlindungan dini terhadap penyakit polio.',
          status: VaksinStatus.belum,
        ),
      ],
    ),
    GrupUsia(
      labelUsia: '1 Bulan',
      keterangan: 'Posyandu Mejan atau Puskesmas Balige',
      vaksinList: [
        VaksinItem(
          namaVaksin: 'BCG',
          usiaPemberian: '1 bulan',
          deskripsi:
              'Vaksin BCG melindungi bayi dari penyakit TBC (Tuberkulosis). '
              'Diberikan sekali seumur hidup.',
          status: VaksinStatus.belum,
        ),
        VaksinItem(
          namaVaksin: 'Polio 1 (OPV)',
          usiaPemberian: '1 bulan',
          deskripsi:
              'Vaksin Polio tetes kedua untuk memperkuat perlindungan '
              'terhadap virus polio.',
          status: VaksinStatus.belum,
        ),
      ],
    ),
    GrupUsia(
      labelUsia: '2 Bulan',
      keterangan: 'Posyandu Mejan atau Puskesmas Balige',
      vaksinList: [
        VaksinItem(
          namaVaksin: 'DPT-HB-Hib 1',
          usiaPemberian: '2 bulan',
          deskripsi:
              'Vaksin kombinasi untuk mencegah Difteri, Pertusis (batuk '
              'rejan), Tetanus, Hepatitis B, dan Haemophilus influenzae.',
          status: VaksinStatus.belum,
        ),
        VaksinItem(
          namaVaksin: 'Polio 2 (OPV)',
          usiaPemberian: '2 bulan',
          deskripsi:
              'Vaksin Polio tetes ketiga sebagai bagian dari seri imunisasi '
              'polio lengkap.',
          status: VaksinStatus.belum,
        ),
        VaksinItem(
          namaVaksin: 'PCV 1',
          usiaPemberian: '2 bulan',
          deskripsi:
              'Vaksin PCV melindungi dari bakteri Pneumokokus penyebab '
              'radang paru-paru dan meningitis.',
          status: VaksinStatus.belum,
        ),
        VaksinItem(
          namaVaksin: 'Rotavirus 1',
          usiaPemberian: '2 bulan',
          deskripsi:
              'Vaksin Rotavirus mencegah diare berat akibat infeksi rotavirus '
              'yang umum pada bayi.',
          status: VaksinStatus.belum,
        ),
      ],
    ),
    GrupUsia(
      labelUsia: '3 Bulan',
      keterangan: 'Posyandu Mejan atau Puskesmas Balige',
      vaksinList: [
        VaksinItem(
          namaVaksin: 'DPT-HB-Hib 2',
          usiaPemberian: '3 bulan',
          deskripsi:
              'Suntikan kedua vaksin DPT-HB-Hib untuk memperkuat kekebalan '
              'terhadap kombinasi penyakit.',
          status: VaksinStatus.belum,
        ),
        VaksinItem(
          namaVaksin: 'Polio 3 (OPV)',
          usiaPemberian: '3 bulan',
          deskripsi: 'Polio tetes keempat untuk melengkapi seri dasar.',
          status: VaksinStatus.belum,
        ),
        VaksinItem(
          namaVaksin: 'PCV 2',
          usiaPemberian: '3 bulan',
          deskripsi: 'Dosis kedua vaksin PCV untuk perlindungan lebih kuat.',
          status: VaksinStatus.belum,
        ),
        VaksinItem(
          namaVaksin: 'Rotavirus 2',
          usiaPemberian: '3 bulan',
          deskripsi: 'Dosis kedua vaksin Rotavirus.',
          status: VaksinStatus.belum,
        ),
      ],
    ),
    GrupUsia(
      labelUsia: '4 Bulan',
      keterangan: 'Posyandu Mejan atau Puskesmas Balige',
      vaksinList: [
        VaksinItem(
          namaVaksin: 'DPT-HB-Hib 3',
          usiaPemberian: '4 bulan',
          deskripsi: 'Dosis ketiga dan terakhir dari seri dasar DPT-HB-Hib.',
          status: VaksinStatus.belum,
        ),
        VaksinItem(
          namaVaksin: 'Polio 4 (OPV + IPV)',
          usiaPemberian: '4 bulan',
          deskripsi:
              'Polio tetes kelima sekaligus suntikan IPV pertama untuk '
              'perlindungan maksimal.',
          status: VaksinStatus.belum,
        ),
        VaksinItem(
          namaVaksin: 'PCV 3',
          usiaPemberian: '4 bulan',
          deskripsi: 'Dosis ketiga vaksin PCV, melengkapi seri dasar.',
          status: VaksinStatus.belum,
        ),
      ],
    ),
    GrupUsia(
      labelUsia: '9 Bulan',
      keterangan: 'Posyandu Mejan atau Puskesmas Balige',
      vaksinList: [
        VaksinItem(
          namaVaksin: 'Campak-Rubela (MR) 1',
          usiaPemberian: '9 bulan',
          deskripsi:
              'Vaksin MR melindungi dari penyakit Campak dan Rubela. '
              'Rubela berbahaya untuk ibu hamil dan janin.',
          status: VaksinStatus.belum,
        ),
        VaksinItem(
          namaVaksin: 'PCV 4',
          usiaPemberian: '9 bulan',
          deskripsi: 'Dosis keempat PCV sebagai booster.',
          status: VaksinStatus.belum,
        ),
        VaksinItem(
          namaVaksin: 'JE (Japanese Encephalitis)',
          usiaPemberian: '9 bulan (daerah endemis)',
          deskripsi:
              'Vaksin JE untuk daerah endemis Japanese Encephalitis. '
              'Konsultasikan dengan petugas Puskesmas Balige.',
          status: VaksinStatus.belum,
        ),
      ],
    ),
    GrupUsia(
      labelUsia: '12 Bulan',
      keterangan: 'Puskesmas Balige',
      vaksinList: [
        VaksinItem(
          namaVaksin: 'Influenza',
          usiaPemberian: '12 bulan (tiap tahun)',
          deskripsi:
              'Vaksin Influenza diulang setiap tahun untuk perlindungan '
              'optimal terhadap flu.',
          status: VaksinStatus.belum,
        ),
      ],
    ),
    GrupUsia(
      labelUsia: '18 Bulan',
      keterangan: 'Posyandu Mejan atau Puskesmas Balige',
      vaksinList: [
        VaksinItem(
          namaVaksin: 'DPT-HB-Hib 4 (Booster)',
          usiaPemberian: '18 bulan',
          deskripsi:
              'Booster DPT-HB-Hib untuk mempertahankan kekebalan yang '
              'mulai menurun sejak seri dasar.',
          status: VaksinStatus.belum,
        ),
        VaksinItem(
          namaVaksin: 'Campak-Rubela (MR) 2 (Booster)',
          usiaPemberian: '18 bulan',
          deskripsi:
              'Booster MR untuk memastikan kekebalan terhadap campak dan '
              'rubela tetap terjaga.',
          status: VaksinStatus.belum,
        ),
      ],
    ),
    GrupUsia(
      labelUsia: '2 Tahun',
      keterangan: 'Puskesmas Balige',
      vaksinList: [
        VaksinItem(
          namaVaksin: 'Tifoid',
          usiaPemberian: '2 tahun (tiap 3 tahun)',
          deskripsi:
              'Vaksin Tifoid melindungi dari demam tifoid (tipes). '
              'Diulang setiap 3 tahun.',
          status: VaksinStatus.belum,
        ),
        VaksinItem(
          namaVaksin: 'Hepatitis A',
          usiaPemberian: '2 tahun (2 dosis)',
          deskripsi:
              'Vaksin Hepatitis A diberikan 2 dosis dengan jarak 6–12 bulan '
              'untuk perlindungan jangka panjang.',
          status: VaksinStatus.belum,
        ),
      ],
    ),
    GrupUsia(
      labelUsia: '5 Tahun',
      keterangan: 'Puskesmas Balige',
      vaksinList: [
        VaksinItem(
          namaVaksin: 'DPT 5 (Booster)',
          usiaPemberian: '5 tahun',
          deskripsi: 'Booster DPT sebelum masuk sekolah dasar.',
          status: VaksinStatus.belum,
        ),
        VaksinItem(
          namaVaksin: 'Campak-Rubela (MR) 3',
          usiaPemberian: '5 tahun',
          deskripsi:
              'Dosis MR ketiga sebagai bagian dari program imunisasi masuk '
              'sekolah.',
          status: VaksinStatus.belum,
        ),
        VaksinItem(
          namaVaksin: 'Polio (IPV 2)',
          usiaPemberian: '5 tahun',
          deskripsi: 'Booster IPV terakhir untuk perlindungan polio penuh.',
          status: VaksinStatus.belum,
        ),
      ],
    ),
  ];
}

// ─────────────────────────────────────────────────────────────────────────────
// ScheduleScreen
// ─────────────────────────────────────────────────────────────────────────────
class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  late DataAnak _selectedAnak;
  late List<GrupUsia> _jadwalList;

  @override
  void initState() {
    super.initState();
    _selectedAnak = globalAnakList.isNotEmpty
        ? globalAnakList.first
        : DataAnak(
            id: '0',
            nama: 'Tidak ada anak',
            tanggalLahir: DateTime.now(),
            jenisKelamin: JenisKelamin.perempuan,
          );
    _jadwalList = _hitungStatusVaksin(_selectedAnak);
  }

  // ————————————————————————————
  // Kalkulasi status vaksin berdasarkan usia anak
  // ————————————————————————————
  int _usiaBulanGrup(String label) {
    switch (label) {
      case '0 Bulan':
        return 0;
      case '1 Bulan':
        return 1;
      case '2 Bulan':
        return 2;
      case '3 Bulan':
        return 3;
      case '4 Bulan':
        return 4;
      case '9 Bulan':
        return 9;
      case '12 Bulan':
        return 12;
      case '18 Bulan':
        return 18;
      case '2 Tahun':
        return 24;
      case '5 Tahun':
        return 60;
      default:
        return 0;
    }
  }

  List<GrupUsia> _hitungStatusVaksin(DataAnak anak) {
    final bln = anak.usiaBulan;
    return _buatJadwalDasar().map((grup) {
      final grupUsia = _usiaBulanGrup(grup.labelUsia);
      return GrupUsia(
        labelUsia: grup.labelUsia,
        keterangan: grup.keterangan,
        vaksinList: grup.vaksinList.map((v) {
          VaksinStatus status;
          if (anak.vaksinSudahDone.contains(v.namaVaksin)) {
            status = VaksinStatus.sudah;
          } else if (grupUsia < bln) {
            // Lewat masa pemberian & belum selesai
            status = VaksinStatus.terlewat;
          } else if (grupUsia <= bln + 1) {
            // Bulan ini atau bulan depan – saatnya imunisasi!
            status = VaksinStatus.segera;
          } else {
            // Belum waktunya
            status = VaksinStatus.belum;
          }
          return VaksinItem(
            namaVaksin: v.namaVaksin,
            usiaPemberian: v.usiaPemberian,
            deskripsi: v.deskripsi,
            status: status,
          );
        }).toList(),
      );
    }).toList();
  }

  // ────────────────────────────
  // HELPER – warna per status
  // ────────────────────────────
  Color _warnaBorder(VaksinStatus s) {
    switch (s) {
      case VaksinStatus.sudah:
        return _C.hijauDaun;
      case VaksinStatus.segera:
        return _C.kuning;
      case VaksinStatus.terlewat:
        return _C.merah;
      case VaksinStatus.belum:
        return _C.abuBorder;
    }
  }

  Color _warnaChipBg(VaksinStatus s) {
    switch (s) {
      case VaksinStatus.sudah:
        return _C.hijauPucat;
      case VaksinStatus.segera:
        return _C.kuningBg;
      case VaksinStatus.terlewat:
        return _C.merahBg;
      case VaksinStatus.belum:
        return _C.abuBg;
    }
  }

  Color _warnaChipTeks(VaksinStatus s) {
    switch (s) {
      case VaksinStatus.sudah:
        return _C.hijauDaun;
      case VaksinStatus.segera:
        return _C.kuning;
      case VaksinStatus.terlewat:
        return _C.merah;
      case VaksinStatus.belum:
        return _C.abuTeks;
    }
  }

  String _labelStatus(VaksinStatus s) {
    switch (s) {
      case VaksinStatus.sudah:
        return '✓ Sudah';
      case VaksinStatus.segera:
        return '⏰ Segera';
      case VaksinStatus.terlewat:
        return '! Terlewat';
      case VaksinStatus.belum:
        return '○ Belum';
    }
  }

  IconData _ikonStatus(VaksinStatus s) {
    switch (s) {
      case VaksinStatus.sudah:
        return Icons.check_circle;
      case VaksinStatus.segera:
        return Icons.access_time_filled;
      case VaksinStatus.terlewat:
        return Icons.warning_rounded;
      case VaksinStatus.belum:
        return Icons.radio_button_unchecked;
    }
  }

  // Hanya usia yang memiliki item berstatus terlewat/segera yang "aktif"
  bool _isGrupAktif(GrupUsia g) => g.vaksinList.any(
    (v) => v.status == VaksinStatus.segera || v.status == VaksinStatus.terlewat,
  );

  // ────────────────────────────
  // BUILD
  // ────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _C.abuBg,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildHeader(),
          _buildLegenda(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
              itemCount: _jadwalList.length,
              itemBuilder: (ctx, i) => _buildGrupUsia(
                _jadwalList[i],
                isLast: i == _jadwalList.length - 1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ────────────────────────────
  // APP BAR
  // ────────────────────────────
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: _C.hijauDaun,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
        onPressed: () => Navigator.maybePop(context),
      ),
      title: const Text(
        'Jadwal Imunisasi Anak',
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        Tooltip(
          message: 'Informasi jadwal imunisasi',
          child: IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.white),
            onPressed: () => _showInfoDialog(),
          ),
        ),
      ],
    );
  }

  // ────────────────────────────
  // HEADER – dropdown pilih anak + ringkasan
  // ────────────────────────────
  Widget _buildHeader() {
    // Hitung ringkasan
    final allVaksin = _jadwalList.expand((g) => g.vaksinList).toList();
    final sudah = allVaksin.where((v) => v.status == VaksinStatus.sudah).length;
    final segera = allVaksin
        .where((v) => v.status == VaksinStatus.segera)
        .length;
    final terlewat = allVaksin
        .where((v) => v.status == VaksinStatus.terlewat)
        .length;
    final total = allVaksin.length;

    return Container(
      color: _C.hijauDaun,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dropdown pilih anak
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: DropdownButton<DataAnak>(
              value: _selectedAnak,
              isExpanded: true,
              underline: const SizedBox(),
              icon: const Icon(Icons.keyboard_arrow_down, color: _C.hijauDaun),
              style: const TextStyle(
                color: _C.teksUtama,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
              items: globalAnakList
                  .map(
                    (a) => DropdownMenuItem<DataAnak>(
                      value: a,
                      child: Text('${a.nama}  (${a.usiaTeks})'),
                    ),
                  )
                  .toList(),
              onChanged: (val) {
                if (val != null) {
                  setState(() {
                    _selectedAnak = val;
                    _jadwalList = _hitungStatusVaksin(val);
                  });
                }
              },
            ),
          ),

          const SizedBox(height: 14),

          // Ringkasan status
          Row(
            children: [
              _chipRingkasan('$sudah Sudah', _C.hijauDaun, _C.hijauPucat),
              const SizedBox(width: 8),
              _chipRingkasan('$segera Segera', _C.kuning, _C.kuningBg),
              const SizedBox(width: 8),
              _chipRingkasan('$terlewat Terlewat', _C.merah, _C.merahBg),
              const Spacer(),
              Text(
                '$sudah/$total',
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Progress bar keseluruhan
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: sudah / total,
              minHeight: 8,
              backgroundColor: Colors.white24,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chipRingkasan(String label, Color teks, Color bg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: teks,
        ),
      ),
    );
  }

  // ────────────────────────────
  // LEGENDA
  // ────────────────────────────
  Widget _buildLegenda() {
    return Container(
      color: _C.putih,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          const Text(
            'Keterangan: ',
            style: TextStyle(fontSize: 12, color: _C.teksAbu),
          ),
          _legendaItem(Icons.check_circle, 'Sudah', _C.hijauDaun),
          const SizedBox(width: 10),
          _legendaItem(Icons.access_time_filled, 'Segera', _C.kuning),
          const SizedBox(width: 10),
          _legendaItem(Icons.warning_rounded, 'Terlewat', _C.merah),
          const SizedBox(width: 10),
          _legendaItem(Icons.radio_button_unchecked, 'Belum', _C.abuTeks),
        ],
      ),
    );
  }

  Widget _legendaItem(IconData icon, String label, Color warna) {
    return Row(
      children: [
        Icon(icon, size: 13, color: warna),
        const SizedBox(width: 3),
        Text(label, style: TextStyle(fontSize: 11, color: warna)),
      ],
    );
  }

  // ────────────────────────────
  // GRUP USIA – timeline card
  // ────────────────────────────
  Widget _buildGrupUsia(GrupUsia grup, {required bool isLast}) {
    final aktif = _isGrupAktif(grup);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── garis timeline kiri ──
          SizedBox(
            width: 36,
            child: Column(
              children: [
                // Lingkaran penanda
                Container(
                  width: 18,
                  height: 18,
                  margin: const EdgeInsets.only(top: 18),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: aktif ? _C.kuning : _C.abuBorder,
                    border: Border.all(
                      color: aktif ? _C.kuning : _C.abuBorder,
                      width: 2,
                    ),
                  ),
                  child: aktif
                      ? const Icon(Icons.circle, size: 8, color: Colors.white)
                      : null,
                ),
                // Garis vertikal
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: _C.abuBorder,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // ── konten card ──
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Label usia
                  Padding(
                    padding: const EdgeInsets.only(top: 14, bottom: 6),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: aktif ? _C.kuningBg : _C.abuBg,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: aktif ? _C.kuning : _C.abuBorder,
                            ),
                          ),
                          child: Text(
                            'Usia ${grup.labelUsia}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: aktif ? _C.kuning : _C.teksAbu,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            grup.keterangan,
                            style: const TextStyle(
                              fontSize: 11,
                              color: _C.teksAbu,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // List vaksin dalam usia ini
                  ...grup.vaksinList.asMap().entries.map(
                    (e) => _buildVaksinItem(e.value, grup),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ────────────────────────────
  // VAKSIN ITEM CARD
  // ────────────────────────────
  Widget _buildVaksinItem(VaksinItem vaksin, GrupUsia grup) {
    final warnaBorder = _warnaBorder(vaksin.status);
    final warnaChipBg = _warnaChipBg(vaksin.status);
    final warnaChipTeks = _warnaChipTeks(vaksin.status);
    final labelStatus = _labelStatus(vaksin.status);
    final ikon = _ikonStatus(vaksin.status);

    return GestureDetector(
      onTap: () => _showDetailSheet(vaksin, grup),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: _C.putih,
          borderRadius: BorderRadius.circular(12),
          border: Border(left: BorderSide(color: warnaBorder, width: 4)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Icon(ikon, color: warnaBorder, size: 22),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      vaksin.namaVaksin,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: _C.teksUtama,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      vaksin.usiaPemberian,
                      style: const TextStyle(fontSize: 12, color: _C.teksAbu),
                    ),
                  ],
                ),
              ),
              // Chip status
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: warnaChipBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  labelStatus,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: warnaChipTeks,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              const Icon(Icons.chevron_right, size: 18, color: _C.teksAbu),
            ],
          ),
        ),
      ),
    );
  }

  // ────────────────────────────
  // BOTTOM SHEET DETAIL
  // ────────────────────────────
  void _showDetailSheet(VaksinItem vaksin, GrupUsia grup) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _DetailSheet(
        vaksin: vaksin,
        labelUsia: grup.labelUsia,
        onTandaiSudah: () {
          setState(() {
            // Simpan ke done-set anak agar persisten saat ganti anak
            _selectedAnak.vaksinSudahDone.add(vaksin.namaVaksin);
            // Hitung ulang seluruh jadwal
            _jadwalList = _hitungStatusVaksin(_selectedAnak);
          });
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '${vaksin.namaVaksin} ditandai sudah imunisasi. ✓',
                style: const TextStyle(fontSize: 14),
              ),
              backgroundColor: _C.hijauDaun,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              duration: const Duration(seconds: 2),
            ),
          );
        },
      ),
    );
  }

  // ────────────────────────────
  // DIALOG INFO
  // ────────────────────────────
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
              'Tentang Jadwal Ini',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: const Text(
          'Jadwal imunisasi ini disusun berdasarkan Buku KIA 2024 '
          'yang diterbitkan Kementerian Kesehatan RI.\n\n'
          'Lokasi layanan:\n'
          '• Posyandu Mejan (tiap bulan)\n'
          '• Puskesmas Balige\n\n'
          'Pengingat disesuaikan dengan usia dan riwayat kunjungan anak.',
          style: TextStyle(fontSize: 14, height: 1.5),
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

// ─────────────────────────────────────────────────────────────────────────────
// Bottom Sheet Detail Vaksin
// ─────────────────────────────────────────────────────────────────────────────
class _DetailSheet extends StatelessWidget {
  final VaksinItem vaksin;
  final String labelUsia;
  final VoidCallback onTandaiSudah;

  const _DetailSheet({
    required this.vaksin,
    required this.labelUsia,
    required this.onTandaiSudah,
  });

  @override
  Widget build(BuildContext context) {
    final sudah = vaksin.status == VaksinStatus.sudah;

    return DraggableScrollableSheet(
      initialChildSize: 0.52,
      minChildSize: 0.4,
      maxChildSize: 0.85,
      builder: (_, controller) => Container(
        decoration: const BoxDecoration(
          color: _C.putih,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          children: [
            // Handle
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: _C.abuBorder,
                borderRadius: BorderRadius.circular(4),
              ),
            ),

            Expanded(
              child: ListView(
                controller: controller,
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                children: [
                  // Nama vaksin + badge usia
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          vaksin.namaVaksin,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: _C.teksUtama,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _C.hijauPucat,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Usia $labelUsia',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: _C.hijauDaun,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  // Usia pemberian
                  Row(
                    children: [
                      const Icon(Icons.schedule, size: 14, color: _C.teksAbu),
                      const SizedBox(width: 6),
                      Text(
                        vaksin.usiaPemberian,
                        style: const TextStyle(fontSize: 13, color: _C.teksAbu),
                      ),
                    ],
                  ),

                  const Divider(height: 28),

                  // Deskripsi
                  const Text(
                    'Tentang Vaksin Ini',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: _C.teksUtama,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    vaksin.deskripsi,
                    style: const TextStyle(
                      fontSize: 14,
                      color: _C.teksAbu,
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Info lokasi
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: _C.abuBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.location_on, color: _C.hijauDaun, size: 18),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Tersedia di Posyandu Mejan dan Puskesmas Balige',
                            style: TextStyle(fontSize: 13, color: _C.teksUtama),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Tombol aksi
                  if (!sudah)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: onTandaiSudah,
                        icon: const Icon(Icons.check_circle_outline, size: 20),
                        label: const Text(
                          'Tandai Sudah Imunisasi',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
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
                    )
                  else
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: _C.hijauPucat,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: _C.hijauDaun,
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Imunisasi ini sudah selesai',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: _C.hijauDaun,
                            ),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 8),

                  // Tutup
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Tutup',
                        style: TextStyle(color: _C.teksAbu, fontSize: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
