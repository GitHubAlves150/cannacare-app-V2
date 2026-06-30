# 1. Cria a pasta para os casos de uso de aplicação (caso não exista)
mkdir -p internal/application/usecase

# 2. Cria o arquivo do caso de uso de criação de associação
cat > internal/application/usecase/create_association.go << 'EOF'
package usecase

import (
	"errors"
	"GitHubAlves150/cannacare-app-V2/cannacare/internal/domain/association"
)

// Definição de erro específico da aplicação
var ErrAssociationAlreadyExists = errors.New("uma associação com este CNPJ já está cadastrada no sistema")

// CreateAssociationInput define os dados que este caso de uso espera receber da tela
type CreateAssociationInput struct {
	Name string `json:"name"`
	CNPJ string `json:"cnpj"`
}

// CreateAssociationUseCase é a estrutura que junta as pecinhas necessárias
type CreateAssociationUseCase struct {
	repo association.Repository
}

// NewCreateAssociationUseCase cria uma nova instância do caso de uso injetando o repositório
func NewCreateAssociationUseCase(repo association.Repository) *CreateAssociationUseCase {
	return &CreateAssociationUseCase{repo: repo}
}

// Execute roda a lógica de negócio do cadastro de ponta a ponta
func (uc *CreateAssociationUseCase) Execute(input CreateAssociationInput) (*association.Association, error) {
	// 1. Regra de Negócio: Verifica se o CNPJ já está em uso
	existing, err := uc.repo.FindByCNPJ(input.CNPJ)
	if err != nil {
		return nil, err
	}
	if existing != nil {
		return nil, ErrAssociationAlreadyExists
	}

	// 2. Cria a entidade de domínio (onde rodam as validações de nome/cnpj vazios)
	assoc, err := association.NewAssociation(input.Name, input.CNPJ)
	if err != nil {
		return nil, err
	}

	// 3. Manda o repositório salvar no banco de dados
	if err := uc.repo.Create(assoc); err != nil {
		return nil, err
	}

	// Retorna a associação criada (agora contendo o ID gerado pelo banco)
	return assoc, nil
}
EOF