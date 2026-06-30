# 1. Cria o Handler de Prescrições
cat > internal/interfaces/http/handler/prescription_handler.go << 'EOF'
package handler

import (
	"net/http"
	"GitHubAlves150/cannacare-app-V2/cannacare/internal/application/usecase"
	"github.com/gin-gonic/gin"
)

type PrescriptionHandler struct {
	useCase *usecase.CreatePrescriptionUseCase
}

func NewPrescriptionHandler(useCase *usecase.CreatePrescriptionUseCase) *PrescriptionHandler {
	return &PrescriptionHandler{useCase: useCase}
}

func (h *PrescriptionHandler) CreatePrescription(c *gin.Context) {
	var input usecase.CreatePrescriptionInput

	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "JSON inválido: " + err.Error()})
		return
	}

	output, err := h.useCase.Execute(input)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusCreated, output)
}
EOF

# 2. Cria as rotas do módulo de prescrições
cat > internal/interfaces/http/route/prescription_routes.go << 'EOF'
package route

import (
	"GitHubAlves150/cannacare-app-V2/cannacare/internal/interfaces/http/handler"
	"github.com/gin-gonic/gin"
)

func RegisterPrescriptionRoutes(r *gin.Engine, h *handler.PrescriptionHandler) {
	r.POST("/prescriptions", h.CreatePrescription)
}
EOF