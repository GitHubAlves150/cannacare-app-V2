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
