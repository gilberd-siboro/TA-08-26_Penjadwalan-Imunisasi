package usecases

import (
	"errors"
	"strconv"
	"strings"
	"time"

	"monitoring-service/app/models"
	"monitoring-service/app/repositories"

	"github.com/golang-jwt/jwt/v5"
	"golang.org/x/crypto/bcrypt"
)

func (m *Main) Login(req models.LoginRequest) (*models.LoginResponse, error) {
	req.NomorTelepon = strings.TrimSpace(req.NomorTelepon)
	req.KataSandi = strings.TrimSpace(req.KataSandi)

	if req.NomorTelepon == "" || req.KataSandi == "" {
		return nil, errors.New("nomor_telepon dan kata_sandi wajib diisi")
	}
	if err := validateNomorTeleponIndonesia(req.NomorTelepon); err != nil {
		return nil, err
	}

	pengguna, err := m.repository.FindPenggunaByNomorTelepon(req.NomorTelepon)
	if err != nil {
		if repositories.IsNotFound(err) {
			return nil, errors.New("nomor telepon atau kata sandi salah")
		}
		return nil, err
	}

	// Compare hash bcrypt dari DB dengan password input
	if err := bcrypt.CompareHashAndPassword([]byte(pengguna.KataSandi), []byte(req.KataSandi)); err != nil {
		return nil, errors.New("nomor telepon atau kata sandi salah")
	}

	roleName := pengguna.Role.NamaRole
	if roleName == "" {
		roleName = "unknown"
	}

	token, err := m.generateAccessToken(pengguna.IDPengguna, pengguna.IDRole, pengguna.IDNoKK, roleName, pengguna.NomorTelepon)
	if err != nil {
		return nil, err
	}

	return &models.LoginResponse{
		Token:               token,
		Role:                roleName,
		WajibGantiKataSandi: req.KataSandi == m.generateDefaultPassword(),
	}, nil
}

func (m *Main) Logout(actor models.AuthClaims) error {
	if actor.IDPengguna <= 0 {
		return errors.New("id_pengguna tidak valid")
	}

	// JWT saat ini stateless, jadi logout pada sisi backend cukup dianggap valid
	// setelah token terverifikasi oleh middleware. Frontend tetap perlu hapus token lokal.
	return nil
}

func (m *Main) ChangePassword(actor models.AuthClaims, req models.ChangePasswordRequest) (*models.ChangePasswordResponse, error) {
	if actor.IDPengguna <= 0 {
		return nil, errors.New("id_pengguna tidak valid")
	}

	req.KataSandiLama = strings.TrimSpace(req.KataSandiLama)
	req.KataSandiBaru = strings.TrimSpace(req.KataSandiBaru)
	req.KonfirmasiKataSandiBaru = strings.TrimSpace(req.KonfirmasiKataSandiBaru)

	if req.KataSandiLama == "" || req.KataSandiBaru == "" || req.KonfirmasiKataSandiBaru == "" {
		return nil, errors.New("kata_sandi_lama, kata_sandi_baru, dan konfirmasi_kata_sandi_baru wajib diisi")
	}
	if req.KataSandiBaru != req.KonfirmasiKataSandiBaru {
		return nil, errors.New("konfirmasi kata sandi baru tidak sama")
	}
	if req.KataSandiLama == req.KataSandiBaru {
		return nil, errors.New("kata sandi baru harus berbeda dari kata sandi lama")
	}
	if len(req.KataSandiBaru) < 8 {
		return nil, errors.New("kata sandi baru minimal 8 karakter")
	}
	if req.KataSandiBaru == m.generateDefaultPassword() {
		return nil, errors.New("kata sandi baru tidak boleh sama dengan kata sandi default")
	}

	pengguna, err := m.repository.FindPenggunaByID(actor.IDPengguna)
	if err != nil {
		if repositories.IsNotFound(err) {
			return nil, errors.New("pengguna tidak ditemukan")
		}
		return nil, err
	}

	if err := bcrypt.CompareHashAndPassword([]byte(pengguna.KataSandi), []byte(req.KataSandiLama)); err != nil {
		return nil, errors.New("kata sandi lama salah")
	}

	hashBaru, err := bcrypt.GenerateFromPassword([]byte(req.KataSandiBaru), bcrypt.DefaultCost)
	if err != nil {
		return nil, err
	}

	if err := m.repository.UpdateKataSandiPengguna(actor.IDPengguna, string(hashBaru)); err != nil {
		if repositories.IsNotFound(err) {
			return nil, errors.New("pengguna tidak ditemukan")
		}
		return nil, err
	}

	return &models.ChangePasswordResponse{IDPengguna: actor.IDPengguna}, nil
}

func (m *Main) generateAccessToken(idPengguna, idRole int64, idNoKK *int64, roleName, nomorTelepon string) (string, error) {
	secret := strings.TrimSpace(m.config.JWTSecret)
	if secret == "" {
		return "", errors.New("jwt secret belum dikonfigurasi")
	}

	now := time.Now()
	expiredAt := now.Add(time.Duration(m.config.JWTAccessTokenMins) * time.Minute)

	claims := models.AuthClaims{
		IDPengguna:   idPengguna,
		IDRole:       idRole,
		IDNoKK:       idNoKK,
		Role:         roleName,
		NomorTelepon: nomorTelepon,
		RegisteredClaims: jwt.RegisteredClaims{
			Subject:   strconv.FormatInt(idPengguna, 10),
			Issuer:    "monitoring-service",
			IssuedAt:  jwt.NewNumericDate(now),
			NotBefore: jwt.NewNumericDate(now),
			ExpiresAt: jwt.NewNumericDate(expiredAt),
		},
	}

	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	return token.SignedString([]byte(secret))
}

func (m *Main) AdminCreatePengguna(actor models.AuthClaims, req models.AdminCreatePenggunaRequest) (*models.AdminCreatePenggunaResponse, error) {
	if !actor.IsAparatDesa() {
		return nil, errors.New("hanya aparat_desa yang boleh membuat akun pengguna")
	}

	if req.IDPenduduk <= 0 {
		return nil, errors.New("id_penduduk tidak valid")
	}
	if req.IDRole <= 0 {
		return nil, errors.New("id_role tidak valid")
	}

	penduduk, err := m.repository.GetPendudukByID(req.IDPenduduk)
	if err != nil {
		if repositories.IsRecordNotFound(err) {
			return nil, errors.New("penduduk tidak ditemukan")
		}
		return nil, err
	}

	if penduduk.IDNoKK == nil || *penduduk.IDNoKK <= 0 {
		return nil, errors.New("id_no_kk pada data penduduk belum tersedia")
	}

	nomorTelepon := strings.TrimSpace(penduduk.NomorTelepon)
	if nomorTelepon == "" {
		return nil, errors.New("nomor_telepon pada data penduduk belum tersedia")
	}
	if err := validateNomorTeleponIndonesia(nomorTelepon); err != nil {
		return nil, err
	}

	idNoKK := *penduduk.IDNoKK

	kkExists, err := m.repository.IsKartuKeluargaExists(idNoKK)
	if err != nil {
		return nil, err
	}
	if !kkExists {
		return nil, errors.New("kartu_keluarga tidak ditemukan")
	}

	kkData, err := m.repository.GetKartuKeluargaByID(idNoKK)
	if err != nil {
		if repositories.IsRecordNotFound(err) {
			return nil, errors.New("kartu_keluarga tidak ditemukan")
		}
		return nil, err
	}

	sudahPunyaAkun, err := m.repository.IsPenggunaByKKExists(idNoKK)
	if err != nil {
		return nil, err
	}
	if sudahPunyaAkun {
		return nil, errors.New("kartu keluarga sudah memiliki akun")
	}

	nomorSudahDipakai, err := m.repository.IsNomorTeleponExists(nomorTelepon)
	if err != nil {
		return nil, err
	}
	if nomorSudahDipakai {
		return nil, errors.New("nomor telepon sudah digunakan")
	}

	passwordDefault := m.generateDefaultPassword()
	passwordHash, err := bcrypt.GenerateFromPassword([]byte(passwordDefault), bcrypt.DefaultCost)
	if err != nil {
		return nil, err
	}

	entity := &models.Pengguna{
		IDPenduduk:   &req.IDPenduduk,
		IDNoKK:       &idNoKK,
		NomorTelepon: nomorTelepon,
		KataSandi:    string(passwordHash),
		IDRole:       req.IDRole,
	}

	if err := m.repository.CreatePengguna(entity); err != nil {
		return nil, err
	}

	return &models.AdminCreatePenggunaResponse{
		IDPengguna:      entity.IDPengguna,
		IDPenduduk:      entity.IDPenduduk,
		NamaPenduduk:    penduduk.NamaLengkap,
		IDNoKK:          idNoKK,
		NoKK:            kkData.NoKK,
		NomorTelepon:    entity.NomorTelepon,
		PasswordDefault: passwordDefault,
	}, nil
}

func (m *Main) ProfileKeluarga(actor models.AuthClaims) (*models.ProfileKeluargaResponse, error) {
	if actor.IDNoKK == nil || *actor.IDNoKK <= 0 {
		return nil, errors.New("akun ini tidak terhubung ke kartu_keluarga")
	}

	anggota, err := m.repository.GetAnggotaKeluargaByKK(*actor.IDNoKK)
	if err != nil {
		return nil, err
	}

	items := make([]models.KeluargaAnggotaResponse, 0, len(anggota))
	for _, v := range anggota {
		tanggalLahir := formatTanggalLahir(v.TanggalLahir)

		items = append(items, models.KeluargaAnggotaResponse{
			IDPenduduk:        v.IDPenduduk,
			NIK:               v.NIK,
			NamaLengkap:       v.NamaLengkap,
			JenisKelamin:      v.JenisKelamin,
			TanggalLahir:      tanggalLahir,
			KedudukanKeluarga: v.KedudukanKeluarga,
		})
	}

	return &models.ProfileKeluargaResponse{
		IDPengguna:      actor.IDPengguna,
		IDNoKK:          *actor.IDNoKK,
		NomorTelepon:    actor.NomorTelepon,
		Role:            actor.Role,
		AnggotaKeluarga: items,
	}, nil
}

func (m *Main) generateDefaultPassword() string {
	return "huta_mejan123"
}

func formatTanggalLahir(tanggal *time.Time) string {
	if tanggal == nil {
		return ""
	}

	return tanggal.Format("02-01-2006")
}
