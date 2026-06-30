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
