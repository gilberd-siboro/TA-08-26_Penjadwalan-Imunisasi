// lib/screens/child_data_screen.dart
// Halaman Data Anak – SEJIWA
// Desa Hutabulu Mejan | Studi Kasus TA-2026
// Referensi: Buku KIA 2024
// HCAI + GenderMag: risk aversion, self-efficacy, step-by-step flow
// Pengguna utama: Ibu usia 20-40 tahun, literasi digital beragam

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../data/sejiwa_data.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Warna (konsisten dengan home_screen & schedule_screen)
// ─────────────────────────────────────────────────────────────────────────────
class _C {
  static const hijauDaun = Color(0xFF3A7D44);
  static const hijauPucat = Color(0xFFE8F5E9);
  static const hijauMuda = Color(0xFF6BBF73);
  static const biruMuda = Color(0xFFE3F2FD);
  static const biruTeks = Color(0xFF1565C0);
  static const kuning = Color(0xFFF9A825);
  static const kuningBg = Color(0xFFFFF8E1);
  static const merah = Color(0xFFC62828);
  static const putih = Color(0xFFFFFFFF);
  static const abuBg = Color(0xFFF5F5F5);
  static const abuBorder = Color(0xFFE0E0E0);
  static const teksUtama = Color(0xFF212121);
  static const teksAbu = Color(0xFF757575);
  static const pink = Color(0xFFF48FB1);
  static const pinkBg = Color(0xFFFCE4EC);
  static const birulaki = Color(0xFF42A5F5);
  static const biruLakiBg = Color(0xFFE3F2FD);
}

// DataAnak, JenisKelamin, hitungVaksinBerikutnya, globalAnakList
// → diimpor dari '../data/sejiwa_data.dart'

// ─────────────────────────────────────────────────────────────────────────────
// ChildDataScreen
// ─────────────────────────────────────────────────────────────────────────────
class ChildDataScreen extends StatefulWidget {
  const ChildDataScreen({super.key});

  @override
  State<ChildDataScreen> createState() => _ChildDataScreenState();
}

class _ChildDataScreenState extends State<ChildDataScreen> {
  // ── helper warna per jenis kelamin ──
  Color _warnaJK(JenisKelamin jk) =>
      jk == JenisKelamin.perempuan ? _C.pink : _C.birulaki;

  Color _warnaBgJK(JenisKelamin jk) =>
      jk == JenisKelamin.perempuan ? _C.pinkBg : _C.biruLakiBg;

  IconData _ikonJK(JenisKelamin jk) =>
      jk == JenisKelamin.perempuan ? Icons.face_3 : Icons.face;

  String _labelJK(JenisKelamin jk) =>
      jk == JenisKelamin.perempuan ? 'Perempuan' : 'Laki-laki';

  // ────────────────────────────
  // BUILD
  // ────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _C.abuBg,
      appBar: _buildAppBar(),
      body: globalAnakList.isEmpty ? _buildKosong() : _buildDaftarAnak(),
      floatingActionButton: _buildFab(),
    );
  }

  // ── APP BAR ──
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: _C.hijauDaun,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
        onPressed: () => Navigator.maybePop(context),
      ),
      title: const Text(
        'Data Anak',
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        // Tooltip info – GenderMag self-efficacy
        Tooltip(
          message: 'Data anak digunakan untuk menyesuaikan jadwal imunisasi',
          child: IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.white),
            onPressed: () => _showInfoDialog(),
          ),
        ),
      ],
    );
  }

  // ── FAB tambah anak – ukuran besar, jelas ──
  Widget _buildFab() {
    return FloatingActionButton.extended(
      onPressed: () => _showFormTambahAnak(),
      backgroundColor: _C.hijauDaun,
      icon: const Icon(Icons.add, color: Colors.white, size: 26),
      label: const Text(
        'Tambah Anak',
        style: TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // ── STATE KOSONG – friendly, tidak menghakimi ──
  Widget _buildKosong() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: _C.hijauPucat,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.child_care,
                size: 56,
                color: _C.hijauDaun,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Belum ada data anak',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _C.teksUtama,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Tambahkan data anak Anda untuk mulai memantau\njadwal imunisasi.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: _C.teksAbu, height: 1.5),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => _showFormTambahAnak(),
              icon: const Icon(Icons.add),
              label: const Text(
                'Tambah Data Anak',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: _C.hijauDaun,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── DAFTAR ANAK ──
  Widget _buildDaftarAnak() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      children: [
        // Tip kecil – HCAI penjelasan kontekstual
        _buildTipBanner(),
        const SizedBox(height: 16),

        // Judul jumlah anak
        Text(
          '${globalAnakList.length} anak terdaftar',
          style: const TextStyle(fontSize: 14, color: _C.teksAbu),
        ),
        const SizedBox(height: 10),

        ...globalAnakList.map((anak) => _buildKartuAnak(anak)),
      ],
    );
  }

  // Banner HCAI – gentle guidance
  Widget _buildTipBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: _C.biruMuda,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Icon(Icons.tips_and_updates_outlined, size: 18, color: _C.biruTeks),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Data anak digunakan sistem untuk menyesuaikan jadwal '
              'imunisasi secara otomatis sesuai usia.',
              style: TextStyle(fontSize: 13, color: _C.biruTeks, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }

  // ── KARTU ANAK ──
  Widget _buildKartuAnak(DataAnak anak) {
    final warna = _warnaJK(anak.jenisKelamin);
    final warnaBg = _warnaBgJK(anak.jenisKelamin);
    final ikon = _ikonJK(anak.jenisKelamin);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: _C.putih,
        borderRadius: BorderRadius.circular(16),
        border: Border(left: BorderSide(color: warna, width: 5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Avatar inisial
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(color: warnaBg, shape: BoxShape.circle),
              child: Icon(ikon, color: warna, size: 30),
            ),

            const SizedBox(width: 14),

            // Info anak
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nama
                  Text(
                    anak.nama,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: _C.teksUtama,
                    ),
                  ),

                  const SizedBox(height: 4),

                  // Usia + jenis kelamin
                  Row(
                    children: [
                      Icon(Icons.cake_outlined, size: 13, color: _C.teksAbu),
                      const SizedBox(width: 4),
                      Text(
                        anak.usiaTeks,
                        style: const TextStyle(fontSize: 13, color: _C.teksAbu),
                      ),
                      const SizedBox(width: 10),
                      Icon(ikon, size: 13, color: warna),
                      const SizedBox(width: 4),
                      Text(
                        _labelJK(anak.jenisKelamin),
                        style: TextStyle(fontSize: 13, color: warna),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Chip vaksin berikutnya
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _C.kuningBg,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.vaccines, size: 13, color: _C.kuning),
                        const SizedBox(width: 5),
                        Text(
                          'Berikutnya: ${hitungVaksinBerikutnya(anak)}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: _C.kuning,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Menu aksi – tombol edit & hapus
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: _C.teksAbu),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              onSelected: (val) {
                if (val == 'edit') _showFormEditAnak(anak);
                if (val == 'hapus') _konfirmasiHapus(anak);
              },
              itemBuilder: (_) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit_outlined, color: _C.hijauDaun, size: 18),
                      SizedBox(width: 10),
                      Text('Ubah Data', style: TextStyle(fontSize: 14)),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'hapus',
                  child: Row(
                    children: [
                      Icon(Icons.delete_outline, color: _C.merah, size: 18),
                      SizedBox(width: 10),
                      Text(
                        'Hapus',
                        style: TextStyle(fontSize: 14, color: _C.merah),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ────────────────────────────
  // FORM TAMBAH ANAK – Bottom Sheet bertahap
  // GenderMag: step-by-step, tidak overwhelming
  // ────────────────────────────
  void _showFormTambahAnak() => _showFormSheet(null);
  void _showFormEditAnak(DataAnak anak) => _showFormSheet(anak);

  void _showFormSheet(DataAnak? existing) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _FormAnakSheet(
        existing: existing,
        onSimpan: (anak) {
          setState(() {
            if (existing == null) {
              globalAnakList.add(anak);
            } else {
              final idx = globalAnakList.indexWhere((a) => a.id == existing.id);
              if (idx != -1) globalAnakList[idx] = anak;
            }
          });
        },
      ),
    );
  }

  // ────────────────────────────
  // KONFIRMASI HAPUS
  // GenderMag: risk aversion – selalu tanya sebelum hapus
  // ────────────────────────────
  void _konfirmasiHapus(DataAnak anak) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: _C.kuning, size: 26),
            SizedBox(width: 8),
            Text(
              'Hapus Data Anak?',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: RichText(
          text: TextSpan(
            style: const TextStyle(
              fontSize: 14,
              color: _C.teksUtama,
              height: 1.5,
            ),
            children: [
              const TextSpan(text: 'Data anak '),
              TextSpan(
                text: anak.nama,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const TextSpan(
                text:
                    ' akan dihapus permanen.\n\n'
                    'Jadwal imunisasi yang sudah tersimpan juga akan ikut terhapus.',
              ),
            ],
          ),
        ),
        actions: [
          // Tombol batal – lebih menonjol (GenderMag: risk aversion)
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: _C.hijauDaun,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Batal',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
          // Tombol hapus – teks merah tapi tidak mencolok
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(
                () => globalAnakList.removeWhere((a) => a.id == anak.id),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Data ${anak.nama} dihapus.',
                    style: const TextStyle(fontSize: 14),
                  ),
                  backgroundColor: _C.teksAbu,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
            child: const Text(
              'Ya, Hapus',
              style: TextStyle(color: _C.merah, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  // ────────────────────────────
  // DIALOG INFO – HCAI transparency
  // ────────────────────────────
  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.child_care, color: _C.hijauDaun, size: 24),
            SizedBox(width: 8),
            Text(
              'Kenapa Data Anak Diperlukan?',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: const Text(
          'Sistem SEJIWA menggunakan data anak (nama, tanggal lahir, jenis kelamin) '
          'untuk:\n\n'
          '• Menghitung usia anak secara otomatis\n'
          '• Menyesuaikan jadwal imunisasi berdasarkan Buku KIA 2024\n'
          '• Memberikan pengingat tepat waktu\n\n'
          'Data Anda tersimpan aman di perangkat ini.',
          style: TextStyle(fontSize: 14, height: 1.6),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: _C.hijauDaun,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 0,
            ),
            child: const Text('Mengerti'),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Form Bottom Sheet – Step-by-step
// GenderMag: learning style, self-efficacy
// ─────────────────────────────────────────────────────────────────────────────
class _FormAnakSheet extends StatefulWidget {
  final DataAnak? existing;
  final void Function(DataAnak) onSimpan;

  const _FormAnakSheet({required this.onSimpan, this.existing});

  @override
  State<_FormAnakSheet> createState() => _FormAnakSheetState();
}

class _FormAnakSheetState extends State<_FormAnakSheet> {
  final _formKey = GlobalKey<FormState>();
  final _namaCtrl = TextEditingController();
  final _beratCtrl = TextEditingController();

  DateTime? _tanggalLahir;
  JenisKelamin _jenisKelamin = JenisKelamin.perempuan;
  String? _golonganDarah;

  // Step 1 = info dasar, Step 2 = info tambahan (opsional)
  int _step = 1;
  bool _sedangSimpan = false;

  final List<String> _opsiGoldar = ['A', 'B', 'AB', 'O', 'Tidak tahu'];

  @override
  void initState() {
    super.initState();
    if (widget.existing != null) {
      _namaCtrl.text = widget.existing!.nama;
      _tanggalLahir = widget.existing!.tanggalLahir;
      _jenisKelamin = widget.existing!.jenisKelamin;
      _beratCtrl.text = widget.existing!.beratLahirKg?.toString() ?? '';
      _golonganDarah = widget.existing!.golonganDarah;
    }
  }

  @override
  void dispose() {
    _namaCtrl.dispose();
    _beratCtrl.dispose();
    super.dispose();
  }

  bool get _isEdit => widget.existing != null;

  // ── Pilih tanggal lahir – custom picker Bahasa Indonesia ──
  // GenderMag: hindari dialog kalender Inggris yang membingungkan
  void _pilihTanggal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _TanggalPilihSheet(
        awal: _tanggalLahir,
        onPilih: (dt) {
          if (mounted) setState(() => _tanggalLahir = dt);
        },
      ),
    );
  }

  String _formatTanggal(DateTime dt) {
    const bulan = [
      '',
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return '${dt.day} ${bulan[dt.month]} ${dt.year}';
  }

  void _lanjutStep2() {
    if (!_formKey.currentState!.validate()) return;
    if (_tanggalLahir == null) {
      _snack('Tanggal lahir belum dipilih.', isError: true);
      return;
    }
    setState(() => _step = 2);
  }

  void _simpan() {
    setState(() => _sedangSimpan = true);

    // Simulasi proses simpan
    Future.delayed(const Duration(milliseconds: 600), () {
      final anak = DataAnak(
        id: _isEdit
            ? widget.existing!.id
            : DateTime.now().millisecondsSinceEpoch.toString(),
        nama: _namaCtrl.text.trim(),
        tanggalLahir: _tanggalLahir!,
        jenisKelamin: _jenisKelamin,
        beratLahirKg: double.tryParse(_beratCtrl.text),
        golonganDarah: (_golonganDarah == 'Tidak tahu') ? null : _golonganDarah,
        // Pertahankan riwayat vaksin yang sudah selesai saat edit
        vaksinSudahDone: _isEdit ? widget.existing!.vaksinSudahDone : {},
      );
      widget.onSimpan(anak);
      Navigator.pop(context);
      _snackGlobal(
        '${anak.nama} berhasil ${_isEdit ? "diperbarui" : "ditambahkan"}. ✓',
      );
    });
  }

  void _snack(String pesan, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(pesan, style: const TextStyle(fontSize: 14)),
        backgroundColor: isError ? _C.merah : _C.hijauDaun,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _snackGlobal(String pesan) {
    // Tampil setelah sheet ditutup
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(pesan, style: const TextStyle(fontSize: 14)),
            backgroundColor: _C.hijauDaun,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    });
  }

  // ── BUILD ──
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.88,
      minChildSize: 0.6,
      maxChildSize: 0.95,
      builder: (_, controller) => Container(
        decoration: const BoxDecoration(
          color: _C.putih,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          children: [
            // Handle
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 4),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: _C.abuBorder,
                borderRadius: BorderRadius.circular(4),
              ),
            ),

            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  Icon(
                    _isEdit ? Icons.edit_outlined : Icons.child_care,
                    color: _C.hijauDaun,
                    size: 24,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _isEdit ? 'Ubah Data Anak' : 'Tambah Data Anak',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: _C.teksUtama,
                      ),
                    ),
                  ),
                  // Indikator langkah – GenderMag: self-efficacy
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _C.hijauPucat,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Langkah $_step dari 2',
                      style: const TextStyle(
                        fontSize: 12,
                        color: _C.hijauDaun,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Progress bar langkah
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: _step == 1 ? 0.5 : 1.0,
                  minHeight: 6,
                  backgroundColor: _C.hijauPucat,
                  valueColor: const AlwaysStoppedAnimation<Color>(_C.hijauDaun),
                ),
              ),
            ),

            const SizedBox(height: 4),

            // Konten form
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  controller: controller,
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
                  children: _step == 1 ? _buildStep1() : _buildStep2(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── STEP 1 – Info Dasar (wajib) ───────────────────────────────────────────
  List<Widget> _buildStep1() {
    return [
      _labelSection('Informasi Dasar', Icons.assignment_ind_outlined),
      const SizedBox(height: 16),

      // Nama anak
      _labelField('Nama Lengkap Anak', wajib: true),
      const SizedBox(height: 6),
      TextFormField(
        controller: _namaCtrl,
        textCapitalization: TextCapitalization.words,
        style: const TextStyle(fontSize: 16),
        decoration: _inputDecor(
          hint: 'Contoh: Asri Hutabulu',
          prefixIcon: Icons.badge_outlined,
          helper: 'Tulis nama lengkap sesuai Kartu Keluarga',
        ),
        validator: (v) {
          if (v == null || v.trim().isEmpty) {
            return 'Nama anak tidak boleh kosong.';
          }
          if (v.trim().length < 2) return 'Nama terlalu pendek.';
          return null;
        },
      ),

      const SizedBox(height: 20),

      // Tanggal lahir
      _labelField('Tanggal Lahir', wajib: true),
      const SizedBox(height: 4),
      // HCAI: jelaskan kenapa tanggal penting sebelum user mengisinya
      const Text(
        'Tanggal lahir membantu sistem menghitung jadwal imunisasi yang tepat.',
        style: TextStyle(fontSize: 12, color: _C.teksAbu, height: 1.4),
      ),
      const SizedBox(height: 8),
      // Tombol buka picker – GenderMag: tampilan jelas, tidak seperti input teks
      Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _pilihTanggal,
          borderRadius: BorderRadius.circular(12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
            decoration: BoxDecoration(
              color: _tanggalLahir == null ? _C.abuBg : _C.hijauPucat,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _tanggalLahir == null ? _C.abuBorder : _C.hijauDaun,
                width: _tanggalLahir == null ? 1.0 : 2.0,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _tanggalLahir == null ? _C.abuBorder : _C.hijauDaun,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _tanggalLahir == null
                        ? Icons.calendar_month_outlined
                        : Icons.event_available,
                    color: _tanggalLahir == null ? _C.teksAbu : Colors.white,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _tanggalLahir == null
                            ? 'Pilih tanggal lahir'
                            : _formatTanggal(_tanggalLahir!),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: _tanggalLahir == null
                              ? FontWeight.normal
                              : FontWeight.bold,
                          color: _tanggalLahir == null
                              ? _C.teksAbu
                              : _C.hijauDaun,
                        ),
                      ),
                      if (_tanggalLahir == null)
                        const Text(
                          'Ketuk di sini untuk memilih',
                          style: TextStyle(fontSize: 12, color: _C.teksAbu),
                        ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: _tanggalLahir == null ? _C.teksAbu : _C.hijauDaun,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),

      const SizedBox(height: 20),

      // Jenis kelamin – tombol visual besar (bukan dropdown)
      _labelField('Jenis Kelamin', wajib: true),
      const SizedBox(height: 10),
      Row(
        children: [
          Expanded(
            child: _tombolJenisKelamin(
              label: 'Laki-laki',
              ikon: Icons.face,
              jk: JenisKelamin.lakilaki,
              warna: _C.birulaki,
              warnaBg: _C.biruLakiBg,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _tombolJenisKelamin(
              label: 'Perempuan',
              ikon: Icons.face_3,
              jk: JenisKelamin.perempuan,
              warna: _C.pink,
              warnaBg: _C.pinkBg,
            ),
          ),
        ],
      ),

      const SizedBox(height: 32),

      // Tombol lanjut
      SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _lanjutStep2,
          style: ElevatedButton.styleFrom(
            backgroundColor: _C.hijauDaun,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Lanjut',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 8),
              Icon(Icons.arrow_forward_rounded, size: 18),
            ],
          ),
        ),
      ),

      const SizedBox(height: 12),

      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text(
          'Batal',
          style: TextStyle(color: _C.teksAbu, fontSize: 14),
        ),
      ),
    ];
  }

  // ─── STEP 2 – Info Tambahan (opsional) ─────────────────────────────────────
  List<Widget> _buildStep2() {
    return [
      _labelSection('Info Tambahan (Opsional)', Icons.info_outline),

      // Keterangan opsional – self-efficacy
      Container(
        margin: const EdgeInsets.symmetric(vertical: 12),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: _C.hijauPucat,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Row(
          children: [
            Icon(Icons.check_circle_outline, size: 16, color: _C.hijauDaun),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'Bagian ini opsional. Anda bisa lewati dan isi nanti.',
                style: TextStyle(
                  fontSize: 13,
                  color: _C.hijauDaun,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),

      // Ringkasan step 1
      _buildRingkasanStep1(),
      const SizedBox(height: 20),

      // Berat lahir
      _labelField('Berat Lahir (kg)', wajib: false),
      const SizedBox(height: 6),
      TextFormField(
        controller: _beratCtrl,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,1}')),
        ],
        style: const TextStyle(fontSize: 16),
        decoration: _inputDecor(
          hint: 'Contoh: 3.2',
          prefixIcon: Icons.monitor_weight_outlined,
          helper: 'Tulis dalam kilogram. Contoh: 3.2 untuk 3,2 kg',
        ),
      ),

      const SizedBox(height: 20),

      // Golongan darah
      _labelField('Golongan Darah', wajib: false),
      const SizedBox(height: 10),
      Wrap(
        spacing: 10,
        runSpacing: 8,
        children: _opsiGoldar.map((g) {
          final dipilih = _golonganDarah == g;
          return GestureDetector(
            onTap: () => setState(() => _golonganDarah = dipilih ? null : g),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: dipilih ? _C.hijauDaun : _C.abuBg,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: dipilih ? _C.hijauDaun : _C.abuBorder,
                ),
              ),
              child: Text(
                g,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: dipilih ? Colors.white : _C.teksUtama,
                ),
              ),
            ),
          );
        }).toList(),
      ),

      const SizedBox(height: 32),

      // Tombol simpan
      SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _sedangSimpan ? null : _simpan,
          style: ElevatedButton.styleFrom(
            backgroundColor: _C.hijauDaun,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
          child: _sedangSimpan
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : Text(
                  _isEdit ? 'Simpan Perubahan' : 'Simpan Data Anak',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),

      const SizedBox(height: 12),

      // Kembali ke step 1
      SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: () => setState(() => _step = 1),
          icon: const Icon(
            Icons.arrow_back_rounded,
            size: 18,
            color: _C.teksAbu,
          ),
          label: const Text(
            'Kembali ke Langkah 1',
            style: TextStyle(color: _C.teksAbu, fontSize: 14),
          ),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12),
            side: const BorderSide(color: _C.abuBorder),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    ];
  }

  // ── Ringkasan step 1 (ditampilkan di step 2) ──
  Widget _buildRingkasanStep1() {
    final jk = _jenisKelamin == JenisKelamin.perempuan
        ? 'Perempuan'
        : 'Laki-laki';
    final tgl = _tanggalLahir != null ? _formatTanggal(_tanggalLahir!) : '-';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _C.abuBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _C.abuBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Data yang sudah diisi:',
            style: TextStyle(
              fontSize: 12,
              color: _C.teksAbu,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          _barisSummary(Icons.badge_outlined, 'Nama', _namaCtrl.text),
          const SizedBox(height: 6),
          _barisSummary(Icons.calendar_today, 'Tanggal Lahir', tgl),
          const SizedBox(height: 6),
          _barisSummary(Icons.face, 'Jenis Kelamin', jk),
        ],
      ),
    );
  }

  Widget _barisSummary(IconData icon, String label, String nilai) {
    return Row(
      children: [
        Icon(icon, size: 14, color: _C.hijauDaun),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: const TextStyle(fontSize: 13, color: _C.teksAbu),
        ),
        Text(
          nilai,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: _C.teksUtama,
          ),
        ),
      ],
    );
  }

  // ── TOMBOL JENIS KELAMIN – visual besar ──
  Widget _tombolJenisKelamin({
    required String label,
    required IconData ikon,
    required JenisKelamin jk,
    required Color warna,
    required Color warnaBg,
  }) {
    final dipilih = _jenisKelamin == jk;
    return GestureDetector(
      onTap: () => setState(() => _jenisKelamin = jk),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: dipilih ? warnaBg : _C.abuBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: dipilih ? warna : _C.abuBorder,
            width: dipilih ? 2.0 : 1.0,
          ),
        ),
        child: Column(
          children: [
            Icon(ikon, size: 40, color: dipilih ? warna : _C.teksAbu),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: dipilih ? warna : _C.teksAbu,
              ),
            ),
            if (dipilih) ...[
              const SizedBox(height: 4),
              Icon(Icons.check_circle, size: 16, color: warna),
            ],
          ],
        ),
      ),
    );
  }

  // ── Helper dekorasi input ──
  InputDecoration _inputDecor({
    required String hint,
    required IconData prefixIcon,
    String? helper,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: _C.teksAbu, fontSize: 15),
      helperText: helper,
      helperStyle: const TextStyle(fontSize: 12, color: _C.teksAbu),
      helperMaxLines: 2,
      prefixIcon: Icon(prefixIcon, color: _C.hijauMuda, size: 20),
      filled: true,
      fillColor: _C.abuBg,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _C.abuBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _C.abuBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _C.hijauDaun, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _C.merah),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _C.merah, width: 1.5),
      ),
    );
  }

  Widget _labelField(String teks, {required bool wajib}) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: teks,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: _C.teksUtama,
            ),
          ),
          if (wajib)
            const TextSpan(
              text: ' *',
              style: TextStyle(
                color: _C.merah,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
    );
  }

  Widget _labelSection(String teks, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: _C.hijauDaun),
        const SizedBox(width: 8),
        Text(
          teks,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: _C.teksUtama,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Widget Pemilih Tanggal Lahir – Khusus HCAI + GenderMag
// Tap-based: pilih Tahun → Bulan (nama Indonesia) → Tanggal (angka besar)
// Tidak ada kalender Inggris, tidak ada scroll yang membingungkan
// ─────────────────────────────────────────────────────────────────────────────
class _TanggalPilihSheet extends StatefulWidget {
  final DateTime? awal;
  final void Function(DateTime) onPilih;

  const _TanggalPilihSheet({required this.onPilih, this.awal});

  @override
  State<_TanggalPilihSheet> createState() => _TanggalPilihSheetState();
}

class _TanggalPilihSheetState extends State<_TanggalPilihSheet> {
  static const _namaBulan = [
    '',
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];

  late int _tahun;
  late int _bulan;
  late int _hari;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _tahun = widget.awal?.year ?? now.year;
    _bulan = widget.awal?.month ?? now.month;
    _hari = widget.awal?.day ?? 1;
    _hari = _hari.clamp(1, _maxHari(_tahun, _bulan));
  }

  // Berapa hari maksimal di bulan & tahun tertentu
  int _maxHari(int tahun, int bulan) => DateTime(tahun, bulan + 1, 0).day;

  // Daftar tahun: 10 tahun ke belakang + tahun ini (selalu update otomatis)
  List<int> get _daftarTahun {
    final sekarang = DateTime.now().year;
    return List.generate(11, (i) => sekarang - i).reversed.toList();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final maxH = (_tahun == now.year && _bulan == now.month)
        ? now
              .day // Bulan ini: hanya sampai hari ini
        : _maxHari(_tahun, _bulan);
    if (_hari > maxH) _hari = maxH;

    return Container(
      decoration: const BoxDecoration(
        color: _C.putih,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Handle ──
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 4),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: _C.abuBorder,
                borderRadius: BorderRadius.circular(4),
              ),
            ),

            // ── Judul ──
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
              child: Row(
                children: const [
                  Icon(Icons.calendar_month, color: _C.hijauDaun, size: 24),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Pilih Tanggal Lahir Anak',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: _C.teksUtama,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── HCAI Chip – jelaskan tujuan ──
            Container(
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: _C.biruMuda,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: const [
                  Icon(Icons.auto_awesome, size: 14, color: _C.biruTeks),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Tanggal lahir membantu sistem '
                      'menghitung jadwal imunisasi yang tepat.',
                      style: TextStyle(
                        fontSize: 12,
                        color: _C.biruTeks,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Konten scrollable ──
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ═══ TAHUN ═══════════════════════════════════════════════
                    _judulBagian('① Tahun Lahir'),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: _C.abuBg,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: _C.hijauDaun, width: 1.5),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 4,
                      ),
                      child: DropdownButton<int>(
                        value: _tahun,
                        isExpanded: true,
                        underline: const SizedBox.shrink(),
                        icon: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: _C.hijauDaun,
                        ),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: _C.hijauDaun,
                        ),
                        dropdownColor: _C.putih,
                        borderRadius: BorderRadius.circular(12),
                        items: _daftarTahun.reversed
                            .map(
                              (th) => DropdownMenuItem(
                                value: th,
                                child: Text(
                                  '$th${th == DateTime.now().year ? "  (tahun ini)" : ""}',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: th == _tahun
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    color: th == _tahun
                                        ? _C.hijauDaun
                                        : _C.teksUtama,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (th) {
                          if (th == null) return;
                          final now = DateTime.now();
                          setState(() {
                            _tahun = th;
                            // Jika pindah ke tahun ini, bulan tidak boleh melebihi bulan sekarang
                            if (_tahun == now.year && _bulan > now.month) {
                              _bulan = now.month;
                            }
                            // Jika bulan+tahun = sekarang, hari tidak boleh melebihi hari ini
                            final maxH =
                                (_tahun == now.year && _bulan == now.month)
                                ? now.day
                                : _maxHari(_tahun, _bulan);
                            _hari = _hari.clamp(1, maxH);
                          });
                        },
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ═══ BULAN ════════════════════════════════════════════════
                    _judulBagian('② Bulan Lahir'),
                    const SizedBox(height: 8),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 8,
                            crossAxisSpacing: 8,
                            childAspectRatio: 2.4,
                          ),
                      itemCount: 12,
                      itemBuilder: (_, i) {
                        final bln = i + 1;
                        final dipilih = bln == _bulan;
                        final now = DateTime.now();
                        // Nonaktifkan bulan masa depan jika tahun = tahun ini
                        final nonaktif = _tahun == now.year && bln > now.month;
                        return _tombolBulan(
                          label: _namaBulan[bln],
                          dipilih: dipilih,
                          nonaktif: nonaktif,
                          onTap: nonaktif
                              ? null
                              : () => setState(() {
                                  _bulan = bln;
                                  _hari = _hari.clamp(
                                    1,
                                    _maxHari(_tahun, _bulan),
                                  );
                                }),
                        );
                      },
                    ),

                    const SizedBox(height: 20),

                    // ═══ TANGGAL ══════════════════════════════════════════════
                    _judulBagian('③ Tanggal Lahir'),
                    const SizedBox(height: 8),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 7,
                            mainAxisSpacing: 6,
                            crossAxisSpacing: 6,
                            childAspectRatio: 1.0,
                          ),
                      itemCount: maxH,
                      itemBuilder: (_, i) {
                        final tgl = i + 1;
                        final dipilih = tgl == _hari;
                        final now = DateTime.now();
                        // Nonaktifkan tanggal masa depan jika bulan+tahun = sekarang
                        final nonaktifTgl =
                            _tahun == now.year &&
                            _bulan == now.month &&
                            tgl > now.day;
                        return GestureDetector(
                          onTap: nonaktifTgl
                              ? null
                              : () => setState(() => _hari = tgl),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            decoration: BoxDecoration(
                              color: nonaktifTgl
                                  ? _C.abuBorder.withOpacity(0.4)
                                  : (dipilih ? _C.hijauDaun : _C.abuBg),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: nonaktifTgl
                                    ? _C.abuBorder
                                    : (dipilih ? _C.hijauDaun : _C.abuBorder),
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '$tgl',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: nonaktifTgl
                                    ? _C.teksAbu.withOpacity(0.4)
                                    : (dipilih ? Colors.white : _C.teksUtama),
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 20),

                    // ═══ PREVIEW HASIL ════════════════════════════════════════
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: _C.hijauPucat,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: _C.hijauDaun),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Tanggal yang dipilih:',
                            style: TextStyle(fontSize: 12, color: _C.teksAbu),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(
                                Icons.event_available,
                                color: _C.hijauDaun,
                                size: 22,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                '$_hari ${_namaBulan[_bulan]} $_tahun',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: _C.hijauDaun,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ═══ TOMBOL KONFIRMASI ════════════════════════════════════
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          widget.onPilih(DateTime(_tahun, _bulan, _hari));
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.check_rounded, size: 20),
                        label: Text(
                          'Ya, Tanggalnya $_hari ${_namaBulan[_bulan]} $_tahun',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _C.hijauDaun,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          'Batal',
                          style: TextStyle(color: _C.teksAbu, fontSize: 14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Helper: judul bagian ──
  Widget _judulBagian(String teks) {
    return Text(
      teks,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: _C.teksUtama,
      ),
    );
  }

  // ── Tombol bulan (grid 3 kolom) ──
  Widget _tombolBulan({
    required String label,
    required bool dipilih,
    required bool nonaktif,
    required VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          color: nonaktif
              ? _C.abuBorder.withOpacity(0.4)
              : (dipilih ? _C.hijauDaun : _C.abuBg),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: nonaktif
                ? _C.abuBorder
                : (dipilih ? _C.hijauDaun : _C.abuBorder),
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: nonaktif
                ? _C.teksAbu.withOpacity(0.4)
                : (dipilih ? Colors.white : _C.teksUtama),
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
