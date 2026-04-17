package models

import "time"

type AdminKeluargaLengkapAnggotaRequest struct {
	NIK                string     `json:"nik"`
	NomorTelepon       string     `json:"nomor_telepon"`
	NamaLengkap        string     `json:"nama_lengkap"`
	JenisKelamin       string     `json:"jenis_kelamin"`
	TanggalLahir       *time.Time `json:"tanggal_lahir,omitempty"`
	TempatLahir        string     `json:"tempat_lahir"`
	GolonganDarah      string     `json:"golongan_darah"`
	Agama              string     `json:"agama"`
	StatusPerkawinan   string     `json:"status_perkawinan"`
	PendidikanTerakhir string     `json:"pendidikan_terakhir"`
	Pekerjaan          string     `json:"pekerjaan"`
	BacaHuruf          *bool      `json:"baca_huruf,omitempty"`
	KedudukanKeluarga  string     `json:"kedudukan_keluarga"`
	Dusun              string     `json:"dusun"`
	TanggalPenambahan  *time.Time `json:"tanggal_penambahan,omitempty"`
	AsalPenduduk       string     `json:"asal_penduduk"`
	TanggalPengurangan *time.Time `json:"tanggal_pengurangan,omitempty"`
	TujuanPindah       string     `json:"tujuan_pindah"`
	TempatMeninggal    string     `json:"tempat_meninggal"`
	Keterangan         string     `json:"keterangan"`

	// Digunakan jika anggota ini berkedudukan Anak dan ingin langsung membuat relasi anak-ibu.
	NIKIbu string `json:"nik_ibu,omitempty"`
}

type AdminCreateKeluargaLengkapRequest struct {
	NoKK           string                               `json:"no_kk"`
	IDRolePengguna int64                                `json:"id_role_pengguna"`
	NIKPemilikAkun string                               `json:"nik_pemilik_akun"`
	Anggota        []AdminKeluargaLengkapAnggotaRequest `json:"anggota"`
}

type AdminCreateKeluargaLengkapResponse struct {
	IDNoKK                int64  `json:"id_no_kk"`
	NoKK                  string `json:"no_kk"`
	JumlahAnggota         int    `json:"jumlah_anggota"`
	JumlahRelasiAnak      int    `json:"jumlah_relasi_anak"`
	IDPengguna            int64  `json:"id_pengguna"`
	IDPendudukPemilikAkun int64  `json:"id_penduduk_pemilik_akun"`
	NamaPemilikAkun       string `json:"nama_pemilik_akun"`
	NomorTeleponAkun      string `json:"nomor_telepon_akun"`
	PasswordDefault       string `json:"password_default"`
}
