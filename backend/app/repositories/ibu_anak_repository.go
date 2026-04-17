package repositories

import (
	"errors"

	"monitoring-service/app/models"

	"gorm.io/gorm"
)

func (m *Main) IsIbuExists(idIbu int64) (bool, error) {
	if idIbu <= 0 {
		return false, errors.New("id_ibu tidak valid")
	}

	var count int64
	err := m.postgres.
		Model(&models.Ibu{}).
		Where("id_ibu = ?", idIbu).
		Count(&count).Error
	if err != nil {
		return false, err
	}

	return count > 0, nil
}

func (m *Main) IsAnakByPendudukExists(idPenduduk int64) (bool, error) {
	if idPenduduk <= 0 {
		return false, errors.New("id_penduduk tidak valid")
	}

	var count int64
	err := m.postgres.
		Model(&models.Anak{}).
		Where("id_penduduk = ?", idPenduduk).
		Count(&count).Error
	if err != nil {
		return false, err
	}

	return count > 0, nil
}

func (m *Main) CreateAnak(anak *models.Anak) error {
	if anak == nil {
		return errors.New("payload anak tidak boleh nil")
	}

	return m.postgres.Create(anak).Error
}

func (m *Main) GetIbuByID(idIbu int64) (*models.Ibu, error) {
	if idIbu <= 0 {
		return nil, errors.New("id_ibu tidak valid")
	}

	var ibu models.Ibu
	err := m.postgres.
		Model(&models.Ibu{}).
		Where("id_ibu = ?", idIbu).
		First(&ibu).Error
	if err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return nil, err
		}
		return nil, err
	}

	return &ibu, nil
}

func (m *Main) GetIbuByPendudukID(idPenduduk int64) (*models.Ibu, error) {
	if idPenduduk <= 0 {
		return nil, errors.New("id_penduduk tidak valid")
	}

	var ibu models.Ibu
	err := m.postgres.
		Model(&models.Ibu{}).
		Where("id_penduduk = ?", idPenduduk).
		First(&ibu).Error
	if err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return nil, err
		}
		return nil, err
	}

	return &ibu, nil
}
