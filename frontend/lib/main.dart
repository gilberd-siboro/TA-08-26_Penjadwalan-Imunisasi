import 'package:flutter/material.dart';
import 'auth/login_page.dart';
import 'integrasi_backend/inti/penyimpanan/penyimpanan_sesi.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kesehatan Ibu & Anak',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4A9EE0)),
        useMaterial3: true,
      ),
      home: const _AuthGate(),
    );
  }
}

class _AuthGate extends StatefulWidget {
  const _AuthGate();

  @override
  State<_AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<_AuthGate> {
  late final Future<String?> _tokenFuture;

  @override
  void initState() {
    super.initState();
    _tokenFuture = PenyimpananSesi().ambilToken();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _tokenFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final token = snapshot.data?.trim() ?? '';
        if (token.isNotEmpty) {
          return const HomeScreen();
        }

        return const LoginPage();
      },
    );
  }
}
