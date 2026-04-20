package routes

import (
	"monitoring-service/app/controllers"
	"monitoring-service/app/middlewares"

	"github.com/labstack/echo/v4"
)

func ConfigureRouter(e *echo.Echo, c *controllers.Main) {
	// Public endpoint
	e.POST("/login", c.Login)
	e.POST("/logout", c.Logout, middlewares.JWTAuth(c.JWTSecret()))
	e.GET("/profile/keluarga", c.ProfileKeluarga, middlewares.JWTAuth(c.JWTSecret()))

	// Protected endpoint (wajib JWT)
	e.POST("/keluarga/anak", c.KeluargaCreateAnak, middlewares.JWTAuth(c.JWTSecret()))

	adminGroup := e.Group("/admin", middlewares.JWTAuth(c.JWTSecret()))
	adminGroup.POST("/keluarga-lengkap", c.AdminCreateKeluargaLengkap)
}
