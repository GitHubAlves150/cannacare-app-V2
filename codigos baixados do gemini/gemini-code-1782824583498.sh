# Cria as pastas necessárias dentro da estrutura internal/
mkdir -p internal/config
mkdir -p internal/infrastructure/database

# Cria o arquivo que lê as configurações do .env
cat > internal/config/config.go << 'EOF'
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
EOF

# Cria o arquivo que faz a conexão com o PostgreSQL de fato
cat > internal/infrastructure/database/postgres.go << 'EOF'
package database

import (
	"database/sql"
	"log"
	"time"

	_ "github.com/lib/pq" // O '_' diz ao Go para carregar o driver do Postgres em segundo plano
)

// NewPostgresConnection tenta abrir o canal de comunicação com o banco de dados
func NewPostgresConnection(dataSourceName string) *sql.DB {
	// sql.Open apenas prepara a estrutura de conexão, ela não testa se a senha está certa ainda
	db, err := sql.Open("postgres", dataSourceName)
	if err != nil {
		log.Fatalf("Erro crítico ao configurar o banco: %v", err)
	}

	// CONFIGURAÇÕES DE ESCALABILIDADE (Pool de Conexões)
	// Isso impede que o banco trave quando centenas de associações usarem o sistema ao mesmo tempo
	db.SetMaxOpenConns(25)                 // Limite de conexões abertas simultaneamente
	db.SetMaxIdleConns(5)                  // Quantas conexões ficam "em espera" ociosas
	db.SetConnMaxLifetime(5 * time.Minute) // Tempo de vida de cada conexão antes de ser renovada

	// db.Ping() é o teste real! Ele vai lá no Docker e tenta conversar com o banco
	if err := db.Ping(); err != nil {
		log.Fatalf("Erro: O Go não conseguiu se conectar ao PostgreSQL no Docker. Detalhe: %v", err)
	}

	log.Println("🎉 Sucesso: Conexão com o PostgreSQL estabelecida de forma segura!")
	return db
}
EOF