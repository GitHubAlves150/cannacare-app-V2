package route

import (
	"GitHubAlves150/cannacare-app-V2/cannacare/internal/interfaces/http/handler"
	"github.com/gin-gonic/gin"
)

func RegisterPrescriptionRoutes(r *gin.Engine, h *handler.PrescriptionHandler) {
	r.POST("/prescriptions", h.CreatePrescription)
}
