// lib/screens/register_screen.dart
// Halaman Registrasi – SEJIWA
// Desa Hutabulu Mejan | Studi Kasus TA-2026
// Referensi: Buku KIA 2024
//
// Prinsip GenderMag (Universal Interface – tidak pisah tampilan per role):
//   • Self-efficacy  → progress bar + label "Langkah X dari 2"
//   • Risk aversion  → konfirmasi sebelum simpan, validasi real-time, auto-reset
//   • Step-by-step   → 2 langkah terpisah, tidak overwhelming
//   • Motivasi       → framing positif: "lindungi keluarga"
//   • Inklusif       → role selector hanya untuk data penelitian, UI sama semua
//
// Prinsip HCAI:
//   • Transparansi   → chip biru jelaskan kenapa data diperlukan
//   • Kontrol user   → toggle kehamilan opsional, tidak diasumsikan
//   • Non-judgmental → bahasa empatik, tidak menggurui
//   • HPHT+TT muncul hanya jika pengguna mengaktifkan toggle kehamilan

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/sejiwa_data.dart';
import 'home_screen.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Warna – konsisten dengan seluruh aplikasi
// ─────────────────────────────────────────────────────────────────────────────
class _C {
  static const hijauDaun = Color(0xFF3A7D44);
  static const hijauPucat = Color(0xFFE8F5E9);
  static const hijauMuda = Color(0xFF6BBF73);
  static const biruMuda = Color(0xFFE3F2FD);
  static const biruTeks = Color(0xFF1565C0);
  static const kuning = Color(0xFFF9A825);
  static const kuningPucat = Color(0xFFFFF8E1);
  static const merah = Color(0xFFC62828);
  static const putih = Color(0xFFFFFFFF);
  static const abuBg = Color(0xFFF5F5F5);
  static const abuBorder = Color(0xFFE0E0E0);
  static const teksUtama = Color(0xFF212121);
  static const teksAbu = Color(0xFF757575);
}

// ─────────────────────────────────────────────────────────────────────────────
// RegisterScreen
// ─────────────────────────────────────────────────────────────────────────────
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey1 = GlobalKey<FormState>();

  // Step 1 – controllers
  final _namaCtrl = TextEditingController();
  final _hpCtrl = TextEditingController();
  final _sandiCtrl = TextEditingController();
  final _konfirmasiSandiCtrl = TextEditingController();
  bool _lihatSandi = false;
  bool _lihatKonfirmasi = false;
  RolePengguna _role = RolePengguna.ibu; // GenderMag: identitas peran

  // Step 2 – data tambahan
  bool _adaKehamilan = false; // toggle universal: apakah ada yang hamil?
  DateTime? _hpht;
  StatusTT _statusTTAwal = StatusTT.belum;

  int _step = 1;
  bool _menyimpan = false;

  @override
  void dispose() {
    _namaCtrl.dispose();
    _hpCtrl.dispose();
    _sandiCtrl.dispose();
    _konfirmasiSandiCtrl.dispose();
    super.dispose();
  }

  // ── Format tanggal Indonesia ──
  String _fmtTanggal(DateTime dt) {
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

  // ── Picker HPHT ──
  void _pilihHPHT() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _HPHTPickerSheet(
        awal: _hpht,
        onPilih: (dt) {
          if (mounted) setState(() => _hpht = dt);
        },
      ),
    );
  }

  // ── Langkah 1 → 2 ──
  void _lanjutStep2() {
    if (!_formKey1.currentState!.validate()) return;
    setState(() => _step = 2);
  }

  // ── Simpan registrasi ──
  void _simpan() {
    // HPHT wajib hanya jika toggle kehamilan aktif
    if (_adaKehamilan && _hpht == null) {
      _snack('Harap pilih Hari Pertama Haid Terakhir (HPHT).', isError: true);
      return;
    }
    setState(() => _menyimpan = true);

    Future.delayed(const Duration(milliseconds: 700), () {
      // Perbarui data pengguna global
      globalPengguna
        ..namaLengkap = _namaCtrl.text.trim()
        ..nomorHP = _hpCtrl.text.trim()
        ..role = _role;

      // Perbarui data kehamilan global – hanya jika toggle kehamilan aktif
      globalDataKehamilan.namaIbu = _namaCtrl.text.trim().split(' ').first;
      if (_adaKehamilan && _hpht != null) {
        globalDataKehamilan.tanggalHPHT = _hpht!;
        globalDataKehamilan.riwayatTT.clear();

        if (_statusTTAwal == StatusTT.sudah1x) {
          globalDataKehamilan.riwayatTT.add(
            KonfirmasiTT(
              tanggal: DateTime.now().subtract(const Duration(days: 28)),
              keterangan: 'Imunisasi Tetanus ke-1 (dicatat saat registrasi)',
            ),
          );
        } else if (_statusTTAwal == StatusTT.lengkap) {
          globalDataKehamilan.riwayatTT.addAll([
            KonfirmasiTT(
              tanggal: DateTime.now().subtract(const Duration(days: 56)),
              keterangan: 'Imunisasi Tetanus ke-1 (dicatat saat registrasi)',
            ),
            KonfirmasiTT(
              tanggal: DateTime.now().subtract(const Duration(days: 28)),
              keterangan: 'Imunisasi Tetanus ke-2 (dicatat saat registrasi)',
            ),
          ]);
        }
      }

      // Navigasi ke HomeScreen
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
          (_) => false,
        );
      }
    });
  }

  // ─────────────────────────────────────────────────────────────────────────
  // BUILD
  // ─────────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _C.abuBg,
      appBar: AppBar(
        backgroundColor: _C.hijauDaun,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
          onPressed: () => _step == 1
              ? Navigator.of(context).pop()
              : setState(() => _step = 1),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Daftar Akun SEJIWA',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              _step == 1
                  ? 'Langkah 1 dari 2 – Informasi Akun'
                  : 'Langkah 2 dari 2 – Data Tambahan',
              style: const TextStyle(fontSize: 11, color: Colors.white70),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Progress bar
          LinearProgressIndicator(
            value: _step == 1 ? 0.5 : 1.0,
            minHeight: 4,
            backgroundColor: _C.hijauPucat,
            valueColor: const AlwaysStoppedAnimation<Color>(_C.hijauMuda),
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(20),
              child: _step == 1 ? _buildStep1() : _buildStep2(),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────
  // STEP 1 – INFORMASI AKUN
  // ─────────────────────────────────────
  Widget _buildStep1() {
    return Form(
      key: _formKey1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header banner
          _buildBanner(
            ikon: Icons.person_add_outlined,
            judul: 'Informasi Akun',
            sub: 'Isi data diri Anda untuk membuat akun',
          ),
          const SizedBox(height: 20),

          // HCAI chip
          _buildChipHCAI(
            'Nama dan nomor HP digunakan untuk menyesuaikan '
            'informasi kesehatan Anda di aplikasi.',
          ),
          const SizedBox(height: 20),

          // Nama lengkap
          _labelField('Nama Lengkap Ibu', wajib: true),
          const SizedBox(height: 6),
          TextFormField(
            controller: _namaCtrl,
            textCapitalization: TextCapitalization.words,
            style: const TextStyle(fontSize: 16),
            decoration: _inputDecor(
              hint: 'Contoh: Sari Hutabulu',
              prefixIcon: Icons.badge_outlined,
              helper: 'Tulis nama lengkap sesuai Kartu Keluarga',
            ),
            validator: (v) {
              if (v == null || v.trim().isEmpty)
                return 'Nama tidak boleh kosong.';
              if (v.trim().length < 2) return 'Nama terlalu pendek.';
              return null;
            },
          ),
          const SizedBox(height: 20),

          // Nomor HP
          _labelField('Nomor Telepon', wajib: true),
          const SizedBox(height: 6),
          TextFormField(
            controller: _hpCtrl,
            keyboardType: TextInputType.phone,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: const TextStyle(fontSize: 16),
            decoration: _inputDecor(
              hint: 'Contoh: 08123456789',
              prefixIcon: Icons.phone_android_outlined,
              helper: 'Gunakan nomor aktif untuk menerima pengingat imunisasi',
            ),
            validator: (v) {
              if (v == null || v.isEmpty) return 'Nomor HP tidak boleh kosong.';
              if (!RegExp(r'^08[1-9][0-9]{7,10}$').hasMatch(v)) {
                return 'Format nomor HP tidak valid. Contoh: 08123456789';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),

          // ── Peran dalam keluarga – GenderMag role tagging ──
          _labelField('Peran dalam Keluarga', wajib: false),
          const SizedBox(height: 6),
          _buildChipHCAI(
            'Pilihan peran hanya digunakan untuk keperluan data penelitian. '
            'Semua pengguna mendapatkan tampilan dan fitur yang sama.',
          ),
          const SizedBox(height: 12),
          _buildPilihRole(),
          const SizedBox(height: 20),

          // Kata sandi
          _labelField('Kata Sandi', wajib: true),
          const SizedBox(height: 6),
          TextFormField(
            controller: _sandiCtrl,
            obscureText: !_lihatSandi,
            style: const TextStyle(fontSize: 16),
            decoration:
                _inputDecor(
                  hint: 'Minimal 6 karakter',
                  prefixIcon: Icons.lock_outline,
                  helper: 'Gunakan kombinasi huruf dan angka',
                ).copyWith(
                  suffixIcon: IconButton(
                    icon: Icon(
                      _lihatSandi
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: _C.teksAbu,
                    ),
                    onPressed: () => setState(() => _lihatSandi = !_lihatSandi),
                  ),
                ),
            validator: (v) {
              if (v == null || v.isEmpty)
                return 'Kata sandi tidak boleh kosong.';
              if (v.length < 6) return 'Kata sandi minimal 6 karakter.';
              return null;
            },
          ),
          const SizedBox(height: 20),

          // Konfirmasi kata sandi
          _labelField('Konfirmasi Kata Sandi', wajib: true),
          const SizedBox(height: 6),
          TextFormField(
            controller: _konfirmasiSandiCtrl,
            obscureText: !_lihatKonfirmasi,
            style: const TextStyle(fontSize: 16),
            decoration:
                _inputDecor(
                  hint: 'Ulangi kata sandi di atas',
                  prefixIcon: Icons.lock_reset_outlined,
                ).copyWith(
                  suffixIcon: IconButton(
                    icon: Icon(
                      _lihatKonfirmasi
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: _C.teksAbu,
                    ),
                    onPressed: () =>
                        setState(() => _lihatKonfirmasi = !_lihatKonfirmasi),
                  ),
                ),
            validator: (v) {
              if (v == null || v.isEmpty)
                return 'Konfirmasi kata sandi tidak boleh kosong.';
              if (v != _sandiCtrl.text) return 'Kata sandi tidak cocok.';
              return null;
            },
          ),
          const SizedBox(height: 32),

          // Tombol lanjut
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _lanjutStep2,
              style: _styleBtn(),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Lanjut ke Data Kehamilan',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward_rounded, size: 18),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Link kembali login
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Sudah punya akun? ',
                  style: TextStyle(color: _C.teksAbu),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    'Masuk di sini',
                    style: TextStyle(
                      color: _C.hijauDaun,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────
  // STEP 2 – DATA TAMBAHAN (Universal)
  // ─────────────────────────────────────
  Widget _buildStep2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Ringkasan data akun step 1
        _buildRingkasanAkun(),
        const SizedBox(height: 16),

        // Header banner – universal untuk semua peran
        _buildBanner(
          ikon: Icons.family_restroom_outlined,
          judul: 'Data Tambahan',
          sub: 'Opsional – dapat diperbarui kapan saja di dalam aplikasi',
        ),
        const SizedBox(height: 20),

        // HCAI chip – universal
        _buildChipHCAI(
          'Informasi ini membantu sistem menampilkan jadwal imunisasi '
          'yang sesuai. Semua field di langkah ini bersifat opsional '
          'dan dapat diisi atau diubah kapan saja.',
        ),
        const SizedBox(height: 24),

        // ── Toggle kehamilan – universal, tidak diasumsikan siapa yang hamil ──
        _buildToggleKehamilan(),
        const SizedBox(height: 16),

        // ── Section HPHT + TT – hanya muncul jika toggle aktif ──
        if (_adaKehamilan) ..._buildSeksiKehamilan(),

        const SizedBox(height: 32),

        // Tombol daftar
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _menyimpan ? null : _simpan,
            style: _styleBtn(),
            child: _menyimpan
                ? const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                : const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_rounded, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Daftar & Mulai Gunakan SEJIWA',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
        const SizedBox(height: 12),
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
              padding: const EdgeInsets.symmetric(vertical: 13),
              side: const BorderSide(color: _C.abuBorder),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  // ── Toggle kehamilan – universal (tidak diasumsikan siapa yang hamil) ──
  Widget _buildToggleKehamilan() {
    return GestureDetector(
      onTap: () => setState(() {
        _adaKehamilan = !_adaKehamilan;
        if (!_adaKehamilan) {
          _hpht = null;
          _statusTTAwal = StatusTT.belum;
        }
      }),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _adaKehamilan ? _C.hijauPucat : _C.putih,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: _adaKehamilan ? _C.hijauDaun : _C.abuBorder,
            width: _adaKehamilan ? 2.0 : 1.0,
          ),
        ),
        child: Row(
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                _adaKehamilan
                    ? Icons.pregnant_woman
                    : Icons.pregnant_woman_outlined,
                key: ValueKey(_adaKehamilan),
                color: _adaKehamilan ? _C.hijauDaun : _C.teksAbu,
                size: 28,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ada anggota keluarga yang sedang hamil?',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: _adaKehamilan ? _C.hijauDaun : _C.teksUtama,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _adaKehamilan
                        ? 'Aktif – isi data kehamilan di bawah'
                        : 'Ketuk untuk mengaktifkan',
                    style: TextStyle(
                      fontSize: 12,
                      color: _adaKehamilan
                          ? _C.hijauDaun.withOpacity(0.75)
                          : _C.teksAbu,
                    ),
                  ),
                ],
              ),
            ),
            Switch(
              value: _adaKehamilan,
              onChanged: (val) => setState(() {
                _adaKehamilan = val;
                if (!val) {
                  _hpht = null;
                  _statusTTAwal = StatusTT.belum;
                }
              }),
              activeThumbColor: _C.hijauDaun,
              activeTrackColor: _C.hijauPucat,
            ),
          ],
        ),
      ),
    );
  }

  // ── Seksi HPHT + TT – ditampilkan hanya jika _adaKehamilan == true ──
  List<Widget> _buildSeksiKehamilan() {
    return [
      Container(
        decoration: BoxDecoration(
          color: _C.hijauPucat,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _C.hijauDaun.withOpacity(0.3)),
        ),
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sub-header
            Row(
              children: const [
                Icon(Icons.info_outline, size: 16, color: _C.hijauDaun),
                SizedBox(width: 6),
                Text(
                  'Data Kehamilan – Referensi Buku KIA 2024',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: _C.hijauDaun,
                  ),
                ),
              ],
            ),
            const Divider(height: 18, color: Color(0xFFA5D6A7)),

            // HPHT
            _labelField('Hari Pertama Haid Terakhir (HPHT)', wajib: true),
            const SizedBox(height: 4),
            const Text(
              'Digunakan untuk menghitung usia kehamilan dan taksiran lahir.',
              style: TextStyle(fontSize: 12, color: _C.teksAbu, height: 1.4),
            ),
            const SizedBox(height: 10),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _pilihHPHT,
                borderRadius: BorderRadius.circular(12),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: _hpht == null ? Colors.white : _C.hijauPucat,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _hpht == null ? _C.abuBorder : _C.hijauDaun,
                      width: _hpht == null ? 1.0 : 2.0,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: _hpht == null ? _C.abuBorder : _C.hijauDaun,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _hpht == null
                              ? Icons.calendar_month_outlined
                              : Icons.event_available,
                          color: _hpht == null ? _C.teksAbu : Colors.white,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _hpht == null
                                  ? 'Pilih tanggal HPHT'
                                  : _fmtTanggal(_hpht!),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: _hpht == null
                                    ? FontWeight.normal
                                    : FontWeight.bold,
                                color: _hpht == null
                                    ? _C.teksAbu
                                    : _C.hijauDaun,
                              ),
                            ),
                            if (_hpht == null)
                              const Text(
                                'Ketuk di sini untuk memilih',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: _C.teksAbu,
                                ),
                              ),
                            if (_hpht != null)
                              Text(
                                'Usia kehamilan: ${_hitungUsia(_hpht!)}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: _C.hijauDaun,
                                ),
                              ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: _hpht == null ? _C.teksAbu : _C.hijauDaun,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Status TT
            _labelField('Status Imunisasi Tetanus (TT) Saat Ini', wajib: false),
            const SizedBox(height: 4),
            const Text(
              'Dapat diperbarui kapan saja di fitur Imunisasi.',
              style: TextStyle(fontSize: 12, color: _C.teksAbu, height: 1.4),
            ),
            const SizedBox(height: 12),
            _buildPilihStatusTT(),
          ],
        ),
      ),
      const SizedBox(height: 8),
    ];
  }

  // ── Widget pilih peran – GenderMag chip selector ──
  Widget _buildPilihRole() {
    final opsi = [
      (role: RolePengguna.ibu, ikon: Icons.woman_outlined, label: 'Ibu'),
      (role: RolePengguna.ayah, ikon: Icons.man_outlined, label: 'Ayah'),
      (
        role: RolePengguna.wali,
        ikon: Icons.supervisor_account_outlined,
        label: 'Wali',
      ),
      (
        role: RolePengguna.kakekNenek,
        ikon: Icons.elderly_outlined,
        label: 'Kakek/Nenek',
      ),
    ];
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: opsi.map((o) {
        final dipilih = _role == o.role;
        return GestureDetector(
          onTap: () => setState(() => _role = o.role),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: dipilih ? _C.hijauDaun : _C.putih,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: dipilih ? _C.hijauDaun : _C.abuBorder,
                width: dipilih ? 2 : 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(o.ikon, size: 18, color: dipilih ? _C.putih : _C.teksAbu),
                const SizedBox(width: 6),
                Text(
                  o.label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: dipilih ? FontWeight.bold : FontWeight.normal,
                    color: dipilih ? _C.putih : _C.teksUtama,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // ── Widget pilih status TT – visual card ──
  Widget _buildPilihStatusTT() {
    final opsi = [
      (
        status: StatusTT.belum,
        label: 'Belum Pernah',
        sub: 'Saya belum pernah imunisasi tetanus',
        ikon: Icons.warning_amber_rounded,
        warna: const Color(0xFFBF360C),
        warnaBg: const Color(0xFFFBE9E7),
      ),
      (
        status: StatusTT.sudah1x,
        label: 'Sudah 1 Kali',
        sub: 'Saya sudah mendapat imunisasi tetanus ke-1',
        ikon: Icons.timelapse_rounded,
        warna: _C.kuning,
        warnaBg: _C.kuningPucat,
      ),
      (
        status: StatusTT.lengkap,
        label: 'Sudah Lengkap (2 kali)',
        sub: 'Saya sudah mendapat 2 dosis imunisasi tetanus',
        ikon: Icons.verified_rounded,
        warna: _C.hijauDaun,
        warnaBg: _C.hijauPucat,
      ),
    ];

    return Column(
      children: opsi.map((o) {
        final dipilih = _statusTTAwal == o.status;
        return GestureDetector(
          onTap: () => setState(() => _statusTTAwal = o.status),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: dipilih ? o.warnaBg : _C.putih,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: dipilih ? o.warna : _C.abuBorder,
                width: dipilih ? 2.0 : 1.0,
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
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: dipilih ? o.warna : _C.abuBg,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    o.ikon,
                    color: dipilih ? Colors.white : _C.teksAbu,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        o.label,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: dipilih ? o.warna : _C.teksUtama,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        o.sub,
                        style: TextStyle(
                          fontSize: 12,
                          color: dipilih
                              ? o.warna.withOpacity(0.8)
                              : _C.teksAbu,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  dipilih
                      ? Icons.check_circle_rounded
                      : Icons.radio_button_unchecked_rounded,
                  color: dipilih ? o.warna : _C.abuBorder,
                  size: 22,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // ── Ringkasan data akun di step 2 ──
  Widget _buildRingkasanAkun() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _C.abuBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _C.abuBorder),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: _C.hijauPucat,
            child: Text(
              _namaCtrl.text.isNotEmpty
                  ? _namaCtrl.text.trim()[0].toUpperCase()
                  : '?',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: _C.hijauDaun,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _namaCtrl.text.trim(),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: _C.teksUtama,
                  ),
                ),
                Text(
                  _hpCtrl.text.trim(),
                  style: const TextStyle(fontSize: 13, color: _C.teksAbu),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () => setState(() => _step = 1),
            child: const Text(
              'Ubah',
              style: TextStyle(
                color: _C.hijauDaun,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Hitung usia kehamilan dari HPHT ──
  String _hitungUsia(DateTime hpht) {
    final selisih = DateTime.now().difference(hpht).inDays;
    final minggu = (selisih / 7).floor();
    if (minggu < 4) return '$selisih hari';
    if (minggu < 13) return '± $minggu minggu (Trimester 1)';
    if (minggu < 28) return '± $minggu minggu (Trimester 2)';
    return '± $minggu minggu (Trimester 3)';
  }

  // ── Helpers UI ──
  Widget _buildBanner({
    required IconData ikon,
    required String judul,
    required String sub,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _C.hijauDaun,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(ikon, color: Colors.white, size: 26),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  judul,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  sub,
                  style: const TextStyle(fontSize: 12, color: Colors.white70),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChipHCAI(String pesan) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: _C.biruMuda,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, size: 18, color: _C.biruTeks),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              pesan,
              style: const TextStyle(
                fontSize: 13,
                color: _C.biruTeks,
                height: 1.45,
              ),
            ),
          ),
        ],
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

  ButtonStyle _styleBtn() => ElevatedButton.styleFrom(
    backgroundColor: _C.hijauDaun,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(vertical: 16),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    elevation: 0,
  );

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
}

// ─────────────────────────────────────────────────────────────────────────────
// HPHT Picker Sheet
// Rentang: max 10 bulan ke belakang (usia kehamilan max ~40 minggu)
// ─────────────────────────────────────────────────────────────────────────────
class _HPHTPickerSheet extends StatefulWidget {
  final DateTime? awal;
  final void Function(DateTime) onPilih;

  const _HPHTPickerSheet({required this.onPilih, this.awal});

  @override
  State<_HPHTPickerSheet> createState() => _HPHTPickerSheetState();
}

class _HPHTPickerSheetState extends State<_HPHTPickerSheet> {
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
    final awal =
        widget.awal ?? DateTime.now().subtract(const Duration(days: 70));
    _tahun = awal.year;
    _bulan = awal.month;
    _hari = awal.day.clamp(1, _maxHari(awal.year, awal.month));
  }

  int _maxHari(int tahun, int bulan) => DateTime(tahun, bulan + 1, 0).day;

  // HPHT harus antara (sekarang - 10 bulan) hingga kemarin
  DateTime get _batasAwal => DateTime.now().subtract(const Duration(days: 300));
  DateTime get _batasTerakhir =>
      DateTime.now().subtract(const Duration(days: 1));

  bool _bulanNonaktif(int tahun, int bulan) {
    final awal = DateTime(_batasAwal.year, _batasAwal.month);
    final akhir = DateTime(_batasTerakhir.year, _batasTerakhir.month);
    final target = DateTime(tahun, bulan);
    return target.isBefore(awal) || target.isAfter(akhir);
  }

  bool _tglNonaktif(int tgl) {
    final target = DateTime(_tahun, _bulan, tgl);
    return target.isBefore(_batasAwal) || target.isAfter(_batasTerakhir);
  }

  // Daftar tahun yang relevan (bisa 1–2 tahun ke belakang)
  List<int> get _daftarTahun {
    final now = DateTime.now();
    final tahunAwal = _batasAwal.year;
    return List.generate(now.year - tahunAwal + 1, (i) => tahunAwal + i);
  }

  @override
  Widget build(BuildContext context) {
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

            // Judul
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
              child: Row(
                children: const [
                  Icon(Icons.calendar_month, color: _C.hijauDaun, size: 24),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Pilih Hari Pertama Haid Terakhir',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: _C.teksUtama,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // HCAI chip
            Container(
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: _C.biruMuda,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: const [
                  Icon(Icons.info_outline, size: 14, color: _C.biruTeks),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'HPHT adalah hari pertama menstruasi terakhir Anda '
                      'sebelum hamil. Pilih tanggal antara 1–10 bulan lalu.',
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

            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ① Tahun
                    _judulBagian('① Tahun'),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _daftarTahun.map((th) {
                        final dipilih = th == _tahun;
                        return GestureDetector(
                          onTap: () => setState(() {
                            _tahun = th;
                            if (_bulanNonaktif(_tahun, _bulan)) {
                              // Reset ke bulan pertama yang valid
                              for (int b = 1; b <= 12; b++) {
                                if (!_bulanNonaktif(_tahun, b)) {
                                  _bulan = b;
                                  break;
                                }
                              }
                            }
                            _hari = _hari.clamp(1, _maxHari(_tahun, _bulan));
                          }),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: dipilih ? _C.hijauDaun : _C.abuBg,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: dipilih ? _C.hijauDaun : _C.abuBorder,
                              ),
                            ),
                            child: Text(
                              '$th',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: dipilih ? Colors.white : _C.teksUtama,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 20),

                    // ② Bulan
                    _judulBagian('② Bulan'),
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
                        final nonaktif = _bulanNonaktif(_tahun, bln);
                        return GestureDetector(
                          onTap: nonaktif
                              ? null
                              : () => setState(() {
                                  _bulan = bln;
                                  _hari = _hari.clamp(
                                    1,
                                    _maxHari(_tahun, _bulan),
                                  );
                                }),
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
                              _namaBulan[bln],
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
                      },
                    ),

                    const SizedBox(height: 20),

                    // ③ Tanggal
                    _judulBagian('③ Tanggal'),
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
                      itemCount: _maxHari(_tahun, _bulan),
                      itemBuilder: (_, i) {
                        final tgl = i + 1;
                        final dipilih = tgl == _hari;
                        final nonaktif = _tglNonaktif(tgl);
                        return GestureDetector(
                          onTap: nonaktif
                              ? null
                              : () => setState(() => _hari = tgl),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 120),
                            decoration: BoxDecoration(
                              color: nonaktif
                                  ? _C.abuBorder.withOpacity(0.4)
                                  : (dipilih ? _C.hijauDaun : _C.abuBg),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: nonaktif
                                    ? _C.abuBorder
                                    : (dipilih ? _C.hijauDaun : _C.abuBorder),
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '$tgl',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: nonaktif
                                    ? _C.teksAbu.withOpacity(0.4)
                                    : (dipilih ? Colors.white : _C.teksUtama),
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 20),

                    // Preview hasil
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
                      child: Row(
                        children: [
                          const Icon(
                            Icons.event_available,
                            color: _C.hijauDaun,
                            size: 22,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'HPHT: $_hari ${_namaBulan[_bulan]} $_tahun',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: _C.hijauDaun,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          if (_tglNonaktif(_hari)) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Tanggal tidak valid. Pilih tanggal 1–10 bulan yang lalu.',
                                ),
                              ),
                            );
                            return;
                          }
                          widget.onPilih(DateTime(_tahun, _bulan, _hari));
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.check_rounded, size: 20),
                        label: Text(
                          'Ya, HPHT saya $_hari ${_namaBulan[_bulan]} $_tahun',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _C.hijauDaun,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
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

  Widget _judulBagian(String teks) => Text(
    teks,
    style: const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      color: _C.teksUtama,
    ),
  );
}
