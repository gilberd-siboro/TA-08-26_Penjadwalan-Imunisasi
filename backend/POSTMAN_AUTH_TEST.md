# Auth API Test Guide (Postman)
## 1. Persiapan

1. Pastikan `.env` sudah terisi koneksi DB Supabase.
2. Jalankan service dari folder `backend/monolith/go-template-main`:

```bash
go run cmd/main.go
```

3. Base URL:

```text
http://localhost:8080
```

## 2. Endpoint yang bisa dites

- `GET /health`
- `POST /auth/register`
- `POST /auth/login`
- `GET /auth/me` (harus pakai Bearer token)

## 3. Health check

Request:

- Method: `GET`
- URL: `http://localhost:8080/health`

Expected:

```json
{
  "status": "ok"
}
```

## 4. Register

Request:

- Method: `POST`
- URL: `http://localhost:8080/auth/register`
- Headers: `Content-Type: application/json`
- Body:

```json
{
  "name": "Dokter Satu",
  "email": "dokter1@example.com",
  "phone_number": "081234567890",
  "password": "password123",
  "role_name": "Dokter"
}
```

Catatan `phone_number`:

- Bisa `0812...`, `62812...`, atau `+62812...`
- Akan dinormalisasi menjadi `+62...`

Role valid:

- `Tenaga-kesehatan`
- `Dokter`
- `Kader`
- `Bidan`
- `Orangtua`

Expected (`201`):

```json
{
  "status_code": 201,
  "message": ["Success"],
  "data": {
    "message": "registrasi berhasil"
  }
}
```

## 5. Login

Request:

- Method: `POST`
- URL: `http://localhost:8080/auth/login`
- Headers: `Content-Type: application/json`
- Body (identifier bisa email atau nomor hp):

```json
{
  "identifier": "dokter1@example.com",
  "password": "password123"
}
```

Contoh login pakai nomor HP:

```json
{
  "identifier": "081234567890",
  "password": "password123"
}
```

Expected (`200`):

```json
{
  "status_code": 200,
  "message": ["Success"],
  "data": {
    "access_token": "<jwt-token>",
    "token_type": "Bearer",
    "expires_in": 3600,
    "user_id": 1,
    "name": "Dokter Satu",
    "email": "dokter1@example.com",
    "phone_number": "+6281234567890",
    "role": "Dokter",
    "target_app": "website",
    "redirect_route": "/dashboard/dokter"
  }
}
```

## 6. Endpoint protected `/auth/me`

Request:

- Method: `GET`
- URL: `http://localhost:8080/auth/me`
- Headers:

```text
Authorization: Bearer <access_token_dari_login>
```

Expected (`200`):

```json
{
  "status_code": 200,
  "message": ["Success"],
  "data": {
    "user_id": 1,
    "email": "dokter1@example.com",
    "phone_number": "+6281234567890",
    "role": "Dokter",
    "target_app": "website",
    "redirect_route": "/dashboard/dokter"
  }
}
```

