package controllers

import (
	"net/http"
	"strings"

	"monitoring-service/app/helpers"
	"monitoring-service/app/models"

	"github.com/labstack/echo/v4"
)

func (m *Main) Login(c echo.Context) error {
	var req models.LoginRequest
	if err := c.Bind(&req); err != nil {
		return helpers.Response(c, http.StatusBadRequest, []string{"format request tidak valid"})
	}

	result, err := m.usecases.Login(req)
	if err != nil {
		errMsg := strings.ToLower(err.Error())

		// Khusus kredensial salah -> Unauthorized
		if strings.Contains(errMsg, "nomor telepon atau kata sandi salah") {
			return helpers.Response(c, http.StatusUnauthorized, []string{err.Error()})
		}

		// Validasi input -> BadRequest
		if strings.Contains(errMsg, "wajib diisi") || strings.Contains(errMsg, "tidak valid") {
			return helpers.Response(c, http.StatusBadRequest, []string{err.Error()})
		}

		// Error lain -> InternalServerError
		return helpers.Response(c, http.StatusInternalServerError, []string{"terjadi kesalahan pada server"})
	}

	return helpers.StandardResponse(
		c,
		http.StatusOK,
		[]string{"login berhasil"},
		result,
		nil,
	)
}

func (m *Main) ProfileKeluarga(c echo.Context) error {
	rawClaims := c.Get("auth_claims")
	claims, ok := rawClaims.(*models.AuthClaims)
	if !ok || claims == nil {
		return helpers.Response(c, http.StatusUnauthorized, []string{"claims token tidak valid"})
	}

	result, err := m.usecases.ProfileKeluarga(*claims)
	if err != nil {
		errMsg := strings.ToLower(err.Error())

		if strings.Contains(errMsg, "tidak terhubung ke kartu_keluarga") {
			return helpers.Response(c, http.StatusBadRequest, []string{err.Error()})
		}

		return helpers.Response(c, http.StatusInternalServerError, []string{"terjadi kesalahan pada server"})
	}

	return helpers.StandardResponse(
		c,
		http.StatusOK,
		[]string{"profil keluarga berhasil diambil"},
		result,
		nil,
	)
}
