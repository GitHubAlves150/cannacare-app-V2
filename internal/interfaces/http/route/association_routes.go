package route

import (
	"GitHubAlves150/cannacare-app-V2/cannacare/internal/interfaces/http/handler"
	"github.com/gin-gonic/gin"
)

// RegisterAssociationRoutes define quais caminhos de URL pertencem a esse módulo
func RegisterAssociationRoutes(r *gin.Engine, h *handler.AssociationHandler) {
	r.POST("/associations", h.CreateAssociation)
}
