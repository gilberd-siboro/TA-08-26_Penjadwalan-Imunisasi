package models

import "time"

const (
	RoleIDAparatDesa   int64 = 1
	RoleNameAparatDesa       = "aparat_desa"
)

type Role struct {
	IDRole    int64      `gorm:"column:id_role;primaryKey" json:"id_role"`
	NamaRole  string     `gorm:"column:nama_role" json:"nama_role"`
	Deskripsi string     `gorm:"column:deskripsi" json:"deskripsi"`
	CreatedAt *time.Time `gorm:"column:created_at" json:"created_at,omitempty"`
	UpdatedAt *time.Time `gorm:"column:updated_at" json:"updated_at,omitempty"`
	IsDeleted bool       `gorm:"column:isDeleted" json:"is_deleted"`
}

func (Role) TableName() string {
	return "role"
}
