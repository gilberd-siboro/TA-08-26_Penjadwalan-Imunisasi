package repositories

import (
	"errors"
	"strings"
	"time"

	"monitoring-service/app/models"

	"gorm.io/gorm"
)

func (m *Main) FindPenggunaByNomorTelepon(nomorTelepon string) (*models.Pengguna, error) {
	nomorTelepon = strings.TrimSpace(nomorTelepon)
	if nomorTelepon == "" {
		return nil, errors.New("nomor telepon wajib diisi")
	}

	var pengguna models.Pengguna
	err := m.postgres.
		Model(&models.Pengguna{}).
		Preload("Role").
		Where(`nomor_telepon = ? AND "isDeleted" = ?`, nomorTelepon, false).
		First(&pengguna).Error
	if err != nil {
		return nil, err
	}

	return &pengguna, nil
}

func (m *Main) FindPenggunaByID(idPengguna int64) (*models.Pengguna, error) {
	if idPengguna <= 0 {
		return nil, errors.New("id_pengguna tidak valid")
	}

	var pengguna models.Pengguna
	err := m.postgres.
		Model(&models.Pengguna{}).
		Where(`id_pengguna = ? AND "isDeleted" = ?`, idPengguna, false).
		First(&pengguna).Error
	if err != nil {
		return nil, err
	}

	return &pengguna, nil
}

func (m *Main) UpdateKataSandiPengguna(idPengguna int64, kataSandiHash string) error {
	if idPengguna <= 0 {
		return errors.New("id_pengguna tidak valid")
	}
	if strings.TrimSpace(kataSandiHash) == "" {
		return errors.New("kata_sandi hash tidak valid")
	}

	now := time.Now()
	result := m.postgres.
		Model(&models.Pengguna{}).
		Where(`id_pengguna = ? AND "isDeleted" = ?`, idPengguna, false).
		Updates(map[string]interface{}{
			"kata_sandi": kataSandiHash,
			"updated_at": &now,
		})
	if result.Error != nil {
		return result.Error
	}
	if result.RowsAffected == 0 {
		return gorm.ErrRecordNotFound
	}

	return nil
}

func (m *Main) IsPendudukExists(idPenduduk int64) (bool, error) {
	if idPenduduk <= 0 {
		return false, errors.New("id_penduduk tidak valid")
	}

	var count int64
	err := m.postgres.
		Model(&models.Penduduk{}).
		Where("id_penduduk = ?", idPenduduk).
		Count(&count).Error
	if err != nil {
		return false, err
	}

	return count > 0, nil
}

func (m *Main) IsKartuKeluargaExists(idNoKK int64) (bool, error) {
	if idNoKK <= 0 {
		return false, errors.New("id_no_kk tidak valid")
	}

	var count int64
	err := m.postgres.
		Model(&models.KartuKeluarga{}).
		Where("id_no_kk = ?", idNoKK).
		Count(&count).Error
	if err != nil {
		return false, err
	}

	return count > 0, nil
}

func (m *Main) IsPenggunaByKKExists(idNoKK int64) (bool, error) {
	if idNoKK <= 0 {
		return false, errors.New("id_no_kk tidak valid")
	}

	var count int64
	err := m.postgres.
		Model(&models.Pengguna{}).
		Where(`id_no_kk = ? AND "isDeleted" = ? AND id_role <> ?`, idNoKK, false, models.RoleIDAparatDesa).
		Count(&count).Error
	if err != nil {
		return false, err
	}

	return count > 0, nil
}

func (m *Main) IsNomorTeleponExists(nomorTelepon string) (bool, error) {
	nomorTelepon = strings.TrimSpace(nomorTelepon)
	if nomorTelepon == "" {
		return false, errors.New("nomor telepon wajib diisi")
	}

	var count int64
	err := m.postgres.
		Model(&models.Pengguna{}).
		Where(`nomor_telepon = ? AND "isDeleted" = ?`, nomorTelepon, false).
		Count(&count).Error
	if err != nil {
		return false, err
	}

	return count > 0, nil
}

func IsNotFound(err error) bool {
	return errors.Is(err, gorm.ErrRecordNotFound)
}

func (m *Main) CreatePengguna(pengguna *models.Pengguna) error {
	if pengguna == nil {
		return errors.New("payload pengguna tidak boleh nil")
	}

	now := time.Now()
	pengguna.CreatedAt = &now
	pengguna.UpdatedAt = &now
	pengguna.IsDeleted = false

	if err := m.postgres.Create(pengguna).Error; err != nil {
		return err
	}

	return nil
}

func (m *Main) GetAnggotaKeluargaByKK(idNoKK int64) ([]models.Penduduk, error) {
	if idNoKK <= 0 {
		return nil, errors.New("id_no_kk tidak valid")
	}

	var anggota []models.Penduduk
	err := m.postgres.
		Model(&models.Penduduk{}).
		Where("id_no_kk = ?", idNoKK).
		Order("CASE " +
			"WHEN kedudukan_keluarga = 'Kepala Keluarga' THEN 1 " +
			"WHEN kedudukan_keluarga = 'Ibu' THEN 2 " +
			"WHEN kedudukan_keluarga = 'Anak' THEN 3 " +
			"ELSE 99 END").
		Order("nama_lengkap ASC").
		Find(&anggota).Error
	if err != nil {
		return nil, err
	}

	return anggota, nil
}
