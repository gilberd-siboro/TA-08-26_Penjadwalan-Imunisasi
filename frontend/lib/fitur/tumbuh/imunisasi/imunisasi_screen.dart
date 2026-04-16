import 'package:flutter/material.dart';
import 'rincian_jadwal_screen.dart';

// ─────────────────────────────────────────────────────────────────
// Model
// ─────────────────────────────────────────────────────────────────
enum ImunisasiStatus {
  selesai,
  terlambat,
  akanDatang,
  sudahSaatnyaBelumKeLokasi,
}

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
          nama: 'Polio Tetes 1',
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
          nama: 'Polio Tetes 2',
          tanggal: 'Seharusnya: 12 Juli 2024',
          status: ImunisasiStatus.terlambat,
        ),
        ImunisasiItem(
          nama: 'Rotavirus (RV1)',
          tanggal: 'Seharusnya: 12 Juli 2024',
          status: ImunisasiStatus.terlambat,
        ),
        ImunisasiItem(
          nama: 'PCV 1',
          tanggal: 'Seharusnya: 12 Juli 2024',
          status: ImunisasiStatus.terlambat,
        ),
      ],
    ),
    ImunisasiGroup(
      usia: 'Hari Ini',
      groupStatus: ImunisasiStatus.sudahSaatnyaBelumKeLokasi,
      statusLabel: 'Hari ini • Belum ke lokasi',
      items: [
        ImunisasiItem(
          nama: 'DPT-HB-Hib 1',
          tanggal: 'Hari ini, 08:00 WIB • Puskesmas Kecamatan',
          status: ImunisasiStatus.sudahSaatnyaBelumKeLokasi,
        ),
        ImunisasiItem(
          nama: 'Polio Tetes 2',
          tanggal: 'Hari ini, 08:00 WIB • Puskesmas Kecamatan',
          status: ImunisasiStatus.sudahSaatnyaBelumKeLokasi,
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
          nama: 'Polio Tetes 3',
          tanggal: 'Estimasi: 12 Agustus 2024',
          status: ImunisasiStatus.akanDatang,
        ),
        ImunisasiItem(
          nama: 'Rotavirus (RV2)',
          tanggal: 'Estimasi: 12 Agustus 2024',
          status: ImunisasiStatus.akanDatang,
        ),
      ],
    ),
    ImunisasiGroup(
      usia: 'Usia 4 Bulan',
      groupStatus: ImunisasiStatus.akanDatang,
      statusLabel: 'Akan Datang',
      items: [
        ImunisasiItem(
          nama: 'DPT-HB-Hib 3',
          tanggal: 'Estimasi: 12 September 2024',
          status: ImunisasiStatus.akanDatang,
        ),
        ImunisasiItem(
          nama: 'Polio Tetes 4',
          tanggal: 'Estimasi: 12 September 2024',
          status: ImunisasiStatus.akanDatang,
        ),
        ImunisasiItem(
          nama: 'Polio Suntik (IPV) 1',
          tanggal: 'Estimasi: 12 September 2024',
          status: ImunisasiStatus.akanDatang,
        ),
        ImunisasiItem(
          nama: 'Rotavirus (RV3)',
          tanggal: 'Estimasi: 12 September 2024',
          status: ImunisasiStatus.akanDatang,
        ),
        ImunisasiItem(
          nama: 'PCV 2',
          tanggal: 'Estimasi: 12 September 2024',
          status: ImunisasiStatus.akanDatang,
        ),
      ],
    ),
    ImunisasiGroup(
      usia: 'Usia 9 Bulan',
      groupStatus: ImunisasiStatus.akanDatang,
      statusLabel: 'Akan Datang',
      items: [
        ImunisasiItem(
          nama: 'Campak Rubella (MR)',
          tanggal: 'Estimasi: 12 Februari 2025',
          status: ImunisasiStatus.akanDatang,
        ),
        ImunisasiItem(
          nama: 'Polio Suntik (IPV) 2',
          tanggal: 'Estimasi: 12 Februari 2025',
          status: ImunisasiStatus.akanDatang,
        ),
      ],
    ),
    ImunisasiGroup(
      usia: 'Usia 18 Bulan',
      groupStatus: ImunisasiStatus.akanDatang,
      statusLabel: 'Akan Datang',
      items: [
        ImunisasiItem(
          nama: 'DPT-HB-Hib Lanjutan',
          tanggal: 'Estimasi: 12 November 2025',
          status: ImunisasiStatus.akanDatang,
        ),
        ImunisasiItem(
          nama: 'Campak Rubella (MR) Lanjutan',
          tanggal: 'Estimasi: 12 November 2025',
          status: ImunisasiStatus.akanDatang,
        ),
        ImunisasiItem(
          nama: 'PCV 3',
          tanggal: 'Estimasi: 12 November 2025',
          status: ImunisasiStatus.akanDatang,
        ),
      ],
    ),
  ];

  bool get _hasDueButNotAtLocation {
    return _groups.any(
      (group) => group.groupStatus == ImunisasiStatus.sudahSaatnyaBelumKeLokasi,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildChildProfile(),
            const SizedBox(height: 4),
            _buildGenderMagGuideCard(),
            const SizedBox(height: 10),
            _buildWarningBanner(_hasDueButNotAtLocation),
            const SizedBox(height: 10),
            _buildScheduleLegendCard(),
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

  Widget _buildGenderMagGuideCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFEFFAF3),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFCBEFD9)),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Panduan Cepat (3 Langkah)',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1F6D43),
            ),
          ),
          SizedBox(height: 8),
          Text(
            '1. Cek jadwal yang terlambat.',
            style: TextStyle(fontSize: 12, color: Color(0xFF245B3E)),
          ),
          SizedBox(height: 4),
          Text(
            '2. Pilih jadwal susulan yang tersedia.',
            style: TextStyle(fontSize: 12, color: Color(0xFF245B3E)),
          ),
          SizedBox(height: 4),
          Text(
            '3. Konfirmasi sebelum menyimpan.',
            style: TextStyle(fontSize: 12, color: Color(0xFF245B3E)),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleLegendCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE6ECF2)),
      ),
      child: Wrap(
        spacing: 12,
        runSpacing: 6,
        children: [
          _legendItem(const Color(0xFF34C168), 'Sudah'),
          _legendItem(const Color(0xFFE09A1A), 'Perlu Susulan'),
          _legendItem(const Color(0xFF9AA5B4), 'Belum Waktunya'),
          _legendItem(const Color(0xFFC62828), 'Saatnya Ke Lokasi'),
        ],
      ),
    );
  }

  Widget _legendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 9,
          height: 9,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Color(0xFF4A5568),
          ),
        ),
      ],
    );
  }

  // ──────────────────────────────────────────────
  // Banner Peringatan
  // ──────────────────────────────────────────────
  Widget _buildWarningBanner(bool hasDueButNotAtLocation) {
    if (hasDueButNotAtLocation) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFFFEBEE),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFFFCDD2), width: 1),
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('📍', style: TextStyle(fontSize: 16)),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Jadwal hari ini, tetapi belum ke lokasi',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFB71C1C),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              'Silakan segera ke Puskesmas Kecamatan sebelum jam layanan berakhir.',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF7F1D1D),
                height: 1.6,
              ),
            ),
            SizedBox(height: 6),
            Text(
              'Jika tidak sempat hari ini, tekan tombol untuk atur jadwal susulan.',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF7F1D1D),
                height: 1.6,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFFFECB3), width: 1),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('⚠️', style: TextStyle(fontSize: 16)),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Ada jadwal yang belum dilakukan',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF92400E),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            'Tenang, ini masih bisa dikejar dengan jadwal susulan.',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF78350F),
              height: 1.6,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Tekan tombol biru di bawah. Ikuti langkahnya satu per satu.',
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
          // Tombol aksi untuk grup yang butuh tindakan pengguna
          if (group.groupStatus == ImunisasiStatus.terlambat ||
              group.groupStatus == ImunisasiStatus.sudahSaatnyaBelumKeLokasi)
            _buildGroupActions(context, group.groupStatus),
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
      case ImunisasiStatus.sudahSaatnyaBelumKeLokasi:
        bgColor = const Color(0xFFFFEBEE);
        textColor = const Color(0xFFC62828);
        icon = Icons.location_off_rounded;
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
      case ImunisasiStatus.sudahSaatnyaBelumKeLokasi:
        iconColor = const Color(0xFFC62828);
        iconData = Icons.warning_amber_rounded;
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
  Widget _buildGroupActions(BuildContext context, ImunisasiStatus status) {
    final isDueNow = status == ImunisasiStatus.sudahSaatnyaBelumKeLokasi;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 14),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const RincianJadwalScreen()),
            );
          },
          icon: Icon(
            isDueNow ? Icons.location_on_rounded : Icons.calendar_month_rounded,
            size: 18,
          ),
          label: Text(
            isDueNow ? 'Lihat Lokasi Sekarang' : 'Pilih Jadwal Susulan',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4A9EE0),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }
}
