package models

import "time"

type Role struct {
	ID        uint      `gorm:"column:id_role;primaryKey" json:"id_role"`
	Name      string    `gorm:"column:nama_role;type:varchar(50);not null;uniqueIndex" json:"name"`
	Deskripsi    string `gorm:"column:deskripsi;type:text;not null" json:"-"`
	CreatedAt time.Time `gorm:"column:created_at" json:"created_at"`
	UpdatedAt time.Time `gorm:"column:updated_at" json:"updated_at"`
}

func (Role) TableName() string {
	return "role"
}
