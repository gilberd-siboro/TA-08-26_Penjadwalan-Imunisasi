import 'package:flutter/material.dart';
import 'ubah_jadwal_screen.dart';

class RincianJadwalScreen extends StatelessWidget {
  const RincianJadwalScreen({super.key});

  static const Color _bgColor = Color(0xFFF5F7FA);
  static const Color _titleColor = Color(0xFF2D3748);
  static const Color _mutedColor = Color(0xFF9AA5B4);
  static const Color _primaryColor = Color(0xFF4A9EE0);

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderCard(),
            const SizedBox(height: 10),
            _buildStepInfoCard(),
            const SizedBox(height: 12),
            _buildInfoCard(
              title: 'WAKTU PELAKSANAAN',
              icon: Icons.calendar_today_outlined,
              content: 'Kamis, 12 Oktober 2023\n08:00 - 09:00 WIB',
            ),
            const SizedBox(height: 10),
            _buildInfoCard(
              title: 'LOKASI',
              icon: Icons.location_on_outlined,
              content:
                  'Puskesmas Kecamatan\nJl. Kesehatan Raya No. 123, Jakarta',
            ),
            const SizedBox(height: 10),
            _buildMapPlaceholder(),
            const SizedBox(height: 12),
            _buildPreparationCard(),
            const SizedBox(height: 12),
            _buildVaccineInfoCard(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomActionBar(context),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: _titleColor,
          size: 18,
        ),
      ),
      title: const Text(
        'Langkah 2 dari 3',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: _titleColor,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.more_vert_rounded, color: _titleColor),
        ),
      ],
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF4CC),
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Text(
              'Dalam 3 Hari',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(0xFF9A6B00),
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Imunisasi DPT-1 & Polio-2',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: _titleColor,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF4F7FB),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFE3ECF5)),
            ),
            child: const Row(
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: Color(0xFF296EDB),
                  child: Icon(Icons.person, color: Colors.white, size: 16),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'David',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: _titleColor,
                        ),
                      ),
                      SizedBox(height: 1),
                      Text(
                        'Bayi (2 Bulan)',
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF7A8797),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepInfoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F7FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD9EAFE)),
      ),
      child: const Text(
        'Kamu sedang di langkah 2. Cek waktu, lokasi, dan persiapan dulu, lalu lanjut pilih tanggal.',
        style: TextStyle(fontSize: 12, height: 1.5, color: Color(0xFF315B7A)),
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required IconData icon,
    required String content,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: _cardDecoration(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: const Color(0xFFEEF4FF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 16, color: _primaryColor),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 10,
                    letterSpacing: 0.6,
                    fontWeight: FontWeight.w700,
                    color: _mutedColor,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  content,
                  style: const TextStyle(
                    fontSize: 12,
                    height: 1.5,
                    fontWeight: FontWeight.w600,
                    color: _titleColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapPlaceholder() {
    return Container(
      height: 170,
      width: double.infinity,
      decoration: _cardDecoration(),
      child: Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFFF4F7FB),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFE3ECF5)),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.map_outlined, color: _mutedColor, size: 26),
              SizedBox(height: 6),
              Text(
                'Peta lokasi',
                style: TextStyle(fontSize: 12, color: _mutedColor),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: _titleColor,
            ),
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }

  Widget _buildBulletItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 7),
            child: Icon(Icons.circle, size: 5, color: _mutedColor),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 12,
                height: 1.6,
                color: Color(0xFF4A5568),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreparationCard() {
    return _buildSectionCard(
      title: 'Persiapan',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBulletItem('Membawa Buku KIA (Kesehatan Ibu dan Anak).'),
          _buildBulletItem(
            'Pastikan anak dalam kondisi sehat (tidak demam atau batuk pilek berat).',
          ),
          _buildBulletItem(
            'Pakaikan pakaian yang nyaman dan mudah diakses untuk penyuntikan.',
          ),
        ],
      ),
    );
  }

  Widget _buildVaccineInfoCard() {
    return _buildSectionCard(
      title: 'Informasi Vaksin',
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'DPT-1: Vaksin untuk mencegah penyakit Difteri, Pertusis (batuk rejan), dan Tetanus.',
            style: TextStyle(
              fontSize: 12,
              height: 1.6,
              color: Color(0xFF4A5568),
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Polio-2: Vaksin untuk mencegah penyakit polio yang dapat menyebabkan kelumpuhan.',
            style: TextStyle(
              fontSize: 12,
              height: 1.6,
              color: Color(0xFF4A5568),
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Baca selengkapnya di Edukasi',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: _primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActionBar(BuildContext context) {
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
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const UbahJadwalScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryColor,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 13),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Lanjut Pilih Tanggal',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
