import 'package:flutter/material.dart';
import 'package:frontend/auth/ubah_kata_sandi_page.dart';

import '../../integrasi_backend/fitur/keluarga/data/api_keluarga.dart';
import '../../integrasi_backend/fitur/keluarga/model/profil_keluarga.dart';
import '../../integrasi_backend/inti/jaringan/klien_api.dart';
import '../../integrasi_backend/inti/jaringan/eksepsi_api.dart';
import '../../screens/home_screen.dart';

class ProfilScreen extends StatefulWidget {
  const ProfilScreen({super.key});

  @override
  State<ProfilScreen> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  ProfilKeluarga? _profil;
  bool _loadingProfil = true;
  String? _errorProfil;
  List<String> _messageProfil = [];
  int _selectedBottomNav = 4;

  @override
  void initState() {
    super.initState();
    _ambilProfil();
  }

  Future<void> _ambilProfil() async {
    try {
      final api = ApiKeluarga(KlienApi());
      final hasil = await api.ambilProfilKeluarga();

      if (!mounted) return;
      setState(() {
        _profil = hasil.data;
        _messageProfil = hasil.message;
        _errorProfil = null;
      });
    } on EksepsiApi catch (e) {
      if (!mounted) return;
      setState(() => _errorProfil = e.pesan);
    } catch (_) {
      if (!mounted) return;
      setState(() => _errorProfil = 'Gagal memuat data profil');
    } finally {
      if (mounted) setState(() => _loadingProfil = false);
    }
  }

  String _formatTanggal(String? iso) {
    final tanggal = _parseTanggalLahir(iso);
    if (tanggal == null) return '-';

    final dd = tanggal.day.toString().padLeft(2, '0');
    final mm = tanggal.month.toString().padLeft(2, '0');
    final yyyy = tanggal.year.toString();
    return '$dd-$mm-$yyyy';
  }

  String _hitungUsiaDariTanggal(String? rawTanggal) {
    final tanggalLahir = _parseTanggalLahir(rawTanggal);
    if (tanggalLahir == null) return '-';

    final now = DateTime.now();
    var usia = now.year - tanggalLahir.year;
    if (now.month < tanggalLahir.month ||
        (now.month == tanggalLahir.month && now.day < tanggalLahir.day)) {
      usia--;
    }

    if (usia < 0) return '-';

    if (usia == 0) {
      var bulan =
          (now.year - tanggalLahir.year) * 12 +
          (now.month - tanggalLahir.month);
      if (now.day < tanggalLahir.day) {
        bulan--;
      }
      if (bulan < 0) bulan = 0;
      return '$bulan bulan';
    }

    return '$usia tahun';
  }

  DateTime? _parseTanggalLahir(String? rawTanggal) {
    if (rawTanggal == null || rawTanggal.isEmpty) return null;

    final ddMmYyyy = RegExp(
      r'^(\d{2})-(\d{2})-(\d{4})$',
    ).firstMatch(rawTanggal);
    if (ddMmYyyy != null) {
      final day = int.tryParse(ddMmYyyy.group(1) ?? '');
      final month = int.tryParse(ddMmYyyy.group(2) ?? '');
      final year = int.tryParse(ddMmYyyy.group(3) ?? '');
      if (day != null && month != null && year != null) {
        return DateTime(year, month, day);
      }
    }

    return DateTime.tryParse(rawTanggal);
  }

  String get _namaTampilan {
    final tampil = _anggotaTampilan;
    if (tampil != null) return tampil.namaLengkap;

    final anggota = _profil?.anggotaKeluarga ?? [];
    if (anggota.isEmpty) return 'Pengguna';

    final ibu = anggota.where(
      (e) => e.kedudukanKeluarga.toLowerCase() == 'ibu',
    );

    if (ibu.isNotEmpty) return ibu.first.namaLengkap;
    return anggota.first.namaLengkap;
  }

  AnggotaKeluarga? get _anggotaTampilan {
    final anggota = _profil?.anggotaKeluarga ?? [];
    if (anggota.isEmpty) return null;

    final ibu = anggota.where(
      (e) => e.kedudukanKeluarga.toLowerCase() == 'ibu',
    );
    if (ibu.isNotEmpty) return ibu.first;

    return anggota.first;
  }

  String get _usiaTampilan {
    final tampil = _anggotaTampilan;
    if (tampil == null) return '-';
    return _hitungUsiaDariTanggal(tampil.tanggalLahir);
  }

  String get _kedudukanTampilan {
    final tampil = _anggotaTampilan;
    if (tampil == null || tampil.kedudukanKeluarga.isEmpty) return '-';
    return tampil.kedudukanKeluarga;
  }

  void _showAnggotaKeluargaSheet() {
    final anggota = _profil?.anggotaKeluarga ?? [];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.75,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Container(
                width: 48,
                height: 5,
                decoration: BoxDecoration(
                  color: const Color(0xFFD7DEE7),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Anggota Keluarga',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEF4FF),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${anggota.length} Orang',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF4A9EE0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: anggota.isEmpty
                    ? const Center(
                        child: Text(
                          'Belum ada data anggota keluarga',
                          style: TextStyle(color: Color(0xFF9AA5B4)),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        itemCount: anggota.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (_, index) {
                          final item = anggota[index];
                          return _buildAnggotaCard(item);
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _bukaUbahKataSandi() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const UbahKataSandiPage()),
    );
  }

  Widget _buildAnggotaCard(AnggotaKeluarga item) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE7EDF4)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFEEF4FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.people_alt_outlined,
              size: 20,
              color: Color(0xFF4A9EE0),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.namaLengkap,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${item.kedudukanKeluarga} • ${item.jenisKelamin}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF7B8794),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'NIK: ${item.nik}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF7B8794),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Tanggal Lahir: ${_formatTanggal(item.tanggalLahir)}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF7B8794),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Usia: ${_hitungUsiaDariTanggal(item.tanggalLahir)}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF7B8794),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  _buildProfileCard(),
                  if (_errorProfil != null)
                    Container(
                      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF4F4),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFFFD8D8)),
                      ),
                      child: Text(
                        _errorProfil!,
                        style: const TextStyle(
                          color: Color(0xFFC53030),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  const SizedBox(height: 20),
                  _buildMenuSection(
                    title: 'Akun Saya',
                    items: [
                      _MenuItem(
                        icon: Icons.person_outline_rounded,
                        iconBg: const Color(0xFFEEF4FF),
                        iconColor: const Color(0xFF4A9EE0),
                        label: 'Ubah Data Diri',
                        subtitle: 'Perbarui nama dan nomor HP Anda',
                        onTap: () {},
                      ),
                      _MenuItem(
                        icon: Icons.groups_outlined,
                        iconBg: const Color(0xFFEFFAF2),
                        iconColor: const Color(0xFF2EAD63),
                        label: 'Anggota Keluarga',
                        subtitle: 'Lihat data ayah, ibu, dan anak',
                        badge: '${_profil?.anggotaKeluarga.length ?? 0} Orang',
                        onTap: _showAnggotaKeluargaSheet,
                      ),
                      _MenuItem(
                        icon: Icons.lock_outline_rounded,
                        iconBg: const Color(0xFFFFF0F5),
                        iconColor: const Color(0xFFE05599),
                        label: 'Ubah Kata Sandi',
                        subtitle: 'Ganti kata sandi akun Anda',
                        onTap: _bukaUbahKataSandi,
                      ),
                      _MenuItem(
                        icon: Icons.notifications_none_rounded,
                        iconBg: const Color(0xFFFFF8EE),
                        iconColor: const Color(0xFFE09A1A),
                        label: 'Notifikasi',
                        subtitle: 'Pengingat jadwal imunisasi anak',
                        trailing: _buildToggle(true),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildMenuSection(
                    title: 'Kesehatan',
                    items: [
                      _MenuItem(
                        icon: Icons.favorite_border_rounded,
                        iconBg: const Color(0xFFFFF0F0),
                        iconColor: const Color(0xFFE05555),
                        label: 'Riwayat Kesehatan',
                        subtitle: 'Lihat catatan kesehatan keluarga',
                        onTap: () {},
                      ),
                      _MenuItem(
                        icon: Icons.calendar_month_outlined,
                        iconBg: const Color(0xFFEEF4FF),
                        iconColor: const Color(0xFF4A9EE0),
                        label: 'Jadwal Saya',
                        subtitle: 'Cek jadwal imunisasi yang akan datang',
                        onTap: () {},
                      ),
                      _MenuItem(
                        icon: Icons.description_outlined,
                        iconBg: const Color(0xFFFFF0F5),
                        iconColor: const Color(0xFFE05599),
                        label: 'Catatan Kesehatan',
                        subtitle: 'Simpan informasi kesehatan penting',
                        onTap: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildMenuSection(
                    title: 'Lainnya',
                    items: [
                      _MenuItem(
                        icon: Icons.help_outline_rounded,
                        iconBg: const Color(0xFFF5F0FF),
                        iconColor: const Color(0xFF8B5CF6),
                        label: 'Bantuan & FAQ',
                        subtitle: 'Panduan penggunaan aplikasi',
                        onTap: () {},
                      ),
                      _MenuItem(
                        icon: Icons.privacy_tip_outlined,
                        iconBg: const Color(0xFFEEF4FF),
                        iconColor: const Color(0xFF4A9EE0),
                        label: 'Kebijakan Privasi',
                        subtitle: 'Cara kami melindungi data Anda',
                        onTap: () {},
                      ),
                      _MenuItem(
                        icon: Icons.info_outline_rounded,
                        iconBg: const Color(0xFFEEFBF3),
                        iconColor: const Color(0xFF34C168),
                        label: 'Tentang Aplikasi',
                        subtitle: 'Informasi versi aplikasi',
                        badge: 'v1.0.0',
                        onTap: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildLogoutButton(context),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // ──────────────────────────────────────────────
  // Header biru (sama seperti halaman lain)
  // ──────────────────────────────────────────────
  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF5DADE2), Color(0xFF3498DB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16,
        left: 20,
        right: 20,
        bottom: 20,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Profil Saya',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Kelola data keluarga dengan mudah',
                style: TextStyle(
                  color: Color(0xFFE9F5FF),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.settings_outlined,
              color: Colors.white,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────
  // Card profil utama
  // ──────────────────────────────────────────────
  Widget _buildProfileCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Avatar
          Stack(
            children: [
              Container(
                width: 82,
                height: 82,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFEEF4FF),
                  border: Border.all(
                    color: const Color(0xFF4A9EE0),
                    width: 2.5,
                  ),
                ),
                child: const Icon(
                  Icons.person_rounded,
                  size: 46,
                  color: Color(0xFF4A9EE0),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 26,
                  height: 26,
                  decoration: const BoxDecoration(
                    color: Color(0xFF4A9EE0),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.edit_rounded,
                    color: Colors.white,
                    size: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Nama
          Text(
            _loadingProfil ? 'Memuat...' : _namaTampilan,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Usia: $_usiaTampilan',
            style: const TextStyle(fontSize: 14, color: Color(0xFF7D8A99)),
          ),
          const SizedBox(height: 16),

          // Divider
          Container(height: 1, color: const Color(0xFFF0F4F8)),
          const SizedBox(height: 16),

          _buildPeranIbuPanel(),
        ],
      ),
    );
  }

  Widget _buildPeranIbuPanel() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F8FF),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFDDE8F8)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Peran',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF7B8794),
            ),
          ),
          Expanded(
            child: Text(
              _kedudukanTampilan,
              textAlign: TextAlign.right,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: Color(0xFF4A9EE0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    final items = [
      {'icon': Icons.home_rounded, 'label': 'Beranda'},
      {'icon': Icons.description_outlined, 'label': 'Catatan'},
      {'icon': Icons.shield_outlined, 'label': 'Imunisasi'},
      {'icon': Icons.menu_book_outlined, 'label': 'Edukasi'},
      {'icon': Icons.person_outline, 'label': 'Profil'},
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (index) {
              final isSelected = _selectedBottomNav == index;
              return GestureDetector(
                onTap: () {
                  setState(() => _selectedBottomNav = index);

                  if (index == 0) {
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                      return;
                    }

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const HomeScreen()),
                    );
                    return;
                  }

                  if (index != 4) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Menu ini sedang dalam pengembangan'),
                      ),
                    );
                  }
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      items[index]['icon'] as IconData,
                      size: 24,
                      color: isSelected
                          ? const Color(0xFF4A9EE0)
                          : const Color(0xFF9AA5B4),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      items[index]['label'] as String,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w400,
                        color: isSelected
                            ? const Color(0xFF4A9EE0)
                            : const Color(0xFF9AA5B4),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildStat(String label, String value, Color valueColor) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Color(0xFF9AA5B4)),
        ),
      ],
    );
  }

  Widget _buildStatDivider() {
    return Container(width: 1, height: 32, color: const Color(0xFFF0F4F8));
  }

  // ──────────────────────────────────────────────
  // Seksi menu
  // ──────────────────────────────────────────────
  Widget _buildMenuSection({
    required String title,
    required List<_MenuItem> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, bottom: 10),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFF9AA5B4),
              letterSpacing: 0.5,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: items.asMap().entries.map((entry) {
              final isLast = entry.key == items.length - 1;
              return _buildMenuItem(entry.value, isLast);
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem(_MenuItem item, bool isLast) {
    return GestureDetector(
      onTap: item.onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                // Ikon
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: item.iconBg,
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Icon(item.icon, color: item.iconColor, size: 20),
                ),
                const SizedBox(width: 14),
                // Label
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.label,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF2D3748),
                        ),
                      ),
                      if (item.subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          item.subtitle!,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF7B8794),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                // Badge atau trailing custom atau chevron
                if (item.badge != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEF4FF),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      item.badge!,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF4A9EE0),
                      ),
                    ),
                  )
                else if (item.trailing != null)
                  item.trailing!
                else
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: Color(0xFFCBD5E0),
                    size: 20,
                  ),
              ],
            ),
          ),
          if (!isLast)
            const Divider(height: 1, indent: 70, color: Color(0xFFF0F4F8)),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────
  // Toggle switch widget
  // ──────────────────────────────────────────────
  Widget _buildToggle(bool value) {
    return _NotifToggle(initialValue: value);
  }

  // ──────────────────────────────────────────────
  // Tombol Keluar
  // ──────────────────────────────────────────────
  Widget _buildLogoutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: () => _showLogoutDialog(context),
          icon: const Icon(
            Icons.logout_rounded,
            size: 18,
            color: Color(0xFFE05555),
          ),
          label: const Text(
            'Keluar dari Akun',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFFE05555),
            ),
          ),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
            side: const BorderSide(color: Color(0xFFFFE0E0), width: 1.5),
            backgroundColor: const Color(0xFFFFF8F8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ),
    );
  }

  // ──────────────────────────────────────────────
  // Dialog konfirmasi keluar
  // ──────────────────────────────────────────────
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Keluar dari Akun?',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        content: const Text(
          'Apakah Anda yakin ingin keluar dari akun ini?',
          style: TextStyle(fontSize: 13, color: Color(0xFF9AA5B4)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Batal',
              style: TextStyle(
                color: Color(0xFF9AA5B4),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              // TODO: logout logic
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE05555),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Keluar',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// Model menu item
// ─────────────────────────────────────────────────────────────────
class _MenuItem {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String label;
  final String? subtitle;
  final String? badge;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _MenuItem({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.label,
    this.subtitle,
    this.badge,
    this.trailing,
    this.onTap,
  });
}

// ─────────────────────────────────────────────────────────────────
// Toggle notifikasi (StatefulWidget kecil)
// ─────────────────────────────────────────────────────────────────
class _NotifToggle extends StatefulWidget {
  final bool initialValue;
  const _NotifToggle({required this.initialValue});

  @override
  State<_NotifToggle> createState() => _NotifToggleState();
}

class _NotifToggleState extends State<_NotifToggle> {
  late bool _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: _value,
      onChanged: (v) => setState(() => _value = v),
      activeColor: const Color(0xFF4A9EE0),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}
