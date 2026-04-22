import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PenyimpananSesi {
  static const _storage = FlutterSecureStorage();
  static const _kunciToken = 'access_token';
  static const _kunciRole = 'user_role';

  Future<void> simpanSesi({required String token, required String role}) async {
    await _storage.write(key: _kunciToken, value: token);
    await _storage.write(key: _kunciRole, value: role);
  }

  Future<String?> ambilToken() async => _storage.read(key: _kunciToken);
  Future<String?> ambilRole() async => _storage.read(key: _kunciRole);

  Future<void> hapusSesi() async {
    await _storage.delete(key: _kunciToken);
    await _storage.delete(key: _kunciRole);
  }
}
