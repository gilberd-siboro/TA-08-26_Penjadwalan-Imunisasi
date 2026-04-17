# Postman Full Endpoint Test Guide (New API Only)

Dokumen ini fokus ke endpoint aktif terbaru. Endpoint lama seperti `/admin/kartu-keluarga`, `/admin/penduduk`, `/admin/pengguna`, `/admin/anak`, `/auth/register`, `/auth/me` tidak dipakai lagi di routing publik.

## 1) Endpoint Aktif

1. `POST /login`
2. `GET /profile/keluarga`
3. `POST /admin/keluarga-lengkap`
4. `POST /keluarga/anak`

## 2) Target Uji End-to-End

Dalam 1 alur test, kita pastikan:

1. Admin bisa login.
2. Admin bisa membuat 1 keluarga lengkap (KK + anggota + akun keluarga).
3. Akun keluarga hasil pembuatan bisa login.
4. Profil keluarga bisa dibaca dari token akun keluarga.
5. Akun keluarga bisa menambah data anak baru lahir (NIK boleh kosong).

## 3) Prasyarat

### 3.1 Jalankan backend

```bash
go run ./cmd
```

### 3.2 Pastikan role tersedia

Minimal ada role:

1. `aparat_desa`
2. `keluarga`

SQL cek:

```sql
select id_role, nama_role
from public.role
order by id_role;
```

### 3.3 Pastikan kolom nomor_telepon pada penduduk sudah ada

```sql
alter table public.penduduk
add column if not exists nomor_telepon varchar(20);
```

### 3.4 Pastikan ada akun admin aktif

Contoh data yang perlu kamu punya:

1. nomor telepon admin
2. password admin
3. role admin = `aparat_desa`

## 4) Setup Postman (Disarankan)

## 4.1 Buat Collection

Nama collection: `TA-08 API Test (New)`

Urutan request di collection:

1. Login Admin
2. Admin Create Keluarga Lengkap
3. Login Keluarga
4. Profile Keluarga
5. Keluarga Tambah Anak

## 4.2 Buat Environment

Nama environment: `Local Backend`

Variabel:

1. `base_url` = `http://localhost:8080`
2. `admin_phone` = `0811111111`
3. `admin_password` = `password_admin`
4. `admin_token` =
5. `keluarga_phone` =
6. `keluarga_password` =
7. `keluarga_token` =
8. `test_id_role_keluarga` = `2`
9. `test_no_kk` = `1204010101010001`
10. `test_nik_ayah` = `1204010101010001`
11. `test_nik_ibu` = `1204010101010002`
12. `test_nik_anak1` = `1204010101010003`
13. `test_id_ibu` =

Catatan penting:

1. `test_id_role_keluarga` harus angka valid sesuai tabel `role`.
2. `test_no_kk` harus unik tiap kali test data baru.
3. Format `nomor_telepon` wajib Indonesia: hanya angka, diawali `08`, panjang total `10-12` digit.

## 5) Langkah Test End-to-End

## 5.1 Request 1 - Login Admin

Method: `POST`

URL:

```text
{{base_url}}/login
```

Headers:

```text
Content-Type: application/json
```

Body:

```json
{
  "nomor_telepon": "{{admin_phone}}",
  "kata_sandi": "{{admin_password}}"
}
```

Expected:

1. HTTP `200`
2. `data.token` terisi
3. `data.role` = `aparat_desa`

Script pada tab Tests:

```javascript
pm.test("Status 200", function () {
  pm.response.to.have.status(200);
});

const body = pm.response.json();

pm.test("Token admin ada", function () {
  pm.expect(body.data).to.have.property("token");
});

pm.test("Role admin benar", function () {
  pm.expect(body.data.role).to.eql("aparat_desa");
});

if (body.data?.token) {
  pm.environment.set("admin_token", body.data.token);
}
```

## 5.2 Request 2 - Admin Create Keluarga Lengkap

Method: `POST`

URL:

```text
{{base_url}}/admin/keluarga-lengkap
```

Headers:

```text
Content-Type: application/json
Authorization: Bearer {{admin_token}}
```

Body contoh:

```json
{
  "no_kk": "{{test_no_kk}}",
  "id_role_pengguna": {{test_id_role_keluarga}},
  "nik_pemilik_akun": "{{test_nik_ibu}}",
  "anggota": [
    {
      "nik": "{{test_nik_ayah}}",
      "nomor_telepon": "081299991111",
      "nama_lengkap": "Ayah Contoh",
      "jenis_kelamin": "Laki-laki",
      "kedudukan_keluarga": "Kepala Keluarga",
      "dusun": "Dusun A"
    },
    {
      "nik": "{{test_nik_ibu}}",
      "nomor_telepon": "081277770000",
      "nama_lengkap": "Ibu Contoh",
      "jenis_kelamin": "Perempuan",
      "kedudukan_keluarga": "Ibu",
      "dusun": "Dusun A"
    },
    {
      "nik": "{{test_nik_anak1}}",
      "nomor_telepon": "081233334444",
      "nama_lengkap": "Anak Contoh",
      "jenis_kelamin": "Laki-laki",
      "kedudukan_keluarga": "Anak",
      "nik_ibu": "{{test_nik_ibu}}",
      "dusun": "Dusun A"
    }
  ]
}
```

Expected:

1. HTTP `200`
2. `data.id_no_kk` terisi
3. `data.jumlah_anggota` = `3`
4. `data.id_pengguna` terisi
5. `data.nomor_telepon_akun` terisi
6. `data.password_default` terisi

Script pada tab Tests:

```javascript
pm.test("Status 200", function () {
  pm.response.to.have.status(200);
});

const body = pm.response.json();

pm.test("Response keluarga lengkap valid", function () {
  pm.expect(body.data).to.have.property("id_no_kk");
  pm.expect(body.data).to.have.property("id_pengguna");
  pm.expect(body.data).to.have.property("nomor_telepon_akun");
  pm.expect(body.data).to.have.property("password_default");
});

if (body.data?.nomor_telepon_akun) {
  pm.environment.set("keluarga_phone", body.data.nomor_telepon_akun);
}

if (body.data?.password_default) {
  pm.environment.set("keluarga_password", body.data.password_default);
}
```

## 5.3 Request 3 - Login Akun Keluarga

Method: `POST`

URL:

```text
{{base_url}}/login
```

Headers:

```text
Content-Type: application/json
```

Body:

```json
{
  "nomor_telepon": "{{keluarga_phone}}",
  "kata_sandi": "{{keluarga_password}}"
}
```

Expected:

1. HTTP `200`
2. `data.token` terisi

Script pada tab Tests:

```javascript
pm.test("Status 200", function () {
  pm.response.to.have.status(200);
});

const body = pm.response.json();

pm.test("Token keluarga ada", function () {
  pm.expect(body.data).to.have.property("token");
});

if (body.data?.token) {
  pm.environment.set("keluarga_token", body.data.token);
}
```

## 5.4 Request 4 - Profile Keluarga

Method: `GET`

URL:

```text
{{base_url}}/profile/keluarga
```

Headers:

```text
Authorization: Bearer {{keluarga_token}}
```

Expected:

1. HTTP `200`
2. `data.id_no_kk` terisi
3. `data.anggota_keluarga` berupa array

Script pada tab Tests:

```javascript
pm.test("Status 200", function () {
  pm.response.to.have.status(200);
});

const body = pm.response.json();

pm.test("Data profile keluarga valid", function () {
  pm.expect(body.data).to.have.property("id_no_kk");
  pm.expect(body.data).to.have.property("anggota_keluarga");
  pm.expect(Array.isArray(body.data.anggota_keluarga)).to.eql(true);
});
```

## 5.5 Ambil ID Ibu untuk request tambah anak

Karena endpoint profile tidak mengembalikan `id_ibu`, ambil dulu `id_ibu` dari SQL editor (Supabase):

```sql
select i.id_ibu, p.nama_lengkap, p.nik, kk.no_kk
from public.ibu i
join public.penduduk p on p.id_penduduk = i.id_penduduk
join public.kartu_keluarga kk on kk.id_no_kk = p.id_no_kk
where kk.no_kk = '{{test_no_kk}}'
order by i.id_ibu desc;
```

Salin hasil `id_ibu` ke environment variable `test_id_ibu`.

## 5.6 Request 5 - Keluarga Tambah Anak (bayi baru lahir)

Method: `POST`

URL:

```text
{{base_url}}/keluarga/anak
```

Headers:

```text
Content-Type: application/json
Authorization: Bearer {{keluarga_token}}
```

Body contoh tanpa NIK dan tanpa nomor telepon:

```json
{
  "id_ibu": {{test_id_ibu}},
  "nama_lengkap": "Bayi Contoh",
  "jenis_kelamin": "Perempuan",
  "tanggal_lahir": "2026-04-17T00:00:00Z",
  "tempat_lahir": "Mejan",
  "dusun": "Dusun A",
  "keterangan": "Bayi baru lahir"
}
```

Expected:

1. HTTP `200`
2. `data.id_anak` terisi
3. `data.id_penduduk` terisi
4. `data.nik` bisa kosong (karena lahir baru)
5. `data.nomor_telepon` boleh kosong
6. jika `nomor_telepon` diisi manual, format wajib `08` + total 10-12 digit

Script pada tab Tests:

```javascript
pm.test("Status 200", function () {
  pm.response.to.have.status(200);
});

const body = pm.response.json();

pm.test("Response tambah anak valid", function () {
  pm.expect(body.data).to.have.property("id_anak");
  pm.expect(body.data).to.have.property("id_penduduk");
  pm.expect(body.data).to.have.property("nik");
  pm.expect(body.data).to.have.property("nomor_telepon");
});
```

## 6) Skenario Negatif (Wajib)

## 6.1 Login

1. Nomor telepon atau password salah -> `401`
2. Field kosong -> `400`
3. Format nomor telepon tidak sesuai standar Indonesia 10-12 digit -> `400`

## 6.2 Endpoint admin (`/admin/keluarga-lengkap`)

1. Tanpa Authorization -> `401`
2. Token invalid/expired -> `401`
3. Role bukan `aparat_desa` -> `403`
4. `no_kk` kosong / tidak 16 digit / non angka -> `400`
5. `no_kk` sudah ada -> `409`
6. `nik_pemilik_akun` tidak ada pada anggota -> `400`
7. `anggota` kosong -> `400`
8. NIK duplikat di payload -> `400`
9. Nomor telepon pemilik akun sudah dipakai -> `409`
10. Nomor telepon anggota tidak diawali 08 atau panjang bukan 10-12 digit -> `400`

## 6.3 Endpoint profile

1. Tanpa token -> `401`
2. Token valid tetapi akun tidak terhubung ke KK -> `400`

## 6.4 Endpoint tambah anak (`/keluarga/anak`)

1. Tanpa token -> `401`
2. `id_ibu` tidak valid -> `400`
3. Data ibu tidak ditemukan -> `404`
4. Ibu beda KK dengan akun login -> `403`
5. `nama_lengkap` atau `jenis_kelamin` kosong -> `400`
6. Jika kirim NIK manual dan sudah dipakai -> `409`
7. Jika kirim nomor telepon manual dan sudah dipakai -> `409`
8. Jika kirim nomor telepon manual dengan format non-Indonesia / bukan 10-12 digit -> `400`

## 7) SQL Verifikasi Data Setelah Test

Catatan: saat copy query ini ke SQL editor, ganti `{{test_no_kk}}` menjadi angka KK sebenarnya.

## 7.1 Verifikasi KK

```sql
select id_no_kk, no_kk
from public.kartu_keluarga
where no_kk = '{{test_no_kk}}';
```

## 7.2 Verifikasi anggota penduduk

```sql
select id_penduduk, id_no_kk, nik, nomor_telepon, nama_lengkap, kedudukan_keluarga
from public.penduduk
where id_no_kk = (
  select id_no_kk from public.kartu_keluarga where no_kk = '{{test_no_kk}}'
)
order by kedudukan_keluarga, nama_lengkap;
```

## 7.3 Verifikasi akun pengguna keluarga

```sql
select id_pengguna, id_penduduk, id_no_kk, nomor_telepon, id_role, "isDeleted"
from public.pengguna
where id_no_kk = (
  select id_no_kk from public.kartu_keluarga where no_kk = '{{test_no_kk}}'
)
order by id_pengguna desc;
```

## 7.4 Verifikasi relasi ibu

```sql
select i.id_ibu, i.id_penduduk, p.nama_lengkap, p.nik
from public.ibu i
join public.penduduk p on p.id_penduduk = i.id_penduduk
where p.id_no_kk = (
  select id_no_kk from public.kartu_keluarga where no_kk = '{{test_no_kk}}'
)
order by i.id_ibu desc;
```

## 7.5 Verifikasi relasi anak

```sql
select a.id_anak, a.id_ibu, a.id_penduduk, p.nama_lengkap as nama_anak, p.nik, p.nomor_telepon
from public.anak a
join public.penduduk p on p.id_penduduk = a.id_penduduk
where p.id_no_kk = (
  select id_no_kk from public.kartu_keluarga where no_kk = '{{test_no_kk}}'
)
order by a.id_anak desc;
```

## 8) Checklist Lulus Pengujian

Semua poin berikut harus terpenuhi:

1. Login admin sukses dan token tersimpan.
2. Create keluarga lengkap sukses dan menghasilkan akun keluarga.
3. Login keluarga sukses menggunakan nomor telepon + password default dari response.
4. Profile keluarga menampilkan data anggota keluarga.
5. Tambah anak sukses walau NIK tidak diisi.
6. Data anak benar-benar masuk ke tabel `penduduk` dan `anak`.

## 9) Troubleshooting Cepat

1. Selalu 401 di endpoint admin: cek `Authorization: Bearer {{admin_token}}` dan token belum expired.
2. 409 pada `no_kk`: ganti `test_no_kk` ke nomor baru yang belum terdaftar.
3. Login keluarga gagal: cek `keluarga_phone` dan `keluarga_password` berhasil tersimpan dari response admin create keluarga.
4. Gagal tambah anak karena `id_ibu`: pastikan ambil `id_ibu` sesuai KK yang sama, bukan dari KK lain.
5. Query SQL kosong: pastikan nilai `{{test_no_kk}}` di SQL diganti menjadi nilai aktual, bukan placeholder mentah.
