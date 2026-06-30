package route

import (
	"GitHubAlves150/cannacare-app-V2/cannacare/internal/interfaces/http/handler"
	"github.com/gin-gonic/gin"
)

func RegisterProductRoutes(r *gin.Engine, h *handler.ProductHandler) {
	r.POST("/products", h.CreateProduct)
	r.POST("/products/dispense", h.DispenseProduct)
}
