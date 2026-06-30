package route

import (
	"GitHubAlves150/cannacare-app-V2/cannacare/internal/interfaces/http/handler"
	"github.com/gin-gonic/gin"
)

func RegisterPatientRoutes(r *gin.Engine, h *handler.PatientHandler) {
	r.POST("/patients", h.CreatePatient)
}
