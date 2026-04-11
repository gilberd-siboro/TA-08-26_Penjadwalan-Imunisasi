package models

import "time"

type User struct {
	ID          uint      `gorm:"column:id;primaryKey" json:"id"`
	Name        string    `gorm:"column:nama;type:varchar(120);not null" json:"name"`
	Email       string    `gorm:"column:email;type:varchar(120);not null;uniqueIndex" json:"email"`
	PhoneNumber string    `gorm:"column:nomor_telepon;type:varchar(20);uniqueIndex" json:"phone_number"`
	Password    string    `gorm:"column:kata_sandi;type:text;not null" json:"-"`
	RoleID      uint      `gorm:"column:id_role;not null;index" json:"role_id"`
	Role        Role      `gorm:"foreignKey:RoleID;references:ID" json:"role"`
	CreatedAt   time.Time `gorm:"column:created_at" json:"created_at"`
	UpdatedAt   time.Time `gorm:"column:updated_at" json:"updated_at"`
}

func (User) TableName() string {
	return "pengguna"
}
