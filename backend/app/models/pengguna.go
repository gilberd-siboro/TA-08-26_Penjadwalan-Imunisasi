package models

import "time"

type Pengguna struct {
	IDPengguna   int64      `gorm:"column:id_pengguna;primaryKey" json:"id_pengguna"`
	IDPenduduk   *int64     `gorm:"column:id_penduduk" json:"id_penduduk,omitempty"`
	IDNoKK       *int64     `gorm:"column:id_no_kk" json:"id_no_kk,omitempty"`
	NomorTelepon string     `gorm:"column:nomor_telepon" json:"nomor_telepon"`
	KataSandi    string     `gorm:"column:kata_sandi" json:"-"`
	IDRole       int64      `gorm:"column:id_role" json:"id_role"`
	CreatedAt    *time.Time `gorm:"column:created_at" json:"created_at,omitempty"`
	UpdatedAt    *time.Time `gorm:"column:updated_at" json:"updated_at,omitempty"`
	IsDeleted    bool       `gorm:"column:isDeleted" json:"is_deleted"`

	Role          Role          `gorm:"foreignKey:IDRole;references:IDRole" json:"role,omitempty"`
	Penduduk      Penduduk      `gorm:"foreignKey:IDPenduduk;references:IDPenduduk" json:"penduduk,omitempty"`
	KartuKeluarga KartuKeluarga `gorm:"foreignKey:IDNoKK;references:IDNoKK" json:"kartu_keluarga,omitempty"`
}

func (Pengguna) TableName() string {
	return "pengguna"
}
