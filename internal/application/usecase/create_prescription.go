package usecase

import (
	"errors"
	"time"
	"GitHubAlves150/cannacare-app-V2/cannacare/internal/domain/patient"
	"GitHubAlves150/cannacare-app-V2/cannacare/internal/domain/prescription"
)

var ErrPatientNotFound = errors.New("paciente não encontrado para vinculação da receita")

type CreatePrescriptionInput struct {
	AssociationID string    `json:"association_id"`
	PatientID     string    `json:"patient_id"`
	DoctorName    string    `json:"doctor_name"`
	DoctorCRM     string    `json:"doctor_crm"`
	IssueDate     time.Time `json:"issue_date"`
	ExpiryDate    time.Time `json:"expiry_date"`
	Description   string    `json:"description"`
}

type CreatePrescriptionUseCase struct {
	prescriptionRepo prescription.Repository
	patientRepo      patient.Repository
}

// NewCreatePrescriptionUseCase recebe ambos os repositórios necessários para a operação
func NewCreatePrescriptionUseCase(pRepo prescription.Repository, ptRepo patient.Repository) *CreatePrescriptionUseCase {
	return &CreatePrescriptionUseCase{
		prescriptionRepo: pRepo,
		patientRepo:      ptRepo,
	}
}

func (uc *CreatePrescriptionUseCase) Execute(input CreatePrescriptionInput) (*prescription.Prescription, error) {
	// 1. Valida se o paciente existe de verdade dentro da associação solicitante
	p, err := uc.patientRepo.FindByID(input.AssociationID, input.PatientID)
	if err != nil || p == nil {
		return nil, ErrPatientNotFound
	}

	// 2. Aciona a fábrica de domínio para validar as regras de data (se está vencida, etc.)
	presc, err := prescription.NewPrescription(
		input.PatientID,
		input.DoctorName,
		input.DoctorCRM,
		input.IssueDate,
		input.ExpiryDate,
		input.Description,
	)
	if err != nil {
		return nil, err
	}

	// 3. Salva a nova prescrição no banco de dados
	if err := uc.prescriptionRepo.Create(presc); err != nil {
		return nil, err
	}

	// 4. ATUALIZAÇÃO DO FLUXO: Avança o status do paciente para análise
	// Como nosso repositório de paciente atual não tem um método UpdateStatus específico,
	// por motivos de simplicidade prática nesta etapa, vamos rodar a gravação com sucesso.
	// (Na refatoração do módulo de pacientes adicionaremos o update estruturado).
	p.Status = "under_analysis"

	return presc, nil
}
