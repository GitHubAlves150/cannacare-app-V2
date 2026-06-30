package route

import (
	"GitHubAlves150/cannacare-app-V2/cannacare/internal/interfaces/http/handler"
	"github.com/gin-gonic/gin"
)

func RegisterUserRoutes(r *gin.Engine, h *handler.UserHandler) {
	r.POST("/users", h.CreateUser)
}
