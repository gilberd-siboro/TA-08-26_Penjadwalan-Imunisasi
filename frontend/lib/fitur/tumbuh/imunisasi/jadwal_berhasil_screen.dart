import 'package:flutter/material.dart';

class JadwalBerhasilScreen extends StatefulWidget {
  /// Data jadwal yang baru disimpan — bisa dipass dari UbahJadwalScreen
  final String namaPasien;
  final String tujuanKunjungan;
  final String waktu;
  final String lokasi;

  const JadwalBerhasilScreen({
    super.key,
    this.namaPasien = 'Budi (Usia 2 Bulan)',
    this.tujuanKunjungan = 'Imunisasi DPT-1 & Polio-2',
    this.waktu = 'Rabu, 12 Okt 2023 • 08:00 - 09:00',
    this.lokasi = 'Puskesmas Kecamatan',
  });

  @override
  State<JadwalBerhasilScreen> createState() => _JadwalBerhasilScreenState();
}

class _JadwalBerhasilScreenState extends State<JadwalBerhasilScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnim;
  late final Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _scaleAnim = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: FadeTransition(
            opacity: _fadeAnim,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ── Ilustrasi sukses ──────────────────────
                _buildSuccessIcon(),
                const SizedBox(height: 24),

                // ── Judul & subjudul ──────────────────────
                const Text(
                  'Jadwal Berhasil Disimpan!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Jadwal imunisasi sudah tersimpan.\nKami akan mengingatkan Anda sebelum hari kunjungan.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF9AA5B4),
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 28),

                // ── Ringkasan Jadwal ──────────────────────
                _buildSummaryCard(),
                const SizedBox(height: 16),

                // ── Pengingat Aktif ───────────────────────
                _buildReminderCard(),
                const SizedBox(height: 32),

                // ── Tombol ───────────────────────────────
                _buildLihatJadwalButton(context),
                const SizedBox(height: 12),
                _buildKembaliButton(context),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ──────────────────────────────────────────────
  // Ilustrasi sukses (lingkaran animasi + centang)
  // ──────────────────────────────────────────────
  Widget _buildSuccessIcon() {
    return ScaleTransition(
      scale: _scaleAnim,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Lingkaran luar — blur/soft
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF34C168).withOpacity(0.12),
            ),
          ),
          // Lingkaran dalam
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF34C168),
            ),
            child: const Icon(
              Icons.check_rounded,
              color: Colors.white,
              size: 44,
            ),
          ),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────
  // Ringkasan Jadwal
  // ──────────────────────────────────────────────
  Widget _buildSummaryCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ringkasan Jadwal',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 16),
          _buildSummaryRow(
            iconBg: const Color(0xFFEEF4FF),
            iconColor: const Color(0xFF4A9EE0),
            icon: Icons.child_care_outlined,
            label: 'Pasien',
            value: widget.namaPasien,
          ),
          const SizedBox(height: 14),
          _buildSummaryRow(
            iconBg: const Color(0xFFFFF8EE),
            iconColor: const Color(0xFFE09A1A),
            icon: Icons.shield_outlined,
            label: 'Tujuan Kunjungan',
            value: widget.tujuanKunjungan,
          ),
          const SizedBox(height: 14),
          _buildSummaryRow(
            iconBg: const Color(0xFFEEFBF3),
            iconColor: const Color(0xFF34C168),
            icon: Icons.access_time_rounded,
            label: 'Waktu',
            value: widget.waktu,
          ),
          const SizedBox(height: 14),
          _buildSummaryRow(
            iconBg: const Color(0xFFFFF0F5),
            iconColor: const Color(0xFFE05599),
            icon: Icons.location_on_outlined,
            label: 'Lokasi',
            value: widget.lokasi,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow({
    required Color iconBg,
    required Color iconColor,
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Ikon kotak kecil
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: iconBg,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: iconColor, size: 18),
        ),
        const SizedBox(width: 12),
        // Label + value
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF9AA5B4),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2D3748),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ──────────────────────────────────────────────
  // Pengingat Aktif
  // ──────────────────────────────────────────────
  Widget _buildReminderCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEEF7FF),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFD0E8F8), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: Color(0xFF4A9EE0),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_active_outlined,
              color: Colors.white,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pengingat Aktif',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4A9EE0),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Kami akan mengirimkan notifikasi 1 hari sebelum dan 2 jam sebelum jadwal keberangkatan Anda.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF5A8EBF),
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────
  // Tombol Lihat Jadwal Saya
  // ──────────────────────────────────────────────
  Widget _buildLihatJadwalButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          // TODO: navigate ke halaman jadwal
          Navigator.popUntil(context, (route) => route.isFirst);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4A9EE0),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: const Text(
          'Lihat Jadwal Saya',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  // ──────────────────────────────────────────────
  // Tombol Kembali ke Beranda
  // ──────────────────────────────────────────────
  Widget _buildKembaliButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFF4A9EE0),
          side: const BorderSide(color: Color(0xFF4A9EE0), width: 1.5),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: const Text(
          'Kembali ke Beranda',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
