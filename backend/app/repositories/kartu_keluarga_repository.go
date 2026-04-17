package repositories

import (
	"errors"
	"strings"

	"monitoring-service/app/models"
)

func (m *Main) IsKartuKeluargaByNoKKExists(noKK string) (bool, error) {
	noKK = strings.TrimSpace(noKK)
	if noKK == "" {
		return false, errors.New("no_kk wajib diisi")
	}

	var count int64
	err := m.postgres.
		Model(&models.KartuKeluarga{}).
		Where("no_kk = ?", noKK).
		Count(&count).Error
	if err != nil {
		return false, err
	}

	return count > 0, nil
}

func (m *Main) CreateKartuKeluarga(kk *models.KartuKeluarga) error {
	if kk == nil {
		return errors.New("payload kartu_keluarga tidak boleh nil")
	}

	kk.NoKK = strings.TrimSpace(kk.NoKK)
	if kk.NoKK == "" {
		return errors.New("no_kk wajib diisi")
	}

	return m.postgres.Create(kk).Error
}

func (m *Main) GetKartuKeluargaByID(idNoKK int64) (*models.KartuKeluarga, error) {
	if idNoKK <= 0 {
		return nil, errors.New("id_no_kk tidak valid")
	}

	var kk models.KartuKeluarga
	err := m.postgres.
		Model(&models.KartuKeluarga{}).
		Where("id_no_kk = ?", idNoKK).
		First(&kk).Error
	if err != nil {
		return nil, err
	}

	return &kk, nil
}
