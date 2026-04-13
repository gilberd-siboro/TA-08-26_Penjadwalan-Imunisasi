import 'package:flutter/material.dart';

class MenyusuiScreen extends StatelessWidget {
  const MenyusuiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          _buildDailySummary(),
          const SizedBox(height: 20),
          _buildQuickMenu(),
          const SizedBox(height: 20),
          _buildRecentHistory(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────
  // Ringkasan Hari Ini
  // ──────────────────────────────────────────────
  Widget _buildDailySummary() {
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
          const Text(
            'RINGKASAN HARI INI',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Color(0xFF9AA5B4),
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              // Menyusui Langsung
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(
                          Icons.access_time_rounded,
                          size: 16,
                          color: Color(0xFF4A9EE0),
                        ),
                        SizedBox(width: 6),
                        Text(
                          'Menyusui Langsung',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF9AA5B4),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    RichText(
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: '2j ',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2D3748),
                            ),
                          ),
                          TextSpan(
                            text: '15m',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2D3748),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      '5 kali sesi hari ini',
                      style: TextStyle(fontSize: 12, color: Color(0xFF9AA5B4)),
                    ),
                  ],
                ),
              ),
              // Divider vertikal
              Container(
                width: 1,
                height: 70,
                color: const Color(0xFFEDF2F7),
                margin: const EdgeInsets.symmetric(horizontal: 12),
              ),
              // Volume Pompa
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(
                          Icons.water_drop_outlined,
                          size: 16,
                          color: Color(0xFFE05555),
                        ),
                        SizedBox(width: 6),
                        Text(
                          'Volume Pompa',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF9AA5B4),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '120 ml',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      '2 kali sesi hari ini',
                      style: TextStyle(fontSize: 12, color: Color(0xFF9AA5B4)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────
  // Menu Cepat
  // ──────────────────────────────────────────────
  Widget _buildQuickMenu() {
    final menuItems = [
      {
        'label': 'Catat ASI',
        'icon': Icons.access_time_rounded,
        'color': const Color(0xFFFFF0F5),
        'iconColor': const Color(0xFFE05599),
      },
      {
        'label': 'Pompa ASI',
        'icon': Icons.water_drop_outlined,
        'color': const Color(0xFFEEF4FF),
        'iconColor': const Color(0xFF4A9EE0),
      },
      {
        'label': 'Timbang',
        'icon': Icons.balance,
        'color': const Color(0xFFEEFBF3),
        'iconColor': const Color(0xFF34C168),
      },
      {
        'label': 'Imunisasi',
        'icon': Icons.shield_outlined,
        'color': const Color(0xFFFFF0F0),
        'iconColor': const Color(0xFFE05555),
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
        'color': const Color(0xFFF5F0FF),
        'iconColor': const Color(0xFF8B5CF6),
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
        onTap: () {},
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
  // Riwayat Terakhir
  // ──────────────────────────────────────────────
  Widget _buildRecentHistory() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // Header row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'RIWAYAT TERAKHIR',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF9AA5B4),
                  letterSpacing: 1.0,
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: const Text(
                  'Lihat Semua',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF4A9EE0),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Item 1 – Menyusui Langsung
          _buildHistoryItem(
            icon: Icons.access_time_rounded,
            iconBgColor: const Color(0xFFFFF0F5),
            iconColor: const Color(0xFFE05599),
            title: 'Menyusui Langsung',
            subtitle: '08:30 • 15 mnt • Payudara Kiri',
          ),
          const SizedBox(height: 10),

          // Item 2 – Pompa ASI
          _buildHistoryItem(
            icon: Icons.water_drop_outlined,
            iconBgColor: const Color(0xFFEEF4FF),
            iconColor: const Color(0xFF4A9EE0),
            title: 'Pompa ASI',
            subtitle: '06:00 • 120 ml',
          ),
          const SizedBox(height: 10),

          // Item 3 – Tips
          _buildTipsItem(),
        ],
      ),
    );
  }

  Widget _buildHistoryItem({
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
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
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF9AA5B4),
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Color(0xFF9AA5B4)),
        ],
      ),
    );
  }

  Widget _buildTipsItem() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFDE7),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFFFECB3), width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: const BoxDecoration(
              color: Color(0xFFFFF8E1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.lightbulb_outline_rounded,
              color: Color(0xFFF59E0B),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tips Memperlancar ASI',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D3748),
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Cukupi kebutuhan air minimal 3 liter/hari',
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
}
