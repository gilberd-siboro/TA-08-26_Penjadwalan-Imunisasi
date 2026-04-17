package usecases

import (
	"errors"
	"strings"

	"monitoring-service/app/models"
	"monitoring-service/app/repositories"
)

func normalizeNIK(raw string) string {
	return strings.TrimSpace(raw)
}

func (m *Main) AdminCreateKeluargaLengkap(actor models.AuthClaims, req models.AdminCreateKeluargaLengkapRequest) (*models.AdminCreateKeluargaLengkapResponse, error) {
	if !actor.IsAparatDesa() {
		return nil, errors.New("hanya aparat_desa yang boleh membuat data keluarga")
	}

	req.NoKK = strings.TrimSpace(req.NoKK)
	req.NIKPemilikAkun = normalizeNIK(req.NIKPemilikAkun)

	if req.NoKK == "" {
		return nil, errors.New("no_kk wajib diisi")
	}
	if req.IDRolePengguna <= 0 {
		return nil, errors.New("id_role_pengguna tidak valid")
	}
	if req.NIKPemilikAkun == "" {
		return nil, errors.New("nik_pemilik_akun wajib diisi")
	}
	if len(req.Anggota) == 0 {
		return nil, errors.New("anggota wajib diisi minimal 1")
	}

	kkRes, err := m.AdminCreateKartuKeluarga(actor, models.AdminCreateKartuKeluargaRequest{NoKK: req.NoKK})
	if err != nil {
		return nil, err
	}

	idNoKK := kkRes.IDNoKK
	nikToPendudukID := make(map[string]int64)
	nikToNama := make(map[string]string)
	nikToIbuID := make(map[string]int64)

	var idPendudukPemilik int64
	var namaPemilik string

	for _, anggota := range req.Anggota {
		nik := normalizeNIK(anggota.NIK)
		if nik == "" {
			return nil, errors.New("nik anggota wajib diisi")
		}
		if _, exists := nikToPendudukID[nik]; exists {
			return nil, errors.New("nik anggota duplikat dalam payload")
		}

		createPendudukReq := models.AdminCreatePendudukRequest{
			IDNoKK:             &idNoKK,
			NIK:                nik,
			NomorTelepon:       strings.TrimSpace(anggota.NomorTelepon),
			NamaLengkap:        strings.TrimSpace(anggota.NamaLengkap),
			JenisKelamin:       strings.TrimSpace(anggota.JenisKelamin),
			TanggalLahir:       anggota.TanggalLahir,
			TempatLahir:        strings.TrimSpace(anggota.TempatLahir),
			GolonganDarah:      strings.TrimSpace(anggota.GolonganDarah),
			Agama:              strings.TrimSpace(anggota.Agama),
			StatusPerkawinan:   strings.TrimSpace(anggota.StatusPerkawinan),
			PendidikanTerakhir: strings.TrimSpace(anggota.PendidikanTerakhir),
			Pekerjaan:          strings.TrimSpace(anggota.Pekerjaan),
			BacaHuruf:          anggota.BacaHuruf,
			KedudukanKeluarga:  strings.TrimSpace(anggota.KedudukanKeluarga),
			Dusun:              strings.TrimSpace(anggota.Dusun),
			TanggalPenambahan:  anggota.TanggalPenambahan,
			AsalPenduduk:       strings.TrimSpace(anggota.AsalPenduduk),
			TanggalPengurangan: anggota.TanggalPengurangan,
			TujuanPindah:       strings.TrimSpace(anggota.TujuanPindah),
			TempatMeninggal:    strings.TrimSpace(anggota.TempatMeninggal),
			Keterangan:         strings.TrimSpace(anggota.Keterangan),
		}

		pendudukRes, createErr := m.AdminCreatePenduduk(actor, createPendudukReq)
		if createErr != nil {
			return nil, createErr
		}

		nikToPendudukID[nik] = pendudukRes.IDPenduduk
		nikToNama[nik] = pendudukRes.NamaLengkap

		if isIbuKedudukan(anggota.KedudukanKeluarga) {
			ibuData, ibuErr := m.repository.GetIbuByPendudukID(pendudukRes.IDPenduduk)
			if ibuErr != nil {
				if repositories.IsRecordNotFound(ibuErr) {
					return nil, errors.New("sinkronisasi ibu gagal")
				}
				return nil, ibuErr
			}
			nikToIbuID[nik] = ibuData.IDIbu
		}

		if nik == req.NIKPemilikAkun {
			idPendudukPemilik = pendudukRes.IDPenduduk
			namaPemilik = pendudukRes.NamaLengkap
		}
	}

	if idPendudukPemilik <= 0 {
		return nil, errors.New("nik_pemilik_akun tidak ditemukan pada anggota")
	}

	penggunaRes, err := m.AdminCreatePengguna(actor, models.AdminCreatePenggunaRequest{
		IDPenduduk: idPendudukPemilik,
		IDRole:     req.IDRolePengguna,
	})
	if err != nil {
		return nil, err
	}

	jumlahRelasiAnak := 0
	for _, anggota := range req.Anggota {
		nikIbu := normalizeNIK(anggota.NIKIbu)
		if nikIbu == "" {
			continue
		}

		nikAnak := normalizeNIK(anggota.NIK)
		idPendudukAnak, existsAnak := nikToPendudukID[nikAnak]
		if !existsAnak {
			return nil, errors.New("relasi anak tidak valid: nik anak tidak ditemukan")
		}

		idIbu, existsIbu := nikToIbuID[nikIbu]
		if !existsIbu {
			return nil, errors.New("relasi anak tidak valid: nik_ibu tidak ditemukan atau bukan ibu")
		}

		_, err = m.AdminCreateAnak(actor, models.AdminCreateAnakRequest{
			IDIbu:      idIbu,
			IDPenduduk: idPendudukAnak,
		})
		if err != nil {
			return nil, err
		}

		jumlahRelasiAnak++
	}

	return &models.AdminCreateKeluargaLengkapResponse{
		IDNoKK:                kkRes.IDNoKK,
		NoKK:                  kkRes.NoKK,
		JumlahAnggota:         len(req.Anggota),
		JumlahRelasiAnak:      jumlahRelasiAnak,
		IDPengguna:            penggunaRes.IDPengguna,
		IDPendudukPemilikAkun: idPendudukPemilik,
		NamaPemilikAkun:       namaPemilik,
		NomorTeleponAkun:      penggunaRes.NomorTelepon,
		PasswordDefault:       penggunaRes.PasswordDefault,
	}, nil
}
