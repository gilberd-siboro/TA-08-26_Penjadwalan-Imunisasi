class HasilLogin {
  final String token;
  final String role;
  final bool wajibGantiKataSandi;

  HasilLogin({
    required this.token,
    required this.role,
    required this.wajibGantiKataSandi,
  });

  factory HasilLogin.fromJson(Map<String, dynamic> json) {
    return HasilLogin(
      token: (json['token'] ?? '').toString(),
      role: (json['role'] ?? '').toString(),
      wajibGantiKataSandi: json['wajib_ganti_kata_sandi'] == true,
    );
  }
}
