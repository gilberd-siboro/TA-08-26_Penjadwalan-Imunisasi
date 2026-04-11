package repositories

import (
	"monitoring-service/pkg/config"

	"gorm.io/gorm"
)

type Main struct {
	postgres *gorm.DB
	config   *config.Config
}

type repository struct {
	Options Options
}

type Options struct {
	Postgres *gorm.DB
	Config   *config.Config
}

func Init(opts Options) *Main {
	m := &Main{
		postgres: opts.Postgres,
		config:   opts.Config,
	}

	return m
}
