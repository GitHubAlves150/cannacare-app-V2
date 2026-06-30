# 1. Cria a pasta do domínio do paciente
mkdir -p internal/domain/patient

# 2. Cria a entidade e a interface do repositório
cat > internal/domain/patient/entity.go << 'EOF'
package patient

import (
	"errors"
	"time"
)

// Definição de erros de negócio para validação de pacientes
var (
	ErrPatientNameEmpty = errors.New("o nome do paciente não pode ser vazio")
	ErrInvalidEmail     = errors.New("o e-mail informado para o paciente é inválido")
)

// Patient representa a estrutura pura de um paciente no coração do sistema
type Patient struct {
	ID            string    `json:"id"`
	AssociationID string    `json:"association_id"`
	Name          string    `json:"name"`
	BirthDate     time.Time `json:"birth_date"`
	Gender        string    `json:"gender"`
	Phone         string    `json:"phone"`
	Email         string    `json:"email"`
	Address       string    `json:"address"`
	Status        string    `json:"status"` // pending_documentation, under_analysis, approved, denied
	CreatedBy     string    `json:"created_by"`
	CreatedAt     time.Time `json:"created_at"`
	UpdatedAt     time.Time `json:"updated_at"`
}

// Repository dita quais operações o banco de dados deve realizar para o paciente
type Repository interface {
	Create(p *Patient) error
	FindByID(associationID, id string) (*Patient, error)
	FindByEmail(associationID, email string) (*Patient, error)
}

// NewPatient é a função fábrica que valida e cria um paciente com status inicial correto
func NewPatient(associationID, name string, birthDate time.Time, gender, phone, email, address, createdBy string) (*Patient, error) {
	if name == "" {
		return nil, ErrPatientNameEmpty
	}
	if email == "" {
		return nil, ErrInvalidEmail
	}

	return &Patient{
		AssociationID: associationID,
		Name:          name,
		BirthDate:     birthDate,
		Gender:        gender,
		Phone:         phone,
		Email:         email,
		Address:       address,
		Status:        "pending_documentation", // Inicia aguardando documentos conforme o fluxo do sistema
		CreatedBy:     createdBy,
		CreatedAt:     time.Now(),
		UpdatedAt:     time.Now(),
	}, nil
}
EOF