cat > internal/infrastructure/repository/user_repository_postgres.go << 'EOF'
package repository

import (
	"database/sql"
	"errors"
	"GitHubAlves150/cannacare-app-V2/cannacare/internal/domain/user"
)

type UserRepositoryPostgres struct {
	db *sql.DB
}

func NewUserRepositoryPostgres(db *sql.DB) *UserRepositoryPostgres {
	return &UserRepositoryPostgres{db: db}
}

func (r *UserRepositoryPostgres) Create(u *user.User) error {
	query := `
		INSERT INTO users (association_id, name, email, password_hash, role, created_at, updated_at)
		VALUES ($1, $2, $3, $4, $5, $6, $7)
		RETURNING id`

	err := r.db.QueryRow(query, u.AssociationID, u.Name, u.Email, u.PasswordHash, u.Role, u.CreatedAt, u.UpdatedAt).Scan(&u.ID)
	return err
}

func (r *UserRepositoryPostgres) FindByEmail(email string) (*user.User, error) {
	query := `SELECT id, association_id, name, email, password_hash, role, created_at, updated_at FROM users WHERE email = $1`
	row := r.db.QueryRow(query, email)

	var u user.User
	err := row.Scan(&u.ID, &u.AssociationID, &u.Name, &u.Email, &u.PasswordHash, &u.Role, &u.CreatedAt, &u.UpdatedAt)
	if err != nil {
		if errors.Is(err, sql.ErrNoRows) {
			return nil, nil // Retorna nil se o e-mail estiver livre
		}
		return nil, err
	}

	return &u, nil
}
EOF