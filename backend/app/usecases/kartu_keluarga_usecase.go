package usecases

import (
	"errors"
	"strings"
	"unicode"

	"monitoring-service/app/models"
)

func (m *Main) AdminCreateKartuKeluarga(actor models.AuthClaims, req models.AdminCreateKartuKeluargaRequest) (*models.AdminCreateKartuKeluargaResponse, error) {
	if !actor.IsAparatDesa() {
		return nil, errors.New("hanya aparat_desa yang boleh membuat data kartu_keluarga")
	}

	req.NoKK = strings.TrimSpace(req.NoKK)
	if req.NoKK == "" {
		return nil, errors.New("no_kk wajib diisi")
	}

	// validasi no_kk harus 16 digit angka
	if len(req.NoKK) != 16 {
		return nil, errors.New("no_kk harus 16 digit")
	}
	for _, ch := range req.NoKK {
		if !unicode.IsDigit(ch) {
			return nil, errors.New("no_kk hanya boleh berisi angka")
		}
	}

	exists, err := m.repository.IsKartuKeluargaByNoKKExists(req.NoKK)
	if err != nil {
		return nil, err
	}
	if exists {
		return nil, errors.New("no_kk sudah terdaftar")
	}

	entity := &models.KartuKeluarga{
		NoKK: req.NoKK,
	}

	if err := m.repository.CreateKartuKeluarga(entity); err != nil {
		return nil, err
	}

	return &models.AdminCreateKartuKeluargaResponse{
		IDNoKK: entity.IDNoKK,
		NoKK:   entity.NoKK,
	}, nil
}
