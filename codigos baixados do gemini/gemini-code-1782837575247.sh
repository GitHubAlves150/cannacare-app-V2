# 1. Cria o Handler que traduz as requisições de pacientes
cat > internal/interfaces/http/handler/patient_handler.go << 'EOF'
package handler

import (
	"net/http"
	"GitHubAlves150/cannacare-app-V2/cannacare/internal/application/usecase"
	"github.com/gin-gonic/gin"
)

type PatientHandler struct {
	createUseCase *usecase.CreatePatientUseCase
}

func NewPatientHandler(createUseCase *usecase.CreatePatientUseCase) *PatientHandler {
	return &PatientHandler{createUseCase: createUseCase}
}

func (h *PatientHandler) CreatePatient(c *gin.Context) {
	var input usecase.CreatePatientInput

	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "JSON inválido: " + err.Error()})
		return
	}

	output, err := h.createUseCase.Execute(input)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusCreated, output)
}
EOF

# 2. Cria as rotas do módulo de pacientes
cat > internal/interfaces/http/route/patient_routes.go << 'EOF'
package route

import (
	"GitHubAlves150/cannacare-app-V2/cannacare/internal/interfaces/http/handler"
	"github.com/gin-gonic/gin"
)

func RegisterPatientRoutes(r *gin.Engine, h *handler.PatientHandler) {
	r.POST("/patients", h.CreatePatient)
}
EOF