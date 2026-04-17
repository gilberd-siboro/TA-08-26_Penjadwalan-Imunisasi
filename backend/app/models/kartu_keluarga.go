package models

type KartuKeluarga struct {
	IDNoKK int64  `gorm:"column:id_no_kk;primaryKey" json:"id_no_kk"`
	NoKK   string `gorm:"column:no_kk" json:"no_kk"`
}

func (KartuKeluarga) TableName() string {
	return "kartu_keluarga"
}
