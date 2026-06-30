package prescription

import (
	"errors"
	"time"
)

// Definição de erros de domínio
var (
	ErrDoctorNameEmpty   = errors.New("o nome do médico é obrigatório")
	ErrDoctorCRMMissing  = errors.New("o CRM do médico é obrigatório")
	ErrPrescriptionExpired = errors.New("não é possível cadastrar uma receita com data de validade vencida")
	ErrInvalidExpiryDate   = errors.New("a data de validade deve ser posterior à data de emissão")
)

// Prescription representa o documento médico que autoriza o tratamento do paciente
type Prescription struct {
	ID         string    `json:"id"`
	PatientID  string    `json:"patient_id"`
	DoctorName string    `json:"doctor_name"`
	DoctorCRM  string    `json:"doctor_crm"`
	IssueDate  time.Time `json:"issue_date"`
	ExpiryDate time.Time `json:"expiry_date"`
	Description string   `json:"description"`
	CreatedAt  time.Time `json:"created_at"`
	UpdatedAt  time.Time `json:"updated_at"`
}

// Repository dita as regras de persistência das receitas
type Repository interface {
	Create(p *Prescription) error
	FindByPatientID(patientID string) ([]*Prescription, error)
}

// NewPrescription valida os prazos e cria uma nova entidade estruturada
func NewPrescription(patientID, doctorName, doctorCRM string, issueDate, expiryDate time.Time, description string) (*Prescription, error) {
	if doctorName == "" {
		return nil, ErrDoctorNameEmpty
	}
	if doctorCRM == "" {
		return nil, ErrDoctorCRMMissing
	}
	if expiryDate.Before(issueDate) {
		return nil, ErrInvalidExpiryDate
	}
	// Validação de segurança: a receita não pode expirar antes do momento atual (hoje)
	if expiryDate.Before(time.Now()) {
		return nil, ErrPrescriptionExpired
	}

	return &Prescription{
		PatientID:   patientID,
		DoctorName:  doctorName,
		DoctorCRM:   doctorCRM,
		IssueDate:   issueDate,
		ExpiryDate:  expiryDate,
		Description: description,
		CreatedAt:   time.Now(),
		UpdatedAt:   time.Now(),
	}, nil
}
