package models

import "time"

type AdminCreatePendudukRequest struct {
	IDNoKK             *int64     `json:"id_no_kk,omitempty"`
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
}

type AdminPendudukResponse struct {
	IDPenduduk   int64  `json:"id_penduduk"`
	NIK          string `json:"nik"`
	NomorTelepon string `json:"nomor_telepon"`
	NamaLengkap  string `json:"nama_lengkap"`
	IDNoKK       *int64 `json:"id_no_kk,omitempty"`
	SyncIbu      bool   `json:"sync_ibu"`
}
