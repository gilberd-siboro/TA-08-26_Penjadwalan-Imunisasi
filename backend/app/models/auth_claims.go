package models

import "github.com/golang-jwt/jwt/v5"

type AuthClaims struct {
	IDPengguna   int64  `json:"id_pengguna"`
	IDRole       int64  `json:"id_role"`
	IDNoKK       *int64 `json:"id_no_kk,omitempty"`
	Role         string `json:"role"`
	NomorTelepon string `json:"nomor_telepon"`
	jwt.RegisteredClaims
}

func (a AuthClaims) IsAparatDesa() bool {
	return a.Role == RoleNameAparatDesa
}
