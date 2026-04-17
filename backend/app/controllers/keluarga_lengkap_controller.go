package controllers

import (
	"net/http"
	"strings"

	"monitoring-service/app/helpers"
	"monitoring-service/app/models"

	"github.com/labstack/echo/v4"
)

func (m *Main) AdminCreateKeluargaLengkap(c echo.Context) error {
	var req models.AdminCreateKeluargaLengkapRequest
	if err := c.Bind(&req); err != nil {
		return helpers.Response(c, http.StatusBadRequest, []string{"format request tidak valid"})
	}

	rawClaims := c.Get("auth_claims")
	claims, ok := rawClaims.(*models.AuthClaims)
	if !ok || claims == nil {
		return helpers.Response(c, http.StatusUnauthorized, []string{"claims token tidak valid"})
	}

	result, err := m.usecases.AdminCreateKeluargaLengkap(*claims, req)
	if err != nil {
		errMsg := strings.ToLower(err.Error())

		if strings.Contains(errMsg, "hanya aparat_desa") {
			return helpers.Response(c, http.StatusForbidden, []string{err.Error()})
		}

		if strings.Contains(errMsg, "wajib diisi") || strings.Contains(errMsg, "tidak valid") || strings.Contains(errMsg, "duplikat") || strings.Contains(errMsg, "belum tersedia") || strings.Contains(errMsg, "sinkronisasi") || strings.Contains(errMsg, "relasi anak tidak valid") {
			return helpers.Response(c, http.StatusBadRequest, []string{err.Error()})
		}

		if strings.Contains(errMsg, "tidak ditemukan") {
			return helpers.Response(c, http.StatusNotFound, []string{err.Error()})
		}

		if strings.Contains(errMsg, "sudah terdaftar") || strings.Contains(errMsg, "sudah digunakan") || strings.Contains(errMsg, "sudah memiliki akun") {
			return helpers.Response(c, http.StatusConflict, []string{err.Error()})
		}

		return helpers.Response(c, http.StatusInternalServerError, []string{"terjadi kesalahan pada server"})
	}

	return helpers.StandardResponse(
		c,
		http.StatusOK,
		[]string{"data keluarga lengkap berhasil dibuat"},
		result,
		nil,
	)
}
