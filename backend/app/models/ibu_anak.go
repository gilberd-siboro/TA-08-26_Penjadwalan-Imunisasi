package models

type Ibu struct {
    IDIbu      int64 `gorm:"column:id_ibu;primaryKey" json:"id_ibu"`
    IDPenduduk int64 `gorm:"column:id_penduduk" json:"id_penduduk"`

    Penduduk Penduduk `gorm:"foreignKey:IDPenduduk;references:IDPenduduk" json:"penduduk,omitempty"`
}

func (Ibu) TableName() string {
    return "ibu"
}

type Anak struct {
    IDAnak     int64 `gorm:"column:id_anak;primaryKey" json:"id_anak"`
    IDIbu      int64 `gorm:"column:id_ibu" json:"id_ibu"`
    IDPenduduk int64 `gorm:"column:id_penduduk" json:"id_penduduk"`

    Ibu      Ibu      `gorm:"foreignKey:IDIbu;references:IDIbu" json:"ibu,omitempty"`
    Penduduk Penduduk `gorm:"foreignKey:IDPenduduk;references:IDPenduduk" json:"penduduk,omitempty"`
}

func (Anak) TableName() string {
    return "anak"
}