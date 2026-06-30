mkdir -p cmd/api

cat > cmd/api/main.go << 'EOF'
package main

import (
	"log"
	"GitHubAlves150/cannacare-app-V2/cannacare/internal/config"
	"GitHubAlves150/cannacare-app-V2/cannacare/internal/infrastructure/database"

	"github.com/joho/godotenv"
)

func main() {
	// 1. Tenta carregar o arquivo .env para a memória do computador
	if err := godotenv.Load(); err != nil {
		log.Println("Aviso: Arquivo .env não encontrado, tentando usar variáveis do sistema.")
	}

	log.Println("Iniciando o sistema Cannacare V2...")

	// 2. Carrega as configurações estruturadas
	cfg := config.Load()
	
	// 3. Tenta ligar o banco de dados
	db := database.NewPostgresConnection(cfg.DBConn)
	
	// O 'defer' garante que, se o programa fechar ou der erro lá na frente, 
	// a conexão com o banco de dados será fechada com segurança, evitando vazamento de memória.
	defer db.Close()

	log.Println("🚀 O motor do Cannacare V2 está pronto para receber as rotas HTTP!")
}
EOF