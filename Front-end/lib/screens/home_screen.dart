// lib/screens/home_screen.dart
// Halaman Utama – SEJIWA: Sistem Imunisasi Ibu dan Anak
// Desa Hutabulu Mejan | Studi Kasus TA-2026
// Pendekatan: Human-Centered AI + GenderMag | Referensi: Buku KIA 2024

import 'package:flutter/material.dart';
import 'FiturLihatJadwal/schedule_screen.dart';
import 'FiturAnak/child_data_screen.dart';
import 'FiturKehamilan/pregnancy_screen.dart';
import 'login_screen.dart';

// ---------------------------------------------------------------------------
// Konstanta warna aplikasi
// ---------------------------------------------------------------------------
class _AppColors {
  static const hijauDaun = Color(0xFF3A7D44);
  static const hijauMuda = Color(0xFF6BBF73);
  static const hijauPucat = Color(0xFFE8F5E9);
  static const biruMuda = Color(0xFFE3F2FD);
  static const biruTeks = Color(0xFF1565C0);
  static const kuningPucat = Color(0xFFFFF8E1);
  static const putih = Color(0xFFFFFFFF);
  static const abuMuda = Color(0xFFF5F5F5);
  static const teksUtama = Color(0xFF212121);
  static const teksAbu = Color(0xFF757575);
}

// ---------------------------------------------------------------------------
// Model & enum
// ---------------------------------------------------------------------------
enum StatusJadwal { aman, mendekati, terlambat }

class JadwalItem {
  final String namaAnak;
  final String jenisVaksin;
  final String tanggal;
  final String lokasi;
  final StatusJadwal status;
  final int sisaHari;
  const JadwalItem({
    required this.namaAnak,
    required this.jenisVaksin,
    required this.tanggal,
    required this.lokasi,
    required this.status,
    required this.sisaHari,
  });
}

// ---------------------------------------------------------------------------
// HomeScreen – StatefulWidget
// ---------------------------------------------------------------------------
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedNavIndex = 0;

  // Simulasi mode offline – ubah true untuk test banner
  final bool _isOffline = false;

  final JadwalItem _jadwalTerdekat = const JadwalItem(
    namaAnak: 'Bayi Asri',
    jenisVaksin: 'DPT tahap 3',
    tanggal: '12 Maret 2026',
    lokasi: 'Posyandu Mejan',
    status: StatusJadwal.mendekati,
    sisaHari: 5,
  );

  final int _imunisasiSelesai = 4;
  final int _imunisasiTotal = 8;
  final String _namaUser = 'Asri';
  final String _roleUser = 'Ibu'; // 'Ibu' atau 'Ayah'

  String get _greetingWaktu {
    final jam = DateTime.now().hour;
    if (jam < 11) return 'Selamat pagi';
    if (jam < 15) return 'Selamat siang';
    if (jam < 18) return 'Selamat sore';
    return 'Selamat malam';
  }

  String get _labelRole => _roleUser == 'Ibu' ? 'Ibu' : 'Ayah';

  Color _warnaStatus(StatusJadwal s) {
    switch (s) {
      case StatusJadwal.aman:
        return _AppColors.hijauDaun;
      case StatusJadwal.mendekati:
        return const Color(0xFFF9A825);
      case StatusJadwal.terlambat:
        return const Color(0xFFB71C1C);
    }
  }

  Color _warnaStatusBg(StatusJadwal s) {
    switch (s) {
      case StatusJadwal.aman:
        return _AppColors.hijauPucat;
      case StatusJadwal.mendekati:
        return _AppColors.kuningPucat;
      case StatusJadwal.terlambat:
        return const Color(0xFFFFEBEE);
    }
  }

  String _labelStatus(StatusJadwal s) {
    switch (s) {
      case StatusJadwal.aman:
        return 'Aman';
      case StatusJadwal.mendekati:
        return 'Segera';
      case StatusJadwal.terlambat:
        return 'Terlambat';
    }
  }

  // ─────────────────────────────────────
  // BUILD
  // ─────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _AppColors.abuMuda,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_isOffline) _buildOfflineBanner(),
              _buildGreetingSection(),
              const SizedBox(height: 20),
              _buildShortcutMenu(),
              const SizedBox(height: 20),
              _buildCardJadwalTerdekat(),
              const SizedBox(height: 8),
              _buildAiChip(),
              const SizedBox(height: 16),
              _buildCardStatusImunisasi(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // ─────────────────────────────────────
  // APP BAR
  // ─────────────────────────────────────
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: _AppColors.hijauDaun,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          CircleAvatar(
            radius: 19,
            backgroundColor: Colors.white.withOpacity(0.25),
            child: const Icon(
              Icons.local_hospital,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 10),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'SEJIWA',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),
              Text(
                'Sistem Imunisasi Ibu & Anak',
                style: TextStyle(fontSize: 11, color: Colors.white70),
              ),
            ],
          ),
        ],
      ),
      actions: [
        Tooltip(
          message: 'Lihat notifikasi pengingat jadwal',
          child: IconButton(
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(
                  Icons.notifications_outlined,
                  color: Colors.white,
                  size: 26,
                ),
                Positioned(
                  top: -2,
                  right: -2,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF9A825),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
            onPressed: () =>
                _snackInfo('Fitur notifikasi akan segera tersedia.'),
          ),
        ),
        Tooltip(
          message: 'Keluar dari akun',
          child: IconButton(
            icon: const Icon(
              Icons.logout_rounded,
              color: Colors.white,
              size: 24,
            ),
            onPressed: _konfirmasiKeluar,
          ),
        ),
        const SizedBox(width: 4),
      ],
    );
  }

  // ─────────────────────────────────────
  // OFFLINE BANNER
  // ─────────────────────────────────────
  Widget _buildOfflineBanner() {
    return Container(
      width: double.infinity,
      color: const Color(0xFFFFF3CD),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: const [
          Icon(Icons.wifi_off, size: 16, color: Color(0xFF856404)),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Mode offline. Data akan diperbarui saat tersambung internet.',
              style: TextStyle(fontSize: 13, color: Color(0xFF856404)),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────
  // GREETING
  // ─────────────────────────────────────
  Widget _buildGreetingSection() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: _AppColors.hijauDaun,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '$_greetingWaktu, $_labelRole $_namaUser ',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const TextSpan(text: '🌿', style: TextStyle(fontSize: 20)),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            _jadwalTerdekat.sisaHari == 0
                ? 'Jadwal imunisasi hari ini!'
                : 'Jadwal imunisasi berikutnya '
                      '${_jadwalTerdekat.sisaHari} hari lagi.',
            style: const TextStyle(fontSize: 15, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────
  // CARD JADWAL TERDEKAT
  // ─────────────────────────────────────
  Widget _buildCardJadwalTerdekat() {
    final j = _jadwalTerdekat;
    final warna = _warnaStatus(j.status);
    final warnaBg = _warnaStatusBg(j.status);
    final label = _labelStatus(j.status);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: warna.withOpacity(0.6), width: 1.5),
        ),
        color: _AppColors.putih,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header card
              Row(
                children: [
                  Icon(Icons.event_available, color: warna, size: 22),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Jadwal Imunisasi Terdekat',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: _AppColors.teksUtama,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: warnaBg,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      label,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: warna,
                      ),
                    ),
                  ),
                ],
              ),

              const Divider(height: 20),

              _infoBaris(Icons.child_care, j.namaAnak, 'Nama Anak'),
              const SizedBox(height: 10),
              _infoBaris(Icons.vaccines, j.jenisVaksin, 'Jenis Imunisasi'),
              const SizedBox(height: 10),
              _infoBaris(Icons.calendar_today, j.tanggal, 'Tanggal'),
              const SizedBox(height: 10),
              _infoBaris(Icons.location_on, j.lokasi, 'Lokasi'),

              const SizedBox(height: 14),

              // CTA – teks jelas, tidak berisiko (GenderMag: risk aversion)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _snackInfo('Membuka detail jadwal lengkap…'),
                  icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                  label: const Text(
                    'Lihat Detail Jadwal',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _AppColors.hijauDaun,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoBaris(IconData icon, String nilai, String label) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: _AppColors.hijauMuda),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: _AppColors.teksAbu),
            ),
            Text(
              nilai,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: _AppColors.teksUtama,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ─────────────────────────────────────
  // AI EXPLANATION CHIP
  // ─────────────────────────────────────
  Widget _buildAiChip() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: _AppColors.biruMuda,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: const [
            Icon(Icons.info_outline, size: 16, color: _AppColors.biruTeks),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'Pengingat ini disesuaikan dengan jadwal anak '
                'dan riwayat kunjungan Anda.',
                style: TextStyle(fontSize: 13, color: _AppColors.biruTeks),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────
  // CARD STATUS IMUNISASI
  // ─────────────────────────────────────
  Widget _buildCardStatusImunisasi() {
    final progres = _imunisasiSelesai / _imunisasiTotal;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: _AppColors.putih,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(
                    Icons.verified_outlined,
                    color: _AppColors.hijauDaun,
                    size: 22,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Status Imunisasi Anak',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _AppColors.teksUtama,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              const Text(
                'Imunisasi Anak',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: _AppColors.teksUtama,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '$_imunisasiSelesai dari $_imunisasiTotal sudah lengkap',
                style: const TextStyle(fontSize: 14, color: _AppColors.teksAbu),
              ),

              const SizedBox(height: 12),

              // LinearProgressIndicator – tidak pakai grafik rumit
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: progres,
                  minHeight: 14,
                  backgroundColor: _AppColors.hijauPucat,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    _AppColors.hijauDaun,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${(progres * 100).round()}% selesai',
                    style: const TextStyle(
                      fontSize: 13,
                      color: _AppColors.hijauDaun,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  // Microcopy – GenderMag self-efficacy
                  Text(
                    '${_imunisasiTotal - _imunisasiSelesai} lagi menuju lengkap',
                    style: const TextStyle(
                      fontSize: 13,
                      color: _AppColors.teksAbu,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────
  // SHORTCUT MENU 2x2
  // ─────────────────────────────────────
  Widget _buildShortcutMenu() {
    final menus = [
      _MenuData(
        icon: Icons.calendar_month_outlined,
        label: 'Jadwal\nLengkap',
        tooltip: 'Lihat semua jadwal imunisasi',
        color: _AppColors.hijauDaun,
        colorBg: _AppColors.hijauPucat,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ScheduleScreen()),
        ),
      ),
      _MenuData(
        icon: Icons.child_care_outlined,
        label: 'Data\nAnak',
        tooltip: 'Lihat dan tambah data anak',
        color: const Color(0xFF1565C0),
        colorBg: _AppColors.biruMuda,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ChildDataScreen()),
        ),
      ),
      _MenuData(
        icon: Icons.pregnant_woman_outlined,
        label: 'Data\nKehamilan',
        tooltip: 'Lihat data kehamilan',
        color: const Color(0xFF6A1B9A),
        colorBg: const Color(0xFFF3E5F5),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const PregnancyScreen()),
        ),
      ),
      _MenuData(
        icon: Icons.location_on_outlined,
        label: 'Lokasi\nLayanan',
        tooltip: 'Posyandu Mejan & Puskesmas Balige',
        color: const Color(0xFFBF360C),
        colorBg: const Color(0xFFFBE9E7),
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Menu Utama',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: _AppColors.teksUtama,
            ),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.55,
            ),
            itemCount: menus.length,
            itemBuilder: (ctx, i) => _menuTile(menus[i]),
          ),
        ],
      ),
    );
  }

  Widget _menuTile(_MenuData m) {
    return Tooltip(
      message: m.tooltip,
      child: GestureDetector(
        onTap: m.onTap ?? () => _snackInfo(m.tooltip),
        child: Container(
          decoration: BoxDecoration(
            color: m.colorBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: m.color.withOpacity(0.2)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: m.color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(m.icon, color: m.color, size: 28),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  m.label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: m.color,
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────
  // BOTTOM NAVIGATION BAR
  // ─────────────────────────────────────
  Widget _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: _selectedNavIndex,
      onTap: (i) {
        if (i == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ScheduleScreen()),
          );
          return;
        }
        setState(() => _selectedNavIndex = i);
      },
      type: BottomNavigationBarType.fixed,
      selectedItemColor: _AppColors.hijauDaun,
      unselectedItemColor: _AppColors.teksAbu,
      selectedFontSize: 13,
      unselectedFontSize: 12,
      elevation: 10,
      backgroundColor: _AppColors.putih,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_month_outlined),
          activeIcon: Icon(Icons.calendar_month),
          label: 'Jadwal',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications_outlined),
          activeIcon: Icon(Icons.notifications),
          label: 'Notifikasi',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: 'Profil',
        ),
      ],
    );
  }

  // ─────────────────────────────────────
  // HELPER
  // ─────────────────────────────────────
  void _snackInfo(String pesan) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(pesan, style: const TextStyle(fontSize: 14)),
        backgroundColor: _AppColors.hijauDaun,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _konfirmasiKeluar() async {
    final yakin = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Keluar Akun',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text('Apakah Anda yakin ingin keluar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text(
              'Batal',
              style: TextStyle(color: _AppColors.teksAbu),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: _AppColors.hijauDaun,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );

    if (yakin == true && mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (_) => false,
      );
    }
  }
}

// ---------------------------------------------------------------------------
// Data class untuk menu shortcut
// ---------------------------------------------------------------------------
class _MenuData {
  final IconData icon;
  final String label;
  final String tooltip;
  final Color color;
  final Color colorBg;
  final VoidCallback? onTap;
  const _MenuData({
    required this.icon,
    required this.label,
    required this.tooltip,
    required this.color,
    required this.colorBg,
    this.onTap,
  });
}
