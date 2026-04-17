package models

import "time"

type Penduduk struct {
	IDPenduduk         int64      `gorm:"column:id_penduduk;primaryKey" json:"id_penduduk"`
	IDNoKK             *int64     `gorm:"column:id_no_kk" json:"id_no_kk,omitempty"`
	NIK                string     `gorm:"column:nik" json:"nik"`
	NomorTelepon       string     `gorm:"column:nomor_telepon" json:"nomor_telepon"`
	NamaLengkap        string     `gorm:"column:nama_lengkap" json:"nama_lengkap"`
	JenisKelamin       string     `gorm:"column:jenis_kelamin" json:"jenis_kelamin"`
	TanggalLahir       *time.Time `gorm:"column:tanggal_lahir" json:"tanggal_lahir,omitempty"`
	TempatLahir        string     `gorm:"column:tempat_lahir" json:"tempat_lahir"`
	GolonganDarah      string     `gorm:"column:golongan_darah" json:"golongan_darah"`
	Agama              string     `gorm:"column:agama" json:"agama"`
	StatusPerkawinan   string     `gorm:"column:status_perkawinan" json:"status_perkawinan"`
	PendidikanTerakhir string     `gorm:"column:pendidikan_terakhir" json:"pendidikan_terakhir"`
	Pekerjaan          string     `gorm:"column:pekerjaan" json:"pekerjaan"`
	BacaHuruf          *bool      `gorm:"column:baca_huruf" json:"baca_huruf,omitempty"`
	KedudukanKeluarga  string     `gorm:"column:kedudukan_keluarga" json:"kedudukan_keluarga"`
	Dusun              string     `gorm:"column:dusun" json:"dusun"`
	TanggalPenambahan  *time.Time `gorm:"column:tanggal_penambahan" json:"tanggal_penambahan,omitempty"`
	AsalPenduduk       string     `gorm:"column:asal_penduduk" json:"asal_penduduk"`
	TanggalPengurangan *time.Time `gorm:"column:tanggal_pengurangan" json:"tanggal_pengurangan,omitempty"`
	TujuanPindah       string     `gorm:"column:tujuan_pindah" json:"tujuan_pindah"`
	TempatMeninggal    string     `gorm:"column:tempat_meninggal" json:"tempat_meninggal"`
	Keterangan         string     `gorm:"column:keterangan" json:"keterangan"`
}

func (Penduduk) TableName() string {
	return "penduduk"
}
