package usecases

import (
	"errors"
	"strings"

	"monitoring-service/app/models"
)

func normalizeKedudukan(raw string) string {
	return strings.ToLower(strings.TrimSpace(raw))
}

func isIbuKedudukan(raw string) bool {
	return normalizeKedudukan(raw) == "ibu"
}

func validatePendudukCoreFields(req models.AdminCreatePendudukRequest) error {
	if strings.TrimSpace(req.NIK) == "" {
		return errors.New("nik wajib diisi")
	}
	if strings.TrimSpace(req.NamaLengkap) == "" {
		return errors.New("nama_lengkap wajib diisi")
	}
	if strings.TrimSpace(req.JenisKelamin) == "" {
		return errors.New("jenis_kelamin wajib diisi")
	}
	jenisKelamin := strings.ToLower(strings.TrimSpace(req.JenisKelamin))
	if jenisKelamin != "laki-laki" && jenisKelamin != "perempuan" {
		return errors.New("jenis_kelamin tidak valid, gunakan 'Laki-laki' atau 'Perempuan'")
	}
	if req.TanggalLahir == nil {
		return errors.New("tanggal_lahir wajib diisi")
	}
	if strings.TrimSpace(req.TempatLahir) == "" {
		return errors.New("tempat_lahir wajib diisi")
	}
	if strings.TrimSpace(req.GolonganDarah) == "" {
		return errors.New("golongan_darah wajib diisi")
	}
	if strings.TrimSpace(req.Agama) == "" {
		return errors.New("agama wajib diisi")
	}
	if strings.TrimSpace(req.StatusPerkawinan) == "" {
		return errors.New("status_perkawinan wajib diisi")
	}
	if strings.TrimSpace(req.PendidikanTerakhir) == "" {
		return errors.New("pendidikan_terakhir wajib diisi")
	}
	if strings.TrimSpace(req.Pekerjaan) == "" {
		return errors.New("pekerjaan wajib diisi")
	}
	if req.BacaHuruf == nil {
		return errors.New("baca_huruf wajib diisi")
	}
	if strings.TrimSpace(req.KedudukanKeluarga) == "" {
		return errors.New("kedudukan_keluarga wajib diisi")
	}

	kedudukan := normalizeKedudukan(req.KedudukanKeluarga)
	nomorTelepon := strings.TrimSpace(req.NomorTelepon)
	if kedudukan == "anak" {
		if nomorTelepon != "" {
			if err := validateNomorTeleponIndonesia(nomorTelepon); err != nil {
				return err
			}
		}
	} else {
		if nomorTelepon == "" {
			return errors.New("nomor_telepon wajib diisi")
		}
		if err := validateNomorTeleponIndonesia(nomorTelepon); err != nil {
			return err
		}
	}

	if strings.TrimSpace(req.Dusun) == "" {
		return errors.New("dusun wajib diisi")
	}
	if req.TanggalPenambahan == nil {
		return errors.New("tanggal_penambahan wajib diisi")
	}
	if strings.TrimSpace(req.AsalPenduduk) == "" {
		return errors.New("asal_penduduk wajib diisi")
	}
	if strings.TrimSpace(req.Keterangan) == "" {
		return errors.New("keterangan wajib diisi")
	}

	return nil
}

func copyCreateReqToPenduduk(entity *models.Penduduk, req models.AdminCreatePendudukRequest) {
	entity.IDNoKK = req.IDNoKK
	entity.NIK = strings.TrimSpace(req.NIK)
	entity.NomorTelepon = strings.TrimSpace(req.NomorTelepon)
	entity.NamaLengkap = strings.TrimSpace(req.NamaLengkap)
	entity.JenisKelamin = strings.TrimSpace(req.JenisKelamin)
	entity.TanggalLahir = req.TanggalLahir
	entity.TempatLahir = strings.TrimSpace(req.TempatLahir)
	entity.GolonganDarah = strings.TrimSpace(req.GolonganDarah)
	entity.Agama = strings.TrimSpace(req.Agama)
	entity.StatusPerkawinan = strings.TrimSpace(req.StatusPerkawinan)
	entity.PendidikanTerakhir = strings.TrimSpace(req.PendidikanTerakhir)
	entity.Pekerjaan = strings.TrimSpace(req.Pekerjaan)
	entity.BacaHuruf = req.BacaHuruf
	entity.KedudukanKeluarga = strings.TrimSpace(req.KedudukanKeluarga)
	entity.Dusun = strings.TrimSpace(req.Dusun)
	entity.TanggalPenambahan = req.TanggalPenambahan
	entity.AsalPenduduk = strings.TrimSpace(req.AsalPenduduk)
	entity.TanggalPengurangan = req.TanggalPengurangan
	entity.TujuanPindah = strings.TrimSpace(req.TujuanPindah)
	entity.TempatMeninggal = strings.TrimSpace(req.TempatMeninggal)
	entity.Keterangan = strings.TrimSpace(req.Keterangan)
}

func (m *Main) syncIbuByKedudukan(entity *models.Penduduk) (bool, error) {
	if entity == nil {
		return false, errors.New("data penduduk tidak valid")
	}

	if !isIbuKedudukan(entity.KedudukanKeluarga) {
		return false, nil
	}

	alreadyIbu, err := m.repository.IsIbuByPendudukExists(entity.IDPenduduk)
	if err != nil {
		return false, err
	}
	if alreadyIbu {
		return false, nil
	}

	if err := m.repository.CreateIbu(&models.Ibu{IDPenduduk: entity.IDPenduduk}); err != nil {
		return false, err
	}

	return true, nil
}

func (m *Main) AdminCreatePenduduk(actor models.AuthClaims, req models.AdminCreatePendudukRequest) (*models.AdminPendudukResponse, error) {
	if !actor.IsAparatDesa() {
		return nil, errors.New("hanya aparat_desa yang boleh membuat data penduduk")
	}

	if err := validatePendudukCoreFields(req); err != nil {
		return nil, err
	}

	if req.IDNoKK != nil && *req.IDNoKK > 0 {
		kkExists, err := m.repository.IsKartuKeluargaExists(*req.IDNoKK)
		if err != nil {
			return nil, err
		}
		if !kkExists {
			return nil, errors.New("kartu_keluarga tidak ditemukan")
		}
	}

	entity := &models.Penduduk{}
	copyCreateReqToPenduduk(entity, req)

	if err := m.repository.CreatePenduduk(entity); err != nil {
		if strings.Contains(strings.ToLower(err.Error()), "duplicate") || strings.Contains(strings.ToLower(err.Error()), "unique") {
			errMsg := strings.ToLower(err.Error())
			if strings.Contains(errMsg, "nomor_telepon") {
				return nil, errors.New("nomor telepon sudah terdaftar")
			}
			return nil, errors.New("nik sudah terdaftar")
		}
		return nil, err
	}

	syncIbu, err := m.syncIbuByKedudukan(entity)
	if err != nil {
		return nil, err
	}

	return &models.AdminPendudukResponse{
		IDPenduduk:   entity.IDPenduduk,
		NIK:          entity.NIK,
		NomorTelepon: entity.NomorTelepon,
		NamaLengkap:  entity.NamaLengkap,
		IDNoKK:       entity.IDNoKK,
		SyncIbu:      syncIbu,
	}, nil
}
