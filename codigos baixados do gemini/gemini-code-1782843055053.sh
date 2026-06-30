cat > cmd/api/main.go << 'EOF'
package main

import (
	"log"
	"net/http"
	"GitHubAlves150/cannacare-app-V2/cannacare/internal/config"
	"GitHubAlves150/cannacare-app-V2/cannacare/internal/application/usecase"
	"GitHubAlves150/cannacare-app-V2/cannacare/internal/infrastructure/database"
	"GitHubAlves150/cannacare-app-V2/cannacare/internal/infrastructure/repository"
	"GitHubAlves150/cannacare-app-V2/cannacare/internal/interfaces/http/handler"
	"GitHubAlves150/cannacare-app-V2/cannacare/internal/interfaces/http/route"

	"github.com/gin-gonic/gin"
	"github.com/joho/godotenv"
)

func main() {
	if err := godotenv.Load(); err != nil {
		log.Println("Aviso: Arquivo .env não encontrado, usando variáveis de ambiente.")
	}

	log.Println("Iniciando o sistema Cannacare V2...")
	cfg := config.Load()
	
	db := database.NewPostgresConnection(cfg.DBConn)
	defer db.Close()

	r := gin.Default()

	r.GET("/health", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{"status": "up", "message": "Cannacare API V2 rodando perfeitamente"})
	})

	// Módulo Associação
	assocRepo := repository.NewAssociationRepositoryPostgres(db)
	assocUseCase := usecase.NewCreateAssociationUseCase(assocRepo)
	assocHandler := handler.NewAssociationHandler(assocUseCase)
	route.RegisterAssociationRoutes(r, assocHandler)

	// Módulo Usuário
	userRepo := repository.NewUserRepositoryPostgres(db)
	userUseCase := usecase.NewCreateUserUseCase(userRepo)
	userHandler := handler.NewUserHandler(userUseCase)
	route.RegisterUserRoutes(r, userHandler)

	// Módulo Paciente
	patientRepo := repository.NewPatientRepositoryPostgres(db)
	patientUseCase := usecase.NewCreatePatientUseCase(patientRepo)
	patientHandler := handler.NewPatientHandler(patientUseCase)
	route.RegisterPatientRoutes(r, patientHandler)

	// Módulo Prescrição
	prescriptionRepo := repository.NewPrescriptionRepositoryPostgres(db)
	prescriptionUseCase := usecase.NewCreatePrescriptionUseCase(prescriptionRepo, patientRepo)
	prescriptionHandler := handler.NewPrescriptionHandler(prescriptionUseCase)
	route.RegisterPrescriptionRoutes(r, prescriptionHandler)

	// Módulo Estoque/Produtos
	productRepo := repository.NewProductRepositoryPostgres(db)
	createProductUC := usecase.NewCreateProductUseCase(productRepo)
	dispenseProductUC := usecase.NewDispenseProductUseCase(productRepo)
	productHandler := handler.NewProductHandler(createProductUC, dispenseProductUC)
	route.RegisterProductRoutes(r, productHandler)

	log.Printf("Servidor rodando na porta %s...", cfg.Port)
	if err := r.Run(":" + cfg.Port); err != nil {
		log.Fatalf("Erro ao iniciar o servidor: %v", err)
	}
}
EOF