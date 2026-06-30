# 1. Cria a pasta para os repositórios de infraestrutura
mkdir -p internal/infrastructure/repository

# 2. Cria o arquivo com os comandos SQL do banco
cat > internal/infrastructure/repository/association_repository_postgres.go << 'EOF'
package repository

import (
	"database/sql"
	"errors"
	"GitHubAlves150/cannacare-app-V2/cannacare/internal/domain/association"
)

// AssociationRepositoryPostgres é a estrutura que carrega o ponteiro do banco de dados
type AssociationRepositoryPostgres struct {
	db *sql.DB
}

// NewAssociationRepositoryPostgres inicializa o repositório injetando a conexão do banco
func NewAssociationRepositoryPostgres(db *sql.DB) *AssociationRepositoryPostgres {
	return &AssociationRepositoryPostgres{db: db}
}

// Create pega a entidade do Go e insere uma nova linha na tabela do Postgres
func (r *AssociationRepositoryPostgres) Create(assoc *association.Association) error {
	query := `
		INSERT INTO associations (name, cnpj, status, created_at, updated_at)
		VALUES ($1, $2, $3, $4, $5)
		RETURNING id`

	// O QueryRow executa o comando SQL e o .Scan() captura o ID gerado pelo 'RETURNING id' 
	// e joga de volta para dentro do objeto assoc do Go.
	err := r.db.QueryRow(query, assoc.Name, assoc.CNPJ, assoc.Status, assoc.CreatedAt, assoc.UpdatedAt).Scan(&assoc.ID)
	if err != nil {
		return err
	}

	return nil
}

// FindByID busca uma associação específica através da chave primária (UUID)
func (r *AssociationRepositoryPostgres) FindByID(id string) (*association.Association, error) {
	query := `SELECT id, name, cnpj, status, created_at, updated_at FROM associations WHERE id = $1`
	row := r.db.QueryRow(query, id)

	var assoc association.Association
	// O Scan mapeia as colunas da tabela de volta para as variáveis da Struct do Go
	err := row.Scan(&assoc.ID, &assoc.Name, &assoc.CNPJ, &assoc.Status, &assoc.CreatedAt, &assoc.UpdatedAt)
	if err != nil {
		if errors.Is(err, sql.ErrNoRows) {
			return nil, errors.New("associação não encontrada")
		}
		return nil, err
	}

	return &assoc, nil
}

// FindByCNPJ serve para podermos verificar se um CNPJ já foi cadastrado antes
func (r *AssociationRepositoryPostgres) FindByCNPJ(cnpj string) (*association.Association, error) {
	query := `SELECT id, name, cnpj, status, created_at, updated_at FROM associations WHERE cnpj = $1`
	row := r.db.QueryRow(query, cnpj)

	var assoc association.Association
	err := row.Scan(&assoc.ID, &assoc.Name, &assoc.CNPJ, &assoc.Status, &assoc.CreatedAt, &assoc.UpdatedAt)
	if err != nil {
		if errors.Is(err, sql.ErrNoRows) {
			return nil, nil // Se não achar nenhum, retorna nil (sem erro), indicando que o CNPJ está livre
		}
		return nil, err
	}

	return &assoc, nil
}
EOF