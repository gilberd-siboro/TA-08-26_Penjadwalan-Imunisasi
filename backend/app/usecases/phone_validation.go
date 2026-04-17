package usecases

import (
	"errors"
	"regexp"
	"strings"
)

var nomorTeleponIndonesiaRegex = regexp.MustCompile(`^08[0-9]{8,10}$`)

func validateNomorTeleponIndonesia(raw string) error {
	nomorTelepon := strings.TrimSpace(raw)
	if nomorTelepon == "" {
		return errors.New("nomor_telepon wajib diisi")
	}

	if !nomorTeleponIndonesiaRegex.MatchString(nomorTelepon) {
		return errors.New("nomor_telepon tidak valid, harus format Indonesia 10-12 digit dan diawali 08")
	}

	return nil
}
