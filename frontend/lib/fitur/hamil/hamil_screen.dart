import 'package:flutter/material.dart';

class HamilScreen extends StatelessWidget {
  const HamilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPregnancyCard(),
          const SizedBox(height: 12),
          _buildBabyInfoCard(),
          const SizedBox(height: 12),
          _buildScheduleCard(),
          const SizedBox(height: 20),
          _buildQuickMenu(),
          const SizedBox(height: 12),
          _buildDangerCard(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildPregnancyCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF4FF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.calendar_month_outlined,
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
                      'Kehamilan 24 Minggu',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                    Text(
                      'Trimester 2 • HPL: 15 Agt 2024',
                      style: TextStyle(fontSize: 12, color: Color(0xFF9AA5B4)),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Color(0xFF9AA5B4)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Minggu 1',
                style: TextStyle(fontSize: 11, color: Color(0xFF9AA5B4)),
              ),
              Text(
                'Minggu 40',
                style: TextStyle(fontSize: 11, color: Color(0xFF9AA5B4)),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: 24 / 40,
              backgroundColor: const Color(0xFFE8F0FB),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFF4A9EE0),
              ),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBabyInfoCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Sebesar Buah Jagung',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Panjang janin sekitar 30 cm dengan berat kurang lebih 600 gram.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF9AA5B4),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          const Text('🌽', style: TextStyle(fontSize: 48)),
        ],
      ),
    );
  }

  Widget _buildScheduleCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F7FF),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFD0E8F8), width: 1),
      ),
      child: Row(
        children: [
          Column(
            children: [
              const Text(
                'AGT',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF4A9EE0),
                  letterSpacing: 0.5,
                ),
              ),
              const Text(
                '12',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A9EE0),
                ),
              ),
            ],
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Periksa Kandungan (USG)',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D3748),
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Klinik Bersalin Sehat • 09:00',
                  style: TextStyle(fontSize: 12, color: Color(0xFF9AA5B4)),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Color(0xFF9AA5B4)),
        ],
      ),
    );
  }

  Widget _buildQuickMenu() {
    final menuItems = [
      {
        'label': 'BB Ibu',
        'icon': Icons.monitor_weight_outlined,
        'color': const Color(0xFFEEF4FF),
        'iconColor': const Color(0xFF4A9EE0),
      },
      {
        'label': 'Periksa',
        'icon': Icons.local_hospital_outlined,
        'color': const Color(0xFFFFF0F0),
        'iconColor': const Color(0xFFE05555),
      },
      {
        'label': 'Nutrisi',
        'icon': Icons.eco_outlined,
        'color': const Color(0xFFEEFBF3),
        'iconColor': const Color(0xFF34C168),
      },
      {
        'label': 'Edukasi',
        'icon': Icons.menu_book_outlined,
        'color': const Color(0xFFFFF8EE),
        'iconColor': const Color(0xFFE09A1A),
      },
      {
        'label': 'Catatan',
        'icon': Icons.description_outlined,
        'color': const Color(0xFFFFF0F5),
        'iconColor': const Color(0xFFE05599),
      },
      {
        'label': 'Keluhan',
        'icon': Icons.favorite_border,
        'color': const Color(0xFFEEF4FF),
        'iconColor': const Color(0xFF4A9EE0),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: menuItems
                .sublist(0, 3)
                .map((item) => _buildMenuItem(item))
                .toList(),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
    );
  }

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
          'Tanda Bahaya Kehamilan',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Color(0xFF2D3748),
          ),
        ),
        subtitle: const Text(
          'Pahami gejala yang perlu diwaspadai',
          style: TextStyle(fontSize: 12, color: Color(0xFF9AA5B4)),
        ),
        trailing: const Icon(Icons.chevron_right, color: Color(0xFF9AA5B4)),
        onTap: () {},
      ),
    );
  }
}
