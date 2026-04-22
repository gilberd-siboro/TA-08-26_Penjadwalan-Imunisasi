import 'package:flutter/material.dart';
import 'package:frontend/screens/home_screen.dart';
import 'package:frontend/integrasi_backend/fitur/autentikasi/data/api_autentikasi.dart';
import 'package:frontend/integrasi_backend/inti/jaringan/klien_api.dart';
import 'package:frontend/integrasi_backend/inti/penyimpanan/penyimpanan_sesi.dart';

class UbahKataSandiPage extends StatefulWidget {
  const UbahKataSandiPage({super.key, this.wajibGanti = false});

  final bool wajibGanti;

  @override
  State<UbahKataSandiPage> createState() => _UbahKataSandiPageState();
}

class _UbahKataSandiPageState extends State<UbahKataSandiPage> {
  final _formKey = GlobalKey<FormState>();
  final _kataSandiLamaController = TextEditingController();
  final _kataSandiBaruController = TextEditingController();
  final _konfirmasiKataSandiBaruController = TextEditingController();

  final _apiAutentikasi = ApiAutentikasi(KlienApi(), PenyimpananSesi());

  bool _sedangSimpan = false;
  bool _lihatLama = false;
  bool _lihatBaru = false;
  bool _lihatKonfirmasi = false;

  @override
  void dispose() {
    _kataSandiLamaController.dispose();
    _kataSandiBaruController.dispose();
    _konfirmasiKataSandiBaruController.dispose();
    super.dispose();
  }

  Future<void> _simpan() async {
    if (_sedangSimpan) return;
    if (!_formKey.currentState!.validate()) return;

    setState(() => _sedangSimpan = true);

    try {
      final pesan = await _apiAutentikasi.changePassword(
        kataSandiLama: _kataSandiLamaController.text.trim(),
        kataSandiBaru: _kataSandiBaruController.text.trim(),
        konfirmasiKataSandiBaru: _konfirmasiKataSandiBaruController.text.trim(),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(pesan)));

      if (widget.wajibGanti) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
          (route) => false,
        );
      } else {
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    } finally {
      if (mounted) {
        setState(() => _sedangSimpan = false);
      }
    }
  }

  String? _validatorWajib(String? value, {int min = 1}) {
    final v = (value ?? '').trim();
    if (v.isEmpty) return 'Field ini wajib diisi';
    if (v.length < min) return 'Minimal $min karakter';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: !widget.wajibGanti,
        title: Text(
          widget.wajibGanti ? 'Ganti Kata Sandi Wajib' : 'Ubah Kata Sandi',
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (widget.wajibGanti)
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: const Text(
                  'Demi keamanan akun, Anda wajib mengganti kata sandi default sebelum melanjutkan.',
                ),
              ),
            TextFormField(
              controller: _kataSandiLamaController,
              obscureText: !_lihatLama,
              validator: (v) => _validatorWajib(v),
              decoration: InputDecoration(
                labelText: 'Kata Sandi Lama',
                suffixIcon: IconButton(
                  onPressed: () => setState(() => _lihatLama = !_lihatLama),
                  icon: Icon(
                    _lihatLama ? Icons.visibility_off : Icons.visibility,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _kataSandiBaruController,
              obscureText: !_lihatBaru,
              validator: (v) => _validatorWajib(v, min: 8),
              decoration: InputDecoration(
                labelText: 'Kata Sandi Baru',
                helperText: 'Minimal 8 karakter',
                suffixIcon: IconButton(
                  onPressed: () => setState(() => _lihatBaru = !_lihatBaru),
                  icon: Icon(
                    _lihatBaru ? Icons.visibility_off : Icons.visibility,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _konfirmasiKataSandiBaruController,
              obscureText: !_lihatKonfirmasi,
              validator: (v) {
                final wajib = _validatorWajib(v, min: 8);
                if (wajib != null) return wajib;
                if ((v ?? '').trim() != _kataSandiBaruController.text.trim()) {
                  return 'Konfirmasi kata sandi tidak sama';
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: 'Konfirmasi Kata Sandi Baru',
                suffixIcon: IconButton(
                  onPressed: () =>
                      setState(() => _lihatKonfirmasi = !_lihatKonfirmasi),
                  icon: Icon(
                    _lihatKonfirmasi ? Icons.visibility_off : Icons.visibility,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 48,
              child: FilledButton(
                onPressed: _sedangSimpan ? null : _simpan,
                child: _sedangSimpan
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Simpan Kata Sandi Baru'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
