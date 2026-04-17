package models

import "time"

type AdminCreateAnakRequest struct {
	IDIbu      int64 `json:"id_ibu"`
	IDPenduduk int64 `json:"id_penduduk"`
}

type AdminCreateAnakResponse struct {
	IDAnak     int64 `json:"id_anak"`
	IDIbu      int64 `json:"id_ibu"`
	IDPenduduk int64 `json:"id_penduduk"`
}

type KeluargaCreateAnakRequest struct {
	IDIbu        int64      `json:"id_ibu"`
	NIK          string     `json:"nik,omitempty"`
	NomorTelepon string     `json:"nomor_telepon,omitempty"`
	NamaLengkap  string     `json:"nama_lengkap"`
	JenisKelamin string     `json:"jenis_kelamin"`
	TanggalLahir *time.Time `json:"tanggal_lahir,omitempty"`
	TempatLahir  string     `json:"tempat_lahir"`
	Dusun        string     `json:"dusun"`
	Keterangan   string     `json:"keterangan"`
}

type KeluargaCreateAnakResponse struct {
	IDAnak                int64  `json:"id_anak"`
	IDIbu                 int64  `json:"id_ibu"`
	IDPenduduk            int64  `json:"id_penduduk"`
	NIK                   string `json:"nik"`
	NomorTelepon          string `json:"nomor_telepon"`
	NomorTeleponSementara bool   `json:"nomor_telepon_sementara"`
}
