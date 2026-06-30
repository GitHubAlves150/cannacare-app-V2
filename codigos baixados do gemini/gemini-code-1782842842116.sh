cat > internal/infrastructure/repository/product_repository_postgres.go << 'EOF'
package repository

import (
	"database/sql"
	"errors"
	"time"
	"GitHubAlves150/cannacare-app-V2/cannacare/internal/domain/product"
)

type ProductRepositoryPostgres struct {
	db *sql.DB
}

func NewProductRepositoryPostgres(db *sql.DB) *ProductRepositoryPostgres {
	return &ProductRepositoryPostgres{db: db}
}

// Create insere um novo medicamento/óleo na tabela de produtos
func (r *ProductRepositoryPostgres) Create(p *product.Product) error {
	query := `
		INSERT INTO products (association_id, name, description, quantity, price_cents, created_at, updated_at)
		VALUES ($1, $2, $3, $4, $5, $6, $7)
		RETURNING id`

	err := r.db.QueryRow(
		query,
		p.AssociationID,
		p.Name,
		p.Description,
		p.Quantity,
		p.PriceCents,
		p.CreatedAt,
		p.UpdatedAt,
	).Scan(&p.ID)

	return err
}

// FindByID busca um produto garantindo o isolamento da associação (Multi-Tenant)
func (r *ProductRepositoryPostgres) FindByID(associationID, id string) (*product.Product, error) {
	query := `SELECT id, association_id, name, description, quantity, price_cents, created_at, updated_at 
	          FROM products WHERE association_id = $1 AND id = $2`

	row := r.db.QueryRow(query, associationID, id)

	var p product.Product
	err := row.Scan(&p.ID, &p.AssociationID, &p.Name, &p.Description, &p.Quantity, &p.PriceCents, &p.CreatedAt, &p.UpdatedAt)
	if err != nil {
		if errors.Is(err, sql.ErrNoRows) {
			return nil, errors.New("produto não encontrado nesta associação")
		}
		return nil, err
	}

	return &p, nil
}

// UpdateStock atualiza apenas o saldo de estoque e a data de modificação do item
func (r *ProductRepositoryPostgres) UpdateStock(associationID, id string, newQuantity int) error {
	query := `UPDATE products SET quantity = $1, updated_at = $2 WHERE association_id = $3 AND id = $4`
	
	_, err := r.db.Exec(query, newQuantity, time.Now(), associationID, id)
	return err
}
EOF