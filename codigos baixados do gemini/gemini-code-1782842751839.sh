# 1. Cria a pasta do domínio do produto
mkdir -p internal/domain/product

# 2. Cria a entidade e as regras de negócio de estoque
cat > internal/domain/product/entity.go << 'EOF'
package product

import (
	"errors"
	"time"
)

// Definição de erros de negócio para o estoque
var (
	ErrProductNameEmpty     = errors.New("o nome do produto é obrigatório")
	ErrInsufficientStock    = errors.New("saldo insuficiente em estoque para realizar a dispensação")
	ErrInvalidQuantity      = errors.New("a quantidade informada deve ser maior que zero")
	ErrInvalidPrice         = errors.New("o preço do produto deve ser maior que zero")
)

// Product representa um medicamento ou item no estoque da associação
type Product struct {
	ID            string    `json:"id"`
	AssociationID string    `json:"association_id"`
	Name          string    `json:"name"`
	Description   string    `json:"description"`
	Quantity      int       `json:"quantity"`
	PriceCents    int       `json:"price_cents"` // Preço armazenado em centavos (ex: R$ 100,50 vira 10050)
	CreatedAt     time.Time `json:"created_at"`
	UpdatedAt     time.Time `json:"updated_at"`
}

// Repository dita as operações de banco de dados para os produtos
type Repository interface {
	Create(p *Product) error
	FindByID(associationID, id string) (*Product, error)
	UpdateStock(associationID, id string, newQuantity int) error
}

// NewProduct cria uma nova instância de produto validando os dados iniciais
func NewProduct(associationID, name, description string, quantity, priceCents int) (*Product, error) {
	if name == "" {
		return nil, ErrProductNameEmpty
	}
	if quantity < 0 {
		return nil, errors.New("a quantidade inicial não pode ser negativa")
	}
	if priceCents <= 0 {
		return nil, ErrInvalidPrice
	}

	return &Product{
		AssociationID: associationID,
		Name:          name,
		Description:   description,
		Quantity:      quantity,
		PriceCents:    priceCents,
		CreatedAt:     time.Now(),
		UpdatedAt:     time.Now(),
	}, nil
}

// RemoveStock valida a regra de ouro: só subtrai se houver saldo suficiente
func (p *Product) RemoveStock(qty int) error {
	if qty <= 0 {
		return ErrInvalidQuantity
	}
	if p.Quantity < qty {
		return ErrInsufficientStock
	}
	p.Quantity -= qty
	p.UpdatedAt = time.Now()
	return nil
}

// AddStock incrementa novas unidades ao estoque atual
func (p *Product) AddStock(qty int) error {
	if qty <= 0 {
		return ErrInvalidQuantity
	}
	p.Quantity += qty
	p.UpdatedAt = time.Now()
	return nil
}
EOF