# 1. Cria as pastas para a camada de interfaces HTTP
mkdir -p internal/interfaces/http/handler
mkdir -p internal/interfaces/http/route

# 2. Cria o Handler que traduz a requisição JSON para o Go
cat > internal/interfaces/http/handler/association_handler.go << 'EOF'
package handler

import (
	"net/http"
	"GitHubAlves150/cannacare-app-V2/cannacare/internal/application/usecase"
	"github.com/gin-gonic/gin"
)

// AssociationHandler carrega o caso de uso que ele precisa acionar
type AssociationHandler struct {
	createUseCase *usecase.CreateAssociationUseCase
}

// NewAssociationHandler inicializa o controlador injetando o caso de uso
func NewAssociationHandler(createUseCase *usecase.CreateAssociationUseCase) *AssociationHandler {
	return &AssociationHandler{createUseCase: createUseCase}
}

// CreateAssociation é o método que o Gin vai executar quando alguém chamar a rota
func (h *AssociationHandler) CreateAssociation(c *gin.Context) {
	var input usecase.CreateAssociationInput

	// O ShouldBindJSON tenta pegar o corpo da requisição (JSON) e converter na nossa estrutura Input
	if err := c.ShouldBindJSON(&input); err != nil {
		// Se o JSON enviado estiver mal formatado, devolve erro 400 (Bad Request)
		c.JSON(http.StatusBadRequest, gin.H{"error": "JSON inválido: " + err.Error()})
		return
	}

	// Executa o nosso caso de uso com os dados recebidos
	output, err := h.createUseCase.Execute(input)
	if err != nil {
		// Se a regra de negócio falhar (ex: CNPJ duplicado), devolve erro 400 ou 500
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	// Se tudo deu certo, devolve Status 211 (Created) e o objeto criado com o ID do banco
	c.JSON(http.StatusCreated, output)
}
EOF

# 3. Cria o arquivo de mapeamento de rotas
cat > internal/interfaces/http/route/association_routes.go << 'EOF'
package route

import (
	"GitHubAlves150/cannacare-app-V2/cannacare/internal/interfaces/http/handler"
	"github.com/gin-gonic/gin"
)

// RegisterAssociationRoutes define quais caminhos de URL pertencem a esse módulo
func RegisterAssociationRoutes(r *gin.Engine, h *handler.AssociationHandler) {
	r.POST("/associations", h.CreateAssociation)
}
EOF