package user

import (
	"errors"
	"time"
	"golang.org/x/crypto/bcrypt"
)

var (
	ErrInvalidEmail = errors.New("o e-mail informado é inválido")
	ErrPasswordTooShort = errors.New("a senha deve ter no mínimo 6 caracteres")
)

type User struct {
	ID            string    `json:"id"`
	AssociationID string    `json:"association_id"`
	Name          string    `json:"name"`
	Email         string    `json:"email"`
	PasswordHash  string    `json:"-"` // O "-" impede que a senha apareça nas respostas JSON por segurança
	Role          string    `json:"role"` // admin, secretary, doctor, pharmacy
	CreatedAt     time.Time `json:"created_at"`
	UpdatedAt     time.Time `json:"updated_at"`
}

type Repository interface {
	Create(user *User) error
	FindByEmail(email string) (*User, error)
}

// NewUser cria um novo usuário aplicando a criptografia na senha
func NewUser(associationID, name, email, plainPassword, role string) (*User, error) {
	if email == "" {
		return nil, ErrInvalidEmail
	}
	if len(plainPassword) < 6 {
		return nil, ErrPasswordTooShort
	}

	// Gera o Hash da senha usando Bcrypt
	hashedPassword, err := bcrypt.GenerateFromPassword([]byte(plainPassword), bcrypt.DefaultCost)
	if err != nil {
		return nil, err
	}

	return &User{
		AssociationID: associationID,
		Name:          name,
		Email:         email,
		PasswordHash:  string(hashedPassword),
		Role:          role,
		CreatedAt:     time.Now(),
		UpdatedAt:     time.Now(),
	}, nil
}

// CheckPassword compara uma senha digitada com o Hash salvo no banco de dados
func (u *User) CheckPassword(plainPassword string) bool {
	err := bcrypt.CompareHashAndPassword([]byte(u.PasswordHash), []byte(plainPassword))
	return err == nil
}
