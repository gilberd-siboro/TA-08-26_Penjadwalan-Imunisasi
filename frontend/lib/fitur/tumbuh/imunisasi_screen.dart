import 'package:flutter/material.dart';
import 'rincian_jadwal_screen.dart';

// ─────────────────────────────────────────────────────────────────
// Model
// ─────────────────────────────────────────────────────────────────
enum ImunisasiStatus { selesai, terlambat, akanDatang }

class ImunisasiItem {
  final String nama;
  final String tanggal;
  final ImunisasiStatus status;

  const ImunisasiItem({
    required this.nama,
    required this.tanggal,
    required this.status,
  });
}

class ImunisasiGroup {
  final String usia;
  final ImunisasiStatus groupStatus;
  final String?
  statusLabel; // "✓ Selesai" / "⏰ Terlambat X Hari" / "📅 Akan Datang"
  final List<ImunisasiItem> items;

  const ImunisasiGroup({
    required this.usia,
    required this.groupStatus,
    this.statusLabel,
    required this.items,
  });
}

// ─────────────────────────────────────────────────────────────────
// Screen
// ─────────────────────────────────────────────────────────────────
class ImunisasiScreen extends StatelessWidget {
  const ImunisasiScreen({super.key});

  // Data jadwal imunisasi
  static const List<ImunisasiGroup> _groups = [
    ImunisasiGroup(
      usia: 'Saat Lahir (0 Bulan)',
      groupStatus: ImunisasiStatus.selesai,
      statusLabel: 'Selesai',
      items: [
        ImunisasiItem(
          nama: 'Hepatitis B (HB-0)',
          tanggal: '12 Mei 2024',
          status: ImunisasiStatus.selesai,
        ),
        ImunisasiItem(
          nama: 'BCG',
          tanggal: '15 Mei 2024',
          status: ImunisasiStatus.selesai,
        ),
        ImunisasiItem(
          nama: 'Polio 1',
          tanggal: '15 Mei 2024',
          status: ImunisasiStatus.selesai,
        ),
      ],
    ),
    ImunisasiGroup(
      usia: 'Usia 2 Bulan',
      groupStatus: ImunisasiStatus.terlambat,
      statusLabel: 'Terlambat 10 Hari',
      items: [
        ImunisasiItem(
          nama: 'DPT-HB-Hib 1',
          tanggal: 'Seharusnya: 12 Juli 2024',
          status: ImunisasiStatus.terlambat,
        ),
        ImunisasiItem(
          nama: 'Polio 2',
          tanggal: 'Seharusnya: 12 Juli 2024',
          status: ImunisasiStatus.terlambat,
        ),
        ImunisasiItem(
          nama: 'PCV 1',
          tanggal: 'Seharusnya: 12 Juli 2024',
          status: ImunisasiStatus.terlambat,
        ),
        ImunisasiItem(
          nama: 'Rotavirus 1',
          tanggal: 'Seharusnya: 12 Juli 2024',
          status: ImunisasiStatus.terlambat,
        ),
      ],
    ),
    ImunisasiGroup(
      usia: 'Usia 3 Bulan',
      groupStatus: ImunisasiStatus.akanDatang,
      statusLabel: 'Akan Datang',
      items: [
        ImunisasiItem(
          nama: 'DPT-HB-Hib 2',
          tanggal: 'Estimasi: 12 Agustus 2024',
          status: ImunisasiStatus.akanDatang,
        ),
        ImunisasiItem(
          nama: 'Polio 3',
          tanggal: 'Estimasi: 12 Agustus 2024',
          status: ImunisasiStatus.akanDatang,
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profil anak
            _buildChildProfile(),
            // Banner peringatan terlambat
            _buildWarningBanner(),
            // Tombol atur jadwal susulan
            _buildScheduleButton(context),
            const SizedBox(height: 20),
            // Label seksi riwayat
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Riwayat & Jadwal Imunisasi',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3748),
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Daftar grup imunisasi
            ..._groups.map((group) => _buildGroup(group, context)),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // ──────────────────────────────────────────────
  // AppBar
  // ──────────────────────────────────────────────
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      surfaceTintColor: Colors.white,
      leading: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: Color(0xFF2D3748),
          size: 20,
        ),
      ),
      title: const Text(
        'Jadwal Imunisasi',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: Color(0xFF2D3748),
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.more_vert_rounded, color: Color(0xFF2D3748)),
          onPressed: () {},
        ),
      ],
    );
  }

  // ──────────────────────────────────────────────
  // Profil Anak
  // ──────────────────────────────────────────────
  Widget _buildChildProfile() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
          // Avatar
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: const Color(0xFFEEF4FF),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFD0E8F8), width: 1.5),
            ),
            child: const Icon(
              Icons.child_care,
              color: Color(0xFF4A9EE0),
              size: 26,
            ),
          ),
          const SizedBox(width: 12),
          // Info
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'David',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Usia: 2 Bulan 10 Hari',
                  style: TextStyle(fontSize: 12, color: Color(0xFF9AA5B4)),
                ),
              ],
            ),
          ),
          // Tombol Ubah
          GestureDetector(
            onTap: () {},
            child: Row(
              children: const [
                Icon(Icons.edit_outlined, size: 14, color: Color(0xFF4A9EE0)),
                SizedBox(width: 4),
                Text(
                  'Ubah',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF4A9EE0),
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
  // Banner Peringatan
  // ──────────────────────────────────────────────
  Widget _buildWarningBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFFFECB3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Judul
          Row(
            children: const [
              Text('⚠️', style: TextStyle(fontSize: 16)),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Pengingat Kedua: Jadwal Terlewat!',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF92400E),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Isi
          const Text(
            'Ibu Siti, Budi belum mendapatkan imunisasi DPT-1 dan Polio-2. Imunisasi ini sangat penting untuk mencegah penyakit menular seperti Difteri dan Lumpuh Layu.',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF78350F),
              height: 1.6,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Tidak apa jika terlambat, masih bisa dilakukan imunisasi susulan. Yuk, segera bawa Budi ke Posyandu atau Puskesmas terdekat! 😊',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF78350F),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────
  // Tombol Atur Jadwal Susulan
  // ──────────────────────────────────────────────
  Widget _buildScheduleButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const RincianJadwalScreen()),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4A9EE0),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
          child: const Text(
            'Atur Jadwal Susulan',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }

  // ──────────────────────────────────────────────
  // Grup Imunisasi
  // ──────────────────────────────────────────────
  Widget _buildGroup(ImunisasiGroup group, BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
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
        children: [
          // Header grup
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  group.usia,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                  ),
                ),
                _buildStatusBadge(group.groupStatus, group.statusLabel ?? ''),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFF0F4F8)),
          // Item-item imunisasi
          ...group.items.asMap().entries.map((entry) {
            final isLast = entry.key == group.items.length - 1;
            return _buildImunisasiItem(entry.value, isLast, group.groupStatus);
          }),
          // Tombol aksi (hanya untuk grup terlambat)
          if (group.groupStatus == ImunisasiStatus.terlambat)
            _buildGroupActions(context),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(ImunisasiStatus status, String label) {
    Color bgColor;
    Color textColor;
    IconData icon;

    switch (status) {
      case ImunisasiStatus.selesai:
        bgColor = const Color(0xFFEEFBF3);
        textColor = const Color(0xFF34C168);
        icon = Icons.check_circle_outline;
        break;
      case ImunisasiStatus.terlambat:
        bgColor = const Color(0xFFFFF3E0);
        textColor = const Color(0xFFE09A1A);
        icon = Icons.access_time_rounded;
        break;
      case ImunisasiStatus.akanDatang:
        bgColor = const Color(0xFFEEF4FF);
        textColor = const Color(0xFF4A9EE0);
        icon = Icons.calendar_today_outlined;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: textColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImunisasiItem(
    ImunisasiItem item,
    bool isLast,
    ImunisasiStatus groupStatus,
  ) {
    Color iconColor;
    IconData iconData;

    switch (item.status) {
      case ImunisasiStatus.selesai:
        iconColor = const Color(0xFF34C168);
        iconData = Icons.check_circle_rounded;
        break;
      case ImunisasiStatus.terlambat:
        iconColor = const Color(0xFFE09A1A);
        iconData = Icons.radio_button_unchecked_rounded;
        break;
      case ImunisasiStatus.akanDatang:
        iconColor = const Color(0xFFCBD5E0);
        iconData = Icons.radio_button_unchecked_rounded;
        break;
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Row(
            children: [
              Icon(iconData, color: iconColor, size: 22),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.nama,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: item.status == ImunisasiStatus.akanDatang
                            ? const Color(0xFF9AA5B4)
                            : const Color(0xFF2D3748),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.tanggal,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF9AA5B4),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (!isLast)
          const Divider(height: 1, indent: 50, color: Color(0xFFF0F4F8)),
      ],
    );
  }

  // ──────────────────────────────────────────────
  // Tombol aksi grup terlambat
  // ──────────────────────────────────────────────
  Widget _buildGroupActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 14),
      child: Row(
        children: [
          // Tandai Selesai
          Expanded(
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF4A9EE0),
                side: const BorderSide(color: Color(0xFF4A9EE0)),
                padding: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Tandai Selesai',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Atur Jadwal
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const RincianJadwalScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4A9EE0),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 10),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Atur Jadwal',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
