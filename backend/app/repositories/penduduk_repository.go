package repositories

import (
	"errors"
	"strings"

	"monitoring-service/app/models"

	"gorm.io/gorm"
)

func (m *Main) CreatePenduduk(entity *models.Penduduk) error {
	if entity == nil {
		return errors.New("payload penduduk tidak boleh nil")
	}

	entity.NIK = strings.TrimSpace(entity.NIK)
	entity.NomorTelepon = strings.TrimSpace(entity.NomorTelepon)

	if entity.NomorTelepon != "" {
		return m.postgres.Create(entity).Error
	}

	var insertedID int64
	err := m.postgres.Raw(`
		INSERT INTO penduduk (
			id_no_kk,
			nik,
			nomor_telepon,
			nama_lengkap,
			jenis_kelamin,
			tanggal_lahir,
			tempat_lahir,
			golongan_darah,
			agama,
			status_perkawinan,
			pendidikan_terakhir,
			pekerjaan,
			baca_huruf,
			kedudukan_keluarga,
			dusun,
			tanggal_penambahan,
			asal_penduduk,
			tanggal_pengurangan,
			tujuan_pindah,
			tempat_meninggal,
			keterangan
		)
		VALUES (?, NULLIF(?, ''), NULLIF(?, ''), ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
		RETURNING id_penduduk
	`, entity.IDNoKK, entity.NIK, entity.NomorTelepon, entity.NamaLengkap, entity.JenisKelamin, entity.TanggalLahir, entity.TempatLahir, entity.GolonganDarah, entity.Agama, entity.StatusPerkawinan, entity.PendidikanTerakhir, entity.Pekerjaan, entity.BacaHuruf, entity.KedudukanKeluarga, entity.Dusun, entity.TanggalPenambahan, entity.AsalPenduduk, entity.TanggalPengurangan, entity.TujuanPindah, entity.TempatMeninggal, entity.Keterangan).Scan(&insertedID).Error
	if err != nil {
		return err
	}

	entity.IDPenduduk = insertedID
	return nil
}

func (m *Main) GetPendudukByID(idPenduduk int64) (*models.Penduduk, error) {
	if idPenduduk <= 0 {
		return nil, errors.New("id_penduduk tidak valid")
	}

	var penduduk models.Penduduk
	err := m.postgres.
		Model(&models.Penduduk{}).
		Where("id_penduduk = ?", idPenduduk).
		First(&penduduk).Error
	if err != nil {
		return nil, err
	}

	return &penduduk, nil
}

func (m *Main) DeletePendudukByID(idPenduduk int64) error {
	if idPenduduk <= 0 {
		return errors.New("id_penduduk tidak valid")
	}

	return m.postgres.
		Where("id_penduduk = ?", idPenduduk).
		Delete(&models.Penduduk{}).Error
}

func (m *Main) CreatePendudukForAnak(entity *models.Penduduk) error {
	if entity == nil {
		return errors.New("payload penduduk tidak boleh nil")
	}

	entity.NIK = strings.TrimSpace(entity.NIK)
	entity.NomorTelepon = strings.TrimSpace(entity.NomorTelepon)

	if entity.NIK != "" && entity.NomorTelepon != "" {
		return m.postgres.Create(entity).Error
	}

	var insertedID int64
	err := m.postgres.Raw(`
		INSERT INTO penduduk (
			id_no_kk,
			nik,
			nomor_telepon,
			nama_lengkap,
			jenis_kelamin,
			tanggal_lahir,
			tempat_lahir,
			kedudukan_keluarga,
			dusun,
			keterangan
		)
		VALUES (?, NULLIF(?, ''), NULLIF(?, ''), ?, ?, ?, ?, ?, ?, ?)
		RETURNING id_penduduk
	`, entity.IDNoKK, entity.NIK, entity.NomorTelepon, entity.NamaLengkap, entity.JenisKelamin, entity.TanggalLahir, entity.TempatLahir, entity.KedudukanKeluarga, entity.Dusun, entity.Keterangan).Scan(&insertedID).Error
	if err != nil {
		return err
	}

	entity.IDPenduduk = insertedID
	return nil
}

func (m *Main) IsIbuByPendudukExists(idPenduduk int64) (bool, error) {
	if idPenduduk <= 0 {
		return false, errors.New("id_penduduk tidak valid")
	}

	var count int64
	err := m.postgres.
		Model(&models.Ibu{}).
		Where("id_penduduk = ?", idPenduduk).
		Count(&count).Error
	if err != nil {
		return false, err
	}

	return count > 0, nil
}

func (m *Main) CreateIbu(ibu *models.Ibu) error {
	if ibu == nil {
		return errors.New("payload ibu tidak boleh nil")
	}

	return m.postgres.Create(ibu).Error
}

func IsRecordNotFound(err error) bool {
	return errors.Is(err, gorm.ErrRecordNotFound)
}
