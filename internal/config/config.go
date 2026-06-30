package config

import (
	"os"
)

type Config struct {
	Port   string
	DBConn string
}

// Load vai ler as variáveis que estão no ambiente e organizar para o nosso sistema
func Load() *Config {
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080" // Se não tiver porta no .env, usa a 8080 por padrão
	}

	// Buscando os dados do banco que escrevemos no .env
	dbHost := os.Getenv("DB_HOST")
	dbPort := os.Getenv("DB_PORT")
	dbUser := os.Getenv("DB_USER")
	dbPass := os.Getenv("DB_PASSWORD")
	dbName := os.Getenv("DB_NAME")
	dbSSL  := os.Getenv("DB_SSLMODE")

	// Montando a String de Conexão (o endereço completo que o Go usa para achar o banco)
	dbConn := "host=" + dbHost + " port=" + dbPort + " user=" + dbUser + " password=" + dbPass + " dbname=" + dbName + " sslmode=" + dbSSL

	return &Config{
		Port:   port,
		DBConn: dbConn,
	}
}
