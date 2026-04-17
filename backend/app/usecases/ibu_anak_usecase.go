package usecases

import (
	"errors"
	"strings"

	"monitoring-service/app/models"
	"monitoring-service/app/repositories"
)

func (m *Main) AdminCreateAnak(actor models.AuthClaims, req models.AdminCreateAnakRequest) (*models.AdminCreateAnakResponse, error) {
	if !actor.IsAparatDesa() {
		return nil, errors.New("hanya aparat_desa yang boleh membuat data anak")
	}

	if req.IDIbu <= 0 {
		return nil, errors.New("id_ibu tidak valid")
	}
	if req.IDPenduduk <= 0 {
		return nil, errors.New("id_penduduk tidak valid")
	}

	ibuExists, err := m.repository.IsIbuExists(req.IDIbu)
	if err != nil {
		return nil, err
	}
	if !ibuExists {
		return nil, errors.New("data ibu tidak ditemukan")
	}

	pendudukExists, err := m.repository.IsPendudukExists(req.IDPenduduk)
	if err != nil {
		return nil, err
	}
	if !pendudukExists {
		return nil, errors.New("penduduk tidak ditemukan")
	}

	anakExists, err := m.repository.IsAnakByPendudukExists(req.IDPenduduk)
	if err != nil {
		return nil, err
	}
	if anakExists {
		return nil, errors.New("penduduk sudah terdaftar sebagai anak")
	}

	ibuData, err := m.repository.GetIbuByID(req.IDIbu)
	if err != nil {
		return nil, err
	}
	if ibuData.IDPenduduk == req.IDPenduduk {
		return nil, errors.New("id_penduduk anak tidak boleh sama dengan id_penduduk ibu")
	}

	entity := &models.Anak{
		IDIbu:      req.IDIbu,
		IDPenduduk: req.IDPenduduk,
	}

	if err := m.repository.CreateAnak(entity); err != nil {
		return nil, err
	}

	return &models.AdminCreateAnakResponse{
		IDAnak:     entity.IDAnak,
		IDIbu:      entity.IDIbu,
		IDPenduduk: entity.IDPenduduk,
	}, nil
}

func isDuplicateError(err error) bool {
	if err == nil {
		return false
	}
	errMsg := strings.ToLower(err.Error())
	return strings.Contains(errMsg, "duplicate") || strings.Contains(errMsg, "unique")
}

func (m *Main) KeluargaCreateAnak(actor models.AuthClaims, req models.KeluargaCreateAnakRequest) (*models.KeluargaCreateAnakResponse, error) {
	if actor.IDNoKK == nil || *actor.IDNoKK <= 0 {
		return nil, errors.New("akun tidak terhubung ke kartu_keluarga")
	}
	if req.IDIbu <= 0 {
		return nil, errors.New("id_ibu tidak valid")
	}
	if strings.TrimSpace(req.NamaLengkap) == "" {
		return nil, errors.New("nama_lengkap wajib diisi")
	}
	if strings.TrimSpace(req.JenisKelamin) == "" {
		return nil, errors.New("jenis_kelamin wajib diisi")
	}

	ibuData, err := m.repository.GetIbuByID(req.IDIbu)
	if err != nil {
		if repositories.IsRecordNotFound(err) {
			return nil, errors.New("data ibu tidak ditemukan")
		}
		return nil, err
	}

	pendudukIbu, err := m.repository.GetPendudukByID(ibuData.IDPenduduk)
	if err != nil {
		if repositories.IsRecordNotFound(err) {
			return nil, errors.New("penduduk ibu tidak ditemukan")
		}
		return nil, err
	}
	if pendudukIbu.IDNoKK == nil || *pendudukIbu.IDNoKK != *actor.IDNoKK {
		return nil, errors.New("ibu tidak berada pada kartu_keluarga yang sama")
	}

	nik := strings.TrimSpace(req.NIK)
	nomorTelepon := strings.TrimSpace(req.NomorTelepon)

	// Untuk bayi baru lahir, NIK dan nomor telepon boleh kosong.
	if nomorTelepon != "" {
		if err := validateNomorTeleponIndonesia(nomorTelepon); err != nil {
			return nil, err
		}
	}

	entityPenduduk := &models.Penduduk{
		IDNoKK:            actor.IDNoKK,
		NIK:               nik,
		NomorTelepon:      nomorTelepon,
		NamaLengkap:       strings.TrimSpace(req.NamaLengkap),
		JenisKelamin:      strings.TrimSpace(req.JenisKelamin),
		TanggalLahir:      req.TanggalLahir,
		TempatLahir:       strings.TrimSpace(req.TempatLahir),
		KedudukanKeluarga: "Anak",
		Dusun:             strings.TrimSpace(req.Dusun),
		Keterangan:        strings.TrimSpace(req.Keterangan),
	}

	if err := m.repository.CreatePendudukForAnak(entityPenduduk); err != nil {
		if isDuplicateError(err) {
			if strings.Contains(strings.ToLower(err.Error()), "nomor_telepon") {
				return nil, errors.New("nomor telepon sudah terdaftar")
			}
			if strings.Contains(strings.ToLower(err.Error()), "nik") {
				return nil, errors.New("nik sudah terdaftar")
			}
			return nil, errors.New("nik sudah terdaftar")
		}
		return nil, err
	}

	entityAnak := &models.Anak{
		IDIbu:      req.IDIbu,
		IDPenduduk: entityPenduduk.IDPenduduk,
	}
	if err := m.repository.CreateAnak(entityAnak); err != nil {
		_ = m.repository.DeletePendudukByID(entityPenduduk.IDPenduduk)

		if isDuplicateError(err) {
			return nil, errors.New("penduduk sudah terdaftar sebagai anak")
		}
		return nil, err
	}

	return &models.KeluargaCreateAnakResponse{
		IDAnak:                entityAnak.IDAnak,
		IDIbu:                 entityAnak.IDIbu,
		IDPenduduk:            entityAnak.IDPenduduk,
		NIK:                   entityPenduduk.NIK,
		NomorTelepon:          entityPenduduk.NomorTelepon,
		NomorTeleponSementara: false,
	}, nil
}
