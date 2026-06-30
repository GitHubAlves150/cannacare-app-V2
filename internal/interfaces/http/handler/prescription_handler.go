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
