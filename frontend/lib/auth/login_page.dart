import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/auth/ubah_kata_sandi_page.dart';
import '../integrasi_backend/inti/jaringan/klien_api.dart';
import '../integrasi_backend/inti/jaringan/eksepsi_api.dart';
import '../integrasi_backend/inti/penyimpanan/penyimpanan_sesi.dart';
import '../integrasi_backend/fitur/autentikasi/data/api_autentikasi.dart';
import '../screens/home_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _controllerNomorHp = TextEditingController();
  final _controllerKataSandi = TextEditingController();
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;

  String? _validasiNomorHp(String? value) {
    final v = (value ?? '').trim();
    if (v.isEmpty) return 'Nomor HP wajib diisi';
    final regex = RegExp(r'^08[0-9]{8,10}$');
    if (!regex.hasMatch(v)) return 'Format nomor HP harus 08xxxxxxxxxx';
    return null;
  }

  String? _validasiKataSandi(String? value) {
    if ((value ?? '').trim().isEmpty) return 'Kata sandi wajib diisi';
    return null;
  }

  Future<void> _submitLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final api = ApiAutentikasi(KlienApi(), PenyimpananSesi());
      final hasil = await api.login(
        nomorTelepon: _controllerNomorHp.text.trim(),
        kataSandi: _controllerKataSandi.text.trim(),
      );

      if (!mounted) return;

      if (hasil.wajibGantiKataSandi) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const UbahKataSandiPage(wajibGanti: true),
          ),
        );
        return;
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } on EksepsiApi catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.pesan)));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Terjadi kesalahan. Coba lagi.')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _controllerNomorHp.dispose();
    _controllerKataSandi.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Menggunakan warna background yang sangat muda agar bersih
      backgroundColor: const Color(0xFFF0F7FF),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade100, // Biru muda di atas
              const Color(0xFFF0F7FF), // Transisi ke background utama
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 70),

              // Bagian Logo & Header
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.2),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.vaccines_rounded,
                      size: 60,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Sobat Imun",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A56BE), // Biru gelap yang elegan
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Lindungi si Kecil dengan Imunisasi Tepat Waktu",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.blueGrey.shade600,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // Form Login
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Field Nomor HP
                      TextFormField(
                        controller: _controllerNomorHp,
                        validator: _validasiNomorHp,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: InputDecoration(
                          hintText: "Nomor HP",
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: const Icon(
                            Icons.person_outline,
                            color: Colors.blue,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Field Password
                      TextFormField(
                        controller: _controllerKataSandi,
                        validator: _validasiKataSandi,
                        obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                          hintText: "Kata Sandi",
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: const Icon(
                            Icons.lock_reset_rounded,
                            color: Colors.blue,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.blue.shade300,
                            ),
                            onPressed: () => setState(
                              () => _isPasswordVisible = !_isPasswordVisible,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),

                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: const Text(
                            "Lupa Kata Sandi?",
                            style: TextStyle(color: Color(0xFF1A56BE)),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Tombol Login dengan Shadow Biru
                      Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.3),
                              blurRadius: 15,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _submitLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1A56BE),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 0,
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  "MASUK",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Footer
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Belum punya akun? "),
                          GestureDetector(
                            onTap: () {},
                            child: const Text(
                              "Hubungi Perangkat Desa",
                              style: TextStyle(
                                color: Color(0xFF1A56BE),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
