package association

import (
	"errors"
	"time"
)

// Definição de erros de negócio que podem acontecer na validação
var (
	ErrNameEmpty = errors.New("o nome da associação não pode ser vazio")
	ErrCNPJEmpty = errors.New("o CNPJ da associação não pode ser vazio")
)

// Association representa a estrutura pura de uma associação cliente no sistema
type Association struct {
	ID        string    `json:"id"`
	Name      string    `json:"name"`
	CNPJ      string    `json:"cnpj"`
	Status    string    `json:"status"` // active, suspended, pending
	CreatedAt time.Time `json:"created_at"`
	UpdatedAt time.Time `json:"updated_at"`
}

// Repository dita o contrato de quais operações o banco de dados deve aceitar.
// Qualquer banco que implementarmos no futuro precisará cumprir esses métodos.
type Repository interface {
	Create(assoc *Association) error
	FindByID(id string) (*Association, error)
	FindByCNPJ(cnpj string) (*Association, error)
}

// NewAssociation é uma função fábrica. Ela garante que nenhuma associação
// seja criada no sistema com dados errados ou inválidos.
func NewAssociation(name, cnpj string) (*Association, error) {
	if name == "" {
		return nil, ErrNameEmpty
	}
	if cnpj == "" {
		return nil, ErrCNPJEmpty
	}

	return &Association{
		Name:      name,
		CNPJ:      cnpj,
		Status:    "active", // Toda associação nova começa ativa por padrão
		CreatedAt: time.Now(),
		UpdatedAt: time.Now(),
	}, nil
}
