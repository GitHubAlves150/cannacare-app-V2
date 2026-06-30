# 1. Cria a pasta para os serviços de integração com a API
mkdir -p src/services

# 2. Cria o arquivo base da API
cat > src/services/api.ts << 'EOF'
const API_URL = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:8080';

type RequestOptions = {
  method?: 'GET' | 'POST' | 'PUT' | 'DELETE';
  body?: any;
  headers?: Record<string, string>;
};

// Wrapper genérico ao redor do fetch para automatizar envios em JSON
export async function apiFetch<T>(endpoint: string, options: RequestOptions = {}): Promise<T> {
  const { method = 'GET', body, headers } = options;

  const defaultHeaders: Record<string, string> = {
    'Content-Type': 'application/json',
    ...headers,
  };

  const response = await fetch(`${API_URL}${endpoint}`, {
    method,
    headers: defaultHeaders,
    body: body ? JSON.stringify(body) : undefined,
  });

  const data = await response.json();

  if (!response.ok) {
    // Captura o erro retornado pelo Go (ex: "saldo insuficiente") e joga para a tela
    throw new Error(data.error || 'Ocorreu um erro na requisição');
  }

  return data as T;
}
EOF