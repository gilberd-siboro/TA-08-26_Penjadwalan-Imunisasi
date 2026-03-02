# SEJIWA – Backend Brief untuk Tim Golang
**Sistem Imunisasi Ibu dan Anak | Desa Hutabulu Mejan**  
*Studi Kasus TA-2026 | Dokumen ini dibuat oleh Tim Frontend Flutter*

---

## 1. Konteks Aplikasi

| Atribut | Nilai |
|---|---|
| Nama sistem | SEJIWA (Sistem Imunisasi Ibu dan Anak) |
| Lokasi | Desa Hutabulu Mejan, Kecamatan Laguboti, Kabupaten Toba |
| Pengguna utama | Ibu/Ayah usia 20–40 tahun, literasi digital beragam |
| Petugas | Kader Posyandu Mejan, Bidan Puskesmas Balige |
| Referensi data | Buku KIA 2024 (Kemenkes RI) |
| Pendekatan UI | Human-Centered AI (HCAI) + GenderMag |

---

## 2. Arsitektur Sederhana yang Diusulkan

```
┌──────────────────────┐        REST/JSON        ┌─────────────────────┐
│  Flutter App (Mobile)│ ◄──────────────────────► │  Go Backend (API)   │
│  lib/                │        HTTPS             │  /api/v1/           │
│  ├─ data/            │                          │                     │
│  │   sejiwa_data.dart│                          │  ├─ handlers/       │
│  └─ screens/         │                          │  ├─ models/         │
│      home_screen      │                          │  ├─ services/       │
│      schedule_screen  │                          │  └─ db/ (SQLite /   │
│      child_data_screen│                          │      PostgreSQL)    │
└──────────────────────┘                          └─────────────────────┘
```

> **Catatan:** Untuk tahap awal, SQLite sudah cukup. Bisa migrasi ke PostgreSQL nanti.

---

## 3. Data Model (dari Frontend → Go Struct)

### 3.1 `Pengguna` (User / Orang Tua)

Di frontend, data user saat ini di-hardcode di `home_screen.dart`:
```dart
final String _namaUser = 'Asri';
final String _roleUser = 'Ibu'; // atau 'Ayah'
```

**Go struct yang dibutuhkan:**
```go
type Pengguna struct {
    ID          string    `json:"id" db:"id"`                    // UUID
    Nama        string    `json:"nama" db:"nama"`                // nama lengkap
    NoHP        string    `json:"no_hp" db:"no_hp"`              // untuk login & notif
    Role        string    `json:"role" db:"role"`                // "ibu" | "ayah" | "kader"
    Desa        string    `json:"desa" db:"desa"`                // "Hutabulu Mejan"
    CreatedAt   time.Time `json:"created_at" db:"created_at"`
    UpdatedAt   time.Time `json:"updated_at" db:"updated_at"`
}
```

---

### 3.2 `Anak` (Data Anak)

Di frontend ini adalah model utama di `lib/data/sejiwa_data.dart`:
```dart
class DataAnak {
  final String id;
  String nama;
  DateTime tanggalLahir;
  JenisKelamin jenisKelamin;   // enum: lakilaki | perempuan
  double? beratLahirKg;        // opsional
  String? golonganDarah;       // opsional: A | B | AB | O
  Set<String> vaksinSudahDone; // kumpulan nama vaksin yang sudah selesai
}
```

**Go struct yang dibutuhkan:**
```go
type Anak struct {
    ID            string    `json:"id" db:"id"`                       // UUID
    PenggunaID    string    `json:"pengguna_id" db:"pengguna_id"`     // FK → Pengguna
    Nama          string    `json:"nama" db:"nama"`
    TanggalLahir  time.Time `json:"tanggal_lahir" db:"tanggal_lahir"`
    JenisKelamin  string    `json:"jenis_kelamin" db:"jenis_kelamin"` // "laki-laki" | "perempuan"
    BeratLahirKg  *float64  `json:"berat_lahir_kg,omitempty" db:"berat_lahir_kg"`
    GolonganDarah *string   `json:"golongan_darah,omitempty" db:"golongan_darah"`
    CreatedAt     time.Time `json:"created_at" db:"created_at"`
    UpdatedAt     time.Time `json:"updated_at" db:"updated_at"`
}
```

---

### 3.3 `Vaksin` (Master Data Jadwal KIA 2024)

Di frontend ini adalah konstanta di `sejiwa_data.dart`:
```dart
const List<(int, String)> kMilestoneVaksin = [
  (0,  'Hepatitis B (HB-0)'),
  (0,  'Polio 0 (OPV)'),
  (1,  'BCG'),
  (1,  'Polio 1 (OPV)'),
  (2,  'DPT-HB-Hib 1'),
  (2,  'Polio 2 (OPV)'),
  (2,  'PCV 1'),
  (2,  'Rotavirus 1'),
  (3,  'DPT-HB-Hib 2'),
  (3,  'Polio 3 (OPV)'),
  (3,  'PCV 2'),
  (3,  'Rotavirus 2'),
  (4,  'DPT-HB-Hib 3'),
  (4,  'Polio 4 (OPV + IPV)'),
  (4,  'PCV 3'),
  (9,  'Campak-Rubela (MR) 1'),
  (9,  'PCV 4'),
  (9,  'JE (Japanese Encephalitis)'),
  (12, 'Influenza'),
  (18, 'DPT-HB-Hib 4 (Booster)'),
  (18, 'Campak-Rubela (MR) 2 (Booster)'),
  (24, 'Tifoid'),
  (24, 'Hepatitis A'),
  (60, 'DPT 5 (Booster)'),
  (60, 'Campak-Rubela (MR) 3'),
  (60, 'Polio (IPV 2)'),
];
// Kolom pertama = usia pemberian dalam BULAN PENUH
```

**Go struct – Master Vaksin (seed data, tidak sering berubah):**
```go
type MasterVaksin struct {
    ID            int    `json:"id" db:"id"`
    NamaVaksin    string `json:"nama_vaksin" db:"nama_vaksin"`
    UsiaBulan     int    `json:"usia_bulan" db:"usia_bulan"`      // usia minimal pemberian
    UsiaTeks      string `json:"usia_teks" db:"usia_teks"`        // ex: "0–24 jam setelah lahir"
    Deskripsi     string `json:"deskripsi" db:"deskripsi"`
    Lokasi        string `json:"lokasi" db:"lokasi"`              // "Posyandu Mejan / Puskesmas Balige"
    Sumber        string `json:"sumber" db:"sumber"`              // "Buku KIA 2024"
}
```

---

### 3.4 `RiwayatImunisasi` (Vaksin yang Sudah Dilakukan)

Di frontend disimpan sebagai `Set<String> vaksinSudahDone` di dalam object `DataAnak`.  
Di backend ini harus jadi tabel relasi tersendiri.

```go
type RiwayatImunisasi struct {
    ID           string    `json:"id" db:"id"`
    AnakID       string    `json:"anak_id" db:"anak_id"`           // FK → Anak
    MasterVaksinID int     `json:"master_vaksin_id" db:"master_vaksin_id"` // FK → MasterVaksin
    NamaVaksin   string    `json:"nama_vaksin" db:"nama_vaksin"`   // denormalized untuk kemudahan
    TanggalDone  time.Time `json:"tanggal_done" db:"tanggal_done"`
    DicatatOleh  string    `json:"dicatat_oleh" db:"dicatat_oleh"` // "ibu" | "kader"
    Catatan      *string   `json:"catatan,omitempty" db:"catatan"`
    CreatedAt    time.Time `json:"created_at" db:"created_at"`
}
```

---

## 4. Business Logic di Frontend (Yang Harus Dipindah ke Backend)

### 4.1 Kalkulasi Status Vaksin

Saat ini logika ini ada di `schedule_screen.dart` fungsi `_hitungStatusVaksin()`:

```
Usia anak (bulan penuh) = sekarang - tanggal_lahir

Untuk setiap vaksin di KIA 2024:
  JIKA nama_vaksin ADA di vaksinSudahDone → status = "sudah"
  JIKA usia_vaksin < usia_anak (terlewat & belum selesai) → status = "terlewat"
  JIKA usia_vaksin <= usia_anak + 1 (bulan ini atau bulan depan) → status = "segera"
  LAINNYA → status = "belum"
```

**Backend sebaiknya menyediakan endpoint yang sudah menghitung status ini**, sehingga Flutter hanya perlu render hasilnya. Contoh response:

```json
{
  "anak_id": "uuid-xxx",
  "usia_bulan": 2,
  "jadwal": [
    {
      "usia_bulan": 0,
      "label_usia": "0 Bulan",
      "keterangan": "Diberikan saat lahir",
      "vaksin_list": [
        {
          "nama_vaksin": "Hepatitis B (HB-0)",
          "usia_pemberian": "0–24 jam setelah lahir",
          "deskripsi": "...",
          "status": "sudah",
          "tanggal_done": "2025-12-26T00:00:00Z"
        }
      ]
    },
    {
      "usia_bulan": 2,
      "label_usia": "2 Bulan",
      "keterangan": "Posyandu Mejan atau Puskesmas Balige",
      "vaksin_list": [
        {
          "nama_vaksin": "DPT-HB-Hib 1",
          "usia_pemberian": "2 bulan",
          "deskripsi": "...",
          "status": "segera",
          "tanggal_done": null
        }
      ]
    }
  ],
  "ringkasan": {
    "sudah": 4,
    "segera": 4,
    "terlewat": 0,
    "belum": 18,
    "total": 26
  }
}
```

### 4.2 Vaksin Berikutnya

Di frontend ada fungsi `hitungVaksinBerikutnya(anak)`:
```
Prioritas: segera (usia tepat/bulan depan) → terlewat → belum berikutnya
```
Backend bisa sertakan field `vaksin_berikutnya` dalam response `GET /anak/:id`.

---

## 5. API Endpoints yang Dibutuhkan (Tahap Pertama)

> Base URL: `https://api.sejiwa.dev/api/v1`  
> Auth: Bearer Token (JWT sederhana dulu, belum OAuth)

### 5.1 Auth

| Method | Endpoint | Deskripsi |
|--------|----------|-----------|
| `POST` | `/auth/login` | Login dengan nomor HP + PIN 6 digit |
| `POST` | `/auth/register` | Daftar pengguna baru |
| `POST` | `/auth/refresh` | Refresh access token |

**Request login:**
```json
{
  "no_hp": "081234567890",
  "pin": "123456"
}
```
**Response:**
```json
{
  "access_token": "eyJ...",
  "refresh_token": "eyJ...",
  "pengguna": {
    "id": "uuid",
    "nama": "Asri",
    "role": "ibu"
  }
}
```

---

### 5.2 Data Anak

| Method | Endpoint | Deskripsi |
|--------|----------|-----------|
| `GET` | `/anak` | List semua anak milik pengguna yang login |
| `POST` | `/anak` | Tambah anak baru |
| `GET` | `/anak/:id` | Detail anak + vaksin berikutnya |
| `PUT` | `/anak/:id` | Update data anak |
| `DELETE` | `/anak/:id` | Hapus data anak |

**Request POST/PUT `/anak`:**
```json
{
  "nama": "Bayi Asri",
  "tanggal_lahir": "2025-12-26",
  "jenis_kelamin": "perempuan",
  "berat_lahir_kg": 3.2,
  "golongan_darah": "A"
}
```

**Response GET `/anak`:**
```json
[
  {
    "id": "uuid-1",
    "nama": "Bayi Asri",
    "tanggal_lahir": "2025-12-26",
    "jenis_kelamin": "perempuan",
    "usia_bulan": 2,
    "usia_teks": "2 bulan",
    "berat_lahir_kg": 3.2,
    "golongan_darah": "A",
    "vaksin_berikutnya": "DPT-HB-Hib 1"
  }
]
```

---

### 5.3 Jadwal Imunisasi

| Method | Endpoint | Deskripsi |
|--------|----------|-----------|
| `GET` | `/anak/:id/jadwal` | Jadwal imunisasi lengkap + status per vaksin |
| `POST` | `/anak/:id/riwayat` | Tandai vaksin sudah selesai |
| `GET` | `/anak/:id/riwayat` | List riwayat imunisasi anak |

**Request POST `/anak/:id/riwayat`:**
```json
{
  "nama_vaksin": "DPT-HB-Hib 1",
  "tanggal_done": "2026-02-28",
  "dicatat_oleh": "ibu",
  "catatan": "tidak ada efek samping"
}
```

---

### 5.4 Master Vaksin (seed, jarang berubah)

| Method | Endpoint | Deskripsi |
|--------|----------|-----------|
| `GET` | `/master/vaksin` | List semua vaksin KIA 2024 |

---

## 6. Struktur Folder Go yang Disarankan

```
sejiwa-backend/
├── main.go
├── go.mod
├── config/
│   └── config.go            ← env, DB connection
├── db/
│   └── migrations/          ← SQL migration files
│       ├── 001_create_pengguna.sql
│       ├── 002_create_anak.sql
│       ├── 003_create_master_vaksin.sql
│       └── 004_create_riwayat_imunisasi.sql
├── models/
│   ├── pengguna.go
│   ├── anak.go
│   ├── vaksin.go
│   └── riwayat.go
├── handlers/
│   ├── auth_handler.go
│   ├── anak_handler.go
│   ├── jadwal_handler.go
│   └── riwayat_handler.go
├── services/
│   ├── auth_service.go
│   ├── anak_service.go
│   └── jadwal_service.go    ← logika kalkulasi status vaksin ada di sini
├── middleware/
│   └── auth_middleware.go   ← validasi JWT
└── seed/
    └── vaksin_kia2024.go    ← seed 26 vaksin dari Buku KIA 2024
```

---

## 7. Seed Data – 26 Vaksin KIA 2024

Backend perlu menyediakan data ini saat pertama kali setup. Bisa jadikan migration atau seed function.

```go
// seed/vaksin_kia2024.go
var VaksinKIA2024 = []MasterVaksin{
    {NamaVaksin: "Hepatitis B (HB-0)",           UsiaBulan: 0,  UsiaTeks: "0–24 jam setelah lahir"},
    {NamaVaksin: "Polio 0 (OPV)",                UsiaBulan: 0,  UsiaTeks: "0–24 jam setelah lahir"},
    {NamaVaksin: "BCG",                           UsiaBulan: 1,  UsiaTeks: "1 bulan"},
    {NamaVaksin: "Polio 1 (OPV)",                UsiaBulan: 1,  UsiaTeks: "1 bulan"},
    {NamaVaksin: "DPT-HB-Hib 1",                UsiaBulan: 2,  UsiaTeks: "2 bulan"},
    {NamaVaksin: "Polio 2 (OPV)",                UsiaBulan: 2,  UsiaTeks: "2 bulan"},
    {NamaVaksin: "PCV 1",                        UsiaBulan: 2,  UsiaTeks: "2 bulan"},
    {NamaVaksin: "Rotavirus 1",                  UsiaBulan: 2,  UsiaTeks: "2 bulan"},
    {NamaVaksin: "DPT-HB-Hib 2",                UsiaBulan: 3,  UsiaTeks: "3 bulan"},
    {NamaVaksin: "Polio 3 (OPV)",                UsiaBulan: 3,  UsiaTeks: "3 bulan"},
    {NamaVaksin: "PCV 2",                        UsiaBulan: 3,  UsiaTeks: "3 bulan"},
    {NamaVaksin: "Rotavirus 2",                  UsiaBulan: 3,  UsiaTeks: "3 bulan"},
    {NamaVaksin: "DPT-HB-Hib 3",                UsiaBulan: 4,  UsiaTeks: "4 bulan"},
    {NamaVaksin: "Polio 4 (OPV + IPV)",          UsiaBulan: 4,  UsiaTeks: "4 bulan"},
    {NamaVaksin: "PCV 3",                        UsiaBulan: 4,  UsiaTeks: "4 bulan"},
    {NamaVaksin: "Campak-Rubela (MR) 1",         UsiaBulan: 9,  UsiaTeks: "9 bulan"},
    {NamaVaksin: "PCV 4",                        UsiaBulan: 9,  UsiaTeks: "9 bulan"},
    {NamaVaksin: "JE (Japanese Encephalitis)",   UsiaBulan: 9,  UsiaTeks: "9 bulan (daerah endemis)"},
    {NamaVaksin: "Influenza",                    UsiaBulan: 12, UsiaTeks: "12 bulan (tiap tahun)"},
    {NamaVaksin: "DPT-HB-Hib 4 (Booster)",      UsiaBulan: 18, UsiaTeks: "18 bulan"},
    {NamaVaksin: "Campak-Rubela (MR) 2 (Booster)", UsiaBulan: 18, UsiaTeks: "18 bulan"},
    {NamaVaksin: "Tifoid",                       UsiaBulan: 24, UsiaTeks: "2 tahun (tiap 3 tahun)"},
    {NamaVaksin: "Hepatitis A",                  UsiaBulan: 24, UsiaTeks: "2 tahun (2 dosis)"},
    {NamaVaksin: "DPT 5 (Booster)",              UsiaBulan: 60, UsiaTeks: "5 tahun"},
    {NamaVaksin: "Campak-Rubela (MR) 3",         UsiaBulan: 60, UsiaTeks: "5 tahun"},
    {NamaVaksin: "Polio (IPV 2)",                UsiaBulan: 60, UsiaTeks: "5 tahun"},
}
```

---

## 8. Alur Login di Frontend

```
SplashScreen (3 detik) 
  → LoginScreen (nomor HP + PIN)
      → HomeScreen (setelah berhasil)
          ├─ ChildDataScreen  (CRUD data anak)
          └─ ScheduleScreen   (jadwal imunisasi per anak)
```

Saat ini login di frontend hanya simulasi (tap tombol → langsung masuk).  
Backend perlu endpoint `/auth/login` yang return JWT, lalu Flutter simpan di `SharedPreferences` atau `flutter_secure_storage`.

---

## 9. Skema Database Sederhana (ERD)

```
pengguna
  id (PK), nama, no_hp, pin_hash, role, desa, created_at, updated_at

anak
  id (PK), pengguna_id (FK), nama, tanggal_lahir, jenis_kelamin,
  berat_lahir_kg, golongan_darah, created_at, updated_at

master_vaksin
  id (PK), nama_vaksin, usia_bulan, usia_teks, deskripsi,
  lokasi, sumber

riwayat_imunisasi
  id (PK), anak_id (FK), master_vaksin_id (FK), nama_vaksin,
  tanggal_done, dicatat_oleh, catatan, created_at
```

---

## 10. Screen yang Sudah Ada di Frontend

| Screen | File | Status | Butuh API |
|--------|------|--------|-----------|
| Splash | `splash_screen.dart` | ✅ Done | Tidak |
| Login | `login_screen.dart` | ✅ Done (simulasi) | `POST /auth/login` |
| Home | `home_screen.dart` | ✅ Done (dummy data) | `GET /anak`, `GET /anak/:id/jadwal` |
| Jadwal Imunisasi | `schedule_screen.dart` | ✅ Done (kalkulasi lokal) | `GET /anak/:id/jadwal`, `POST /anak/:id/riwayat` |
| Data Anak | `child_data_screen.dart` | ✅ Done (local state) | `GET/POST/PUT/DELETE /anak` |
| Data Kehamilan | *(belum)* | ⏳ Pending | `GET/POST /kehamilan` |
| Lokasi Layanan | *(belum)* | ⏳ Pending | `GET /lokasi` (bisa static) |
| Notifikasi | *(belum)* | ⏳ Pending | `GET /notifikasi` |
| Profil | *(belum)* | ⏳ Pending | `GET/PUT /profil` |

---

## 11. Prioritas Integrasi (Saran Urutan Kerja)

```
Tahap 1 (Minimal Viable)
  ✦ Auth (login/register dengan no HP + PIN)
  ✦ CRUD Anak
  ✦ GET Jadwal per Anak (kalkulasi status di backend)
  ✦ POST Riwayat (tandai sudah imunisasi)

Tahap 2
  ✦ Kehamilan (TT vaksin, HPHT, ANC)
  ✦ Notifikasi Push (FCM – opsional)
  ✦ Lokasi layanan static JSON

Tahap 3 (Rule Engine/AI)
  ✦ Rekomendasi jadwal otomatis
  ✦ Deteksi jadwal terlewat + alert
  ✦ Dashboard kader Posyandu
```

---

## 12. Catatan Penting untuk Backend

- **PIN bukan password panjang** — pengguna desa, cukup 6 digit angka. Tetap di-hash dengan bcrypt.
- **Nomor HP sebagai username** — tidak pakai email.
- **Usia bulan dihitung di backend** — jangan simpan sebagai field, hitung dari `tanggal_lahir` saat runtime.
- **Nama vaksin konsisten** — backend HARUS pakai nama yang persis sama seperti di tabel `kMilestoneVaksin` di atas, karena frontend mencocokkan `nama_vaksin` sebagai string key.
- **Offline-first** — pertimbangkan response yang bisa di-cache di Flutter (pakar cukup simpan JSON lokal dulu, sinkron saat online).
- **Lokasi layanan:** Posyandu Mejan + Puskesmas Balige — bisa hardcode di seed atau konfigurasi, belum perlu dynamic.

---

*Dokumen ini dihasilkan dari kode frontend Flutter SEJIWA per 26 Februari 2026.*  
*Pertanyaan: hubungi Tim Frontend via repositori yang sama.*
