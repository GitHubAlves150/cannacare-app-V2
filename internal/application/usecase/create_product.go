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
