package models

type LoginRequest struct {
	NomorTelepon string `json:"nomor_telepon"`
	KataSandi    string `json:"kata_sandi"`
}

type LoginResponse struct {
	Token               string `json:"token"`
	Role                string `json:"role"`
	WajibGantiKataSandi bool   `json:"wajib_ganti_kata_sandi"`
}

type ChangePasswordRequest struct {
	KataSandiLama           string `json:"kata_sandi_lama"`
	KataSandiBaru           string `json:"kata_sandi_baru"`
	KonfirmasiKataSandiBaru string `json:"konfirmasi_kata_sandi_baru"`
}

type ChangePasswordResponse struct {
	IDPengguna int64 `json:"id_pengguna"`
}

type AdminCreatePenggunaRequest struct {
	IDPenduduk int64 `json:"id_penduduk"`
	IDRole     int64 `json:"id_role"`
}

type AdminCreatePenggunaResponse struct {
	IDPengguna      int64  `json:"id_pengguna"`
	IDPenduduk      *int64 `json:"id_penduduk,omitempty"`
	NamaPenduduk    string `json:"nama_penduduk"`
	IDNoKK          int64  `json:"id_no_kk"`
	NoKK            string `json:"no_kk"`
	NomorTelepon    string `json:"nomor_telepon"`
	PasswordDefault string `json:"password_default"`
}

type KeluargaAnggotaResponse struct {
	IDPenduduk        int64  `json:"id_penduduk"`
	NIK               string `json:"nik"`
	NamaLengkap       string `json:"nama_lengkap"`
	JenisKelamin      string `json:"jenis_kelamin"`
	TanggalLahir      string `json:"tanggal_lahir,omitempty"`
	KedudukanKeluarga string `json:"kedudukan_keluarga"`
}

type ProfileKeluargaResponse struct {
	IDPengguna      int64                     `json:"id_pengguna"`
	IDNoKK          int64                     `json:"id_no_kk"`
	NomorTelepon    string                    `json:"nomor_telepon"`
	Role            string                    `json:"role"`
	AnggotaKeluarga []KeluargaAnggotaResponse `json:"anggota_keluarga"`
}
