# 1. Cria o Caso de Uso para Cadastrar Produtos
cat > internal/application/usecase/create_product.go << 'EOF'
package usecase

import (
	"GitHubAlves150/cannacare-app-V2/cannacare/internal/domain/product"
)

type CreateProductInput struct {
	AssociationID string `json:"association_id"`
	Name          string `json:"name"`
	Description   string `json:"description"`
	Quantity      int    `json:"quantity"`
	PriceCents    int    `json:"price_cents"`
}

type CreateProductUseCase struct {
	repo product.Repository
}

func NewCreateProductUseCase(repo product.Repository) *CreateProductUseCase {
	return &CreateProductUseCase{repo: repo}
}

func (uc *CreateProductUseCase) Execute(input CreateProductInput) (*product.Product, error) {
	p, err := product.NewProduct(input.AssociationID, input.Name, input.Description, input.Quantity, input.PriceCents)
	if err != nil {
		return nil, err
	}

	if err := uc.repo.Create(p); err != nil {
		return nil, err
	}

	return p, nil
}
EOF

# 2. Cria o Caso de Uso para a Dispensação (Baixa de Estoque)
cat > internal/application/usecase/dispense_product.go << 'EOF'
package usecase

import (
	"GitHubAlves150/cannacare-app-V2/cannacare/internal/domain/product"
)

type DispenseProductInput struct {
	AssociationID string `json:"association_id"`
	ProductID     string `json:"product_id"`
	Quantity      int    `json:"quantity"`
}

type DispenseProductUseCase struct {
	repo product.Repository
}

func NewDispenseProductUseCase(repo product.Repository) *DispenseProductUseCase {
	return &DispenseProductUseCase{repo: repo}
}

func (uc *DispenseProductUseCase) Execute(input DispenseProductInput) (*product.Product, error) {
	// 1. Busca o produto garantindo o isolamento da associação
	p, err := uc.repo.FindByID(input.AssociationID, input.ProductID)
	if err != nil {
		return nil, err
	}

	// 2. Aplica a regra de negócio do domínio (subtrai e checa se há saldo)
	if err := p.RemoveStock(input.Quantity); err != nil {
		return nil, err
	}

	// 3. Atualiza apenas a nova quantidade no banco de dados
	if err := uc.repo.UpdateStock(p.AssociationID, p.ID, p.Quantity); err != nil {
		return nil, err
	}

	return p, nil
}
EOF