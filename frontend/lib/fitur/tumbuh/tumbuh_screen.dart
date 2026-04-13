import 'package:flutter/material.dart';
import 'imunisasi_screen.dart';

class TumbuhScreen extends StatelessWidget {
  const TumbuhScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          _buildAddChildCard(),
          const SizedBox(height: 20),
          _buildQuickMenu(context),
          const SizedBox(height: 12),
          _buildDangerCard(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────
  // Tambah Profil Anak
  // ──────────────────────────────────────────────
  Widget _buildAddChildCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF4A9EE0), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: const BoxDecoration(
              color: Color(0xFFEEF7FF),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.refresh_rounded,
              color: Color(0xFF4A9EE0),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tambah Profil Anak',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2D3748),
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Mulai pantau tumbuh kembang si kecil',
                  style: TextStyle(fontSize: 12, color: Color(0xFF9AA5B4)),
                ),
              ],
            ),
          ),
          Container(
            width: 30,
            height: 30,
            decoration: const BoxDecoration(
              color: Color(0xFFEEF7FF),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.add, color: Color(0xFF4A9EE0), size: 18),
          ),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────
  // Menu Cepat — Imunisasi navigasi ke ImunisasiScreen
  // ──────────────────────────────────────────────
  Widget _buildQuickMenu(BuildContext context) {
    // Setiap item memiliki optional onTap
    final menuItems = [
      {
        'label': 'Timbang',
        'icon': Icons.balance,
        'color': const Color(0xFFEEF4FF),
        'iconColor': const Color(0xFF4A9EE0),
        'onTap': null,
      },
      {
        'label': 'Imunisasi',
        'icon': Icons.shield_outlined,
        'color': const Color(0xFFEEFBF3),
        'iconColor': const Color(0xFF34C168),
        // ← navigasi ke ImunisasiScreen
        'onTap': () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ImunisasiScreen()),
        ),
      },
      {
        'label': 'Periksa',
        'icon': Icons.local_hospital_outlined,
        'color': const Color(0xFFFFF0F0),
        'iconColor': const Color(0xFFE05555),
        'onTap': null,
      },
      {
        'label': 'Edukasi',
        'icon': Icons.menu_book_outlined,
        'color': const Color(0xFFFFF8EE),
        'iconColor': const Color(0xFFE09A1A),
        'onTap': null,
      },
      {
        'label': 'Catatan',
        'icon': Icons.description_outlined,
        'color': const Color(0xFFFFF0F5),
        'iconColor': const Color(0xFFE05599),
        'onTap': null,
      },
      {
        'label': 'Bahaya',
        'icon': Icons.warning_amber_outlined,
        'color': const Color(0xFFFFF8EE),
        'iconColor': const Color(0xFFE09A1A),
        'onTap': null,
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Menu Cepat',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: menuItems
                .sublist(0, 3)
                .map((item) => _buildMenuItem(item))
                .toList(),
          ),
          const SizedBox(height: 12),
          Row(
            children: menuItems
                .sublist(3, 6)
                .map((item) => _buildMenuItem(item))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(Map<String, dynamic> item) {
    return Expanded(
      child: GestureDetector(
        onTap: item['onTap'] as void Function()?,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: item['color'] as Color,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  item['icon'] as IconData,
                  color: item['iconColor'] as Color,
                  size: 22,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                item['label'] as String,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF2D3748),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ──────────────────────────────────────────────
  // Tanda Bahaya
  // ──────────────────────────────────────────────
  Widget _buildDangerCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8F8),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFFFE0E0), width: 1),
      ),
      child: ListTile(
        leading: Container(
          width: 36,
          height: 36,
          decoration: const BoxDecoration(
            color: Color(0xFFFFEEEE),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.warning_amber_rounded,
            color: Color(0xFFE05555),
            size: 18,
          ),
        ),
        title: const Text(
          'Kenali Tanda Bahaya',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Color(0xFF2D3748),
          ),
        ),
        subtitle: const Text(
          'Segera ke faskes jika ada gejala ini',
          style: TextStyle(fontSize: 12, color: Color(0xFF9AA5B4)),
        ),
        trailing: const Icon(
          Icons.keyboard_arrow_down_rounded,
          color: Color(0xFF9AA5B4),
        ),
        onTap: () {},
      ),
    );
  }
}
