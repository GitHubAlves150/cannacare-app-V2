# 1. Cria o Handler de Produtos
cat > internal/interfaces/http/handler/product_handler.go << 'EOF'
package handler

import (
	"net/http"
	"GitHubAlves150/cannacare-app-V2/cannacare/internal/application/usecase"
	"github.com/gin-gonic/gin"
)

type ProductHandler struct {
	createUseCase   *usecase.CreateProductUseCase
	dispenseUseCase *usecase.DispenseProductUseCase
}

func NewProductHandler(cUC *usecase.CreateProductUseCase, dUC *usecase.DispenseProductUseCase) *ProductHandler {
	return &ProductHandler{createUseCase: cUC, dispenseUseCase: dUC}
}

func (h *ProductHandler) CreateProduct(c *gin.Context) {
	var input usecase.CreateProductInput
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

func (h *ProductHandler) DispenseProduct(c *gin.Context) {
	var input usecase.DispenseProductInput
	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "JSON inválido: " + err.Error()})
		return
	}

	output, err := h.dispenseUseCase.Execute(input)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, output)
}
EOF

# 2. Cria as rotas do módulo de estoque
cat > internal/interfaces/http/route/product_routes.go << 'EOF'
package route

import (
	"GitHubAlves150/cannacare-app-V2/cannacare/internal/interfaces/http/handler"
	"github.com/gin-gonic/gin"
)

func RegisterProductRoutes(r *gin.Engine, h *handler.ProductHandler) {
	r.POST("/products", h.CreateProduct)
	r.POST("/products/dispense", h.DispenseProduct)
}
EOF