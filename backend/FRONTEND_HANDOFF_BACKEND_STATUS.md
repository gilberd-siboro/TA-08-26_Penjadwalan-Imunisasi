# Backend Handoff untuk Frontend Flutter

Dokumen ini adalah panduan integrasi backend untuk aplikasi mobile Project 2 (imunisasi).

## 1. Scope Project 2

Endpoint yang dipakai frontend:
1. POST /login
2. POST /logout
3. GET /profile/keluarga
4. POST /keluarga/anak

Endpoint yang tidak dipakai frontend Project 2:
1. POST /admin/keluarga-lengkap (khusus Project 1, alur admin input data keluarga)

## 2. Status Backend Saat Ini

Backend sudah siap dipakai untuk flow inti aplikasi mobile:
1. Login pengguna (JWT)
2. Ambil profil keluarga
3. Tambah data anak dari akun keluarga
4. Logout acknowledgement endpoint

Catatan arsitektur backend:
1. Layer: routes -> controllers -> usecases -> repositories
2. Database: PostgreSQL (Supabase)
3. Auth: JWT bearer token

## 3. Base URL dan Header

Base URL lokal backend:
1. http://localhost:8080

Header untuk endpoint protected:
1. Authorization: Bearer <token>

## 4. Kontrak Response Standar

Response sukses:

```json
{
  "status_code": 200,
  "message": ["..."],
  "data": {}
}
```

Response error:

```json
{
  "status_code": 4xx,
  "message": ["pesan error"]
}
```

Aturan parsing frontend:
1. Selalu baca status_code, message, data.
2. message dapat berupa array string.
3. Jika status_code 401, anggap sesi habis dan paksa login ulang.

## 5. Endpoint Detail

### 5.1 POST /login

Tujuan:
1. Login akun dan mendapatkan token JWT.

Request:

```json
{
  "nomor_telepon": "081234567890",
  "kata_sandi": "password"
}
```

Response sukses:

```json
{
  "status_code": 200,
  "message": ["login berhasil"],
  "data": {
    "token": "<jwt>",
    "role": "aparat_desa | keluarga"
  }
}
```

Error umum:
1. 400: format request tidak valid atau field kosong
2. 401: nomor telepon atau kata sandi salah

### 5.2 POST /logout

Tujuan:
1. Menutup sesi pada sisi API.

Header:
1. Authorization: Bearer <token>

Request body:

```json
{}
```

Response sukses:

```json
{
  "status_code": 200,
  "message": ["logout berhasil"],
  "data": null
}
```

Catatan penting:
1. JWT backend saat ini stateless.
2. Setelah hit /logout, frontend tetap wajib menghapus token lokal (secure storage/shared prefs).

### 5.3 GET /profile/keluarga

Tujuan:
1. Ambil data keluarga berdasarkan akun login.

Header:
1. Authorization: Bearer <token>

Response sukses:

```json
{
  "status_code": 200,
  "message": ["profil keluarga berhasil diambil"],
  "data": {
    "id_pengguna": 10,
    "id_no_kk": 5,
    "nomor_telepon": "0812...",
    "role": "keluarga",
    "anggota_keluarga": [
      {
        "id_penduduk": 20,
        "nik": "1204...",
        "nama_lengkap": "Nama",
        "jenis_kelamin": "Laki-laki",
        "tanggal_lahir": "2018-01-01T00:00:00Z",
        "kedudukan_keluarga": "Anak"
      }
    ]
  }
}
```

Error umum:
1. 401: token invalid atau expired
2. 400: akun tidak terhubung ke kartu keluarga

### 5.4 POST /keluarga/anak

Tujuan:
1. Menambah anak baru dari akun keluarga.

Header:
1. Authorization: Bearer <token keluarga>

Request:

```json
{
  "id_ibu": 1,
  "nik": "",
  "nomor_telepon": "",
  "nama_lengkap": "Bayi A",
  "jenis_kelamin": "Laki-laki",
  "tanggal_lahir": "2026-04-01T00:00:00Z",
  "tempat_lahir": "Medan",
  "dusun": "Dusun A",
  "keterangan": "Bayi baru"
}
```

Catatan input:
1. nik boleh kosong untuk bayi baru lahir
2. nomor_telepon boleh kosong
3. jika nomor_telepon diisi, wajib format Indonesia

Response sukses:

```json
{
  "status_code": 200,
  "message": ["data anak berhasil dibuat"],
  "data": {
    "id_anak": 10,
    "id_ibu": 1,
    "id_penduduk": 77,
    "nik": "",
    "nomor_telepon": "",
    "nomor_telepon_sementara": false
  }
}
```

Error umum:
1. 400: field tidak valid
2. 403: ibu beda KK dengan akun login
3. 404: ibu tidak ditemukan
4. 409: nik atau nomor telepon duplikat

## 6. Validasi yang Wajib Diikuti Frontend

1. nomor_telepon: diawali 08, panjang 10-12 digit
2. jenis_kelamin: Laki-laki atau Perempuan
3. pada tambah anak, nik dan nomor_telepon boleh kosong

## 7. Mapping ke Screen Flutter

Implementasi rekomendasi:
1. Login Screen -> POST /login
2. Home/Profile Screen -> GET /profile/keluarga
3. Tambah Anak Screen -> POST /keluarga/anak
4. Logout Action -> POST /logout lalu clear token lokal

## 8. Alur Integrasi Frontend (Urutan Kerja)

1. Implement API client + interceptor bearer token
2. Implement login dan simpan token
3. Implement profile keluarga setelah login sukses
4. Implement form tambah anak
5. Implement logout + clear local session
6. Implement auto logout saat menerima 401

## 9. Checklist QA Frontend

Checklist minimal sebelum merge:
1. Login sukses menampilkan halaman utama
2. Token tersimpan dan dipakai di endpoint protected
3. Profile keluarga berhasil dimuat
4. Tambah anak sukses dengan nik kosong
5. Logout menghapus token dan kembali ke login
6. Jika token invalid, user otomatis keluar ke login

## 10. Catatan Penting untuk Tim Frontend

1. Project 2 tidak membuat akun keluarga dari mobile app.
2. Jangan pakai endpoint POST /admin/keluarga-lengkap pada aplikasi mobile.
3. Jika butuh endpoint imunisasi lanjutan (jadwal, notifikasi), koordinasikan sebagai fase berikutnya.
