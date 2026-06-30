package usecase

import (
	"errors"
	"GitHubAlves150/cannacare-app-V2/cannacare/internal/domain/user"
)

var ErrUserAlreadyExists = errors.New("este e-mail já está cadastrado no sistema")

type CreateUserInput struct {
	AssociationID string `json:"association_id"`
	Name          string `json:"name"`
	Email         string `json:"email"`
	Password      string `json:"password"`
	Role          string `json:"role"`
}

type CreateUserUseCase struct {
	userRepo user.Repository
}

func NewCreateUserUseCase(userRepo user.Repository) *CreateUserUseCase {
	return &CreateUserUseCase{userRepo: userRepo}
}

func (uc *CreateUserUseCase) Execute(input CreateUserInput) (*user.User, error) {
	// 1. Verifica se o e-mail já está em uso
	existing, err := uc.userRepo.FindByEmail(input.Email)
	if err != nil {
		return nil, err
	}
	if existing != nil {
		return nil, ErrUserAlreadyExists
	}

	// 2. Cria a entidade (criptografando a senha nativamente)
	u, err := user.NewUser(input.AssociationID, input.Name, input.Email, input.Password, input.Role)
	if err != nil {
		return nil, err
	}

	// 3. Salva no banco de dados
	if err := uc.userRepo.Create(u); err != nil {
		return nil, err
	}

	return u, nil
}
