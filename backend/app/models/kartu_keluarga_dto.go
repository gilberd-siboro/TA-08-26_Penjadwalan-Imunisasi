package models

type AdminCreateKartuKeluargaRequest struct {
	NoKK string `json:"no_kk"`
}

type AdminCreateKartuKeluargaResponse struct {
	IDNoKK int64  `json:"id_no_kk"`
	NoKK   string `json:"no_kk"`
}
