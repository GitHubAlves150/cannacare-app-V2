CREATE TABLE IF NOT EXISTS associations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    cnpj VARCHAR(18) NOT NULL UNIQUE,
    status VARCHAR(50) DEFAULT 'active', -- active, suspended, pending
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Cria um índice para o CNPJ para deixar as buscas por documento super rápidas
CREATE INDEX IF NOT EXISTS idx_associations_cnpj ON associations(cnpj);
