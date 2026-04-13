import 'package:flutter/material.dart';
import 'jadwal_berhasil_screen.dart';

class UbahJadwalScreen extends StatefulWidget {
  const UbahJadwalScreen({super.key});

  @override
  State<UbahJadwalScreen> createState() => _UbahJadwalScreenState();
}

class _UbahJadwalScreenState extends State<UbahJadwalScreen> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  final TextEditingController _lokasiController = TextEditingController(
    text: 'Puskesmas Kecamatan',
  );
  final TextEditingController _alasanController = TextEditingController();

  @override
  void dispose() {
    _lokasiController.dispose();
    _alasanController.dispose();
    super.dispose();
  }

  // ──────────────────────────────────────────────
  // Date Picker
  // ──────────────────────────────────────────────
  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 2),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF4A9EE0),
            onPrimary: Colors.white,
            surface: Colors.white,
            onSurface: Color(0xFF2D3748),
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  // ──────────────────────────────────────────────
  // Time Picker
  // ──────────────────────────────────────────────
  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 8, minute: 0),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF4A9EE0),
            onPrimary: Colors.white,
            surface: Colors.white,
            onSurface: Color(0xFF2D3748),
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _selectedTime = picked);
  }

  // ──────────────────────────────────────────────
  // Format helpers
  // ──────────────────────────────────────────────
  String get _formattedDate {
    if (_selectedDate == null) return '';
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agt',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    return '${_selectedDate!.day} ${months[_selectedDate!.month - 1]} ${_selectedDate!.year}';
  }

  String get _formattedTime {
    if (_selectedTime == null) return '';
    final h = _selectedTime!.hour.toString().padLeft(2, '0');
    final m = _selectedTime!.minute.toString().padLeft(2, '0');
    return '$h:$m WIB';
  }

  // ──────────────────────────────────────────────
  // Simpan
  // ──────────────────────────────────────────────
  void _simpan() {
    if (_selectedDate == null) {
      _showSnack('Pilih tanggal terlebih dahulu');
      return;
    }
    if (_selectedTime == null) {
      _showSnack('Pilih waktu terlebih dahulu');
      return;
    }

    final endHour = ((_selectedTime!.hour + 1) % 24).toString().padLeft(2, '0');
    final endMinute = _selectedTime!.minute.toString().padLeft(2, '0');
    final hh = _selectedTime!.hour.toString().padLeft(2, '0');
    final mm = _selectedTime!.minute.toString().padLeft(2, '0');
    final days = [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
      'Minggu',
    ];
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agt',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    final dayName = days[_selectedDate!.weekday - 1];
    final dateFmt =
        '$dayName, ${_selectedDate!.day} ${months[_selectedDate!.month - 1]} ${_selectedDate!.year}';
    final timeFmt = '$hh:$mm - $endHour:$endMinute';

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => JadwalBerhasilScreen(
          namaPasien: 'David (Usia 2 Bulan)',
          tujuanKunjungan: 'Imunisasi DPT-1 & Polio-2',
          waktu: '$dateFmt • $timeFmt',
          lokasi: _lokasiController.text.trim().isEmpty
              ? 'Puskesmas Kecamatan'
              : _lokasiController.text.trim(),
        ),
      ),
    );
  }

  void _showSnack(String msg, {bool success = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: success
            ? const Color(0xFF34C168)
            : const Color(0xFFE05555),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  // ─────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoCard(),
            const SizedBox(height: 24),
            _buildDateField(),
            const SizedBox(height: 16),
            _buildTimeField(),
            const SizedBox(height: 16),
            _buildLokasiField(),
            const SizedBox(height: 16),
            _buildAlasanField(),
            const SizedBox(height: 32),
            _buildSimpanButton(),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // ──────────────────────────────────────────────
  // AppBar
  // ──────────────────────────────────────────────
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      surfaceTintColor: Colors.white,
      centerTitle: true,
      leading: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: Color(0xFF2D3748),
          size: 20,
        ),
      ),
      title: const Text(
        'Ubah Jadwal',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: Color(0xFF2D3748),
        ),
      ),
    );
  }

  // ──────────────────────────────────────────────
  // Info Card – jadwal lama
  // ──────────────────────────────────────────────
  Widget _buildInfoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEEF7FF),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFD0E8F8), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Imunisasi DPT-1 & Polio-2',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4A9EE0),
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Budi (2 Bulan)',
            style: TextStyle(fontSize: 13, color: Color(0xFF4A9EE0)),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Icon(
                Icons.calendar_today_outlined,
                size: 14,
                color: Color(0xFF9AA5B4),
              ),
              SizedBox(width: 6),
              Text(
                '12 Okt 2023',
                style: TextStyle(fontSize: 13, color: Color(0xFF2D3748)),
              ),
              SizedBox(width: 20),
              Icon(
                Icons.access_time_rounded,
                size: 14,
                color: Color(0xFF9AA5B4),
              ),
              SizedBox(width: 6),
              Text(
                '08:00 WIB',
                style: TextStyle(fontSize: 13, color: Color(0xFF2D3748)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────
  // Field — Tanggal Baru
  // ──────────────────────────────────────────────
  Widget _buildDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tanggal Baru',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2D3748),
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _pickDate,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _selectedDate != null
                    ? const Color(0xFF4A9EE0)
                    : const Color(0xFFE2E8F0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_month_outlined,
                  size: 18,
                  color: _selectedDate != null
                      ? const Color(0xFF4A9EE0)
                      : const Color(0xFF9AA5B4),
                ),
                const SizedBox(width: 10),
                Text(
                  _selectedDate != null ? _formattedDate : 'Pilih tanggal baru',
                  style: TextStyle(
                    fontSize: 13,
                    color: _selectedDate != null
                        ? const Color(0xFF2D3748)
                        : const Color(0xFF9AA5B4),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ──────────────────────────────────────────────
  // Field — Waktu Baru
  // ──────────────────────────────────────────────
  Widget _buildTimeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Waktu Baru',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2D3748),
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _pickTime,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _selectedTime != null
                    ? const Color(0xFF4A9EE0)
                    : const Color(0xFFE2E8F0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(
                  Icons.access_time_rounded,
                  size: 18,
                  color: _selectedTime != null
                      ? const Color(0xFF4A9EE0)
                      : const Color(0xFF9AA5B4),
                ),
                const SizedBox(width: 10),
                Text(
                  _selectedTime != null ? _formattedTime : 'Pilih waktu baru',
                  style: TextStyle(
                    fontSize: 13,
                    color: _selectedTime != null
                        ? const Color(0xFF2D3748)
                        : const Color(0xFF9AA5B4),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ──────────────────────────────────────────────
  // Field — Lokasi
  // ──────────────────────────────────────────────
  Widget _buildLokasiField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Lokasi',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2D3748),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE2E8F0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: _lokasiController,
            style: const TextStyle(fontSize: 13, color: Color(0xFF2D3748)),
            decoration: InputDecoration(
              prefixIcon: const Icon(
                Icons.location_on_outlined,
                size: 18,
                color: Color(0xFF9AA5B4),
              ),
              hintText: 'Masukkan lokasi',
              hintStyle: const TextStyle(
                fontSize: 13,
                color: Color(0xFF9AA5B4),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ──────────────────────────────────────────────
  // Field — Alasan Perubahan
  // ──────────────────────────────────────────────
  Widget _buildAlasanField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Alasan Perubahan (Opsional)',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2D3748),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE2E8F0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: _alasanController,
            maxLines: 4,
            style: const TextStyle(fontSize: 13, color: Color(0xFF2D3748)),
            decoration: const InputDecoration(
              hintText:
                  'Tulis alasan mengubah jadwal (misal: anak sedang sakit)...',
              hintStyle: TextStyle(fontSize: 13, color: Color(0xFF9AA5B4)),
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(16),
            ),
          ),
        ),
      ],
    );
  }

  // ──────────────────────────────────────────────
  // Tombol Simpan Perubahan
  // ──────────────────────────────────────────────
  Widget _buildSimpanButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _simpan,
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
          'Simpan Perubahan',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
