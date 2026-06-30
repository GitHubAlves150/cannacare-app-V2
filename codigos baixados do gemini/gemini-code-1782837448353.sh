cat > internal/application/usecase/create_patient.go << 'EOF'
package usecase

import (
	"errors"
	"time"
	"GitHubAlves150/cannacare-app-V2/cannacare/internal/domain/patient"
)

var ErrPatientEmailAlreadyExists = errors.New("um paciente com este e-mail já está cadastrado nesta associação")

// CreatePatientInput define todos os dados que o formulário da secretaria vai enviar
type CreatePatientInput struct {
	AssociationID string    `json:"association_id"`
	Name          string    `json:"name"`
	BirthDate     time.Time `json:"birth_date"`
	Gender        string    `json:"gender"`
	Phone         string    `json:"phone"`
	Email         string    `json:"email"`
	Address       string    `json:"address"`
	CreatedBy     string    `json:"created_by"`
}

type CreatePatientUseCase struct {
	repo patient.Repository
}

func NewCreatePatientUseCase(repo patient.Repository) *CreatePatientUseCase {
	return &CreatePatientUseCase{repo: repo}
}

// Execute orquestra a validação e a inserção do paciente
func (uc *CreatePatientUseCase) Execute(input CreatePatientInput) (*patient.Patient, error) {
	// 1. Regra Multi-Tenant: Verifica se o e-mail já existe DENTRO da mesma associação
	existing, err := uc.repo.FindByEmail(input.AssociationID, input.Email)
	if err != nil {
		return nil, err
	}
	if existing != nil {
		return nil, ErrPatientEmailAlreadyExists
	}

	// 2. Aciona a fábrica do domínio (onde rodam as validações de campos obrigatórios)
	p, err := patient.NewPatient(
		input.AssociationID,
		input.Name,
		input.BirthDate,
		input.Gender,
		input.Phone,
		input.Email,
		input.Address,
		input.CreatedBy,
	)
	if err != nil {
		return nil, err
	}

	// 3. Manda o repositório persistir no PostgreSQL
	if err := uc.repo.Create(p); err != nil {
		return nil, err
	}

	return p, nil
}
EOF